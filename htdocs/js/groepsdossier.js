var groepsdossier_id = null;
var groepsdossier_bsn = new Array();


function persoonPrint() {
    $('div#groepsdossier_wrap').hide();
    $('div#zoeken_wrap').hide();
    window.print();
    $('div#persoonsdossier_wrap').show();
    $('div#zoeken_wrap').show();
}

function groepPrint() {
    $('div#persoonsdossier_wrap').hide();
    $('div#zoeken_wrap').hide();
    window.print();
    $('div#persoonsdossier_wrap').show();
    $('div#zoeken_wrap').show();
}

function groepBSNToevoegen(bsn) {
    if (groepsdossier_bsn.length == 0) {
        $("#groep_personalia").find('tbody').html('<tr><th class="noprint" style="border: 0px; padding: 0px;"></th><th>bsn</th><th>naam</th><th>geboren</th><th>lftd</th><th>mv</th><th>burg.<br/>staat</th><th>aantal<br/>huw</th><th>aantal<br/>scheid</th><th>aantal<br/>kind</th></tr>');
    }

    if (groepsdossier_bsn.indexOf(bsn) < 0) {
        $("div#groepsdossier_wrap").show();
        groepsdossier_bsn.push(bsn);
        $.ajax({type:'GET', url: '/BSN/'+bsn, success: groepPRS});
    }
    return false;
}

function groepRelaties(response, target) {
    if ($($(response).filterNode('SectorModel:PRSPRSOUD')).filterNode('SectorModel:PRS').length > 0) {
        $(target).append('<tr><th>Ouders</th></tr>');
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
                        bsntd = '<td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td>';
                    } else {
                        bsntd = '<td></td>';
                    }

                    $(target).append('<tr class="grpoud_'+bsn+'">'+bsntd+'</td><td>'+geb+'</td><td>'+naam+'</td><td>'+mv+'</td><td>'+adres+'</td></tr>');

                    if (bsn != '') {
                        $.ajax({type:'GET', url: '/BSNKORT/'+bsn, success: function(xml) { return updatePRSInline2(xml, 'grpoud_'+bsn); }});
                    }
                });
        });
        $(target).append('<tr><td style="border: 0px; padding: 0px;">&nbsp;</td></tr>');
    }

    if ($($(response).filterNode('SectorModel:PRSPRSKND')).filterNode('SectorModel:PRS').length > 0) {
        $(target).append('<tr><th>Kinderen</th></tr>');
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
                        bsntd = '<td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td>';
                    } else {
                        bsntd = '<td></td>';
                    }

                    $(target).append('<tr class="knd_'+bsn+'">'+bsntd+'</td><td>'+geb+'</td><td>'+naam+'</td><td>'+mv+'</td><td>'+adres+'</td></tr>');
                    if (bsn != '') {
                        $.ajax({type:'GET', url: '/BSNKORT/'+bsn, success: function(xml) { return updatePRSInline2(xml, 'knd_'+bsn); }});
                    }
                });
        });
        $(target).append('<tr><td style="border: 0px; padding: 0px;">&nbsp;</td></tr>');
    }

    if ($($(response).filterNode('SectorModel:PRSPRSHUW')).filterNode('SectorModel:PRS').length > 0) {
        $(target).append('<tr><th>Huwelijken</th></tr>');
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

                    if (bsn != '') {
                        bsntd = '<td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td>';
                    } else {
                        bsntd = '<td></td>';
                    }

                    $(target).append('<tr>'+bsntd+'</td><td>'+geb+'</td><td>'+naam+'</td><td>'+mv+'</td><td class="huw_'+bsn+'">'+adres+'</td><td>'+van+'</td><td>'+tot+'</td><td>'+soort+'</td></tr>');

                    if (bsn != '') {
                        $.ajax({type:'GET', url: '/BSNKORT/'+bsn, success: function(xml) { return updateADRInline(xml, 'huw_'+bsn); }});
                    }
                });
        });
        $(target).append('<tr><td style="border: 0px; padding: 0px;">&nbsp;</td></tr>');
    }
}

function groepUitkering(response, target) {
    if ($(response).filterNode('izmede:gwsdossier').length > 0) {
        $(target).append('<tr><th>Uitkering</th></tr>');
        $(response).filterNode('izmede:gwsdossier').each(function() {
                dossier = this;
                var datum = datumOpmaak($($(dossier).filterNode('izmede:datum')[0]).text());
                var betreft = $($(dossier).filterNode('izmede:betreft')[0]).text();
                var omschrijving = $($(dossier).filterNode('izmede:omschrijving')[0]).text();

                $(target).append('<tr><td>'+datum+'</td><td>'+betreft+'</td><td>'+omschrijving+'</td></tr>');
        });
        $(target).append('<tr><td style="border: 0px; padding: 0px;">&nbsp;</td></tr>');
    }
}

function groepSchuldhulp(response, target) {
    if ($(response).filterNode('izmede:bsbdossier').length > 0) {
        $(target).append('<tr><th>Schuldhulp</th></tr>');
        $(response).filterNode('izmede:bsbdossier').each(function() {
                dossier = this;
                var datum = datumOpmaak($($(dossier).filterNode('izmede:datum')[0]).text());
                var betreft = $($(dossier).filterNode('izmede:betreft')[0]).text();

                $(target).append('<tr><td>'+datum+'</td><td>'+betreft+'</td></tr>');
        });
        $(target).append('<tr><td style="border: 0px; padding: 0px;">&nbsp;</td></tr>');
    }
}

function groepLeerplicht(response, target) {
    if ($(response).filterNode('izmede:lptdossier').length > 0) {
         $(target).append('<tr><th>Leerplicht</th></tr>');
         $(response).filterNode('izmede:lptdossier').each(function() {
              lptdossier = this;
              var datum = datumOpmaak($($(lptdossier).filterNode('izmede:datum')[0]).text());
                   var betreft = $($(lptdossier).filterNode('izmede:betreft')[0]).text();
                    var reden = $($(lptdossier).filterNode('izmede:reden')[0]).text();

                    $(target).append('<tr><td>'+datum+'</td><td>'+betreft+'</td><td>'+reden+'</td></tr>');
            });
        $(target).append('<tr><td style="border: 0px; padding: 0px;">&nbsp;</td></tr>');
    }
}

function groepSamenvatting(bsn, target) {
    $.ajax({type:'GET', url: '/GWS/'+bsn, success: function(xml) { return groepUitkering(xml, target); }});
    $.ajax({type:'GET', url: '/BSB/'+bsn, success: function(xml) { return groepSchuldhulp(xml, target); }});
    $.ajax({type:'GET', url: '/LPT/'+bsn, success: function(xml) { return groepLeerplicht(xml, target); }});
}

function groepNieuw() {
    groepsdossier_id = null;
    groepsdossier_bsn = new Array();
    $("#groep_personalia").find('tbody').empty();
    $("#groepsdossier-samenvatting").hide();
    $("#gdtab-samenvatting").hide();
    $("#groep_bronsystemen").find('tbody').empty();
    $("#groep_bronpersonen").find('tbody').empty();
    $("#groepsdossier-personen").empty();
}

function groepPRS(response) {
    $($(response).filterNode('SectorModel:PRS')[0]).each(function() {
        var persoon = this;
        var kinderen = 0;
        var huwelijk = 0;
        var scheiding = 0;
        var burgstaat = '';

        $($(persoon).filterNode('SectorModel:PRSPRSKND')).each(function() { $(this).filterNode('SectorModel:PRS').each(function() { kinderen += 1; }); });
        $($(persoon).filterNode('SectorModel:PRSPRSHUW')).each(function() { 
            if ($($(this).filterNode('SectorModel:datumOntbinding')[0]).text() != '') {
                scheiding += 1;
            }
            $(this).filterNode('SectorModel:PRS').each(function() { huwelijk += 1; }); 
        });

        var bsn   = $($(persoon).filterNode('SectorModel:bsn-nummer')[0]).text();
        var naam  = $($(persoon).filterNode('SectorModel:voorvoegselGeslachtsnaam')[0]).text() + ' ' +
                    $($(persoon).filterNode('SectorModel:geslachtsnaam')[0]).text() + ', ' +
                    $($(persoon).filterNode('SectorModel:voornamen')[0]).text();
        var geb   = $($(persoon).filterNode('SectorModel:geboortedatum')[0]).text();
        var leeftijd = getAge(geb);
        geb = datumOpmaak(geb);
        var mv    = $($(persoon).filterNode('SectorModel:geslachtsaanduiding')[0]).text();

        if (kinderen > 0) {
            mv += '+';
        }

        var adres = $($(persoon).filterNode('SectorModel:straatnaam')[0]).text() + ' ' +
                    $($(persoon).filterNode('SectorModel:huisnummer')[0]).text() + ' ' +
                    $($(persoon).filterNode('SectorModel:huisletter')[0]).text() + ' ' +
                    $($(persoon).filterNode('SectorModel:huisnummertoevoeging')[0]).text() + '<br />' +
                    $($(persoon).filterNode('SectorModel:postcode')[0]).text() + ' ' + 
                    $($(persoon).filterNode('SectorModel:woonplaatsnaam')[0]).text();
        
        $($(persoon).filterNode('SectorModel:extraElementen')[0]).filterNode('StUF:extraElement').each(function() {
            var naam = this.attributes.getNamedItem("naam").value;
            if (naam == 'omschrijvingBurgerlijkeStaat') {
                burgstaat = $(this).text();
            }
        });

        var datumoverlijden = datumOpmaak($($(persoon).filterNode('SectorModel:datumOverlijden')[0]).text());
        if (datumoverlijden != '') {
            burgstaat = 'Overleden';
        }

        $("td.bsnnaam_"+bsn).html(naam);

        $("#groep_personalia").find('tbody').append('<tr><td class"noprint" style="border: 0px; padding: 0px;"><button title="Toon persoonsdossier" class="ui-state-default ui-corner-all" onclick="return persoonsDossier('+bsn+');"><span class="ui-icon ui-icon-document"></span></button></td><td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td><td>'+naam+'</td><td>'+geb+'</td><td>'+leeftijd+'</td><td>'+mv+'</td><td>'+burgstaat+'</td><td>'+huwelijk+'</td><td>'+scheiding+'</td><td>'+kinderen+'</td><td class"noprint" style="border: 0px; padding: 0px;"><button title="Toon persoonsdossier" class="ui-state-default ui-corner-all" onclick="return groepVerwijderBSN('+bsn+');"><span class="ui-icon ui-icon-trash"></span></button></td></tr>');

        $("#groepsdossier-personen").append('<div><div id="grpprs_'+bsn+'"></div><table style="margin-top: 1em;" class="overzicht"><tbody id="grprel_'+bsn+'" /></table><table style="margin-top: 1em;" class="overzicht"><tbody id="grpsam_'+bsn+'" /></table></div><hr />');
        persoonTabGBA(response, '#grpprs_'+bsn);
        groepRelaties(response, '#grprel_'+bsn);
        groepSamenvatting(bsn, '#grpsam_'+bsn);
    });
}

function groepLaden(response) {
    $("#groepsdossier-personen").empty();
    $('#groepsdossier').tabs('select', 0);
    $("#groepsdossier_wrap").show();
    $('html, body').animate({ scrollTop: $('#groepsdossier_wrap').offset().top}, 1000);

    $("#groep_personalia").find('tbody').html('<tr><th class="noprint" style="border: 0px; padding: 0px;"></th><th>bsn</th><th>naam</th><th>geboren</th><th>lftd</th><th>mv</th><th>burg.<br/>staat</th><th>aantal<br/>huw</th><th>aantal<br/>scheid</th><th>aantal<br/>kind</th></tr>');

    $("#groep_alias").html("Groepsdossier: "+$(response).filterNode('izmede:groepsdossier')[0].attributes.getNamedItem("alias").value);

    groepsdossier_bsn = new Array();
    rows = '';
    $("#groep_bronsystemen").find('tbody').html('<tr><th>Systeem</th><th>Periode</th><th>Totaal</th></tr>');
        $(response).filterNode('izmede:bron').each(function() {
                systeem = this.attributes.getNamedItem("systeem").value;
                jr_van = this.attributes.getNamedItem("jr_van").value;
                jr_tot = this.attributes.getNamedItem("jr_tot").value;
                totaal = this.attributes.getNamedItem("totaal").value;
                $("#groep_bronsystemen").find('tbody').append('<tr><td>'+systeem+'</td><td>'+jr_van+' - '+jr_tot+'</td><td>'+totaal+'</td></tr>');
                });

    $("#groep_bronpersonen").find('tbody').html('<tr><th>Naam</th><th>Periode</th><th>GWS</th><th>BSB</th><th>LPT</th><th>Totaal</th></tr>');
        $(response).filterNode('izmede:bronprs').each(function() {
                bsn = this.attributes.getNamedItem("bsn").value;
                jr_van = this.attributes.getNamedItem("jr_van").value;
                jr_tot = this.attributes.getNamedItem("jr_tot").value;
                lpt = this.attributes.getNamedItem("lpt").value;
                gws = this.attributes.getNamedItem("gws").value;
                bsb = this.attributes.getNamedItem("bsb").value;
                totaal = this.attributes.getNamedItem("totaal").value;
                $("#groep_bronpersonen").find('tbody').append('<tr><td class="bsnnaam_'+bsn+'">'+bsn+'</td><td>'+jr_van+' - '+jr_tot+'</td><td>'+gws+'</td><td>'+bsb+'</td><td>'+lpt+'</td><td>'+totaal+'</td></tr>');
                });
    
    $(response).filterNode('izmede:prs').each(function() {
            bsn = this.attributes.getNamedItem("bsn").value;
            groepsdossier_bsn.push(bsn);
            $.ajax({type:'GET', url: '/BSN/'+bsn, success: groepPRS});
            });


    $("#groepsdossier-samenvatting").show();
    $("#gdtab-samenvatting").show();
}

function groepLadenId(id) {
    groepsdossier_id = id;
    $.ajax({type:'GET', url: '/GROEP/'+id, success: groepLaden});
}

function groepOpslaan(bsn) {
    if (groepsdossier_bsn.length > 0) {
        var naam = prompt("Naam van het groepsdossier","");
        if (naam != null && naam != '') {
            var my_groepsdossier = {'naam': naam, 'bsn': groepsdossier_bsn};
            $.ajax({type:'POST', url: '/GROEP/', data: my_groepsdossier, success: function(response) {
                    groepLaden(response);
                    }
                    });
        }
    } else {
        alert("Groep is leeg! Groep wordt niet opgeslagen.");
    }
    return false;
}

function groepVerwijderen() {
    if (groepsdossier_id !== null) {
        var answer = confirm("Weet u zeker dat u dit groepsdossier wilt verwijderen?");
        if (answer == true) {
            $.ajax({type:'GET', url: '/GROEPDEL/'+groepsdossier_id, success: function(response) {
                    groepsdossier_id = null;
                    }
                    });
        }
    } else {
        alert("Geen groep geselecteerd! Groep kan niet worden verwijderd.");
    }
    return false;
}

function groepVerwijderBSN(bsn) {
    if (groepsdossier_id !== null) {
        var answer = confirm("Weet u zeker dat u BSN "+bsn+" wilt verwijderen?");
        if (answer == true) {
            $.ajax({type:'GET', url: '/GROEPDELBSN/'+groepsdossier_id+'/'+bsn, success: function(response) { groepLadenId(groepsdossier_id); } });
        }
    } else {
        alert("Geen groep geselecteerd! BSN kan niet worden verwijderd.");
    }
    return false;
}

