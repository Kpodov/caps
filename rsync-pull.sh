#!/bin/bash
# Change the IP address to lure's and change 'health' to the lure type
rsync -rtu --delete rsync://ubuntu@3.133.213.19/logs ~/logs/health
