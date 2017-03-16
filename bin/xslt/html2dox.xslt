<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:import href="xslt/libPrintCol.xsl" />
    <xsl:param name="fileName">unknow</xsl:param>
    <xsl:param name="INLINE_SOURCE">true</xsl:param>
    <xsl:output method="xml"
                omit-xml-declaration='yes'
                indent="no" />
                <!--
 /**
 * @file html2dox.xslt
 *
 * XHTML stylesheet for doxygen filters.
 * This trasformation is for XHTML files: the XHTLM is documented as
 * a whole, at file level, then (optional) the XHTML code is presented, with syntax highlighting and collassable nodes.
 * At end are all javascript fragments, in standard doxygen style.
 * @param
 * INLINE_SOURCE controls the XHTML source output (default = true)
 * @param
 * fileName used to build comments.
 *  @pre. The input file: <br/>
 *  - It must be a well-formed XHTML file.
 *  - All documentation blocks must be java-like ('/'+'*'+'*') inside a HTML comments ('<'+'!'+'-'+'-'), and at first level, children of <HTML> tag.
 *  - The javascript documentation is in standard doxygen style.
 *
 * @see libPrintCol.xsl
 *
 * @author Copyright 2006-2009 Marco Sillano (sillano@mclink.it).
 */  -->

 <!--
 /**
 *  main template. <br/>
 *  It process a XHTML file:
 *  - extracts the documentation blocs ( only at first level, as childs of <HTML> tag) putting them at start.
 *  - uses libPrintCol.xsl on full XHTML tree
 *  - adds javadoc fragments at end for doxygen process.
 */ -->
    <xsl:template match="/">
        <xsl:variable name="cstart"
                      select="concat('/','**')" />
        <xsl:variable name="cend"
                      select="concat('*','/')" />
        <xsl:text>
dummy=null;
</xsl:text>
        <xsl:value-of select="$cstart" />
        <xsl:text>
  @file </xsl:text><xsl:value-of select="$fileName" />
        <xsl:for-each select="/ * / comment()[contains(., $cstart)]">

            <xsl:value-of select="substring-before(substring-after(., $cstart),$cend)"
                          disable-output-escaping="yes" />
        </xsl:for-each>
        <!-- the html pretty print -->
        <xsl:if test="$INLINE_SOURCE='true'">@par HTML <xsl:value-of select="$fileName" />: 
        <br />
  @htmlonly 
           <xsl:call-template name="embeddedHeader" />
           <div class="fragment" style="border: 1px solid #CCCCCC; background-color: #f8f8f8;">
              <xsl:apply-templates mode="printCol" />
           </div>
           <xsl:text>
 @endhtmlonly 
</xsl:text>
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
