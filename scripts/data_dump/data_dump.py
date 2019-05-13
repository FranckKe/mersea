 #!/usr/bin/env python
# coding: utf-8

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

dotenv_path = join(dirname(realpath('__file__')), '.env')
load_dotenv(dotenv_path)

URL_API = os.getenv('URL_API')
DATA_DIR = path("./data")
MAX_RETRY = 5
TIMEOUT = 5

# TODO
# - Use path concatenation and/or os.path.join (ctrl+f path)
# - Add base url to photos url in tracers data
# - Create function for each calls (reports(json), reports(geojson), tracers, upload_file)

logging.basicConfig(format='%(process)d-%(levelname)s-%(message)s')

logger = logging.getLogger()
headers_json = {"Content-Type": "application/json"}
headers_geojson = {"Content-Type": "application/json",
                   "Accept": "application/geo+json",
                   "Cache-Control": "no-cache"}

session = requests.Session()
session.mount(HTTPAdapter(max_retries=MAX_RETRY))

try:
    response_json = session.get(
        URL_API + "/reports", headers=headers_json, timeout=TIMEOUT).raise_for_status()
    try:
        json_reports = response_json.json()

        logger.info("Json reports downloaded")

        # Anonymize data
        for proprety in json_reports:
            del proprety['name']
            del proprety['status']
            del proprety['address']

        json_to_df = pd.read_json(json.dumps(json_reports))

        json_to_df.to_csv(path("DATA_DIR", "/reports.csv"),
                          encoding='utf-8', index=False)

        with open(path("DATA_DIR", "reports.json"), 'w') as f:
            json.dump(json_reports, f)

        logger.info("Json reports written to disk")

    except JSONDecodeError as e:
        logger.error("Empty response during reports retrieval")
        logger.error(e)
        sys.exit

except:
    logger.error('Error during json reports retrieval')
    logger.error(e)
    sys.exit


try:
    response_geojson = session.get(
        URL_API + "/reports", headers=headers_geojson, timeout=TIMEOUT).raise_for_status
    try:
        geojson_reports = response_geojson.json()

        logger.info("Geojson reports downloaded")

        # Anonymize data
        for prop in geojson_reports['features']:
            del prop['properties']['user']

        with open(path("DATA_DIR", "reports.geojson"), 'w') as file:
            json.dump(geojson_reports, file)

        logger.info("Geojson reports written to disk")

    except JSONDecodeError as e:
        logger.error("Empty response during geosjon reports retrieval")
        logger.error(e)
        sys.exit
except:
    logger.error('Error during geojson reports retrieval')
    logger.error(e)
    sys.exit

try:
    tracers_response = session.get(
        URL_API + "/tracers", headers=json_reports, timeout=TIMEOUT).raise_for_status
    try:
        json_tracers = tracers_response.json()

        logger.info("Json tracers downloaded")

        # Remove useless data
        for proprety in json_reports:
            del proprety['color']

        # TODO Add url to each photo

        with open(path("DATA_DIR", "reports.geojson"), 'w') as file:
            json.dump(json_tracers, file)

        logger.info("Tracers reports written to disk")

    except JSONDecodeError as e:
        logger.error("Empty response during json tracers retrieval")
        logger.error(e)
        sys.exit
except:
    logger.error('Error during json tracers retrieval')
    logger.error(e)
    sys.exit

# For json and csv in path("DATA_DIR")
    # Upload file on data gouv
