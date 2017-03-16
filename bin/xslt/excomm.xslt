<?xml version="1.0" encoding="utf-8"?>
<!--
 /**
 * @file excomm.xslt
 *
 * XHTML stylesheet filter for XML.
 *  @pre. The input file: <br/>
 *     It must be a well-formed XHTML file.
 * @post.
 *     The output is valid XML 
 *
 * @author Copyright 2006-2009 Marco Sillano (sillano@mclink.it).
 */  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:param name="fileName">unknow</xsl:param>
      <xsl:output method="xml" omit-xml-declaration='yes' indent="no" />
      <!--
 /**
 *  main template. <br/>
 *  It process a XHTML file:
 *  - extracts the documentation blocs ( only at first level, as childs of <HTML> tag) putting them at start.
 *  - uses libPrintCol.xsl on full XHTML tree
 *  - adds javadoc fragments at end for doxygen process.
 */ -->
      <xsl:template match="/">
            <xsl:text disable-output-escaping="yes">&lt;!-- /**
 *@par XSKprocesses
</xsl:text>
            <xsl:apply-templates select="*" mode="info" />
            <xsl:text disable-output-escaping="yes">
*/ --&gt;
      </xsl:text>
            <xsl:apply-templates select="*" mode="COPY" />
   </xsl:template>
      
      <xsl:template match="XSKprocess" mode="info"> *@li <xsl:value-of 
      select="position()" /> - @e <xsl:value-of 
      select="@XSKtodo" />   <xsl:apply-templates select="."></xsl:apply-templates><xsl:text>
</xsl:text>
      </xsl:template>

      <xsl:template match="*[XSKprocess]" mode="inf2">  <xsl:text disable-output-escaping="yes">
 * &lt;i> 
</xsl:text>
         <xsl:apply-templates select="XSKprocess" mode="info"></xsl:apply-templates>
 <xsl:text disable-output-escaping="yes"> * &lt;/i></xsl:text>
      </xsl:template>
  
  
      <xsl:template match="XSKprocess" mode="COPY">
      <xsl:text disable-output-escaping="yes">&lt;!--  process#</xsl:text>
      <xsl:value-of select="position()" />: <xsl:value-of 
      select="@XSKtodo" />   <xsl:apply-templates select="."></xsl:apply-templates>
      <xsl:text disable-output-escaping="yes">  --&gt;
      </xsl:text>
<!--
      <xsl:if test="./*/*/XSKprocess">
         <xsl:apply-templates select="*/*/XSKprocess" mode="COPY"></xsl:apply-templates>
      </xsl:if>
-->
      </xsl:template>
      
      <xsl:template match="comment()"><xsl:text disable-output-escaping="yes">&lt;!-- </xsl:text>
      <xsl:value-of select="." /><xsl:text disable-output-escaping="yes" >--&gt; 
</xsl:text></xsl:template>

      <xsl:template match="XSKprocess[@XSKtodo='ZIPFILE']"> (command &quot;<xsl:value-of 
      select="XSKparameter[@XSKname='command']" /><xsl:text disable-output-escaping="yes">&quot;)  </xsl:text>
      <xsl:call-template name="Xfromto" />
      </xsl:template>
      
      
      <xsl:template match="XSKprocess[@XSKtodo='COPY']">
            <xsl:call-template name="fromto" />
      </xsl:template>
 
      <xsl:template match="XSKprocess[@XSKtodo='OUTPUT']">
            <xsl:if test="./XSKusing/@mode"> using: <xsl:value-of 
            select="./XSKusing/@mode" /></xsl:if>
            <xsl:if test="./XSKusing/@entity"> (<xsl:value-of 
            select="./XSKusing/@entity" />) </xsl:if>
            <xsl:call-template name="fromout" />
      </xsl:template>
 
      <xsl:template match="XSKprocess[@XSKtodo='FO2PDF']">
        <xsl:call-template name="fromout" />
      </xsl:template>
      
      <xsl:template match="XSKprocess[@XSKtodo='GETBIN']">
         <xsl:if test="./XSKparameter[@XSKname='coding']"> coding: <xsl:value-of 
            select="./XSKparameter[@XSKname='coding']" /></xsl:if>
        <xsl:call-template name="frommerge" />
      </xsl:template>

       <xsl:template match="XSKprocess[@XSKtodo='SAVEBIN']">
         <xsl:if test="./XSKparameter[@XSKname='coding']"> coding: <xsl:value-of 
            select="./XSKparameter[@XSKname='coding']" /></xsl:if>
        <xsl:call-template name="fromto" />
      </xsl:template>

      <xsl:template match="XSKprocess[@XSKtodo='TRANSFORM']">
            <xsl:if test="./XSKusing/@mode"> using: <xsl:value-of 
            select="./XSKusing/@mode" /></xsl:if>
            <xsl:if test="not(./XSKusing/@mode)"> using: default (POP) </xsl:if>
            <xsl:if test="./XSKusing/@entity"> (<xsl:value-of 
            select="./XSKusing/@entity" />) </xsl:if>
            <xsl:call-template name="fromto" />
      </xsl:template>
 
      <xsl:template match="XSKprocess[@XSKtodo='VALIDATE']">
        <xsl:call-template name="onlyfrom" />
        <xsl:if test="./XSKusing/@mode"> using <xsl:call-template
          name="valMode" />: <xsl:value-of 
          select="./XSKusing/@mode" /></xsl:if>
        <xsl:if test="./XSKusing/@entity"> (<xsl:value-of 
             select="./XSKusing/@entity" />) </xsl:if>
        <xsl:if test="not(./XSKusing)"> using internal <xsl:call-template
             name="valMode" /></xsl:if>
        </xsl:template>
  
      <xsl:template match="XSKprocess[@XSKtodo='MERGE']">
            <xsl:call-template name="frommerge" />
      </xsl:template>
 
      <xsl:template match="XSKprocess[@XSKtodo='DELETE']">
            <xsl:call-template name="onlyfrom" />
      </xsl:template>

      <xsl:template match="XSKprocess[@XSKtodo='SELECT']">
            <xsl:call-template name="onlyfrom" /><xsl:text>
            </xsl:text>
            <xsl:call-template name="DO" />
 *@li    Process SELECT end <br />
      </xsl:template>
      
       <xsl:template match="XSKprocess[@XSKtodo='EXECU']">
           commandline: <xsl:value-of 
            select="./XSKparameter[@XSKname='command'][1]" />...(more)...
      </xsl:template>
	  
       <xsl:template match="XSKprocess[@XSKtodo='EXECW']">
           commandline: <xsl:value-of 
            select="./XSKparameter[@XSKname='command'][1]" />...(more)...
      </xsl:template>


    <xsl:template match="XSKprocess[@XSKtodo='SETTRACE']">
            <xsl:call-template name="trace" />
      </xsl:template>
  
      <xsl:template match="XSKprocess[@XSKtodo='ADDCOOKIE']">  name: <xsl:value-of select="./XSKcookie/@XSKname" />
      </xsl:template>

      <xsl:template match="XSKprocess[@XSKtodo='GETCOOKIES']"><xsl:if
       test="./XSKcookie/@XSKname"> name: <xsl:value-of
       select="./XSKcookie/@XSKname" /></xsl:if><xsl:if
       test="not (./XSKcookie/@XSKname)"> name: any </xsl:if>
      </xsl:template>
 
      <xsl:template match="XSKprocess[@XSKtodo='SUBTASK']">
        <xsl:if test="./XSKusing/@mode"> using: <xsl:value-of 
            select="./XSKusing/@mode" />
            <xsl:if test="./XSKusing/@entity"> (<xsl:value-of 
            select="./XSKusing/@entity" />) </xsl:if></xsl:if>
        <xsl:call-template name="DO" />
      </xsl:template>
      
      
      
      <xsl:template match="XSKprocess[@XSKtodo='DBOPEN']">
       <xsl:if test="XSKparameter[@XSKname='XSKclass']">
         Config DBASE:<xsl:value-of 
      select="XSKparameter[@XSKname='XSKclass']" /> </xsl:if>
       <xsl:if test="not(XSKparameter[@XSKname='XSKclass'])">
         Config DBASE:default </xsl:if>
       <xsl:call-template name="DO" />
      </xsl:template>
      
      <xsl:template match="XSKprocess[@XSKtodo='WRTEMAIL']">
       <xsl:if test="XSKparameter[@XSKname='XSKclass']">
         Config EMAIL:<xsl:value-of 
      select="XSKparameter[@XSKname='XSKclass']" /> </xsl:if>
       <xsl:if test="not(XSKparameter[@XSKname='XSKclass'])">
         Config EMAIL:default </xsl:if>
       <xsl:call-template name="onlyfrom" />
        <xsl:if test="./XSKusing/@mode"> <br />attach from: <xsl:value-of 
            select="./XSKusing/@mode" />
            <xsl:if test="./XSKusing/@entity"> (<xsl:value-of 
            select="./XSKusing/@entity" />) </xsl:if></xsl:if>
       </xsl:template>

      
      <xsl:template match="XSKprocess[@XSKtodo='FOREACH']">
            <xsl:call-template name="frommerge" />
            <xsl:call-template name="DO" />
      </xsl:template>
      

      <xsl:template match="XSKprocess">
            <xsl:call-template name="norfromto" />
      </xsl:template>
      
      
      <xsl:template name="DO">
         <xsl:for-each select="./XSKdo"><br/><xsl:if test="./@value"><xsl:if
       test="./@eval"> if eval(<xsl:value-of 
       select="./@eval" />) ==  </xsl:if><xsl:if
       test="not(./@eval)">if true </xsl:if>(<xsl:value-of 
       select="./@value " />)</xsl:if> executes XSKtask<xsl:if 
       test="./@mode"> from: <xsl:value-of 
       select="./@mode" /></xsl:if><xsl:if 
       test="not(./@mode)"> from: default (DSTACK) </xsl:if>
       <xsl:if test="./@entity"> (<xsl:value-of 
            select="./@entity" />)</xsl:if>
      <xsl:if test="./*/XSKprocess">
         <xsl:apply-templates select="*[XSKprocess]" mode="inf2"></xsl:apply-templates>
      </xsl:if>

           </xsl:for-each>
       </xsl:template>



 <!-- standard mandatory From and To -->
      <xsl:template name="fromto">
            <xsl:if test="./XSKfrom/@mode"> from: <xsl:value-of 
            select="./XSKfrom/@mode" /></xsl:if>
            <xsl:if test="not(./XSKfrom/@mode)"> from: default (DSTACK)</xsl:if>
            <xsl:if test="./XSKfrom/@entity"> (<xsl:value-of 
            select="./XSKfrom/@entity" />)</xsl:if><xsl:if 
            test="./XSKfrom/@XSKpath"> using XPath</xsl:if>
            <xsl:if test="./XSKto/@mode"> to: <xsl:value-of 
            select="./XSKto/@mode" /></xsl:if>
            <xsl:if test="not(./XSKto/@mode)"> to: default (DSTACK)</xsl:if>
            <xsl:if test="./XSKto/@entity"> (<xsl:value-of 
            select="./XSKto/@entity" />) </xsl:if>
      </xsl:template>
 
      <!-- standard mandatory From and Merge -->
      <xsl:template name="frommerge">
            <xsl:if test="./XSKfrom/@mode"> from: <xsl:value-of 
            select="./XSKfrom/@mode" /></xsl:if>
            <xsl:if test="not(./XSKfrom/@mode)"> from: default (DSTACK)</xsl:if>
            <xsl:if test="./XSKfrom/@entity"> (<xsl:value-of 
            select="./XSKfrom/@entity" />)</xsl:if><xsl:if 
            test="./XSKfrom/@XSKpath"> using XPath</xsl:if>
            <xsl:if test="./XSKmerge/@mode"> into: <xsl:value-of 
            select="./XSKmerge/@mode" /></xsl:if>
            <xsl:if test="not(./XSKmerge/@mode)"> into: default (DSTACK)</xsl:if>
            <xsl:if test="./XSKmerge/@entity"> (<xsl:value-of 
            select="./XSKmerge/@entity" />) </xsl:if>
      </xsl:template>
 
 <!-- standard mandatory multiple From and To -->
      <xsl:template name="Xfromto">
      <xsl:for-each select="./XSKfrom"><br/> from: <xsl:value-of 
            select="./@mode" /><xsl:if test="./@entity"> (<xsl:value-of 
            select="./@entity" />) </xsl:if><xsl:if
            test="./@XSKpath"> using XPath</xsl:if>
      </xsl:for-each>
            <xsl:if test="not(./XSKfrom/@mode)"><br/> from: default (DSTACK)</xsl:if>
            <xsl:if test="./XSKto/@mode"><br/>  to: <xsl:value-of 
            select="./XSKto/@mode" /></xsl:if>
            <xsl:if test="./XSKto/@entity"> (<xsl:value-of 
            select="./XSKto/@entity" />) </xsl:if>
      </xsl:template>
 
 <!-- standard mandatory From and OUTPUT -->
      <xsl:template name="fromout">
            <xsl:if test="./XSKfrom/@mode"> from: <xsl:value-of 
            select="./XSKfrom/@mode" /></xsl:if>
            <xsl:if test="not(./XSKfrom/@mode)"> from: default (DSTACK) </xsl:if>
            <xsl:if test="./XSKfrom/@entity"> (<xsl:value-of 
            select="./XSKfrom/@entity" />) </xsl:if><xsl:if 
            test="./XSKfrom/@XSKpath"> using XPath</xsl:if>
            <xsl:if test="./XSKto/@mode"> to: <xsl:value-of 
            select="./XSKto/@mode" /></xsl:if>
            <xsl:if test="not(./XSKto/@mode)"> to: OUTPUT</xsl:if>
            <xsl:if test="./XSKto/@entity"> (<xsl:value-of 
            select="./XSKto/@entity" />) </xsl:if>
            <xsl:if test="./XSKto/@mime"> as [<xsl:value-of 
               select="./XSKto/@mime" />] </xsl:if>
      </xsl:template>
 
 <!-- standard only From  -->
      <xsl:template name="onlyfrom">
            <xsl:if test="./XSKfrom/@mode"> from: <xsl:value-of 
            select="./XSKfrom/@mode" /></xsl:if>
            <xsl:if test="not(./XSKfrom/@mode)"> from: default (DSTACK) </xsl:if>
             <xsl:if test="./XSKfrom/@entity"> (<xsl:value-of 
            select="./XSKfrom/@entity" />) </xsl:if><xsl:if 
            test="./XSKfrom/@XSKpath"> using XPath</xsl:if>
      </xsl:template>
 
 <!-- standard no From, mandatory To  -->
      <xsl:template name="onlyto">
            <xsl:if test="not(./XSKto/@mode)"> to: default (DSTACK)</xsl:if>
            <xsl:if test="./XSKto/@mode"> to: <xsl:value-of 
            select="./XSKto/@mode" /></xsl:if>
            <xsl:if test="./XSKto/@entity"> (<xsl:value-of
             select="./XSKto/@entity" />) </xsl:if>
      </xsl:template>
 
 <!-- optional From and To (no defaults) -->
      <xsl:template name="norfromto">
            <xsl:if test="./XSKfrom/@mode"> from: <xsl:value-of
             select="./XSKfrom/@mode" /><xsl:if test="./XSKfrom/@entity"> (<xsl:value-of
             select="./XSKfrm/@entity" />) </xsl:if><xsl:if 
            test="./XSKfrom/@XSKpath"> using XPath</xsl:if></xsl:if>
            <xsl:if test="./XSKto/@mode"> to: <xsl:value-of 
            select="./XSKto/@mode" /><xsl:if test="./XSKto/@entity"> (<xsl:value-of
             select="./XSKto/@entity" />) </xsl:if></xsl:if>
      </xsl:template>

      <!-- special for VALIDATE -->
      <xsl:template name="valMode">
       <xsl:if test="./XSKparameter[@XSKname='mode']"> <xsl:value-of 
              select="./XSKparameter[@XSKname='mode']" /></xsl:if>
       <xsl:if test="not(./XSKparameter[@XSKname='mode'])"> DTD</xsl:if>
    </xsl:template>

      

  <!-- special for SETTRACE -->
     <xsl:template name="trace">: <xsl:if test="./XSKparameter[@XSKname='traceTask']"> TaskSTACK = &quot;<xsl:value-of
             select="./XSKparameter[@XSKname='traceTask']" />&quot;</xsl:if>
            <xsl:if test="./XSKparameter[@XSKname='traceData']"> DataSTACK = &quot;<xsl:value-of
             select="./XSKparameter[@XSKname='traceData']" />&quot;</xsl:if>
            <xsl:if test="./XSKparameter[@XSKname='traceAPI']"> APIcall = &quot;<xsl:value-of
             select="./XSKparameter[@XSKname='traceAPI']" />&quot;</xsl:if>
            <xsl:if test="./XSKparameter[@XSKname='traceDebug']"> Debug = &quot;<xsl:value-of
             select="./XSKparameter[@XSKname='traceDebug']" />&quot;</xsl:if>
       </xsl:template>
 
      <xsl:template match="*" mode="info">
            <xsl:apply-templates select="*" mode="info"/>
      </xsl:template>
 
      <xsl:template match="@*|text()" />
 
      <xsl:template match="/ | @* | node()" mode="COPY">
<!--
            <xsl:copy>
                  <xsl:apply-templates select="@* | node()" mode="COPY" />
            </xsl:copy>
-->
                  <xsl:apply-templates select="*" mode="COPY" />
      </xsl:template>
</xsl:stylesheet>
