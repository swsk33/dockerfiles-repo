#!/bin/bash
cd /nacos/bin
bash ./startup.sh -m standalone
tail -f /nacos/logs/start.out
