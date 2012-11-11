import uwsgi
import psycopg2
import urlparse
from const import pg_connect

COMMON_HEADERS = [('Content-Type', 'application/xml'), ('Access-Control-Allow-Origin', '*'), ('Access-Control-Allow-Headers', 'Requested-With,Content-Type')]

# create table groepsdossier(id serial primary key, naam varchar(32));
# create table groepsdossier_bsn(gid integer references groepsdossier, bsn numeric(9,0), unique(gid, bsn));

def notfound(start_response):
    start_response('404 File Not Found', COMMON_HEADERS + [('Content-length', '12')])
    return '<notfound />'

def Groep(environ, start_response):
    reply = ''
    url = environ['PATH_INFO'][1:]
    if len(url) > 0 and url[-1] == '/':
        url = url[:-1]

    arguments = url.split('/')
    conn = psycopg2.connect(pg_connect)

    reply = '<izmede:fout xmlns:izmede="izmede.nl/ns/root" />'

    if arguments[0] == 'GROEP':
        if len(arguments) == 1:
            cur = conn.cursor()
            post_input = urlparse.parse_qs(environ['wsgi.input'].readline().decode(),True)
            naam = post_input['naam'][0]
            cur.execute("insert into groepsdossier (naam) values (%s);", (naam,))
            cur.execute("select max(id) from groepsdossier;")
            gid = cur.fetchone()[0]
            for bsn in post_input['bsn[]']:
                cur.execute("insert into groepsdossier_bsn (gid, bsn) values (%s, %s);", (gid, int(bsn)))
            conn.commit()

            reply = '<izmede:groepsdossiers xmlns:izmede="izmede.nl/ns/root">'
            reply += '<izmede:groepsdossier id="%d">%s</izmede:groepsdossier>' % (gid, naam)
            reply += '</izmede:groepsdossiers>'
        else:
            try:
                gid = int(arguments[1])
            except:
                return notfound(start_response)

            cur = conn.cursor()
            cur.execute("select naam from groepsdossier where id = %s;", (gid,))
            naam = cur.fetchone()
            if naam is None:
                return notfound(start_response)
            else:
                naam = naam[0]
            reply = '<izmede:groepsdossier xmlns:izmede="izmede.nl/ns/root" id="%d" alias="%s">' % (gid, naam)

            cur.execute("select bsn from groepsdossier_bsn where gid = %s ORDER BY bsn;", (gid,))
            for (bsn) in cur.fetchall():
                reply += '<izmede:prs bsn="%d" />' % (bsn)

            cur.execute("SELECT systeem, min(jr_van) AS jr_van, max(jr_tm) AS jr_tm, sum(totaal) AS totaal FROM vw_gd_feqbron, groepsdossier_bsn WHERE gid = %s and vw_gd_feqbron.bsn = groepsdossier_bsn.bsn GROUP BY vlgnr, systeem ORDER BY vlgnr", (gid,))
            for (systeem, jr_van, jr_tm, totaal) in cur.fetchall():
                reply += '<izmede:bron systeem="%s" jr_van="%s" jr_tot="%s" totaal="%s" />' % (systeem, jr_van, jr_tm, totaal)

            cur.execute("SELECT bsn_feq.bsn, jr_van, jr_tm, xgws, xbsb, xlpt, xsyst as totaal FROM bsn_feq, groepsdossier_bsn WHERE gid = %s and bsn_feq.bsn = groepsdossier_bsn.bsn", (gid,))
            for (bsn, jr_van, jr_tm, gws, bsb, lpt, totaal) in cur.fetchall():
                reply += '<izmede:bronprs bsn="%s" jr_van="%s" jr_tot="%s" totaal="%s" gws="%s" bsb="%s" lpt="%s" />' % (bsn, jr_van, jr_tm, totaal, gws, bsb, lpt)

            reply += '</izmede:groepsdossier>'

    elif arguments[0] == 'SAMENVATTING':
        try:
           bsn = int(arguments[1])
        except:
           return notfound(start_response)

        reply = '<izmede:samenvatting xmlns:izmede="izmede.nl/ns/root" id="%d">' % (bsn)

        cur = conn.cursor()
        cur.execute("SELECT systeem, min(jr_van) AS jr_van, max(jr_tm) AS jr_tm, sum(totaal) AS totaal FROM vw_gd_feqbron WHERE vw_gd_feqbron.bsn = %s GROUP BY vlgnr, systeem ORDER BY vlgnr", (bsn,))
        for (systeem, jr_van, jr_tm, totaal) in cur.fetchall():
            reply += '<izmede:bron systeem="%s" jr_van="%s" jr_tot="%s" totaal="%s" />' % (systeem, jr_van, jr_tm, totaal)

        reply += '</izmede:samenvatting>'

    elif arguments[0] == 'GROEPDEL':
        try:
           gid = int(arguments[1])
        except:
           return notfound(start_response)

        cur = conn.cursor()
        cur.execute("delete from groepsdossier_bsn where gid = %s;", (gid,))
        cur.execute("delete from groepsdossier where id = %s;", (gid,))
        conn.commit()

        reply = '<izmede:verwijderd xmlns:izmede="izmede.nl/ns/root" />'
     
    elif arguments[0] == 'GROEPDELBSN':
        try:
           gid = int(arguments[1])
           bsn = int(arguments[2])
        except:
           return notfound(start_response)

        cur = conn.cursor()
        cur.execute("delete from groepsdossier_bsn where gid = %s and bsn = %s;", (gid, bsn,))
        conn.commit()

        reply = '<izmede:verwijderd xmlns:izmede="izmede.nl/ns/root" />'
                
    elif arguments[0] == 'GROEPALIAS':
        cur = conn.cursor()
        if len(arguments) == 2:
            like = '%' + arguments[1] + '%'
            cur.execute("select id, naam from groepsdossier where naam ilike %s order by naam;", (like,))
        else:
            cur.execute("select id, naam from groepsdossier order by naam;")
        
        reply = '<izmede:groepsdossiers xmlns:izmede="izmede.nl/ns/root">'
        for (id, naam) in cur.fetchall():
            reply += '<izmede:groepsdossier id="%d" alias="%s" />' % (id, naam)

        reply += '</izmede:groepsdossiers>'

    elif arguments[0] == 'BSB':
        cur = conn.cursor()
        if len(arguments) == 2:
            bsn = int(arguments[1])
            cur.execute("SELECT dossier, datum, betreft, Aanvraag, Startdatum, Einddatum, medewerker FROM vw_pd_bsb WHERE bsn = %s ORDER BY datum", (bsn,))
            
            reply = '<izmede:bsb xmlns:izmede="izmede.nl/ns/root" bsn="%d">' % (bsn)
            for row in cur.fetchall():
                reply += "<izmede:bsbdossier id='%s'><izmede:datum>%s</izmede:datum><izmede:betreft>%s</izmede:betreft><izmede:aanvraag>%s</izmede:aanvraag><izmede:startdatum>%s</izmede:startdatum><izmede:einddatum>%s</izmede:einddatum><izmede:medewerker>%s</izmede:medewerker></izmede:bsbdossier>" % tuple([str(x or '') for x in row])
            reply += '</izmede:bsb>'
    
    elif arguments[0] == 'LPT':
        cur = conn.cursor()
        if len(arguments) == 2:
            bsn = int(arguments[1])

            reply = '<izmede:lpt xmlns:izmede="izmede.nl/ns/root" bsn="%d">' % (bsn)
            cur.execute("SELECT beheerder FROM lpt_beh WHERE bsn = %s", (bsn,))
            for (beheerder,) in cur.fetchall():
                reply += "<izmede:lptbeheerder>%s</izmede:lptbeheerder>" % (beheerder)
            
            cur.execute("SELECT dossier, datum, betreft, startdatum, einddatum, dagen, type, reden, school FROM vw_pd_lpt WHERE bsn = %s ORDER BY datum", (bsn,))
            for row in cur.fetchall():
                reply += "<izmede:lptdossier id='%s'><izmede:datum>%s</izmede:datum><izmede:betreft>%s</izmede:betreft><izmede:startdatum>%s</izmede:startdatum><izmede:einddatum>%s</izmede:einddatum><izmede:dagen>%s</izmede:dagen><izmede:type>%s</izmede:type><izmede:reden>%s</izmede:reden><izmede:school>%s</izmede:school></izmede:lptdossier>" % tuple([str(x or '') for x in row])
            reply += '</izmede:lpt>'

    elif arguments[0] == 'GWS':
        cur = conn.cursor()
        if len(arguments) == 2:
            bsn = int(arguments[1])
            cur.execute("SELECT dossier, datum, betreft, startdatum, einddatum, datumlaatst, regeling, omschrijving, leefvorm, huisvesting, burgstaat, medewerker FROM vw_pd_gws WHERE bsn = %s ORDER BY datum", (bsn,))

            reply = '<izmede:gws xmlns:izmede="izmede.nl/ns/root" bsn="%d">' % (bsn)
            for row in cur.fetchall():
                reply += "<izmede:gwsdossier id='%s'><izmede:datum>%s</izmede:datum><izmede:betreft>%s</izmede:betreft><izmede:startdatum>%s</izmede:startdatum><izmede:einddatum>%s</izmede:einddatum><izmede:datumlaatst>%s</izmede:datumlaatst><izmede:regeling>%s</izmede:regeling><izmede:omschrijving>%s</izmede:omschrijving><izmede:leefvorm>%s</izmede:leefvorm><izmede:huisvesting>%s</izmede:huisvesting><izmede:burgstaat>%s</izmede:burgstaat><izmede:medewerker>%s</izmede:medewerker></izmede:gwsdossier>" % tuple([str(x or '') for x in row])
            reply += '</izmede:gws>'

    elif arguments[0] == 'VIEW':
        cur = conn.cursor()
        if len(arguments) == 3:
            if not arguments[1].startswith('vw_'):
                view = 'vw_' + arguments[1]
            else:
                view = arguments[1]

            bsns = ','.join([str(int(x)) for x in arguments[2].split(',')])

            cur.execute("SELECT * FROM " + view + " WHERE bsn IN (" +bsns+ ");")
            reply = '<html xmlns="http://www.w3.org/1999/xhtml"><head><title>%s</title></head><body><table>' % (view)
            for row in cur.fetchall():
                reply += '<tr><td>' + '</td><td>'.join([str(x or '') for x in row]) + '</td></tr>'
            reply += '</table></body></html>'

    conn.close()
    start_response('200 OK', COMMON_HEADERS + [('Content-length', str(len(reply)))])
    return reply

uwsgi.applications = {'': Groep}
