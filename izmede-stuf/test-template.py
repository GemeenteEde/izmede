import sys
import re
import codecs
from time import localtime, strftime
from pysimplesoap.client import SoapClient
from pysimplesoap.simplexml import SimpleXMLElement

from const import soap_location, soap_action, soap_key, soap_cert

def leesTemplate(bestandsnaam):
    return codecs.open(bestandsnaam, 'r', 'UTF-8').read()

def testTemplate(bestandsnaam, variabelen):
    template = leesTemplate(bestandsnaam) 
    return template % variabelen

def notfound(start_response):
    start_response('404 File Not Found', COMMON_HEADERS + [('Content-length', '2')])
    yield '<notfound />'


bsn = sys.argv[2]
variabelen  = {'BSN_van': bsn, 'BSN_tot': bsn, 'tijdstipbericht': strftime("%Y%m%d%H%M%S00", localtime()), 'referentienummer': '0'}
vraag = testTemplate(sys.argv[1], variabelen)

client = SoapClient(
    namespace = "http://www.egem.nl/StUF/sector/bg/0204", soap_ns='soap', trace = True, ns = 'SectorModel',
    location = soap_location, action = soap_action, key = soap_key, cert = soap_cert)

vraagBericht = SimpleXMLElement(vraag)

response = client.call('vraagBericht',vraagBericht)
#reply = response.as_xml()
