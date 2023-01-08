<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs">

  <!-- FIXME: implement the proper (as opposed to naive) behaviors here. -->
  <xsl:variable name="time" select="/score-partwise/part[1]/measure[1]/attributes/time"/>
  <xsl:variable name="key-fifths" select="/score-partwise/part[1]/measure[1]/attributes/key/fifths"/>
  <xsl:variable name="divisions" select="/score-partwise/part[1]/measure[1]/attributes/divisions"/>

  <xsl:template match="/">
    <mnx>
      <global>
        <measure-global>
          <directions-global>
            <xsl:apply-templates mode="time-signature" select="$time"/>
            <xsl:apply-templates mode="key-signature" select="$key-fifths"/>
          </directions-global>
        </measure-global>
      </global>
      <xsl:apply-templates select="/score-partwise/part"/>
    </mnx>
  </xsl:template>

  <xsl:template mode="time-signature" match="time">
    <time signature="{beats}/{beat-type}"/>
  </xsl:template>

  <xsl:template mode="key-signature" match="fifths[. eq '0']"/>
  <xsl:template mode="key-signature" match="fifths">
    <key fifths="{.}"/>
  </xsl:template>

  <xsl:template match="part">
    <part>
      <xsl:apply-templates select="/score-partwise/part-list/score-part[@id eq current()/@id]"/>
      <xsl:apply-templates select="measure"/>
    </part>
  </xsl:template>

  <xsl:template match="part-name">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="measure">
    <measure>
      <directions-part>
        <xsl:apply-templates select="attributes/clef"/>
      </directions-part>
      <sequence>
        <xsl:apply-templates select="note"/>
      </sequence>
    </measure>
  </xsl:template>

  <xsl:template match="clef">
    <clef sign="{sign}" line="{line}"/>
  </xsl:template>

  <xsl:template match="note">
    <event value="/{4 div (duration div $divisions)}">
      <note pitch="{pitch/step}{pitch/octave}"/>
    </event>
  </xsl:template>

</xsl:stylesheet>
