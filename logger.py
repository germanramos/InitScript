#! /usr/bin/env python

import logging
import logging.handlers
import sys

if len(sys.argv) != 4:
    print 'Usage: ' + sys.argv[0] + ' fileToLog bytesPerFile numberOfFiles'
    sys.exit()
    
LOG_FILENAME = sys.argv[1]
MAX_BYTES = sys.argv[2]
BACKUP_COUNT = sys.argv[3]

# Set up a specific logger with our desired output level
my_logger = logging.getLogger('MyLogger')
my_logger.setLevel(logging.DEBUG)

# Add the log message handler to the logger
handler = logging.handlers.RotatingFileHandler(
              LOG_FILENAME, maxBytes=int(MAX_BYTES), backupCount=int(BACKUP_COUNT))

my_logger.addHandler(handler)

try:
    for line in sys.stdin:
        my_logger.debug('%s', line.strip())
except KeyboardInterrupt:
    pass
