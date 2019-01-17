::/**  @file ShdoxFilter.bat   
:: *  Enables "*.sh" files documentation in doxygen (win).
:: *  This filter does a transformation of input 'sh' file (shellScript) to  a 'java-like' function style for Doxygen process.
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li project/EXTENSION_MAPPING section set 'sh=Java'
:: *  @li input/FILTER_PATTERNS section set value '*.sh=C:/filters_dox/ShdoxFilter.bat' (path can change).
:: *  @li input/FILE_PATTERNS section add value '*.sh' 
:: * @par Inline code
:: *  @li to include the source in documentation set source_browser/INLINE_SOURCE = true and
:: *    input/FILTER_SOURCE_FILES = true.
:: *  @see <tt>make_win.doxygen</tt> for basic doxygen config file.
:: *  @see ShdoxFilter.sh for linux version.
:: */
::/** @file
:: * @version 06/01/19 for Doxygen 1.8.15
:: * @author Copyright &copy;2006 Marco Sillano.
:: */
::
::/**
::*  Pseudo-function with actual BAT code.
::*  This driver uses @ref regexfilter.java with a regex file 'ad hoc': <tt>rgx\sh2dox.rgx</tt>.
::*  Allows single and multiline documentation blocks.
::*  @par SH &rarr; Java-like transformation rules:
::*    @li Accepts '#' (in first position) as comment mark.
::*    @li Extracts only '#' comments followed by a java block style comment: '#'+'/'+'*'+'*'  and '#'+'*'+'/'. 
::*    @li In multiline comments, every line can have '#'+'*' or only "#".
::*    @li The first block (starting '@'+'file') is the detailed file descripition block.
::*    @li Next blocks are standard variable/function block documentation. .
::*    @li Documentation works better using one or more functions and putting in last line (main) only a call to a function
::* (no code outside the functions body) and defining explicity global variables.
::*  @param %1 the path of the input <tt>*.sh</tt> file (mandatory).
::*  @return it uses sout (as required by Doxygen).
::*  @par Debug
::*  The penultimate commented line in code saves the filtered output to file <tt>%1filter.txt</tt>.
::*  @par example:
::*     See all filters/*.sh files.
::*  @see regexfilter.java
::*/
@ECHO OFF
C:
CD "C:\filters_dox\bin"
  rem rem for debug:
  :: :: java.exe regexfilter -b rgx\sh2dox.rgx  -i %1 > %1filter.txt
java.exe regexfilter -b rgx\sh2dox.rgx  -i %1

