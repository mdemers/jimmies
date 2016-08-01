<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>
<xsl:template match="text()"/>
<xsl:template match="index">
<cues>
    <solespeaker><xsl:value-of select="//interviewee"/></solespeaker>
	<xsl:apply-templates select="point"/>
</cues>
</xsl:template> 

<xsl:template match="point[title!='END']">
<cue>
	<start><xsl:value-of select="time"/><xsl:text>.000</xsl:text></start>
	<end><xsl:value-of select="following-sibling::point/time[position()=1]"/><xsl:text>.000</xsl:text></end>
	<title><xsl:value-of select="title"/></title>
	<annotation><xsl:value-of select="synopsis"/></annotation>
	<transcript><xsl:value-of select="partial_transcript"/></transcript>
</cue>
</xsl:template>

</xsl:stylesheet>