rem global:
:: /**  
:: *   @file XMLdoxFilter.bat 
:: *   Enables "*.xml" files documentation (no source) in doxygen (win).
:: *   
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li in input/FILTER_PATTERNS section add the value '*.xml=C:/filters/XMLdoxFilter.bat' (path can change).
:: *  @li in input/FILE_PATTERNS section add the value '*.xml' 
:: *  @li in project/EXSTENSION_MAPPING add 'xml=Java';
:: *  @see XMLdoxFilter_is.bat for XML source inclusion.
:: *  @see XMLdoxFilter.sh for linux version
:: */
rem
::/**
::*  This filter uses a XSLT file (xslt\xml2dox.xslt) to do a tranformation on the input 'xml'
::*   file to a 'java-like' function style for Doxygen process.
::*  @param %1 the path of the XML input file.
::*  @return it uses sout.
::*  @par note:
::*   @li processes comments (&lt;!-- -->) followed by a javadoc style comment: '/'+'*'+'*'
::*    and '*'+'/' <br /> 
::*    @li processes only blocks at first livel, inside the root tag.
::*    @li a first optional block (starting '@'+mainpage) is the global documentation block.
::*    @li a second optional block (starting '@'+'file' +&lt;name_file>) is the detailed descripition block.
::*    @li the last bock is the XML documentation (as a whole).
::*    @li the source XML code is NOT included in documentation
::*  @par example:
::*     See sample_files/example01.xml.
::*   @see xmlfilter.java
::*/
rem code starts here:
@ECHO OFF
C:
CD "C:\filters\bin"
rem java.exe  xmlfilter  xslt\xml2dox.xslt -i %1  --usr="INLINE_SOURCE&false" > %1filter.txt
java.exe  xmlfilter  xslt\xml2dox.xslt -i %1  --usr="INLINE_SOURCE&false" 
