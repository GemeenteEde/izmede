#!/bin/sh
export PATH=/path/to/base/bin:$PATH
cd /path/to/izmede-stuf
uwsgi -s 127.0.0.1:1233 -w groepdossier
