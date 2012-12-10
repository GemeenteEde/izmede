import uwsgi
import re
import codecs
from time import localtime, strftime
from pysimplesoap.client import SoapClient
from pysimplesoap.simplexml import SimpleXMLElement

from const import soap_location, soap_action, soap_key, soap_cert

COMMON_HEADERS = [('Content-Type', 'application/xml'), ('Access-Control-Allow-Origin', '*'), ('Access-Control-Allow-Headers', 'Requested-With,Content-Type')]

def leesTemplate(bestandsnaam):
    return codecs.open(bestandsnaam, 'r', 'UTF-8').read()

def testTemplate(bestandsnaam, variabelen):
    template = leesTemplate(bestandsnaam) 
    return template % variabelen

def notfound(start_response):
    start_response('404 File Not Found', COMMON_HEADERS + [('Content-length', '12')])
    yield '<notfound />'

def Synchroon(environ, start_response):
    url = environ['PATH_INFO'][1:]
    try:
        username = environ['REMOTE_USER']
    except:
        return notfound(start_response)

    if len(url) > 0 and url[-1] == '/':
        url = url[:-1]

    arguments = url.split('/')

    if arguments[0] == 'BSN':
        try:
            bsn = int(arguments[1])
        except:
            return notfound(start_response)

        variabelen  = {'username': username, 'BSN_van': bsn, 'BSN_tot': bsn, 'tijdstipbericht': strftime("%Y%m%d%H%M%S00", localtime()), 'referentienummer': '0'}
        vraag = testTemplate('templates/vraag_uitgebreid_bsn.xml', variabelen)

    elif arguments[0] == 'BSNKORT':
        try:
            bsn = int(arguments[1])
        except:
            return notfound(start_response)

        variabelen  = {'username': username, 'BSN_van': bsn, 'BSN_tot': bsn, 'tijdstipbericht': strftime("%Y%m%d%H%M%S00", localtime()), 'referentienummer': '0'}
        vraag = testTemplate('templates/vraag_snel_bsn.xml', variabelen)
   
    elif arguments[0] == 'GROEPBSN':
        try:
            bsn = int(arguments[1])
        except:
            return notfound(start_response)

        variabelen  = {'username': username, 'BSN_van': bsn, 'BSN_tot': bsn, 'tijdstipbericht': strftime("%Y%m%d%H%M%S00", localtime()), 'referentienummer': '0'}
        vraag = testTemplate('templates/vraag_groepsdossier_bsn.xml', variabelen)

    elif arguments[0] == 'SB':
        try:
            bsn = int(arguments[1])
        except:
            return notfound(start_response)

        variabelen  = {'username': username, 'BSN_van': bsn, 'BSN_tot': bsn, 'tijdstipbericht': strftime("%Y%m%d%H%M%S00", localtime()), 'referentienummer': '0'}
        vraag = testTemplate('templates/vraag_stamboom.xml', variabelen)
    
    elif arguments[0] == 'PC':
        try:
            postcode = re.compile('^[0-9]{4}[A-Z]{2}$').match(arguments[1]).group(0)
            huisnummer = int(arguments[2])
        except:
            return notfound(start_response)
    
        variabelen  = {'username': username, 'PC_van': postcode, 'PC_tot': postcode, 'HN_van': huisnummer, 'HN_tot': huisnummer, 'tijdstipbericht': strftime("%Y%m%d%H%M%S00", localtime()), 'referentienummer': '0'}
        vraag = testTemplate('templates/vraag_beknopt_postcode.xml', variabelen)
    
    elif arguments[0] == 'GD':
        try:
            geboortedatum = re.compile('^[0-9]{8}$').match(arguments[1]).group(0)
        except:
            return notfound(start_response)

        variabelen  = {'username': username, 'GD_van': geboortedatum, 'GD_tot': geboortedatum, 'tijdstipbericht': strftime("%Y%m%d%H%M%S00", localtime()), 'referentienummer': '0'}
        vraag = testTemplate('templates/vraag_beknopt_geboortedatum.xml', variabelen)
        
    else:
        return notfound(start_response)

    client = SoapClient(
        namespace = "http://www.egem.nl/StUF/sector/bg/0204", soap_ns='soap', trace = False, ns = 'SectorModel',
        location = soap_location, action = soap_action, key = soap_key, cert = soap_cert)

    vraagBericht = SimpleXMLElement(vraag)

    response = client.call('vraagBericht',vraagBericht)
    reply = response.as_xml()

    start_response('200 OK', COMMON_HEADERS + [('Content-length', str(len(reply)))])
    return reply

uwsgi.applications = {'': Synchroon}
