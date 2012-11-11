var prs_relaties = {'SectorModel:body': '', 'SectorModel:PRSPRSOUD': 'Ouder', 'SectorModel:PRSPRSHUW': 'Huwelijk', 'SectorModel:PRSPRSKND': 'Kind'}

function persoonLPT(response) {
    if ($(response).filterNode('izmede:lptdossier').length == 0) {
        $("#tabs-leerplicht").hide();
        $("#tab-leerplicht").hide();
        return; 
    }

    $("#tabs-leerplicht").show();
    $("#tab-leerplicht").show();
    $("#leerplicht").html('<tr><th>datum</th><th>betreft</th><th>start</th><th>eind</th><th>dagen</th><th>type</th><th>reden</th><th>school</th></tr>');

    var lptbeheerder = new Array();

     $(response).filterNode('izmede:lptbeheerder').each(function() { lptbeheerder.push($(this).text()); });

    if (lptbeheerder.length > 0) {
        $("#lptbeheerder").html("Beheerder: " + lptbeheerder.join(", "));
    } else {
        $("#lptbeheerder").empty();
    }

    $(response).filterNode('izmede:lptdossier').each(function() {
            lptdossier = this;
            var datum = datumOpmaak($($(lptdossier).filterNode('izmede:datum')[0]).text());
            var betreft = $($(lptdossier).filterNode('izmede:betreft')[0]).text();
            var startdatum = datumOpmaak($($(lptdossier).filterNode('izmede:startdatum')[0]).text());
            var einddatum = datumOpmaak($($(lptdossier).filterNode('izmede:einddatum')[0]).text());
            var dagen = $($(lptdossier).filterNode('izmede:dagen')[0]).text();
            var type = $($(lptdossier).filterNode('izmede:type')[0]).text();
            var reden = $($(lptdossier).filterNode('izmede:reden')[0]).text();
            var school = $($(lptdossier).filterNode('izmede:school')[0]).text();

            // lptdossier = this;
            // dossier = this.attributes.getNamedItem("id").value;

            $("#leerplicht").append('<tr><td>'+datum+'</td><td>'+betreft+'</td><td>'+startdatum+'</td><td>'+einddatum+'</td><td>'+dagen+'</td><td>'+type+'</td><td>'+reden+'</td><td>'+school+'</td></tr>');

            });

    $("#leerplicht").html(tbody);
}

function persoonAdressen(response) {
    var tbody = '';

    $($(response).filterNode('SectorModel:PRSADRINS')).each(function() {
            var adres = this;
            var datum = datumOpmaak($($(adres).filterNode('StUF:begindatumRelatie')[0]).text());

            tbody += '<tr><td>'+datum+'</td><td>'+stufAdres(this)+'</td></tr>';
            });
    $("#adressen").html('<tr><th>datum</th><th>adres</th></tr>' + tbody);
}

function updateADRInline(response, id) {
    $('td.'+id).html(stufAdres(response));
}

function updatePRSInline(response, id) {
    var trow = ''
        $($(response).filterNode('SectorModel:PRS')).each(function() {
                var persoon = this;
                var bsn   = $($(persoon).filterNode('SectorModel:bsn-nummer')[0]).text();
                var naam  = $($(persoon).filterNode('SectorModel:voorvoegselGeslachtsnaam')[0]).text() + ' ' +
                $($(persoon).filterNode('SectorModel:geslachtsnaam')[0]).text() + ', ' +
                $($(persoon).filterNode('SectorModel:voornamen')[0]).text();
                var geb   = datumOpmaak($($(persoon).filterNode('SectorModel:geboortedatum')[0]).text());
                var mv    = $($(persoon).filterNode('SectorModel:geslachtsaanduiding')[0]).text();
                var adres = stufAdres(persoon);

                trow += '<td class"noprint" style="border: 0px; padding: 0px;"><button title="Toon persoonsdossier" class="ui-state-default ui-corner-all" onclick="return persoonsDossier('+bsn+');"><span class="ui-icon ui-icon-document"></span></button></td><td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td><td>'+geb+'</td><td>'+naam+'</td><td>'+mv+'</td><td>'+adres+'</td>';
                });
    $('tr.'+id).html(trow);
}

function updatePRSInline2(response, id) {
    var trow = ''
        $($(response).filterNode('SectorModel:PRS')).each(function() {
                var persoon = this;
                var bsn   = $($(persoon).filterNode('SectorModel:bsn-nummer')[0]).text();
                var naam  = $($(persoon).filterNode('SectorModel:voorvoegselGeslachtsnaam')[0]).text() + ' ' +
                $($(persoon).filterNode('SectorModel:geslachtsnaam')[0]).text() + ', ' +
                $($(persoon).filterNode('SectorModel:voornamen')[0]).text();
                var geb   = datumOpmaak($($(persoon).filterNode('SectorModel:geboortedatum')[0]).text());
                var mv    = $($(persoon).filterNode('SectorModel:geslachtsaanduiding')[0]).text();
                var adres = stufAdres(persoon);

                trow += '<td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td><td>'+geb+'</td><td>'+naam+'</td><td>'+mv+'</td><td>'+adres+'</td>';
                });
    $('tr.'+id).html(trow);
}

function persoonStamboom(response) {
    var show = false;

    $("#ouders").html('<tr><th class"noprint" style="border: 0px; padding: 0px;"></th><th>bsn</th><th>geboren</th><th>naam</th><th>mv</th><th>adres</th></tr>');
    $($(response).filterNode('SectorModel:PRSPRSOUD')).each(function() {
            var ouder = this;

            $($(ouder).filterNode('SectorModel:PRS')).each(function() {
                var persoon = this;
                var bsn   = $($(persoon).filterNode('SectorModel:bsn-nummer')[0]).text();
                var naam  = $($(persoon).filterNode('SectorModel:voorvoegselGeslachtsnaam')[0]).text() + ' ' +
                $($(persoon).filterNode('SectorModel:geslachtsnaam')[0]).text() + ', ' +
                $($(persoon).filterNode('SectorModel:voornamen')[0]).text();
                var geb   = datumOpmaak($($(persoon).filterNode('SectorModel:geboortedatum')[0]).text());
                var mv    = $($(persoon).filterNode('SectorModel:geslachtsaanduiding')[0]).text();
                var adres = stufAdres(persoon);

                if (bsn != '') {
                    bsntd = '<td class"noprint" style="border: 0px; padding: 0px;"><button title="Toon persoonsdossier" class="ui-state-default ui-corner-all" onclick="return persoonsDossier('+bsn+');"><span class="ui-icon ui-icon-document"></span></button></td><td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td>';
                } else {
                    bsntd = '<td class"noprint" style="border: 0px; padding: 0px;"></td><td></td>';
                }

                $("#ouders").append('<tr class="oud_'+bsn+'">'+bsntd+'</td><td>'+geb+'</td><td>'+naam+'</td><td>'+mv+'</td><td>'+adres+'</td></tr>');
 
                if (bsn != '') {
                    $.ajax({type:'GET', url: '/BSNKORT/'+bsn, success: function(xml) { return updatePRSInline(xml, 'oud_'+bsn); }});
                }
                show = true;
                });
    });
    if (show) {
        $("#tab-ouders").show();
        $("#tabs-ouders").show();
    } else {
        $("#tab-ouders").hide();
        $("#tabs-ouders").hide();
        $("#ouders").empty();
    }

    show = false; 
    $("#kinderen").html('<tr><th class"noprint" style="border: 0px; padding: 0px;"></th><th>bsn</th><th>geboren</th><th>naam</th><th>mv</th><th>adres</th></tr>');
    $($(response).filterNode('SectorModel:PRSPRSKND')).each(function() {
            var kind = this;
            $($(kind).filterNode('SectorModel:PRS')).each(function() {
                var persoon = this;
                var bsn   = $($(persoon).filterNode('SectorModel:bsn-nummer')[0]).text();
                var naam  = $($(persoon).filterNode('SectorModel:voorvoegselGeslachtsnaam')[0]).text() + ' ' +
                $($(persoon).filterNode('SectorModel:geslachtsnaam')[0]).text() + ', ' +
                $($(persoon).filterNode('SectorModel:voornamen')[0]).text();
                var geb   = $($(persoon).filterNode('SectorModel:geboortedatum')[0]).text();
                var mv    = $($(persoon).filterNode('SectorModel:geslachtsaanduiding')[0]).text();
                var adres = stufAdres(persoon);

                if (bsn != '') {
                    bsntd = '<td class"noprint" style="border: 0px; padding: 0px;"><button title="Toon persoonsdossier" class="ui-state-default ui-corner-all" onclick="return persoonsDossier('+bsn+');"><span class="ui-icon ui-icon-document"></span></button></td><td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td>';
                } else {
                    bsntd = '<td class"noprint" style="border: 0px; padding: 0px;"></td><td></td>';
                }

                $("#kinderen").append('<tr class="knd_'+bsn+'">'+bsntd+'</td><td>'+geb+'</td><td>'+naam+'</td><td>'+mv+'</td><td>'+adres+'</td></tr>');
                if (bsn != '') {
                    $.ajax({type:'GET', url: '/BSNKORT/'+bsn, success: function(xml) { return updatePRSInline(xml, 'knd_'+bsn); }});
                }
                show = true;
                });
    });
    if (show) {
        $("#tab-kinderen").show();
        $("#tabs-kinderen").show();
    } else {
        $("#tab-kinderen").hide();
        $("#tabs-kinderen").hide();
        $("#kinderen").empty();
    }

    show = false; 
    $("#huwelijken").html('<tr><th class"noprint" style="border: 0px; padding: 0px;"></th><th>bsn</th><th>geboren</th><th>naam</th><th>mv</th><th>adres</th><th>van</th><th>tot</th><th>soort</th></tr>');
    $($(response).filterNode('SectorModel:PRSPRSHUW')).each(function() {
            var huwelijk = this;
            $($(huwelijk).filterNode('SectorModel:PRS')).each(function() {
                var persoon = this;
                var bsn   = $($(persoon).filterNode('SectorModel:bsn-nummer')[0]).text();
                var naam  = $($(persoon).filterNode('SectorModel:voorvoegselGeslachtsnaam')[0]).text() + ' ' +
                $($(persoon).filterNode('SectorModel:geslachtsnaam')[0]).text() + ', ' +
                $($(persoon).filterNode('SectorModel:voornamen')[0]).text();
                var geb   = datumOpmaak($($(persoon).filterNode('SectorModel:geboortedatum')[0]).text());
                var mv    = $($(persoon).filterNode('SectorModel:geslachtsaanduiding')[0]).text();
                var adres = stufAdres(persoon);

                var van  = datumOpmaak($($(huwelijk).filterNode('SectorModel:datumSluiting')[0]).text());
                var tot  = datumOpmaak($($(huwelijk).filterNode('SectorModel:datumOntbinding')[0]).text());
                var soort  = $($(huwelijk).filterNode('SectorModel:soortVerbintenis')[0]).text();

                if (soort == 'P') {
                    soort = 'Partnerschap';
                } else if (soort == 'H') {
                    soort = 'Huwelijk';
                }

                /* var type = '';

                $($(huwelijk).filterNode('SectorModel:extraElementen')[0]).filterNode('StUF:extraElement').each(function() {
                    var naam = this.attributes.getNamedItem("naam").value;
                    if (naam == 'soortVerbintenisOmschrijving') {
                    type = $(this).text();
                    }
                    });*/
                if (bsn != '') {
                    bsntd = '<td class"noprint" style="border: 0px; padding: 0px;"><button title="Toon persoonsdossier" class="ui-state-default ui-corner-all" onclick="return persoonsDossier('+bsn+');"><span class="ui-icon ui-icon-document"></span></button></td><td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td>';
                } else {
                    bsntd = '<td class"noprint" style="border: 0px; padding: 0px;"></td><td></td>';
                }

                $("#huwelijken").append('<tr>'+bsntd+'</td><td>'+geb+'</td><td>'+naam+'</td><td>'+mv+'</td><td class="huw_'+bsn+'">'+adres+'</td><td>'+van+'</td><td>'+tot+'</td><td>'+soort+'</td></tr>');

                if (bsn != '') {
                    $.ajax({type:'GET', url: '/BSNKORT/'+bsn, success: function(xml) { return updateADRInline(xml, 'huw_'+bsn); }});
                }
                show = true;
            });
    });
    if (show) {
        $("#tab-huwelijken").show();
        $("#tabs-huwelijken").show();
    } else {
        $("#tab-huwelijken").hide();
        $("#tabs-huwelijken").hide();
        $("#huwelijken").empty();
    }
}

function persoonGBA(response) {
    persoonTabGBA(response, '#gba');
    persoonAdressen(response);
    persoonStamboom(response);
}

function persoonTabGBA(response, target) {
    var persoon = $(response).filterNode('SectorModel:PRS')[0];
    var bsn = $($(persoon).filterNode('SectorModel:bsn-nummer')[0]).text();
    var naam = $($(persoon).filterNode('SectorModel:voorvoegselGeslachtsnaam')[0]).text() + ' ' +
        $($(persoon).filterNode('SectorModel:geslachtsnaam')[0]).text() + ', ' +
        $($(persoon).filterNode('SectorModel:voornamen')[0]).text();

    var geboren = datumOpmaak($($(persoon).filterNode('SectorModel:geboortedatum')[0]).text());
    var adres = stufAdres(persoon);
    var geslacht = $($(persoon).filterNode('SectorModel:geslachtsaanduiding')[0]).text();

    if (geslacht == 'V') {
        geslacht = 'Vrouw';
    } else if (geslacht == 'M') {
        geslacht = 'Man';
    }

    var burgstaat = '';

    $($(persoon).filterNode('SectorModel:extraElementen')[0]).filterNode('StUF:extraElement').each(function() {
            var naam = this.attributes.getNamedItem("naam").value;
            if (naam == 'omschrijvingBurgerlijkeStaat') {
                burgstaat = $(this).text();
            } else if (naam == 'geboorteplaatsnaam') {
                geboren += ' te ' + $(this).text();
            }
            });

    var nationaliteit = new Array();

    $(persoon).filterNode('SectorModel:NAT').each(function() {
        nationaliteit.push($($(this).filterNode('SectorModel:omschrijving')[0]).text());
    });

    nationaliteit = nationaliteit.join(', ');

    var datumoverlijden = datumOpmaak($($(persoon).filterNode('SectorModel:datumOverlijden')[0]).text());
    if (datumoverlijden != '') {
        datumoverlijden = '<td>Overleden:</td><td>'+datumoverlijden+'</td>';
        burgstaat = 'Overleden';
    }

    var tbody = '<tr><td>Naam:</td><td>'+naam+'</td><td style="width: 3em;"></td><td>Geslacht:</td><td>'+geslacht+'</td></tr>' +
        '<tr><td>Geboren:</td><td>'+geboren+'</td><td></td><td>Burg. Staat:</td><td>'+burgstaat+'</td></tr>' + 
        '<tr><td>Adres:</td><td>'+adres+'</td><td></td><td>Nationaliteit:</td><td>'+nationaliteit+'</td></tr>' +
        '<tr><td>BSN:</td><td>'+bsn+'</td>'+datumoverlijden+'</tr>';

    $(target).html(tbody);
}

function persoonSAMENVATTING(response) {
    if ($(response).filterNode('izmede:bron').length == 0) {
        $("#tabs-samenvatting").hide();
        $("#tab-samenvatting").hide();
        return;
    } else {
        $("#tabs-samenvatting").show();
        $("#tab-samenvatting").show();
    }

    $("#samenvatting").html('<tr><th>systeem</th><th>periode</th><th>totaal</th></tr>');

    $(response).filterNode('izmede:bron').each(function() {
            bron = this;
            var systeem = this.attributes.getNamedItem("systeem").value;
            var periode = this.attributes.getNamedItem("jr_van").value + '-' + this.attributes.getNamedItem("jr_tot").value;
            var totaal = this.attributes.getNamedItem("totaal").value;
            $("#samenvatting").append('<tr><td>'+systeem+'</td><td>'+periode+'</td><td>'+totaal+'</td></tr>');
            });
}

function persoonGWS(response) {
    if ($(response).filterNode('izmede:gwsdossier').length == 0) {
        $("#tabs-uitkeringen").hide();
        $("#tab-uitkeringen").hide();
        return;
    } else {
        $("#tabs-uitkeringen").show();
        $("#tab-uitkeringen").show();
    }

    var tbody = '<tr><th>datum</th><th>betreft</th><th>dossier</th><th>veld</th><th>waarde</th></tr>';
    $(response).filterNode('izmede:gwsdossier').each(function() {
            dossier = this;

            var datum = datumOpmaak($($(dossier).filterNode('izmede:datum')[0]).text());
            var betreft = $($(dossier).filterNode('izmede:betreft')[0]).text();
            var dossierid = this.attributes.getNamedItem("id").value;
            var laatst = datumOpmaak($($(dossier).filterNode('izmede:datumlaatst')[0]).text());

            var keys = {'startdatum': true, 'einddatum': true, 'regeling': true, 'omschrijving': true, 'leefvorm': true, 'huisvesting': true, 'burgstaat': true, 'medewerker': true};
            var tbody_tmp = ''
            var velden = new Array();
            var rowspan = 1;

            $.each(keys, function(value, display) {
                var waarde = $($(dossier).filterNode('izmede:'+value)[0]).text();
                var row = '';
                if (waarde != '') {
                row = '<tr>';
                if (display === true) {
                row += '<td>'+value+'</td>';
                } else if (display === false) {
                row += '<td></td>';
                } else {
                row += '<td>'+display+'</td>';
                }
                if (value == 'startdatum' || value == 'einddatum') {
                    waarde = datumOpmaak(waarde);
                }
                row += '<td>'+waarde+'</td></tr>';
                rowspan += 1;
                }
                tbody_tmp += row;
                });

            tbody += '<tr><td rowspan="'+rowspan+'">'+datum+'</td><td rowspan="'+rowspan+'">'+betreft+'</td><td rowspan="'+rowspan+'">'+dossierid+'</td><td>datum laatst</td><td>'+laatst+'</td></tr>' + tbody_tmp;
    });
    $("#uitkeringen").html(tbody);
}

function persoonBSB(response) {
    if ($(response).filterNode('izmede:bsbdossier').length == 0) {
        $("#tabs-schuldhulp").hide();
        $("#tab-schuldhulp").hide();
    } else {
        $("#tabs-schuldhulp").show();
        $("#tab-schuldhulp").show();
    }

    var tbody = '<tr><th>datum</th><th>betreft</th><th>dossier</th><th>veld</th><th>waarde</th></tr>';
    $(response).filterNode('izmede:bsbdossier').each(function() {
            dossier = this;

            var datum = datumOpmaak($($(dossier).filterNode('izmede:datum')[0]).text());
            var betreft = $($(dossier).filterNode('izmede:betreft')[0]).text();
            var dossierid = this.attributes.getNamedItem("id").value;
            var aanvraag = datumOpmaak($($(dossier).filterNode('izmede:aanvraag')[0]).text());

            var keys = {'startdatum': true, 'einddatum': true, 'medewerker': true};
            var tbody_tmp = ''
            var velden = new Array();
            var rowspan = 1;

            $.each(keys, function(value, display) {
                var waarde = $($(dossier).filterNode('izmede:'+value)[0]).text();
                var row = '';
                if (waarde != '') {
                row = '<tr>';
                if (display === true) {
                row += '<td>'+value+'</td>';
                } else if (display === false) {
                row += '<td></td>';
                } else {
                row += '<td>'+display+'</td>';
                }
                if (value == 'startdatum' || value == 'einddatum') {
                    waarde = datumOpmaak(waarde);
                }
                row += '<td>'+waarde+'</td></tr>';
                rowspan += 1;
                }
                tbody_tmp += row;
                });

            tbody += '<tr><td rowspan="'+rowspan+'">'+datum+'</td><td rowspan="'+rowspan+'">'+betreft+'</td><td rowspan="'+rowspan+'">'+dossierid+'</td><td>aanvraag</td><td>'+aanvraag+'</td></tr>' + tbody_tmp;
    });
    $("#schuldhulp").html(tbody);
}

function persoonsDossier(bsn) {
    $('div#persoonsdossier_wrap').show();
    $('html, body').animate({ scrollTop: $('div#persoonsdossier_wrap').offset().top}, 1000);
    $('#persoonsdossier').tabs('select', 0);

    $.ajax({type:'GET', url: '/BSN/'+bsn, success: persoonGBA});
    $.ajax({type:'GET', url: '/SAMENVATTING/'+bsn, success: persoonSAMENVATTING});
    $.ajax({type:'GET', url: '/GWS/'+bsn, success: persoonGWS});
    $.ajax({type:'GET', url: '/BSB/'+bsn, success: persoonBSB});
    $.ajax({type:'GET', url: '/LPT/'+bsn, success: persoonLPT});
    return false;
}

function persoonPrint() {
    $('div#groepsdossier_wrap').hide();
    $('div#zoeken_wrap').hide();
    window.print();
    $('div#persoonsdossier_wrap').show();
    $('div#zoeken_wrap').show();
}

