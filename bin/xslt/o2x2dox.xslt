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
      * Main template for root
      */
-->
  <xsl:template match="/">
  <xsl:text>  /*&#x002A;
    @file </xsl:text><xsl:value-of select="$fileName"/>
  <xsl:text>  </xsl:text>
  <xsl:for-each select="/*/comment()[contains(., '/*&#x002A;')]" >
          <xsl:value-of select="substring-before(substring-after(.,'/*&#x002A;'),'*/')"/>
          </xsl:for-each>
  <xsl:for-each select="/*/o2x:annotation" >
          <xsl:apply-templates select='o2x:documentation'/>
          </xsl:for-each>
  @htmlonly
          <xsl:call-template name="embeddedHeader"/>
          <div class="fragment" style="border: medium;">
          <p>
          <xsl:apply-templates select="@*"
                                  mode="printCol" />
          <xsl:apply-templates select="."
                                  mode="namespace" />
          </p>
          </div>
  @endhtmlonly
  <xsl:text> */ </xsl:text>
  
  <xsl:for-each select="/*/o2x:dataType" >
          <xsl:text>  /*&#x002A;</xsl:text>
          <xsl:for-each select="./comment()[contains(., '/*&#x002A;')]" >
          <xsl:value-of select="substring-before(substring-after(.,'/*&#x002A;'),'*/')"/>
          </xsl:for-each>
          <xsl:for-each select="./o2x:annotation" >
          <xsl:apply-templates select='o2x:documentation'/>
          </xsl:for-each>
          @htmlonly
          <div class="lpc_fragment" style="border: medium;">
          <p>
          <xsl:apply-templates select="@*"
                                  mode="printCol" />
          <xsl:apply-templates select="."
                                  mode="namespace" />
          </p>
          </div>
          @endhtmlonly
          <xsl:if test="*[not(o2x:documentation)]">
          @par typedef:
          @htmlonly
          <div class="fragment">
            <xsl:apply-templates select="*[not(o2x:documentation)]" mode="printCol"   /> 
          </div>
          @endhtmlonly
        </xsl:if>
          <xsl:text> */ </xsl:text>
          typedef XSLschema
          <xsl:call-template name="getFileName"/>_DataType ;
  </xsl:for-each>
  
  <xsl:for-each select="/*/o2x:dataValues" >
          <xsl:text>  /*&#x002A;</xsl:text>
          <xsl:for-each select="./comment()[contains(., '/*&#x002A;')]" >
          <xsl:value-of select="substring-before(substring-after(.,'/*&#x002A;'),'*/')"/>
          </xsl:for-each>
          <xsl:for-each select="./o2x:annotation" >
          <xsl:apply-templates select='o2x:documentation'/>
          </xsl:for-each>
          @htmlonly
          <div class="lpc_fragment" style="border: medium;">
          <p>
          <xsl:apply-templates select="@*"
                                  mode="printCol" />
          <xsl:apply-templates select="."
                                  mode="namespace" />
          </p>
          </div>
          @endhtmlonly
          <xsl:if test="*[not(o2x:documentation)]">
          @par data:
  @htmlonly
          <div class="fragment">
          <xsl:apply-templates select="*[not(o2x:documentation)]" mode="printCol"   /> 
          </div>
  @endhtmlonly
        </xsl:if>
          <xsl:text> */ </xsl:text>
          XMLdata
          <xsl:call-template name="getFileName"/>_DataValues_<xsl:number value="position()"/> ;
          <xsl:text> 
   
          </xsl:text>
  </xsl:for-each>
  
  <xsl:for-each select="/*/o2x:relationship" >
          <xsl:text>  /*&#x002A;</xsl:text>
          <xsl:for-each select="./comment()[contains(., '/*&#x002A;')]" >
          <xsl:value-of select="substring-before(substring-after(.,'/*&#x002A;'),'*/')"/>
          </xsl:for-each>
          <xsl:for-each select="./o2x:annotation" >
          <xsl:apply-templates select='o2x:documentation'/>
          </xsl:for-each>
@htmlonly
          <div class="lpc_fragment" style="border: medium;">
          <p>
          <xsl:apply-templates select="@*"
                                  mode="printCol" />
          <xsl:apply-templates select="."
                                  mode="namespace" />
          </p>
          </div>
          @endhtmlonly
          <xsl:if test="*[not(o2x:documentation)]">
          @par relations:
  @htmlonly
          <div class="fragment">
          <xsl:apply-templates select="*[not(o2x:documentation)]" mode="printCol"   /> 
          </div>
  @endhtmlonly
         </xsl:if>
          <xsl:text> */ </xsl:text>
          link
          <xsl:call-template name="getFileName"/>_relationship_<xsl:number value="position()"/> ;
  </xsl:for-each>
  
  <xsl:for-each select="/*/o2x:method" >
          <xsl:text>  /*&#x002A;</xsl:text>
          <xsl:for-each select="./comment()[contains(., '/*&#x002A;')]" >
          <xsl:value-of select="substring-before(substring-after(.,'/*&#x002A;'),'*/')"/>
          </xsl:for-each>
          <xsl:for-each select="./o2x:annotation" >
          <xsl:apply-templates select='o2x:documentation'/>
          </xsl:for-each>
          @htmlonly
          <div class="lpc_fragment" style="border: medium;">
          <p>
          <xsl:apply-templates select="@*"
                                  mode="printCol" />
          <xsl:apply-templates select="."
                                  mode="namespace" />
          </p>
          </div>
          @endhtmlonly
          <xsl:if test="*[not(o2x:documentation)]">
          @par stylesheet: 
  @htmlonly
          <div class="fragment">
          <xsl:apply-templates select="*[not(o2x:documentation)]" mode="printCol"   /> 
          </div>
  @endhtmlonly
             </xsl:if>
         <xsl:text> */ </xsl:text>
          <xsl:call-template name="getFileName"/>_method_<xsl:number value="position()"/>()
          <xsl:text> 
          {/* end method */}
          </xsl:text>
  </xsl:for-each>
  
  <xsl:for-each select="/*/o2x:contentList" >
          <xsl:text>  /*&#x002A;</xsl:text>
          <xsl:for-each select="./comment()[contains(., '/*&#x002A;')]" >
          <xsl:value-of select="substring-before(substring-after(.,'/*&#x002A;'),'*/')"/>
          </xsl:for-each>
          <xsl:for-each select="./o2x:annotation" >
          <xsl:apply-templates select='o2x:documentation'/>
          </xsl:for-each>
          @htmlonly
          <div class="lpc_fragment" style="border: medium;">
          <p>
          <xsl:apply-templates select="@*"
                                  mode="printCol" />
          <xsl:apply-templates select="."
                                  mode="namespace" />
          </p>
          </div>
      @endhtmlonly
      <xsl:if test="*[not(o2x:documentation)]">
          @par children list:
  @htmlonly
          <div class="fragment">
          <xsl:apply-templates select="*[not(o2x:documentation)]" mode="printCol"   /> 
          </div>
  @endhtmlonly
</xsl:if>
          <xsl:text> */ </xsl:text>
          struct
          <xsl:call-template name="getFileName"/>_contentList_<xsl:number value="position()"/>;
  </xsl:for-each>
  </xsl:template>
  
  <!--
      /**
      * Process o2x:documentation nodes
      */
      --> 
  
  <xsl:template match="o2x:documentation" >
@par <xsl:value-of select="@source" />:
<xsl:text>
@htmlonly
</xsl:text> 
  <div class="lpc_fragment" style="border: medium;"> 
  <pre>
  <xsl:value-of select="."  disable-output-escaping="yes" />
  </pre></div> 
@endhtmlonly
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
