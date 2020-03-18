#!/bin/sh

yes | sed 's|y|n|g' | ./install/environment.sh 2>/dev/null
