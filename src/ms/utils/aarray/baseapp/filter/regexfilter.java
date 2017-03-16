/*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *  http://gnu.org/licenses/gpl.html
 */
// note: following documentation is escaped and formatted to
// give good HTML pages using Doxygen (not javadoc)
 
/**
 * @file regexfilter.java
 * Filter input text using regex/replacement pairs.
 *
 *  General purpose filter, replaces regular expressions (regex) in the input stream. 
 *  This tool can helps to create a 'c-like' syntax from shell script and other languages, suitable to be processed by Doxygen. <BR>
 *  It works like egrep and sed, or like Perl regex, but it is simpler and  it can be used on Unix/Linux  and  Windows O.S.
 *  
 * @pre 
 *      - input: standard input (allows piping) or file. 
 *      - regex: all pairs regex/replacement are in a file.
 *      - works line by line or on whole input. 
 *      - output: standard output or file
 *
 * @author M. Sillano (marco.sillano@gmail.com)
 * @version 4.02 10/11/25 (c) M.Sillano 2006-2011
 */

/**
 * @package ms.filters
 * General purpose text filters. 
 */

import java.io.File;
import java.io.IOException;

import ms.utils.aarray.baseapp.AABaseAppl;

// note: following documentation is escaped and formatted to
// give good HTML pages using doxygen (see
// http://java.sun.com/javase/6/docs/api/java/util/regex/Pattern.html#sum )

/**
 * @file regexfilter.java
 * This application implements a text filter for multiple replacements using regular expressions (regex).
 * 
 * Filters the input stream, via java.String.replaceAll(), using
 * regex/replacement pairs.@n All regex/replacement pairs are stored in an ASCII
 * file, and they are all processed in sequence for every input line or for the
 * whole input in block mode.
 * 
 * 
 * @par use
 * 
 * <PRE> 
 Usage:     regexfilter -h|-?|--help|--version",
            regexfilter [-bx] [-i=FILE] [-u=FILE] [datFile]",
            regexfilter [--CTextconfigload=FILE]|[--CXmlconfigload=FILE] "
            
            Filters the inputFile, using regex/replacement pairs in datFile.
            
            options:  -h|-?|--help    display this help and exit.
                      --version       print version and exit.
                      -b              block mode. Default = line mode.
                      -x              datFile in XML mode. Default = plain text.
            -i=FILE, --input=FILE     the text input file.
                                      Default = standard input.
            -o=FILE, --output=FILE    the text output file.
                                      Default = standard output.
            datFile:                  regex/replacement pairs file. Default = ./regexfilter.dat.
                                      if not found, builds an example file. 
            --CTextconfigload=FILE    read option/param from a config file, text mode 
                                      (can also contains regex/replacement pairs)
            --CXmlconfigload=FILE     read option/param from a config file, XML mode 
                                      (can also contains regex/replacement pairs)
            --CSaveconfig[=FILE]      save all options/parameter to a config file,
                                      default=regexfilter.dat.
 </PRE>
 * 
 * @li regex must be double-escaped ('\\\\') using regex rules (not in XML mode)
 * @li in replacement  some chars must be single-escaped (\\space, \\", \\', \\\\,
 *     \\t, \\f, \\n, \\r) and same for hexadecimal unicode: \ uxxxx. Some must be 
 *     double-escaped (\\\\$).
 * @li in replacement $n is a references to 'n' captured subsequences.
 * @li in replacement $N is the file name of the input file, $P is the path (file excluded) and $F is full path.
 * @li replacement allows empty lines (delete) <BR>
 * 
 * @par datFile - text format
 * <PRE># rule 1: replaces "# /**" with "/**" 
 regex1=^#[ ]*(/\\\\*\\\\*)
 replacement1=$1 
 # rule 2: replaces "# *"   with "*"
 regex2=^#[ ]*\\\\*
 replacement2=*</PRE>
 *
 * @par datFile - XML format
 * <PRE>&lt;comment> rule 1: replaces "# /**" with "/**"  &lt;/comment>
 &lt;entry key="regex1">^#[ ]*(/\*\*)&lt;/entry>
 &lt;entry key="replacement1">$1&lt;/entry>
 &lt;comment> rule 2: replaces "# *" with "*"  &lt;/comment>
 &lt;entry key="regex2">^#[ ]*\*&lt;/entry>
 &lt;entry key="replacement2">*&lt;/entry></PRE>
 *
 * 
 * <hr> @par Summary of regular-expression constructs
 * 
 * (from JDK 6 documentation)
 * @htmlonly <table border="0" cellpadding="1" cellspacing="0" summary="Regular
 *           expression constructs, and what they match">
 * 
 * <tr align="left">
 * <th bgcolor="#CCCCFF" align="left" id="construct">Construct</th>
 * <th bgcolor="#CCCCFF" align="left" id="matches">Matches</th>
 * </tr>
 * 
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="characters">Characters</th>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct characters"><i>x</i></td>
 * <td headers="matches">The character <i>x</i></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\\</tt></td>
 * <td headers="matches">The backslash character</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\0</tt><i>n</i></td>
 * 
 * <td headers="matches">The character with octal value <tt>0</tt><i>n</i>
 * (0&nbsp;<tt>&lt;=</tt>&nbsp;<i>n</i>&nbsp;<tt>&lt;=</tt>&nbsp;7)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\0</tt><i>nn</i></td>
 * <td headers="matches">The character with octal value <tt>0</tt><i>nn</i>
 * 
 * (0&nbsp;<tt>&lt;=</tt>&nbsp;<i>n</i>&nbsp;<tt>&lt;=</tt>&nbsp;7)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\0</tt><i>mnn</i></td>
 * <td headers="matches">The character with octal value <tt>0</tt><i>mnn</i>
 * (0&nbsp;<tt>&lt;=</tt>&nbsp;<i>m</i>&nbsp;<tt>&lt;=</tt>&nbsp;3,
 * 0&nbsp;<tt>&lt;=</tt>&nbsp;<i>n</i>&nbsp;<tt>&lt;=</tt>&nbsp;7)</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\x</tt><i>hh</i></td>
 * <td headers="matches">The character with hexadecimal&nbsp;value&nbsp;<tt>0x</tt><i>hh</i></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct characters"><tt>&#92;u</tt><i>hhhh</i></td>
 * <td headers="matches">The character with hexadecimal&nbsp;value&nbsp;<tt>0x</tt><i>hhhh</i></td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="matches"><tt>\t</tt></td>
 * <td headers="matches">The tab character (<tt>'&#92;u0009'</tt>)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\n</tt></td>
 * <td headers="matches">The newline (line feed) character (<tt>'&#92;u000A'</tt>)</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\r</tt></td>
 * <td headers="matches">The carriage-return character (<tt>'&#92;u000D'</tt>)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\f</tt></td>
 * <td headers="matches">The form-feed character (<tt>'&#92;u000C'</tt>)</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\a</tt></td>
 * <td headers="matches">The alert (bell) character (<tt>'&#92;u0007'</tt>)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\e</tt></td>
 * <td headers="matches">The escape character (<tt>'&#92;u001B'</tt>)</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct characters"><tt>\c</tt><i>x</i></td>
 * <td headers="matches">The control character corresponding to <i>x</i></td>
 * </tr>
 * 
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="classes">Character classes</th>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct classes"><tt>[abc]</tt></td>
 * 
 * <td headers="matches"><tt>a</tt>, <tt>b</tt>, or <tt>c</tt> (simple
 * class)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct classes"><tt>[^abc]</tt></td>
 * <td headers="matches">Any character except <tt>a</tt>, <tt>b</tt>, or
 * <tt>c</tt> (negation)</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct classes"><tt>[a-zA-Z]</tt></td>
 * <td headers="matches"><tt>a</tt> through <tt>z</tt> or <tt>A</tt>
 * through <tt>Z</tt>, inclusive (range)</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct classes"><tt>[a-d[m-p]]</tt></td>
 * <td headers="matches"><tt>a</tt> through <tt>d</tt>, or <tt>m</tt>
 * through <tt>p</tt>: <tt>[a-dm-p]</tt> (union)</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct classes"><tt>[a-z&&[def]]</tt></td>
 * <td headers="matches"><tt>d</tt>, <tt>e</tt>, or <tt>f</tt>
 * (intersection)</tr>
 * <tr>
 * <td valign="top" headers="construct classes"><tt>[a-z&&[^bc]]</tt></td>
 * 
 * <td headers="matches"><tt>a</tt> through <tt>z</tt>, except for
 * <tt>b</tt> and <tt>c</tt>: <tt>[ad-z]</tt> (subtraction)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct classes"><tt>[a-z&&[^m-p]]</tt></td>
 * 
 * <td headers="matches"><tt>a</tt> through <tt>z</tt>, and not <tt>m</tt>
 * through <tt>p</tt>: <tt>[a-lq-z]</tt>(subtraction)</td>
 * </tr>
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * 
 * <tr align="left">
 * <th colspan="2" id="predef">Predefined character classes</th>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct predef"><tt>.</tt></td>
 * <td headers="matches">Any character (may or may not match line terminators)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct predef"><tt>\d</tt></td>
 * <td headers="matches">A digit: <tt>[0-9]</tt></td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct predef"><tt>\D</tt></td>
 * <td headers="matches">A non-digit: <tt>[^0-9]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct predef"><tt>\s</tt></td>
 * <td headers="matches">A withespace character: <tt>[ \t\n\x0B\f\r]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct predef"><tt>\S</tt></td>
 * 
 * <td headers="matches">A non-withespace character: <tt>[^\s]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct predef"><tt>\w</tt></td>
 * <td headers="matches">A word character: <tt>[a-zA-Z_0-9]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct predef"><tt>\W</tt></td>
 * <td headers="matches">A non-word character: <tt>[^\w]</tt></td>
 * </tr>
 * 
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="posix">POSIX character classes</b> (US-ASCII only)<b></th>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Lower}</tt></td>
 * <td headers="matches">A lower-case alphabetic character: <tt>[a-z]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Upper}</tt></td>
 * 
 * <td headers="matches">An upper-case alphabetic character:<tt>[A-Z]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{ASCII}</tt></td>
 * <td headers="matches">All ASCII:<tt>[\x00-\x7F]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Alpha}</tt></td>
 * <td headers="matches">An alphabetic character:<tt>[\p{Lower}\p{Upper}]</tt></td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Digit}</tt></td>
 * <td headers="matches">A decimal digit: <tt>[0-9]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Alnum}</tt></td>
 * <td headers="matches">An alphanumeric character:<tt>[\p{Alpha}\p{Digit}]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Punct}</tt></td>
 * 
 * <td headers="matches">Punctuation: One of
 * <tt>!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~</tt></td>
 * </tr>
 * <!-- <tt>[\!"#\$%&'\(\)\*\+,\-\./:;\<=\>\?@\[\\\]\^_`\{\|\}~]</tt>
 <tt>[\X21-\X2F\X31-\X40\X5B-\X60\X7B-\X7E]</tt>
 * -->
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Graph}</tt></td>
 * <td headers="matches">A visible character: <tt>[\p{Alnum}\p{Punct}]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Print}</tt></td>
 * 
 * <td headers="matches">A printable character: <tt>[\p{Graph}\x20]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Blank}</tt></td>
 * <td headers="matches">A space or a tab: <tt>[ \t]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Cntrl}</tt></td>
 * <td headers="matches">A control character: <tt>[\x00-\x1F\x7F]</tt></td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{XDigit}</tt></td>
 * <td headers="matches">A hexadecimal digit: <tt>[0-9a-fA-F]</tt></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct posix"><tt>\p{Space}</tt></td>
 * <td headers="matches">A withespace character: <tt>[ \t\n\x0B\f\r]</tt></td>
 * </tr>
 * 
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * 
 * <tr align="left">
 * <th colspan="2">java.lang.Character classes (simple java
 * character type)</th>
 * </tr>
 * 
 * <tr>
 * <td valign="top"><tt>\p{javaLowerCase}</tt></td>
 * <td>Equivalent to java.lang.Character.isLowerCase()</td>
 * </tr>
 * <tr>
 * <td valign="top"><tt>\p{javaUpperCase}</tt></td>
 * <td>Equivalent to java.lang.Character.isUpperCase()</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top"><tt>\p{javawithespace}</tt></td>
 * <td>Equivalent to java.lang.Character.iswithespace()</td>
 * </tr>
 * <tr>
 * <td valign="top"><tt>\p{javaMirrored}</tt></td>
 * <td>Equivalent to java.lang.Character.isMirrored()</td>
 * </tr>
 * 
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="unicode">Classes for Unicode blocks and categories</th>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct unicode"><tt>\p{InGreek}</tt></td>
 * <td headers="matches">A character in the Greek&nbsp;block (simple bloc)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct unicode"><tt>\p{Lu}</tt></td>
 * <td headers="matches">An uppercase letter (simple category)</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct unicode"><tt>\p{Sc}</tt></td>
 * <td headers="matches">A currency symbol</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct unicode"><tt>\P{InGreek}</tt></td>
 * <td headers="matches">Any character except one in the Greek block (negation)</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct unicode"><tt>[\p{L}&&[^\p{Lu}]]&nbsp;</tt></td>
 * 
 * <td headers="matches">Any letter except an uppercase letter (subtraction)</td>
 * </tr>
 * 
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="bounds">Boundary matchers</th>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct bounds"><tt>^</tt></td>
 * <td headers="matches">The beginning of a line</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct bounds"><tt>$</tt></td>
 * 
 * <td headers="matches">The end of a line</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct bounds"><tt>\b</tt></td>
 * <td headers="matches">A word boundary</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct bounds"><tt>\B</tt></td>
 * <td headers="matches">A non-word boundary</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct bounds"><tt>\A</tt></td>
 * 
 * <td headers="matches">The beginning of the input</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct bounds"><tt>\G</tt></td>
 * <td headers="matches">The end of the previous match</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct bounds"><tt>\Z</tt></td>
 * <td headers="matches">The end of the input but for the final terminator, if&nbsp;any</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct bounds"><tt>\z</tt></td>
 * <td headers="matches">The end of the input</td>
 * </tr>
 * 
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="greedy">Greedy quantifiers</th>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct greedy"><i>X</i><tt>?</tt></td>
 * 
 * <td headers="matches"><i>X</i>, once or not at all</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct greedy"><i>X</i><tt>*</tt></td>
 * <td headers="matches"><i>X</i>, zero or more times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct greedy"><i>X</i><tt>+</tt></td>
 * <td headers="matches"><i>X</i>, one or more times</td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct greedy"><i>X</i><tt>{</tt><i>n</i><tt>}</tt></td>
 * <td headers="matches"><i>X</i>, exactly <i>n</i> times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct greedy"><i>X</i><tt>{</tt><i>n</i><tt>,}</tt></td>
 * <td headers="matches"><i>X</i>, at least <i>n</i> times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct greedy"><i>X</i><tt>{</tt><i>n</i><tt>,</tt><i>m</i><tt>}</tt></td>
 * <td headers="matches"><i>X</i>, at least <i>n</i> but not more than <i>m</i>
 * times</td>
 * </tr>
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="reluc">Reluctant quantifiers</th>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct reluc"><i>X</i><tt>??</tt></td>
 * <td headers="matches"><i>X</i>, once or not at all</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct reluc"><i>X</i><tt>*?</tt></td>
 * <td headers="matches"><i>X</i>, zero or more times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct reluc"><i>X</i><tt>+?</tt></td>
 * <td headers="matches"><i>X</i>, one or more times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct reluc"><i>X</i><tt>{</tt><i>n</i><tt>}?</tt></td>
 * <td headers="matches"><i>X</i>, exactly <i>n</i> times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct reluc"><i>X</i><tt>{</tt><i>n</i><tt>,}?</tt></td>
 * <td headers="matches"><i>X</i>, at least <i>n</i> times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct reluc"><i>X</i><tt>{</tt><i>n</i><tt>,</tt><i>m</i><tt>}?</tt></td>
 * <td headers="matches"><i>X</i>, at least <i>n</i> but not more than <i>m</i>
 * times</td>
 * </tr>
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="poss">Possessive quantifiers</th>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct poss"><i>X</i><tt>?+</tt></td>
 * <td headers="matches"><i>X</i>, once or not at all</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct poss"><i>X</i><tt>*+</tt></td>
 * <td headers="matches"><i>X</i>, zero or more times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct poss"><i>X</i><tt>++</tt></td>
 * <td headers="matches"><i>X</i>, one or more times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct poss"><i>X</i><tt>{</tt><i>n</i><tt>}+</tt></td>
 * <td headers="matches"><i>X</i>, exactly <i>n</i> times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct poss"><i>X</i><tt>{</tt><i>n</i><tt>,}+</tt></td>
 * <td headers="matches"><i>X</i>, at least <i>n</i> times</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct poss"><i>X</i><tt>{</tt><i>n</i><tt>,</tt><i>m</i><tt>}+</tt></td>
 * <td headers="matches"><i>X</i>, at least <i>n</i> but not more than <i>m</i>
 * times</td>
 * </tr>
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="logical">Logical operators</th>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct logical"><i>XY</i></td>
 * <td headers="matches"><i>X</i> followed by <i>Y</i></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct logical"><i>X</i><tt>|</tt><i>Y</i></td>
 * <td headers="matches">Either <i>X</i> or <i>Y</i></td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct logical"><tt>(</tt><i>X</i><tt>)</tt></td>
 * <td headers="matches">X, as a capturing group</td>
 * </tr>
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="backref">Back references</th>
 * </tr> 
 * <tr>
 * <td valign="bottom" headers="construct backref"><tt>\</tt><i>n</i></td>
 * <td valign="bottom" headers="matches">Whatever the <i>n</i><sup>th</sup>
 * capturing group matched</td>
 * </tr>
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="quot">Quotation</th>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct quot"><tt>\</tt></td>
 * <td headers="matches">Nothing, but quotes the following character</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct quot"><tt>\Q</tt></td>
 * <td headers="matches">Nothing, but quotes all characters until <tt>\E</tt></td>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct quot"><tt>\E</tt></td>
 * <td headers="matches">Nothing, but ends quoting started by <tt>\Q</tt></td>
 * </tr>
 * <!-- Metachars: !$()*+.<>?[\]^{|} -->
 * 
 * <tr>
 * <th>&nbsp;</th>
 * </tr>
 * <tr align="left">
 * <th colspan="2" id="special">Special constructs (non-capturing)</th>
 * </tr>
 * 
 * <tr>
 * <td valign="top" headers="construct special"><tt>(?:</tt><i>X</i><tt>)</tt></td>
 * 
 * <td headers="matches"><i>X</i>, as a non-capturing group</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct special"><tt>(?idmsux-idmsux)&nbsp;</tt></td>
 * <td headers="matches">Nothing, but turns match flags i d m s u x on - off</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct special"><tt>(?idmsux-idmsux:</tt><i>X</i><tt>)</tt>&nbsp;&nbsp;</td>
 * <td headers="matches"><i>X</i>, as a non-capturing group
 * with the given flags i d m s u x on - off</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct special"><tt>(?=</tt><i>X</i><tt>)</tt></td>
 * 
 * <td headers="matches"><i>X</i>, via zero-width positive lookahead</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct special"><tt>(?!</tt><i>X</i><tt>)</tt></td>
 * <td headers="matches"><i>X</i>, via zero-width negative lookahead</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct special"><tt>(?&lt;=</tt><i>X</i><tt>)</tt></td>
 * 
 * <td headers="matches"><i>X</i>, via zero-width positive lookbehind</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct special"><tt>(?&lt;!</tt><i>X</i><tt>)</tt></td>
 * <td headers="matches"><i>X</i>, via zero-width negative lookbehind</td>
 * </tr>
 * <tr>
 * <td valign="top" headers="construct special"><tt>(?&gt;</tt><i>X</i><tt>)</tt></td>
 * 
 * <td headers="matches"><i>X</i>, as an independent, non-capturing group</td>
 * </tr>
 * </table>
 *  <br><I>Copyright 2008 Sun Microsystems, Inc. Reprinted with permission 
 *  (see http://java.sun.com/javase/6/docs/api/java/util/regex/Pattern.html#sum)</I>
 * @endhtmlonly
 * 
 * @par line terminators 
 * 
 *      The following are recognized as line terminators in regex:<BR>
 *    - A newline (line feed) character ("\n"), - UNIX 
 *    - A carriage-return character followed immediately by a newline character ("\r\n"), - DOS/WIN 
 *    - A standalone carriage-return character ("\r"), - MAC
 *    - A next-line character ("\u0085Q"), 
 *    - A line-separator character ("\u2028")
 *    - A paragraph-separator character ("\u2029").
 * 
 * @par flag expressions (?idmsux-idmsux)
 * 
 * @li In <i>block mode</i> [-b] the expressions "^" and "$" match at the beginning and
 *     the end of the entire input sequence. The embedded flag expression "(?m)"
 *     enables multiline mode, so these expressions match just after or just
 *     before, respectively, any line terminator.
 * @li In  <i>dotall mode</i>, the expression "." matches any character, including a
 *     line terminator. By default this expression does not match line
 *     terminators. Dotall mode can be enabled via the embedded flag expression
 *     (?s).
 * @li  <i>Case-insensitive</i> matching for ASCII can be enabled via the embedded (?i).
 * @li  <i>Unicode-aware</i> case folding can be enabled via the embedded flag
 *     expression (?u). Requires (?i).
 * @li  <i>Comments mode</i> can be enabled via the embedded flag expression (?x). In
 *     this mode, whitespace is ignored, and embedded comments starting with #
 *     are ignored until the end of a line.
 * @li  <i>Unix-lines</i> mode can be enabled via the embedded flag expression (?d). In
 *     this mode only "\n" line terminator is recognized in the behavior of
 *     ".","^", and "$". 
 */
 
/**
 * Stand-alone text filter using regular expressions. 
 * Extends ZeroFilter defining private data
 * structures: version, help, Option, Parameter and default datFile name.<BR>
 * Input/Output from/to files or standard in/out. <BR>
 * If the Option "b" is true, the input is processed as a whole (block mode),
 * else it is processed line by line.<BR>
 * If the Option "x" is true, the datFile file is in XML format, else datFile is
 * in plain text format. This application can read options from command line or
 * from a config file: the config file can also include the regex/replacement
 * pairs. <BR>
 * 
 * @author M. Sillano (marco.sillano@gmail.com)
 * @version 4.02 10/11/25 (c) M.Sillano 2006-2011
 */

public class regexfilter extends ZeroFilter {
	// =======================================================
	// standard ZeroFIle extensions
	static private final String version = "regexfilter 4.02 (10/11/25) \n"
			+ "Copyright (C) 2006-2011  M.Sillano \n"
			+ "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html> \n"
			+ "This is free software: you are free to change and redistribute it. \n"
			+ "There is NO WARRANTY, to the extent permitted by law.";

	static private final String[] regexHelp = {
			"Usage:     regexfilter -h|-?|--help|--version",
			"           regexfilter [-bx] [-i=FILE] [-o=FILE] [datFile]",
			"           regexfilter [--CTextconfigload=FILE]|[--CXmlconfigload=FILE] ",
			"Filters the inputFile, using regex/replacement pairs in datFile.",
			"options:  -h|-?|--help    display this help and exit.",
			"          --version       print version and exit.",
			"          -b              block mode. Default = line mode.",
			"          -x              datFile in XML mode. Default = plain text.",
			"-i=FILE, --input=FILE     the text input file.",
			"                          Default = standard input.",
			"-o=FILE, --output=FILE    the text output file.",
			"                          Default = standard output.",
			"datFile:                  regex/replacement pairs file. Default =regexfilter.dat.",
			"                          if not found, builds an example file.",
			"--CTextconfigload=FILE    read option/param from config file, text mode ",
			"                          (can also contains regex/replacement pairs)",
			"--CXmlconfigload=FILE     read option/param from config file, XML mode ",
			"                          (can also contains regex/replacement pairs)",
			"--CSaveconfig=FILE        save all options/parameter to a config file",
			"                          default=regexfilter.dat."

	};
	//
	static private final String Opts = "bx";
	//
	static private final String[] Params = { "-input", "i", "-output", "o" };
	//
	static private final String DEFAULT_CONFIG = "regexfilter.cfg";
	static private final String FILETITLE = "by regexfilter 4.02 (10/11/25)";
	// end standard stuff
	// =======================================================

	static private final String DEFAULT_DATAFILE = "regexfilter.dat";

	/**
	 * Initializes aaBase and all custom data structures. It uses
	 * ZeroFilter.startup for input/output standard processing.
	 * 
	 * @param args
	 *            command line from main().
	 */
	protected static void startup(String[] args) {
		// =======================================================
		// static setup
		AABaseAppl.version = regexfilter.version;
		AABaseAppl.helpStrings = regexfilter.regexHelp;
		AABaseAppl.fileTitle = regexfilter.FILETITLE;
		// Dynamic setup
		aaBase = new AABaseAppl(Opts, Params);
		aaBase.setConfigFile(DEFAULT_CONFIG);
		ZeroFilter.startup(args);
		// end standard setup
		// =======================================================
		// ...for this filter
		// --- datFile
		if (aaBase.isOption("x"))
			aaBase.setIOMode(AABaseAppl.MODE_XML);
		else
			aaBase.setIOMode(AABaseAppl.MODE_TXT);
		//
		//  from here save config file not allowed ....
		//  merges datafile to cfg file...
		String datFileN = aaBase.getArgument(1);
		if (datFileN != null)
			aaBase.setConfigFile(datFileN);
		else
			aaBase.setConfigFile(DEFAULT_DATAFILE);
		File cnf = new File(aaBase.getConfigFile());
		if (cnf.canRead())
			aaBase.loadConfigFile();
		else
			exampleDatAndDies();
		return;
	}

	/*
	 * Creates a example datFile and exit PROCESS_FAILURE;
	 */
	private static void exampleDatAndDies() {
		aaBase.cleanAllSpecial(true, true);
		aaBase.setProperty("regex1", "^#[ ]*(/\\*\\*)");
		aaBase.setProperty("replacement1", "$1");
		aaBase.setProperty("regex2", "^#[ ]*\\*");
		aaBase.setProperty("replacement2", "*");
		aaBase.setProperty("regex3", "^#");
		aaBase.setProperty("replacement3", "//");
		aaBase.saveConfigFile();
		aaBase.helpAndDies("ERROR: not found regex definition file: this creates an example file "
				+ aaBase.getConfigFile());
	}
	
private static String getReplacement(int i){
	String rep = aaBase.getProperty("replacement" + i);
	if (inFile != null){
		try {
	if (rep.contains("$N"))
	{
		String n = inFile.getName();
		int x = n.indexOf('.');
		if (x>0)
			n=n.substring(0, x);
		rep = rep.replace("$N", n);
	}
	if (rep.contains("$F")){
		String n = inFile.getCanonicalPath();
		n = n.replace("\\","\\\\");
		rep = rep.replace("$F", n);
	}
	if (rep.contains("$P")){
		String n =  inFile.getParentFile().getCanonicalPath();
		n = n.replace("\\","\\\\");
		rep = rep.replace("$P", n);
	}
		} catch (IOException e) {
			// nothing TODO A
		}
	}
	return rep;
}
	/*
	 * processes one String
	 * @param xStr the input line or file.
	 * @return the input processed
	 */
	private static String processed(String xStr) {
		int i = 1;
		try {
		while (aaBase.containsKey("regex" + i)) {
			
			xStr = xStr.replaceAll(aaBase.getProperty("regex" + i),
					getReplacement(i));
			i++;
		}
		} 
		catch (Exception e){
			return "ERROR: "+e.toString();
		}
		return xStr;
	}

	/**
	 * The main is static. This main uses this.startup() to eval Options and
	 * Params, and uses the method process() to make the regex replacements.
	 * 
	 * @param args
	 *            command line argoments array processed by startup().
	 */
	public static void main(String[] args) {
		startup(args);
		try {
			String iStr = "";
			if (aaBase.isOption("b")) {
				// block mode
				String full = "";
				while (iStr != null) {
					iStr = fin.readLine();
					if (iStr != null)
						full += iStr + newline;
				}
				fout.print(processed(full));
			} else {
				// line mode
				while (iStr != null) {
					iStr = fin.readLine();
					if (iStr != null)
						fout.println(processed(iStr));
				}
			}
			fin.close();
			fout.flush();
			fout.close();
		} catch (Exception e) {
			System.err.println("ERROR");
			e.printStackTrace();
			System.exit(AABaseAppl.PROCESS_FAILURE);
		}
	}
}
