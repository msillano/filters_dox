<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="xslt/libPrintCol.xsl" />
    <xsl:param name="fileName">unknow</xsl:param>
    <xsl:param name="INLINE_SOURCE">true</xsl:param>
    <xsl:param name="status">close</xsl:param>
    <xsl:output method="xml"
                omit-xml-declaration='yes'
                indent="no" />
 <!--
 /** @file 
 * Process a XHTML file, documented using Doxygen+filters_dox style. 
 * This trasformation is for generic XHTML files, to build a 'javascript-like' file processable by Doxygen. <BR />
 * This trasformation is for XHTML files: the XHTLM is documented as
 * a whole, at file level, then the XHTML code is presented, with syntax highlighting and collassable nodes.
 * At end are all javascript fragments, in standard doxygen style.
 * @param
 * INLINE_SOURCE controls the XHTML source output (default = true)
 * @param
 *  status  controls the XHTML tree look (default = close)
 * @param
 * fileName used to build comments.
 * @pre The input file: <br/>
 *  - must be a well-formed XHTML file.
 *  - all documentation blocks must be java-like ('/'+'*'+'*') inside a HTML comments ('<'+'!'+'-'+'-'), and at first level, children of &lt;HTML> tag.
 *  - If some Javascript is present, it must be documented in standard doxygen style.
 *  - See @ref sample_files/example01.html for some quirks on writing XHTML comments.
 * @use
 *  This transformation must be used by 
 */  -->
 
<!-- 
/** @file
 * @version 06/01/19 for Doxygen 1.8.15
 * @author Copyright &copy;2006 Marco Sillano.
 */ -->
 

 <!--
 /**
 *  main template.
 *  It process a XHTML file to get a Javascript-like file:
 *  - extracts the documentation blocs ( only at first level, as childs of &lt;HTML> tag) putting them at start.
 *  - includes the XHTML tree to the Detailed Descripion ( if INLINE_SOURCE = true).
 *  - adds javascript fragments (if any) at end for doxygen process.
 */ -->
    <xsl:template match="/">
<!-- meta-Doxygen commands, to exclude any interference -->    
        <xsl:variable name="cstart"
                      select="concat('/','**')" />
        <xsl:variable name="cend"
                      select="concat('*','/')" />
        <xsl:variable name="cfile"   select="concat('@','file')"/>
        <xsl:variable name="chstr"  select="concat('@','htmlonly')"/>
        <xsl:variable name="chend"  select="concat('@','endhtmlonly')"/>
 <!-- required if miss first template or detailed comment by Doxygen: not in output -->
     <xsl:text>
 param dummy = "null"; </xsl:text>
          <xsl:for-each select="/ * / comment()[contains(., $cstart)]">
             <xsl:value-of select="substring-before(.,$cend)" disable-output-escaping="yes"/>
             <xsl:choose>
                <xsl:when test = "position() = 1">
                   <xsl:for-each select="/ * / * / link">
                     <xsl:text> @par Import (css)
 include <xsl:value-of select="@href"/> </xsl:text> 
                   </xsl:for-each>
                   <xsl:for-each select="/ * / * / script[@src]">
                     <xsl:text> @par Import (js)
 include <xsl:value-of select="@src"/> </xsl:text> 
                   </xsl:for-each>
                  <xsl:text><xsl:value-of select="$cend"/></xsl:text>
                   </xsl:when>
               <xsl:otherwise>
                  <xsl:text><xsl:value-of select="$cend"/></xsl:text>
               </xsl:otherwise>
          </xsl:choose>
      </xsl:for-each> 
        <!-- the html pretty print -->
   <xsl:if test="$INLINE_SOURCE='true'">
      <xsl:text>
 <xsl:value-of select="concat($cstart, ' ', $cfile)"/></xsl:text> 
   <xsl:text>      
 <xsl:value-of select="concat(' @','details ')" /></xsl:text>
      <xsl:text>
<xsl:value-of select="$chstr"/></xsl:text>
       <xsl:text>     
       </xsl:text>
        <xsl:call-template name="embeddedHeader" />
           <div class="fragment" style="border: 1px solid #CCCCCC; background-color: #f8f8f8;">
              <xsl:apply-templates mode="printCol" />
           </div>
       <xsl:value-of select="$chend" />
        </xsl:if>
        <xsl:text>
<xsl:value-of select="$cend" /> 
</xsl:text>
        <!-- output JScript directly after HTML -->
        <xsl:for-each select="// *[local-name(.)='script']/text()">
        // script, no comment 
        <xsl:value-of select="."
                      disable-output-escaping="yes" /></xsl:for-each>
        <xsl:for-each select="// *[local-name(.)='script']/comment()">
        // script, in comment 
        <xsl:value-of select="."
                      disable-output-escaping="yes" /></xsl:for-each>
    </xsl:template>
<!--
/**
Special formatting for Doxygen.
Scripts node content is skipped
*/
-->
    <xsl:template match="*[local-name(.)='script']"
                  mode="printCol">
        <div class="e">
            <span class="m">&lt;</span>
            <span class="en">script</span>
            <xsl:if test="@*">
                <xsl:text>
</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="@*"
                                 mode="printCol" />
            <xsl:apply-templates select="."
                                 mode="namespace" />
            <span class="m">
                <xsl:text>
&gt;
</xsl:text>
            </span>
            <xsl:if test="(comment()) or (text())">
                <span class="u">[See var &amp; function
                documentation]</span>
            </xsl:if>
            <span class="m">&lt;/</span>
            <span class="en">script</span>
            <span class="m">
                <xsl:text>
&gt;
</xsl:text>
            </span>
        </div>
    </xsl:template>
    <!--
 /**
 * Formats xhtml STYLE nodes.
 *
 **/
 -->
    <xsl:template match="*[local-name(.)='style']"
                  mode="printCol">
        <div class="e">
            <div>
                <span class="b"
                      onclick="doClick(event)">-</span>
                <span class="m">&lt;</span>
                <span class="en">style</span>
                <xsl:if test="@*">
                    <xsl:text>
 
</xsl:text>
                </xsl:if>
                <xsl:apply-templates select="@*"
                                     mode="printCol" />
                <xsl:apply-templates select="."
                                     mode="namespace" />
                <span class="m">
                    <xsl:text>
&gt;
</xsl:text>
                </span>
            </div>
            <div>
                <div class="s">
                    <pre>
                        
<xsl:value-of select="." />
                    
</pre>
                </div>
                <div>
                    <span class="m">&lt;/</span>
                    <span class="en">style</span>
                    <span class="m">
                        <xsl:text>
&gt;
</xsl:text>
                    </span>
                </div>
            </div>
        </div>
    </xsl:template>
    <!-- 
    /** 
    * match comments.
    * special for DOXygen:: kill 
    */ -->
    <xsl:template match="comment()[contains(., concat('/','**'))]"
                  mode="printCol"></xsl:template>
</xsl:stylesheet>
