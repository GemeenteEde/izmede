function zoekGROEPALIAS(form, needle) {
    if (needle !== undefined) {
        $(form).find('.search').val(needle);
    } else {
        needle = $(form).find('.search').val();
    }

    var form_id = $(form).attr('id');
    $("#accordion").accordion({event: "mouseover", active: accordion_index[form_id] });

    $(form).find('.form_result tbody').html('<tr><td>zoeken...</td></tr>');

    $.ajax({type:'GET', url: '/'+form_id+'/'+needle, dataType: 'xml', success: function(response) {
            var tbl_body = '';
            $(response).filterNode("izmede:groepsdossier").each(function() {
                tbl_row = '<td><a href="#groepsdossier-1" onClick="javascript:groepLadenId('+this.attributes.getNamedItem("id").value+');return false;">'+this.attributes.getNamedItem("alias").value+'</a></td>';
                tbl_body += '<tr>'+tbl_row+'</tr>';
                });
            $(form).find('.form_result tbody').html(tbl_body);                
            }});
    return false;
}

function zoekPC(form) {
    var postcode = $(form).find('.postcode').val();
    var huisnummer = $(form).find('.huisnummer').val();
    if (postcode != '' && huisnummer != '') {
        needle = $(form).find('.postcode').val() + '/' + $(form).find('.huisnummer').val();
        return zoekSTUF(form, needle);
    }
    return;
}

function zoekPCHN(postcode, huisnummer) {
    form = '#PC';
    $(form).find('.postcode').val(postcode);
    $(form).find('.huisnummer').val(huisnummer);
    if (postcode != '' && huisnummer != '') {
        needle = $(form).find('.postcode').val() + '/' + $(form).find('.huisnummer').val();
        return zoekSTUF(form, needle);
    }
}

function zoekSTUF(form, needle) {
    var form_id = $(form).attr('id');
    if (needle !== undefined) {
        $(form).find('.search').val(needle);
    } else {
        needle = $(form).find('.search').val();
        if (needle == '') return false;
    }

    if (form_id == 'GD') {
        datum = needle.replace(/-/g, '');
        datum = datum.substring(4,8) + datum.substring(2,4) + datum.substring(0,2);
        needle = datum;
    } else if (form_id == 'PC') {
        needle = needle.replace(/ /g, '');
    }

    $("#accordion").accordion({event: "mouseover", active: accordion_index[form_id] });

    $(form).find('.form_result tbody').html('<tr><td>zoeken...</td></tr>');

    $.ajax({type:'GET', url: '/'+form_id+'/'+needle, dataType: 'xml', success: function(response) {
            if (form_id == 'BSN') {
                $(form).find('.form_result tbody').html('<tr><th colspan="2"></th><th>bsn</th><th>geboren</th><th>MV</th><th>naam</th><th>adres</th><th>relatie</th></tr>');
            } else {
                $(form).find('.form_result tbody').html('<tr><th colspan="2"></th><th>bsn</th><th>geboren</th><th>MV</th><th>naam</th><th>adres</th></tr>');
            }

            $(response).filterNode('SectorModel:PRS').each(function() {
                var persoon = this;
                var bsn     = $($(persoon).filterNode('SectorModel:bsn-nummer')[0]).text();
                var naam    = $($(persoon).filterNode('SectorModel:voorvoegselGeslachtsnaam')[0]).text() + ' ' +
                $($(persoon).filterNode('SectorModel:geslachtsnaam')[0]).text() + ', ' +
                $($(persoon).filterNode('SectorModel:voornamen')[0]).text();
                var geb     = datumOpmaak($($(persoon).filterNode('SectorModel:geboortedatum')[0]).text());
                var mv      = $($(persoon).filterNode('SectorModel:geslachtsaanduiding')[0]).text();
                var adres2  = stufAdres2(persoon);
                var tbl_row  = '';

                if (bsn != '') {
                    tbl_row += '<td><button title="Selecteer persoon" class="ui-state-default ui-corner-all" onclick="return groepBSNToevoegen('+bsn+');"><span class="ui-icon ui-icon-pin-s"></span></button></td><td><button title="Toon persoonsdossier" class="ui-state-default ui-corner-all" onclick="return persoonsDossier('+bsn+');"><span class="ui-icon ui-icon-document"></span></button></td><td><a onClick="javascript:zoekSTUF(\'#BSN\','+bsn+');return false;" href="#BSN">'+bsn+'</a></td>';
                } else {
                    tbl_row += '<td colspan="3"></td>';
                }
                
                tbl_row += '<td><a onClick="javascript:zoekSTUF(\'#GD\',\''+geb.replace(/-/g,'')+'\');return false;" href="#GD">'+geb+'</a></td>' +
                           '<td>'+mv+'</td><td>'+naam+'</td><td><a onClick="javascript:zoekPCHN(\''+adres2[1]+'\',\''+adres2[2]+'\');return false;" href="#PC">'+adres2[0]+'</a></td>';

                if (form_id == 'BSN') {
                    tbl_row += '<td>'+prs_relaties[persoon.parentNode.tagName]+'</td>';
                }

                $(form).find('.form_result tbody').append('<tr>'+tbl_row+'</tr>');
            });
    }, error: function() { $(form).find('.form_result tbody').html('<tr><td>Helaas is het zoeken mislukt.</td></tr>'); } });
    return false;
}
