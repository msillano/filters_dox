<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="xslt/libPrintCol.xsl" />
    <xsl:param name="INLINE_HEADER">false</xsl:param>
    <xsl:output method="html"
                omit-xml-declaration='yes'
                indent="no" />
<!--
 /**
 * @file nodePrintCol.xsl
 *
 *
 * @see libPrintCol.xsl
 *
 * @author Copyright 2006-2009 Marco Sillano (sillano@mclink.it).
 */  -->
 
<!--
 /**
 *  main template. <br/>
 *  It process a XML node fragment:
 *  - Puts the required header (only if INLINE_HEADER parameter = 'true').
 *  - uses libPrintCol.xsl on root node
 */ -->
  <xsl:template match="/">
   @htmlonly 
           <xsl:if test="$INLINE_HEADER='true'">
                 <xsl:call-template name="embeddedHeader" />
           </xsl:if>
           <div class="node" style="border: 1px solid #CCCCCC; background-color: #f8f8f8;">
              <br />
              <xsl:apply-templates mode="printCol" />
              <br />
           </div>
           <xsl:text>
  @endhtmlonly 
</xsl:text>
    </xsl:template>
</xsl:stylesheet>
