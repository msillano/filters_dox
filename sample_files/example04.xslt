<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:o2x="http://www.o2xdl.org/2.0/o2xdl"
  exclude-result-prefixes="xsl o2x" >
   <!-- sample import -->
   <xsl:import href="libPrintCol.xsl" />
   <!-- sample param, auto-comment by xslt2dox.exe -->
  <xsl:param name="status">close</xsl:param>

  <xsl:output   method = "xml"
      indent="yes"
      omit-xml-declaration = "yes" 
      encoding = "UTF-8" />
      
<!-- first documentation block is for file, mandatory -->      
<!-- 
/** @file
 *  Sample XSLT file with comments.
 *  Example of XSLT file using Doxygen+filters_dox documentation style.@n
 *  @note
 *     This documentation is build by Doxygen using the @ref xslt2doxfilter.java Filter.@n
 *    - To exclude the template's SLT source tree, set <tt>INLINE_SOURCE&false</tt> in 
 *     driver @ref XSLTdoxFilter.bat @n
 *    - If <tt>INLINE_SOURCE&true</tt>, to get an open XML tree (default is closed)  set
 *        param @c status to @c close in @ref nodePrintCol.xsl 
 * @param
 *    status  controls the starting tree look.
 */ -->

<!-- additional documentation blocks, optionals  -->
<!-- 
/** @file
 * @version 06/01/19 for Doxygen 1.8.15
 * @author Copyright &copy;2006 Marco Sillano.
 */ -->
 
<!-- last block is for next template, mandatory --> 
<!--
/**
 * This template processes root node.
 * comment details here (JAVADOC_AUTOBRIEF on)
 */ -->
  <xsl:template match="/">
                 <div>
                    <span class="m">&lt;/</span>
                    <span class="en">style</span>
                    <span class="m">
                        <xsl:text>
&gt;
</xsl:text>
                    </span>
                </div>
   </xsl:template>
  
 <!--
/**
* The template processes o2x:documentation nodes.
* @par Return 
*  a div tag containing preformatted documentation
*/   --> 
  
  <xsl:template match="o2x:documentation" >
  <div class="lpc_fragment" style="border: medium;"> 
  <!--  ebedded documentation -->
  <pre>
  <xsl:value-of select="."  disable-output-escaping="yes" />
  </pre></div> 
  <!-- more embedded -->
 </xsl:template>
 
 <!--
 /**
 * The templaye kills o2x:documention  nodes mode="printCol".
 * Overwrite the default process by libPrintCol.
 */ --> 

  <xsl:template match="o2x:documentation"  mode="printCol"  />
  
 <!--
/**
* Function (named template) to strip a filename.
* @par Return 
*   the file name without extension
*/ --> 

  <xsl:template name="getFileName" >
     <xsl:value-of select="substring-before($fileName,'.')"/>
  </xsl:template>

  
  
  </xsl:stylesheet>
