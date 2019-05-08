#!/usr/bin/env python
# coding: utf-8

# In[5]:


import requests
import pandas as pd
import json
from requests.exceptions import Timeout, RetryError
import logging
import sys
from pathlib import Path
from logging.config import dictConfig
from requests.packages.urllib3.util import Retry
from os.path import join, dirname, realpath
from dotenv import load_dotenv
import os
from json import JSONDecodeError
from requests.adapters import HTTPAdapter 


# In[6]:


#lecture du fichier .env pour récupérer les paramètres de config
dotenv_path = join(dirname(realpath('__file__')),'.env.path')
load_dotenv(dotenv_path)

urlAPI = os.getenv('URL_API')
csvPath = os.getenv('CSV_PATH')
jsonPath = os.getenv('JSON_PATH')
geojsonPath = os.getenv('GEOJSON_PATH')


# In[7]:


logging.basicConfig(format='%(process)d-%(levelname)s-%(message)s')

logger = logging.getLogger()
#les headers du json et geojson
headers_json = {"Content-Type" : "application/json"}
headers_geojson = {"Content-Type" : "application/json",
           "Accept" : "application/geo+json",
           "Cache-Control" : "no-cache"}

session = requests.Session()
#retry une seule fois si le status est 500, 503, 504 (est-ce que tu veux d'autres code status pour le force du retry ?)
session.mount('https://', HTTPAdapter(
    max_retries=Retry(total=1, status_forcelist=[500, 503, 504, 404])
    )
)
try:
    response_json = session.get(urlAPI,headers=headers_json, timeout=6)
    if response_json.status_code not in [200, 201, 202, 203, 204, 205, 206]:
        logger.error("le status du get est : " + str(response_json.status_code))
        sys.exit
    try:
        data_json = response_json.json()

        #suppression des propreties status, name et address du json
        for proprety in data_json:
            del proprety['name']
            del proprety['status']
            del proprety['address']

        json_to_df = pd.read_json(json.dumps(data_json))

        #écrire le résultat du json dans un csv
        json_to_df.to_csv(csvPath, encoding='utf-8', index=False)
        config = Path(csvPath) 
        if config.is_file():
            print('charger le fichier dans data gouv' + csvPath)
        else:
            #raise FileNotFoundError("fichier n'exsite pas ou n'a pas été créé")
            logger.error("fichier suivant : " + csvPath +" n'exsite pas ou n'a pas été créé")
            sys.exit

        #écrire le resultats de la requête http dans un fichier json
        with open(jsonPath, 'w') as f:
            #indent permet d'ajouter une nouvelle ligne et une tabulation
            json.dump(data_json, f, indent=3)
        #vérifier si le fichier a bien été crée si non on lance une exception
        config = Path(jsonPath) 
        if config.is_file():
            print('charger le fichier dans data gouv' + jsonPath)
        else:
            #raise FileNotFoundError("fichier n'exsite pas ou n'a pas été créé")
            logger.error("fichier suivant : " + jsonPath +" n'exsite pas ou n'a pas été créé")
            sys.exit
    except JSONDecodeError as e:
        logger.error("no data returned")
        logger.error(e)
        sys.exit
        
except Timeout as e:
    logger.error('le time out es dépassé')
    logger.error(e)
    sys.exit
    
except RetryError as e:
    logger.error('le serveur ne répond pas')
    logger.error(e)
    sys.exit
      
#est-ce que tu veux deux scripts différents pour le geojson et json (csv) ou je mets tous dans le même script ?
try:     
    response_geojson = session.get(urlAPI,headers=headers_geojson, timeout=6)
    if response_geojson.status_code not in [200, 201, 202, 203, 204, 205, 206]:
        logger.error("le status du get est : " + str(response_geojson.status_code))
        sys.exit
    try:
        data_geo_json = response_geojson.json()

        #suppression de user dans les résulats
        for prop in data_geo_json['features']:
            del prop['properties']['user']

        #écrire le resultats de la requête http dans un fichier json
        with open(geojsonPath, 'w') as f:
            #indent permet d'ajouter une nouvelle ligne et une tabulation
            json.dump(data_geo_json, f, indent=3)
        #vérifier si le fichier a bien été crée si non on lance une exception
        config = Path(geojsonPath) 
        if config.is_file():
            print('charger le fichier dans data gouv' + geojsonPath)
        else:
            logger.error("Le fichier suivant : "+ geojsonPath +" n'exsite pas ou n'a pas été créé")
    except JSONDecodeError as e:
        logger.error("no data returned")
        logger.error(e)
        sys.exit
except Timeout as e:
    logger.error('le time out es dépassé')
    logger.error(e)
    sys.exit
    
except RetryError as e:
    logger.error('le serveur ne répond pas')
    logger.error(e)
    sys.exit


# In[ ]:




