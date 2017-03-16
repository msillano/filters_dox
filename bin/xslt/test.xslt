<?xml version="1.0" encoding="UTF-8"?>
  
  <xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:o2x="http://www.o2xdl.org/2.0/o2xdl"
  exclude-result-prefixes="xsl o2x" >
  
  <xsl:param name="fileName">unknow</xsl:param>
  <!-- la copia in engine -->
  <xsl:import href="libPrintCol.xsl" />
  <xsl:output   method = "xml"
  indent="yes"
  omit-xml-declaration = "yes" 
  encoding = "utf8" />
 <!--
     /**
      * @file test.xslt
      * first line.
      * file comment line 2
      */
-->
  
  <!--
      /**
      * Main template for root.
      * comment main line 2 <br>
      * comment main line 3.
      */
-->
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
      * Process o2x:documentation nodes.
      * @return a div tag containing preformatted documentation
      */
      --> 
  
  <xsl:template match="o2x:documentation" >
  <div class="lpc_fragment" style="border: medium;"> 
  <pre>
  <xsl:value-of select="."  disable-output-escaping="yes" />
  </pre></div> 
 </xsl:template>
 <!--
     /**
     * Kills o2x:documention  nodes mode="printCol" 
     * Overwrite default processing by libPrintCol.
     */
     --> 

  <xsl:template match="o2x:documentation"  mode="printCol"  />
  <!--
      /**
      * To strip a filename.
      */
      --> 

  <xsl:template name="getFileName" >
    <xsl:value-of select="substring-before($fileName,'.')"/>
  </xsl:template>

  
  
  </xsl:stylesheet>
