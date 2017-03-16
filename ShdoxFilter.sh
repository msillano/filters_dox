#!/bin/sh
#/**  @file ShdoxFilter.sh 
#*    Enables "*.sh" files documentation in doxygen (linux).
#*  @par use:
#* Using Doxygen GUI, update config in 'expert' tab:
#*  @li project/EXTENSION_MAPPING section set 'sh=Java'
#*  @li input/FILTER_PATTERNS section set value '*.sh=ShdoxFilter.sh' (path can change).
#*  @li input/FILE_PATTERNS section add value '*.sh' 
#*  @li in input/EXCLUDE_SYMBOLS section add values from '__pad0__' to '__pad10__'(workaround for obscure doxygen bug).
#*  @li to include the source in documentation set source_browser/INLINE_SOURCE = true).
#* @see ShdoxFilter.bat for win version.
#*/

#/**
#*  This filter  uses regex (rgx\sh2dox.rgx).
#*  This does a transformation of input 'sh' file (shellScript)  to a 'java-like' function style for Doxygen process.
#*  Allows single and multiline documentation blocks.
#* @param %1 the path of the sh input file.
#* @par note
#*    @li Accepts '#'  sh style comments followed by a javadoc style comment: '/'+'*'+'*'
#*    and '*'+'/'
#*    @li In multiline comments, every line must have '#'+'*'
#*    @li A first optional block (starting '@'+mainpage) is the global documentation block.
#*    @li A second optional block (starting '@'+file +<name_file>) is the detailed descripition block.
#*    @li Next blocks are standard variable/function block documentation. <br />

#* Documentation works better:
#*  @li using one or more functions and putting in last line (main) only a call to a function
#* (no code outside the functions body).
#*  @li defining explicity global variables.
#*  @par example:
#*     See all filters/*.sh files.
#*  @see regexfilter.java
#*/
sh_filter (){
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
java filters/regexfilter -b sh2dox.rgx  -i $1
}
#/** Calls sh_filter() to do the job.
#*   @param $1 the input file path, required
#*/
sh_filter $1
