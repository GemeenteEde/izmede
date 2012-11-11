# In dit bestand dienen de juiste certificaten te worden ingesteld om met
# de Gemeentelijke Basis Administratie "De Makelaar" via SOAP te communiceren.
soap_key='ssl/jouwcertificaat.pem'
soap_cert='ssl/jouwcertificaat.pem'

soap_location = "https://makelaar/Webservices/services/StUFBGSynchroon"
soap_action = 'https://makelaar/Webservices/services/StUFBGSynchroon'

# Configureer hier de database, gebruikersnaam en wachtwoord
pg_connect="dbname=izm"
