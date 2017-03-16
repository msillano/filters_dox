#!/bin/sh
#/**  
#*  @file BatdoxFilter.sh   
#*  Enables "*.bat" files documentation in doxygen (linux).
#*  @par use:
#*  Using Doxygen GUI, update config in 'expert' tab:
#*  @li project/EXTENSION_MAPPING section set 'bat=Java'
#*  @li input/FILTER_PATTERNS section set value '*.bat=BatdoxFilter.sh' (if in path).
#*  @li input/FILE_PATTERNS section add value '*.bat' 
#*  @li input/EXCLUDE_SYMBOLS section add values '__pad0__' .. '__pad10__'(workaround).
#*  @li to include the source in documentation set source_browser/INLINE_SOURCE = true and
#*    input/FILTER_SOURCE_FILES = true.
#*  @see BatdoxFilter.bat for windows version.
#*/
#/**
#*  This filter  uses regex (rgx\bat2dox.rgx).
#*  It transforms the input 'bat' file (shellScript) to a 'java-like' function style for Doxygen process
#*  Allows single and multiline documentation blocks.
#*  @param $1 the path of the bat input file (mandatory).
#*  @return it uses sout.
#*  @par note:
#*    @li Accepts '::' and 'r|R'+'e|E'+'m|M' BAT style comments.
#*    @li Extracts only BAT comments followed by a javadoc style comment: '/'+'*'+'*'
#*    and '*'+'/'
#*    @li In multiline comments, every line must have '*'
#*    @li A first optional block (starting '@'+mainpage) is the global documentation block.
#*    @li A second optional block (starting '@'+'file' +&lt;name_file>) is the detailed descripition block.
#*    @li Last bock is the function documentation. The function body is the original BAT file, processed as comment.
#*  @par example:
#*     See all filters/*.bat files.
#*  @see regexfilter.java
#*/
bat_filter (){
# first changedir to the directory of this script
# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
 
cd `dirname "$PRG"`
java ms/filters/regexfilter -b bat2dox.rgx  -i $1
}
#/** Calls bat_filter to do the job.
#*   @param $1 the input file path, required */
bat_filter $1
