#!/bin/sh

command='result/bin/* '$@
echo CHANGELOG.md | entr -ps "$command" 
