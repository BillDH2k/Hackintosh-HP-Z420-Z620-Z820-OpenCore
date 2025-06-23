#!/bin/sh

#  Script.sh
#  helionx
#
#  Created by Theodore Vaida - Astek on 10/2/12.
#  Copyright (c) 2012 com.astekcorp. All rights reserved.

if [ -e /tmp/helion_licenses.bin ]; then
    ./helion_activation_tool --unsave /tmp/helion_licenses.bin --write
    /bin/rm /tmp/helion_licenses.bin
fi
exit 0