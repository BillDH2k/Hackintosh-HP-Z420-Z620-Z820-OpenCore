#!/bin/sh

#  save_licenses.sh
#  helionx
#
#  Created by Theodore Vaida - Astek on 10/2/12.
#  Copyright (c) 2012 com.astekcorp. All rights reserved.

if [ -e /System/Library/Extensions/AstekFusion2Adapter.kext ]; then
    ./helion_activation_tool --save /tmp/helion_licenses.bin
    exit 0
fi