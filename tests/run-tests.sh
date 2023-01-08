#!/bin/bash

export TMP_FILE=tempdiffs12341234.txt

rm -rf actual expected diffs.txt

java net.sf.saxon.Transform \
     -catalog:../dtd/catalog.xml \
     test-case-results.xsl \
     test-case-results.xsl \
     conversion-xslt=../musicxml-to-mnx.xsl

echo

DIFF=$(diff -r expected actual)
if [ "$DIFF" != "" ]
then
    diff -rq expected actual >$TMP_FILE
    echo "FAILING TESTS ($(cat $TMP_FILE | wc -l) out of $(ls expected | wc -l)):"
    cat $TMP_FILE
    rm $TMP_FILE
    echo "$DIFF" >diffs.txt
    echo "See diffs.txt for the details of the failed tests"
else
    echo "ALL TESTS PASSED!"
fi
