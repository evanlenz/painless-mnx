<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="http://localhost"
  exclude-result-prefixes="my xs">

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
        <xsl:for-each-group select="note" group-starting-with="note[not(chord)]">
          <xsl:apply-templates mode="event" select="."/>
        </xsl:for-each-group>
      </sequence>
    </measure>
  </xsl:template>

  <xsl:template match="clef">
    <clef sign="{sign}" line="{line}"/>
  </xsl:template>

  <xsl:template mode="event" match="note">
    <event value="/{4 div (duration div $divisions)}">
      <xsl:apply-templates mode="note" select="current-group()/pitch"/>
    </event>
  </xsl:template>

  <xsl:template mode="note" match="pitch">
    <note pitch="{step}{my:pitch-modifier(alter)}{octave}">
      <xsl:apply-templates select="../accidental"/>
    </note>
  </xsl:template>

  <xsl:template match="accidental">
    <xsl:attribute name="accidental" select="."/>
  </xsl:template>

  <xsl:function name="my:pitch-modifier">
    <xsl:param name="alter"/>
    <xsl:apply-templates mode="translate-pitch-modifier" select="$alter"/>
  </xsl:function>

          <xsl:template mode="translate-pitch-modifier" match="alter"/>
          <xsl:template mode="translate-pitch-modifier" match="alter[. eq '-1']">b</xsl:template>
          <xsl:template mode="translate-pitch-modifier" match="alter[. eq '1']">#</xsl:template>

</xsl:stylesheet>
