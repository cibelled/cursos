# import libraries
import os
import sys
import argparse
import warnings
from dotenv import load_dotenv
from google_pub_sub import PubSub
from musics import Musics

# warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

# get env
load_dotenv()

# load variables
get_dt_rows = os.getenv("EVENTS")

# main
if __name__ == '__main__':

    # instantiate arg parse
    parser = argparse.ArgumentParser(description='python application for ingesting data & events into a data store')

    # add parameters to arg parse
    parser.add_argument('entity', type=str, choices=[
        'pubsub-music-events',
    ], help='entities')

    # invoke help if null
    args = parser.parse_args(args=None if sys.argv[1:] else ['--help'])

    # init variables
    musics_object_name = Musics().get_multiple_rows(get_dt_rows)

    # real-time data ingestion
    if sys.argv[1] == 'pubsub-music-events':
        PubSub().push_payload()