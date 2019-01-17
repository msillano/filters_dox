<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
   <xsl:import href="xslt/libPrintCol.xsl" /> 
 
   <!-- INLINE_SOURCE controls the XML tree output in doc -->
   <xsl:param name="INLINE_SOURCE">true</xsl:param>
   <!-- XML file name, used in documentation -->
  <xsl:param name="fileName">unknow</xsl:param>
  <!-- XML-tree: override defaut in  libPrintCol.xsl -->
  <xsl:param name="status">open</xsl:param>
  
 <!--
 /** @file
 * Process a XML file, documented using Doxygen+filters_dox style. 
 * This trasformation is for generic XML files, to build a 'C-like' file processable by Doxygen. <BR />
 * It first groups at top all documentation blocks.<br />
 * If the external parameter INLINE_SOURCE is true (default) it
 * converts the XML file to an XHTML tree with syntax highlighting and collassable nodes in <i>Detailed Description</i> section. <br />
 *  @pre. The input file must be a well-formed XML file. <br />
 *  - Any documentation blocks must be java-like ('/'+'*'+'*') inside XML comments ('<'+'!'+'-'+'-')
 *  - The first block must use the Doxygen tag '@'+'file'.
 *  - The XML file is processed as a whole, without pseudo-functions ( if INLINE_SOURCE = true).
 *  - See @ref sample_files/example03.xml for some quirks on writing XML comments.
 *
 *@post
 *    The output mimics a C file syntax. 
 * @param
 * INLINE_SOURCE controls the presence of the XHTML source in output (default = true)
 * @param
 *  status  controls the XHTML tree look (default = close)
 * @param
 * fileName used to build comments.
*@par Use
 *    This file must be used with xmlFilter.java  (see Doxygen filters XMLdoxFilter.bat, XMLdoxFilter.sh ).
*/ -->
<!-- 
/** @file
 * @version 06/01/19 for Doxygen 1.8.15
 * @author Copyright &copy;2006 Marco Sillano.
 */ -->

<!--
 /** 
 *  main template. 
 *  @details This template processes a generic XML file to get a c-like file:
 *   - extracts all documentation blocs putting them at start
 *   - adds to Detailed Description the full XML tree built by @ref libPrintCol.xsl (if INLINE_SOURCE = true).
 *
 */ -->

   <xsl:template match="/">
   <!-- meta-doxygen commands, to avoid interferences -->
   <xsl:variable name="cstart" select="concat('/','**')"/>
   <xsl:variable name="cend"   select="concat('*','/')"/>
   <xsl:variable name="chstr"  select="concat('@','htmlonly')"/>
   <xsl:variable name="chend"  select="concat('@','endhtmlonly')"/>
  
 <!-- required if miss first template or detailed comment by Doxygen: not in output -->
     <xsl:text>
 param dummy = "null"; </xsl:text>
  <xsl:for-each select="/ * /comment()[contains(., $cstart)]" >
           <xsl:value-of select="substring-before(.,$cend)" disable-output-escaping="yes"/>
           <xsl:text><xsl:value-of select="$cend"/>  
</xsl:text> 
        </xsl:for-each>
 <!--  ends global -->

 <xsl:if test="$INLINE_SOURCE='true'">
      <xsl:text>
 <xsl:value-of select="$cstart"/></xsl:text> 
   <xsl:text>      
 <xsl:value-of select="concat(' @','details ')" /></xsl:text>
      <xsl:text>
<xsl:value-of select="$chstr"/></xsl:text>
       <xsl:text>     
       </xsl:text>
     <xsl:call-template name="embeddedHeader"/> 
       <div class="fragment" style="border: 1px solid #CCCCCC; background-color: #f8f8f8;">
             <xsl:text><br /></xsl:text>
             <xsl:apply-templates select="/ *" mode="printCol" />
             <xsl:text><br /></xsl:text>
        </div>
      <xsl:text>
 <xsl:value-of select="$chend"/></xsl:text>
     <xsl:text>
 <xsl:value-of select="$cend"/></xsl:text>
  <xsl:text>
 XML_code(); 
</xsl:text>
  </xsl:if>
<!--  
    <xsl:text>
<xsl:value-of select="$cstart"/><xsl:value-of select="concat('@','}',$cend)"/></xsl:text>
-->
  </xsl:template>

<!--
 /**
 *  matchs comments, special processing for doxygen.
 *  Overrides the default rule in libPrintCol.xsl.
 */ -->

 
  <xsl:template match="comment()[not (contains(., concat('/','**')))]" mode="printCol">
      <div class="e">
           <xsl:if test="$status='close'">
            <span>
             <span class="b"
                  onclick="doClick(event)">+</span>
             <span class="m">&lt;!--</span>
            </span>
            <div class="c" style="display:none" >
                <pre><xsl:value-of select="." /></pre>
                <span class="m">--&gt;</span>
             </div>
          </xsl:if>
          <xsl:if test="$status='open'">
           <span>
             <span class="b"
                  onclick="doClick(event)">-</span>
             <span class="m">&lt;!--</span>
           </span>
           <div class="c">
                <pre><xsl:value-of select="." /></pre>
                <span class="m">--&gt;</span>
             </div>
            </xsl:if>
          
        </div>
   </xsl:template>

<!--
/**
 *  matchs comments, special processing for doxygen.
 *  Overrides the default rule in libPrintCol.xsl.
 */ -->
 
   <xsl:template match="comment()[contains(., concat('/','**'))]" mode="printCol" />

</xsl:stylesheet>
