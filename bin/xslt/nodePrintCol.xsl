<?xml version="1.0" encoding="UTF-8"?>
 <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
   <xsl:import href="xslt/libPrintCol.xsl" /> 
 
    <!-- Adds headers, caller set true only for first call in page -->
    <xsl:param name="INLINE_HEADER">false</xsl:param>
   <!-- XML created tree status: open|close
        override value in libPrintCol          -->
    <xsl:param name="status">close</xsl:param>
    <xsl:output method="html"
                omit-xml-declaration='yes'
                indent="no" />

 <!--
/** @file
 *  @brief Pretty-prints XML/XHTML files/fragments.
 *  @details This XSLT file completes the library libPrintCol.xsl, for processing XML nodes.
 *  - Puts the required tags &lt;style> and &gt;script> (only if INLINE_HEADER parameter = 'true').
 *  - Initial tree status open or close (status parameter, external)
 *
 * @post
 *    The output is valid XHTML 1.1
 * @param
 *    INLINE_HEADER  adds the required tags &lt;style> and &gt;script> .
 * @param
 *    status  controls the starting tree look.
 * @see
 *    Used by xslt2doxfilter.java  
 */ -->

 <!--
 /** 
 * @var INLINE_HEADER 
 * @details Controls the output of tags  &lt;style> and &gt;script>, to make a stand-alone page.
 * @var Param status 
 * @details Controls the default initial look of the XML tree: accepts 'open'|'close'.
 *
 */ --> 

 <!-- 
/** @file
 * @version 06/01/19 for Doxygen 1.8.15
 * @author Copyright &copy;2006 Marco Sillano.
 */ -->

<!--
 /**
 *  main template. 
 *  It process a XML node and produces a HTML fragment htmlonly with the tree.
 */ -->
  <xsl:template match="/">
 <!-- meta-Doxygen commands, to exclude any interference -->    
            <xsl:variable name="chstr"  select="concat(' @','htmlonly')"/>
            <xsl:variable name="chend"  select="concat(' @','endhtmlonly')"/>
            
            <xsl:text>
   <xsl:value-of select="$chstr" /></xsl:text> 
             <xsl:text>
             </xsl:text>
             <xsl:if test="$INLINE_HEADER='true'">
                    <xsl:call-template name="embeddedHeader" />
           </xsl:if>
           <div class="node" style="border: 1px solid #CCCCCC; background-color: #f8f8f8;">
              <br />
              
              <xsl:apply-templates select="." mode="printCol" />
              
              <br />
           </div>
           <xsl:text>
   <xsl:value-of select="$chend" /></xsl:text>
            <xsl:text>
             </xsl:text>
     </xsl:template>
    
</xsl:stylesheet>
