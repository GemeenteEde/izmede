$.fn.filterNode = function(name) {
    return this.find('*').filter(function() {
            return this.nodeName === name;
    });
};

function stufAdres2(response) {
    var adresBinnenlandOpgemaakt1 = '';
    var adresBinnenlandOpgemaakt2 = '';
    var postcode = $($(response).filterNode('SectorModel:postcode')[0]).text();
    var huisnummer = $($(response).filterNode('SectorModel:huisnummer')[0]).text();
    var adres = '';

    $($($(response).filterNode('SectorModel:ADR')).filterNode('SectorModel:extraElementen')[0]).filterNode('StUF:extraElement').each(function() {
        var naam = this.attributes.getNamedItem("naam").value;
        if (naam == 'adresBinnenlandOpgemaakt1') {
            adresBinnenlandOpgemaakt1 = $(this).text();
        } else if (naam == 'adresBinnenlandOpgemaakt2') {
            adresBinnenlandOpgemaakt2 = $(this).text();
        }
    });

    if (adresBinnenlandOpgemaakt1 == '' || adresBinnenlandOpgemaakt2 == '') {
            var straat = $($(response).filterNode('SectorModel:straatnaam')[0]).text();
           if (straat != '') {
                adres = straat + ' ' + huisnummer + ' ' +
                $($(response).filterNode('SectorModel:huisletter')[0]).text() + ' ' +
                $($(response).filterNode('SectorModel:huisnummertoevoeging')[0]).text() + ', ' +
                postcode + ' ' + 
                $($(response).filterNode('SectorModel:woonplaatsnaam')[0]).text();
            }
    } else {
        adres = adresBinnenlandOpgemaakt1 + ', ' + adresBinnenlandOpgemaakt2;
    }

    return new Array(adres, postcode, huisnummer);

}

function stufAdres(response) {
    var adresBinnenlandOpgemaakt1 = '';
    var adresBinnenlandOpgemaakt2 = '';
    var adres = '';

    $($($(response).filterNode('SectorModel:ADR')).filterNode('SectorModel:extraElementen')[0]).filterNode('StUF:extraElement').each(function() {
        var naam = this.attributes.getNamedItem("naam").value;
        if (naam == 'adresBinnenlandOpgemaakt1') {
            adresBinnenlandOpgemaakt1 = $(this).text();
        } else if (naam == 'adresBinnenlandOpgemaakt2') {
            adresBinnenlandOpgemaakt2 = $(this).text();
        }
    });

    if (adresBinnenlandOpgemaakt1 == '' || adresBinnenlandOpgemaakt2 == '') {
            straat = $($(response).filterNode('SectorModel:straatnaam')[0]).text();
            if (straat != '') {
                adres = straat + ' ' +
                $($(response).filterNode('SectorModel:huisnummer')[0]).text() + ' ' +
                $($(response).filterNode('SectorModel:huisletter')[0]).text() + ' ' +
                $($(response).filterNode('SectorModel:huisnummertoevoeging')[0]).text() + ', ' +
                $($(response).filterNode('SectorModel:postcode')[0]).text() + ' ' + 
                $($(response).filterNode('SectorModel:woonplaatsnaam')[0]).text();
            }
    } else {
        adres = adresBinnenlandOpgemaakt1 + ', ' + adresBinnenlandOpgemaakt2;
    }

    return adres;
}

function datumOpmaak(geboren) {
    if (geboren == '')
        return geboren;
    return geboren.substring(6,8) + '-' + geboren.substring(4,6) + '-' + geboren.substring(0,4);
}

if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function (searchElement /*, fromIndex */ ) {
        "use strict";
        if (this == null) {
            throw new TypeError();
        }
        var t = Object(this);
        var len = t.length >>> 0;
        if (len === 0) {
            return -1;
        }
        var n = 0;
        if (arguments.length > 0) {
            n = Number(arguments[1]);
            if (n != n) { // shortcut for verifying if it's NaN
                n = 0;
            } else if (n != 0 && n != Infinity && n != -Infinity) {
                n = (n > 0 || -1) * Math.floor(Math.abs(n));
            }
        }
        if (n >= len) {
            return -1;
        }
        var k = n >= 0 ? n : Math.max(len - Math.abs(n), 0);
        for (; k < len; k++) {
            if (k in t && t[k] === searchElement) {
                return k;
            }
        }
        return -1;
    }
}

function getAge(birthDateStr) {
  if (birthDateStr == '') {
    return;
  }

  var now = new Date();
  var parts = birthDateStr.match(/(\d{4})(\d{2})(\d{2})/);
  var birthDate = new Date(parts[1], parts[2]-1, parts[3]);

  function isLeap(year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  // days since the birthdate    
  var days = Math.floor((now.getTime() - birthDate.getTime())/1000/60/60/24);
  var age = 0;
  // iterate the years
  for (var y = birthDate.getFullYear(); y <= now.getFullYear(); y++){
    var daysInYear = isLeap(y) ? 366 : 365;
    if (days >= daysInYear){
      days -= daysInYear;
      age++;
      // increment the age only if there are available enough days for the year.
    }
  }
  return age;
}
