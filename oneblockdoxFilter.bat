
::/**  @file oneblockdoxFilter.bat   
:: *  Enables generic "*.xxx" files documentation in doxygen (win).
:: *  For file formats not programmation-like, as INI file. Filters only documentation blocks.
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li project/EXTENSION_MAPPING section set 'xxx=Java'
:: *  @li input/FILTER_PATTERNS section set value '*.xxx=C:/filters/oneblockdoxFilter.bat' (path can change).
:: *  @li input/FILE_PATTERNS section add value '*.xxx' 
:: *  @see oneblockdoxFilter.sh for linux version.
:: */
::
::/**
::*  This filter uses regex (rgx\oneblockdox.rgx).
::*  It does a transformation of input 'xxx' file to a style for Doxygen process:
::*  it puts in output only the first documentation block.
::*  @param %1 the path of the input file.
::* @par note
::*    @li Accepts '#'  style comments followed by a javadoc style comment: '/'+'*'+'*'
::*    and '*'+'/'
::*    @li In multiline comments, every line can have '#'+'*' or only "#".
::*    @li The first block (starting '@'+'file' +&lt;name_file>) is the detailed descripition block.
::*  @par example:
::*     See all filters/bin/rgx/*.rgx files.
::*  @see regexfilter.java
::*/
@ECHO OFF
C:
CD "C:\filters\bin"
rem java.exe regexfilter -b rgx\oneblockdox.rgx  -i %1 > %1filter.txt
java.exe regexfilter -b rgx\oneblockdox.rgx  -i %1

