rem global:
:: /**  
:: *   @file XSLTdoxFilter.bat 
:: *   Enables XSLT ("*.xsl") files documentation in doxygen (win).
:: *   Any "xsl:template" is processed as a function, and can have a documentation block.
:: *   
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li in project/EXSTENSION_MAPPING add 'xsl=Java';
:: *  @li input/FILTER_PATTERNS section set value '*.xsl=C:/filters/XMLdoxFilter.bat' (path can change).
:: *  @li input/FILE_PATTERNS section add value '*.xsl' 
:: *  @see make.dox model for doxygen config file.
:: *  @li to include the source in documentation set source_browser/INLINE_SOURCE = true and
:: *    input/FILTER_SOURCE_FILES = true.
:: *  @see XSLTdoxFilter.sh for linux version
:: */
rem
::/**
::*  This filter does a transformation of input 'xmlt' file 
::*   to a 'java-like' style for Doxygen process. Uses the xslt2doxfilter.java application.
::*  @param %1 the path of the XSLT input file.
::*  @return it uses sout.
::*  @par note:
::*    @li Extracts only XML comments (&lt;!-- -->) followed by a javadoc style comment: '/'+'*'+'*'
::*    and '*'+'/' <br /> 
::*    @li processes only documentation blocks at first livel, inside the &lt;xsl:stylesheet> root tag.
::*    @li a first optional block (starting '@'+mainpage) is the global documentation block.
::*    @li a second optional block (starting '@'+'file' +&lt;name_file>) is the detailed descripition block.
::*    @li all next blocks are associated to following &lt;xsl:template>
::*  @par example:
::*     See bin/xslt/libPrintCol.xsl.
::*   @see xslt2doxfilter.java
::*/
rem code starts here:
@ECHO OFF
C:
CD "C:\filters\bin"
java.exe xslt2doxfilter  -d  -i %1  > %1out.txt
java.exe xslt2doxfilter -d -i %1  
