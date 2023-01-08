#!/bin/bash

if [ $# -lt 1 ]; then
    echo "You must supply the file stem of the test you want to visualize: e.g. ./visualize.sh basic"
    exit 1
fi

INPUT_FILE=mnxconverter/tests/$1.musicxml
if [ ! -f "$INPUT_FILE" ]; then
    echo "File not found: $INPUT_FILE"
    exit 1
fi

rm -rf visualized-conversions/build/$1
rm -rf visualized-conversions/$1.html

echo Trace-enabling the conversion XSLT
java net.sf.saxon.Transform \
    -s:../musicxml-to-mnx.xsl \
    -xsl:xslt-visualizer/xsl/trace-enable.xsl \
    -o:visualized-conversions/code/musicxml-to-mnx.xsl

PREPARED_INPUT=visualized-conversions/$1.xml
echo Preparing the input file by adding indentation
java net.sf.saxon.Transform \
    -catalog:../dtd/catalog.xml \
    -s:$INPUT_FILE \
    -o:$PREPARED_INPUT \
    -xsl:viz-prepare.xsl

echo Running the trace
java net.sf.saxon.Transform \
    -s:$PREPARED_INPUT \
    -o:visualized-conversions/build/$1/results \
    -xsl:xslt-visualizer/xsl/run-trace.xsl \
    trace-enabled-stylesheet-uri=../../visualized-conversions/code/musicxml-to-mnx.xsl

echo Rendering the results
java net.sf.saxon.Transform \
    -s:visualized-conversions/build/$1/trace-data/$1.xml \
    -o:visualized-conversions/$1.html \
    -xsl:xslt-visualizer/xsl/render.xsl

echo Copying the web assets
mkdir -p visualized-conversions/assets
cp -ru xslt-visualizer/assets/* visualized-conversions/assets

echo
echo "Open visualized-conversions/$1.html in the browser to see the visualization (and note the horizontal slider at the top)."
