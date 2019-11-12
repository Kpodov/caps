#!/bin/bash
# Change the IP address to lure's and change 'health' to the lure type
rsync -arvRtu --delete rsync://ubuntu@3.134.137.46/logs ~/logs/health
