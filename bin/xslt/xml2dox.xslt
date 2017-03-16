<?xml version="1.0" encoding="UTF-8"?>



<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="fileName">unknow</xsl:param>
  <xsl:param name="INLINE_SOURCE">true</xsl:param>
<!-- la copia in engine -->
   <xsl:import href="xslt/libPrintCol.xsl" />
<!--
 /**
 * @file xml2dox.xslt
 *
 * XSLT stylesheet for doxygen filters.
 * This trasformation is for generic XML files.  It first groups at top all documentation blocks.
 * If the external parameter INLINE_SOURCE is true (default) it
 * converts the XML file to HTML with syntax highlighting and collassable nodes. <br />
 *  @pre. The imput file: <br/>
 *  - It must be a well-formed XML file.
 *  - All documentation blocks must be java-like ('/'+'*'+'*') inside XML comments ('<'+'!'+'-'+'-').
 *  - The XML file is processed as a whole, without pseudo-functions.
 * @post.
 *     The output is valid XHTML 1.1
 * @see libPrintCol.xsl
 *
 * @author Copyright 2006-2009 Marco Sillano (sillano@mclink.it).
 */  -->
    
<!--
 /**
 *  main template. <br/>
 *  It process a generic XML file:
 *  - extracts all documentation blocs putting them at start.
 *  - uses libPrintCol.xsl on full XML tree.
 */ -->

   <xsl:template match="/">
   <xsl:variable name="cstart" select="concat('/','**')"/>
   <xsl:variable name="cend" select="concat('*','/')"/>
   <!-- for doxygen, some code required -->
  <xsl:text> dummy=null;
  </xsl:text>
   
   <xsl:value-of select="$cstart"/>
   <xsl:for-each select="/ * /comment()[contains(., $cstart)]" >
           <xsl:value-of select="$cend"/>
           <xsl:value-of select="substring-before(.,$cend)" disable-output-escaping="yes"/>
           </xsl:for-each>
 <xsl:if test="$INLINE_SOURCE='true'">

     @par Code <xsl:value-of select="$fileName"/>:
     <br />
     @htmlonly
       <xsl:call-template name="embeddedHeader"/>
       <div class="fragment" style="border: 1px solid #CCCCCC; background-color: #f8f8f8;">
             <br />
             <xsl:apply-templates select="/ *" mode="printCol" />
             <br />
        </div>
    @endhtmlonly
  </xsl:if>
  <xsl:text> 
  <xsl:value-of select="$cend"/> </xsl:text>
   </xsl:template>



   <!-- match comments: special for DOXygen -->
<!--
 /**
 *  matchs comments, special processing for doxygen.
 *  Overrides the default rule in libPrintCol.xsl.
 */ -->

  <xsl:template match="comment()[not (contains(., concat('/','**')))]" mode="printCol">
        <div class="e">
          <span>
            <span class="b"
                  onclick="doClick(event)">-</span>
            <span class="m">&lt;!--</span>
          </span>
          <div class="c">
                <pre><xsl:value-of select="." /></pre>
            <span class="m">--&gt;</span>
          </div>
        </div>
   </xsl:template>

 <!-- match comments special for DOXygen:: kill -->
  <!--
/**
 *  matchs comments, special processing for doxygen.
 *  Overrides the default rule in libPrintCol.xsl.
 */ -->
   <xsl:template match="comment()[contains(., concat('/','**'))]" mode="printCol" />


</xsl:stylesheet>
