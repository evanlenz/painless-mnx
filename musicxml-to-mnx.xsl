<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:my="http://localhost"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="my xs math">

  <!-- FIXME: implement the proper (as opposed to naive) behavior here. -->
  <xsl:variable name="divisions" select="/score-partwise/part[1]/measure[1]/attributes/divisions"/>

  <xsl:template match="/">
    <mnx>
      <global>
        <!-- ASSUMPTION: Each part in the input has the same number of measures -->
        <xsl:apply-templates mode="measure-global" select="/score-partwise/part[1]/measure"/>
      </global>
      <xsl:apply-templates select="/score-partwise/part"/>
    </mnx>
  </xsl:template>

  <xsl:template mode="measure-global" match="measure">
    <xsl:variable name="directions" as="element()*">
      <xsl:apply-templates mode="time-signature" select="attributes/time"/>
      <xsl:apply-templates mode="key-signature" select="attributes/key/fifths"/>
      <xsl:apply-templates mode="repeat" select="barline/repeat"/>
    </xsl:variable>
    <measure-global>
      <xsl:if test="$directions">
        <directions-global>
          <xsl:sequence select="$directions"/>
        </directions-global>
      </xsl:if>
    </measure-global>
  </xsl:template>

  <xsl:template mode="time-signature" match="time">
    <time signature="{beats}/{beat-type}"/>
  </xsl:template>

  <xsl:template mode="key-signature" match="fifths[. eq '0']"/>
  <xsl:template mode="key-signature" match="fifths">
    <key fifths="{.}"/>
  </xsl:template>

  <xsl:template mode="repeat" match="repeat">
    <repeat type="{if (@direction eq 'forward') then 'start' else 'end'}">
      <xsl:copy-of select="@times"/>
    </repeat>
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
    <xsl:variable name="clef" as="element()?">
      <xsl:apply-templates select="attributes/clef"/>
    </xsl:variable>
    <measure>
      <xsl:if test="$clef">
        <directions-part>
          <xsl:sequence select="$clef"/>
        </directions-part>
      </xsl:if>
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
    <xsl:variable name="base-duration" select="ceiling(duration * math:pow((2 div 3), count(dot)))"/>
    <event value="/{4 div ($base-duration div $divisions)}{
                    for $dot in (0 to count(dot)) return 'd'[$dot ge 1]}">
      <xsl:apply-templates mode="note-or-rest" select="current-group()/(pitch | rest)"/>
    </event>
  </xsl:template>

  <xsl:template mode="note-or-rest" match="pitch">
    <note pitch="{step}{my:pitch-modifier(alter)}{octave}">
      <xsl:apply-templates select="../accidental"/>
    </note>
  </xsl:template>

  <xsl:template mode="note-or-rest" match="rest">
    <rest/>
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
