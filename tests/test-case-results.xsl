<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="http://localhost"
  expand-text="yes"
  exclude-result-prefixes="xs">

  <xsl:output indent="yes"/>

  <xsl:param name="conversion-xslt" select="'../musicxml-to-mnx.xsl'"/>

  <xsl:template match="/">
    <xsl:apply-templates mode="expected" select="collection('mnxconverter/tests?select=*.mnx')"/>
    <xsl:apply-templates mode="actual" select="collection('mnxconverter/tests?select=*.musicxml')"/>
  </xsl:template>

  <xsl:template mode="expected" match="/">
    <xsl:result-document href="expected/{my:file-name(.)}">
      <xsl:sequence select="."/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template mode="actual" match="/">
    <xsl:message>Transforming {my:file-name(.)}</xsl:message>
    <xsl:result-document href="actual/{my:file-name(.) ! replace(., '.musicxml$', '.mnx')}">
      <xsl:sequence select="transform(
                              map{
                                'stylesheet-location':$conversion-xslt,
                                'source-node':.
                              }
                            )?output"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:function name="my:file-name" as="xs:string">
    <xsl:param name="doc" as="document-node()"/>
    <xsl:sequence select="base-uri($doc) ! tokenize(.,'/')[last()]"/>
  </xsl:function>

</xsl:stylesheet>
