<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="http://localhost"
  exclude-result-prefixes="xs">

  <xsl:template match="/">

    <!-- Collect the expected results -->
    <xsl:for-each select="collection('mnxconverter/tests?select=*.mnx')">
      <xsl:result-document href="expected/{my:basename(base-uri(.))}">
        <xsl:sequence select="."/>
      </xsl:result-document>
    </xsl:for-each>

    <!-- Collect the actual results -->
    <xsl:for-each select="collection('mnxconverter/tests?select=*.musicxml')">
      <xsl:result-document href="actual/{my:basename(base-uri(.)) ! replace(., '.musicxml$', '.mnx')}">
        <xsl:sequence select="transform(
                                map{
                                  'stylesheet-location':'../musicxml-to-mnx.xsl',
                                  'source-node':.
                                }
                              )?output"/>
      </xsl:result-document>
    </xsl:for-each>

  </xsl:template>

  <xsl:function name="my:basename">
    <xsl:param name="file-path"/>
    <xsl:sequence select="tokenize($file-path,'/')[last()]"/>
  </xsl:function>

</xsl:stylesheet>
