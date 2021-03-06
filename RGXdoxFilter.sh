#!/bin/sh
#/**  @file   
# *   Enables "*.RGX" files documentation in doxygen (linux).
# *   Custom file formats not programmation-like, INI-like. Filters only documentation blocks.
# *  @par use:
# *  Using Doxygen GUI, update config in 'expert' tab:
# *  @li project/EXTENSION_MAPPING section set 'rgx=Java'
# *  @li input/FILTER_PATTERNS SECTION set value '*.rgx=RGXdoxFilter.bat'(if in path).
# *  @li input/FILE_PATTERNS section add value '*.rgx' 
# *  @see RGXdoxFilter.bat for win version.
# */
#
#/**
#*  This filter uses regex (rgx\rgx2dox.rgx).
#*  It does a transformation of input 'rgx' file to a style for Doxygen process:
#*   it puts in output only the first documentation block.
#*  @param $1 the path of the input file.
#* @par note
#*    @li Accepts '#'  style comments followed by a javadoc style comment: '/'+'*'+'*'
#*    and '*'+'/'
#*    @li In multiline comments, every line can have '#'+'*' or only "#"
#*    @li The first block (starting '@'+'file') is the detailed descripition block.
#*  @par example:
#*     See all filters/bin/rgx/*.rgx files.
#*  @see regexfilter.java
#*/
oneb_filter (){
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
#/** Calls oneb_filter() to do the job.
#*   @param $1 the input file path, required
#*/
oneb_filter $1
