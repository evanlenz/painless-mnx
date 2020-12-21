#!/bin/bash

rm -rf actual expected

java -cp "$CLASSPATH" \
     net.sf.saxon.Transform \
     -catalog:../dtd/catalog.xml \
     test-case-results.xsl \
     test-case-results.xsl

diff -r expected actual
