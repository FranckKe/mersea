#!/usr/bin/env python
# coding: utf-8

def dump_json_reports(headers_json, URL_API, DATA_DIR, session):
    try:
        response_json = session.get(
            URL_API + "/reports", headers=headers_json, timeout=TIMEOUT)
        try:
            json_reports = response_json.json()

            logger.info("Json reports downloaded")

            # Anonymize data
            for proprety in json_reports:
                del proprety['name']
                del proprety['status']
                del proprety['address']

            json_to_df = pd.read_json(json.dumps(json_reports))

            json_to_df.to_csv(Path(DATA_DIR, "reports.csv"),
                              encoding='utf-8', index=False)

            with open(Path(DATA_DIR, "reports.json"), 'w') as f:
                json.dump(json_reports, f, indent=3)

            logger.info("Json reports written to disk")

        except JSONDecodeError as e:
            logger.error("Empty response during reports retrieval")
            logger.error(e)
            sys.exit

    except Exception as e:
        logger.error('Error during json reports retrieval')
        logger.error(e)
        sys.exit
        
def dump_geojson_reports(headers_geojson, URL_API, DATA_DIR, session):
    try:
        response_geojson = session.get(
            URL_API + "/reports", headers=headers_geojson, timeout=TIMEOUT)
        try:
            geojson_reports = response_geojson.json()

            logger.info("Geojson reports downloaded")

            # Anonymize data
            for prop in geojson_reports['features']:
                del prop['properties']['user']

            with open(Path(DATA_DIR, "reports.geojson"), 'w') as file:
                json.dump(geojson_reports, file, indent=3)

            logger.info("Geojson reports written to disk")

        except JSONDecodeError as e:
            logger.error("Empty response during geosjon reports retrieval")
            logger.error(e)
            sys.exit
    except Exception as e:
        logger.error('Error during geojson reports retrieval')
        logger.error(e)
        sys.exit
        
def dump_tracers(headers_json, URL_API, DATA_DIR, session):
    try:
        tracers_response = session.get(
            URL_API + "/tracers", headers=headers_json, timeout=TIMEOUT)
        try:
            json_tracers = tracers_response.json()

            logger.info("Json tracers downloaded")

            # Remove useless data and update the photo column
            for proprety in json_tracers:
                del proprety['color']
                proprety['photo'] = URL_API + proprety['photo']


            json_to_df = pd.read_json(json.dumps(json_tracers))

            json_to_df.to_csv(Path(DATA_DIR, "tracers.csv"),
                              encoding='utf-8', index=False)

            with open(Path(DATA_DIR, "tracers.json"), 'w') as file:
                json.dump(json_tracers, file, indent=3)

            logger.info("Tracers reports written to disk")

        except JSONDecodeError as e:
            logger.error("Empty response during json tracers retrieval")
            logger.error(e)
            sys.exit
    except Exception as e:
        logger.error('Error during json tracers retrieval')
        logger.error(e)
        sys.exit

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
from pathlib import Path

dotenv_path = join(dirname(realpath('__file__')), '.env.sample')
load_dotenv(dotenv_path)

URL_API = os.getenv('URL_API')
DATA_GOUV_URL_API = os.getenv('DATA_GOUV_URL_API')
DATASET = os.getenv('DATASET')
API_KEY = os.getenv('API_KEY')

DATA_DIR = Path("./data")
MAX_RETRY = 5
TIMEOUT = 5

logging.basicConfig(format='%(process)d-%(levelname)s-%(message)s')

logger = logging.getLogger()
headers_json = {"Content-Type": "application/json"}
headers_geojson = {"Content-Type": "application/json",
                  "Accept": "application/geo+json",
                  "Cache-Control": "no-cache"}
HEADERS = {
   'X-API-KEY': API_KEY,
   "Content-Type": "application/json"
}
session = requests.Session()
session.mount('https://',HTTPAdapter(max_retries=MAX_RETRY))


dump_json_reports(headers_json=headers_json, URL_API=URL_API, DATA_DIR=DATA_DIR, session=session)
dump_geojson_reports(headers_geojson=headers_geojson, URL_API=URL_API, DATA_DIR=DATA_DIR, session=session)
dump_tracers(headers_json=headers_json, URL_API=URL_API, DATA_DIR=DATA_DIR, session=session)


resources = {}
resources["reports.json"] = os.getenv('JSON_REPORTS_RESOURCE')
resources["reports.geojson"] = os.getenv('GEOJSON_REPORTS_RESOURCE') 
resources["reports.csv"] = os.getenv('CSV_REPORTS_RESOURCE') 
resources["tracers.csv"] = os.getenv('CSV_TRACERS_RESOURCE') 
resources["tracers.json"] = os.getenv('JSON_TRACERS_RESOURCE')

headers = {
    'X-API-KEY': "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjoiNTdmY2ZkYTg4OGVlMzg1ZTAyNWZmNDkwIiwidGltZSI6MTU1NTYwMDU3Mi4wNjU4ODF9.7dNaLM2ldkfinJFSsUOoLUIgLLDQFIiU88EZDQkvzRY"
}
for key, value in resources.items():
    url = DATA_GOUV_URL_API + '/datasets/{}/resources/{}/upload/'.format(DATASET, value)
    response = requests.request("POST", url, files={'file': open(Path(DATA_DIR,key), 'rb')},
                                headers=headers)   

