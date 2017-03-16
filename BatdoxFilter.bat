rem file doc
:: /**  
:: *  @file BatdoxFilter.bat 
:: *  Enables "*.bat" files documentation in doxygen (win).
:: *  @par use:
:: *  Using Doxygen GUI, update dox config file in 'expert' tab:
:: *  @li in project/EXSTENSION_MAPPING add 'bat=Java';
:: *  @li in input/FILE_PATTERNS section add value '*.bat'.
:: *  @li in input/FILTER_PATTERNS section set value '*.bat=C:/filters/BatdoxFilter.bat' (path can change).
:: *  @li in input/EXCLUDE_SYMBOLS section add values from '__pad0__' to '__pad10__'(workaround for obscure doxygen bug).
:: *  @li to include the source in documentation set source_browser/INLINE_SOURCE = true and
:: *    input/FILTER_SOURCE_FILES = true.
:: *  @see BatdoxFilter.sh for linux version.
:: * 
:: */
rem code doc
::/**
::*  This filter uses regex (rgx\bat2dox.rgx).
::*  It tranforms the input 'bat'
::*   file (shellScript) to a 'java-like' function style for Doxygen process.
::*  @param %1 the path of the bat input file (mandatory).
::*  @return it uses sout.
::*  @par note:
::*    @li Accepts '::' and 'r|R'+'e|E'+'m|M' BAT style comments.
::*    @li Extracts only BAT comments followed by a javadoc style comment: '/'+'*'+'*'
::*    and '*'+'/'
::*    @li In multiline comments, every line must have '*'
::*    @li A first optional block (starting '@'+mainpage) is the global documentation block.
::*    @li A second optional block (starting '@'+'file'+&lt;name_file>) is the detailed descripition block.
::*    @li Last bock is the code documentation. The function body is the original BAT file, processed as comment.
::*  @par example:
::*     See all filters/*.bat files.
::*  @see regexfilter.java
::*/
rem code starts here:
@ECHO OFF
C:
CD "C:\filters\bin"
rem java.exe regexfilter -b rgx\bat2dox.rgx  -i %1 -o %1filter.txt
java.exe regexfilter -b rgx\bat2dox.rgx  -i %1 
