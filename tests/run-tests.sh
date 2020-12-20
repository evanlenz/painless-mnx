rm -rf actual expected
java -cp "C:\saxon10\saxon-he-10.3.jar;C:\xml-commons-resolver-1.2\resolver.jar" net.sf.saxon.Transform -catalog:../dtd/catalog.xml test-results.xsl test-results.xsl
diff -r expected actual
