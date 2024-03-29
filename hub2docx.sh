#!/bin/bash
cygwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true;
esac

DIR="$( cd -P "$(dirname $( readlink -f "${BASH_SOURCE[0]}" ))" && pwd )"
HUB="$( readlink -f "$1" )"
DOCX_TEMPLATE="$( readlink -f "$2" )"
XPL=$DIR/docx_modify-lib/xpl/docx_modify.xpl
MODIFY_XPL=$DIR/hub2docx-lib/xpl/hub2docx.xpl
XSL=$DIR/hub2docx-lib/xsl/hub2docx.xsl
DEBUG_DIR_URI=debug

if [ -z $HUB ]; then
    echo "Usage: [DEBUG=yes|no] [HEAP=xxxxm] hub2docx.sh SOURCE_XML HUB DOCX_TEMPLATE";
    exit 1;
fi

if [ -z $DOCX_TEMPLATE ]; then
    echo "Please supply a .docx template as second argument"
    exit 1
fi

if [ -z $DEBUG ]; then
    DEBUG=no
fi

if [ -z $DEBUG_DIR_URI ]; then
    DEBUG_DIR_PARAM=""
else
    DEBUG_DIR_PARAM="debug-dir-uri=$DEBUG_DIR_URI"
fi

if [ -z $HEAP ]; then
    HEAP=1024m
fi


if $cygwin; then
  HUB=file:/$(cygpath -ma $HUB)
  DOCX_TEMPLATE=$(cygpath -ma $DOCX_TEMPLATE)
  XPL=file:/$(cygpath -ma $XPL)
  XSL=file:/$(cygpath -ma $XSL)
  MODIFY_XPL=file:/$(cygpath -ma $MODIFY_XPL)
  DEBUG_DIR_PARAM="debug-dir-uri=file:/$(cygpath -ma $DEBUG_DIR_URI)"
fi

echo HUB: $HUB
echo DOCX_TEMPLATE: $DOCX_TEMPLATE
echo XPL: $XPL
echo XSL: $XSL

$DIR/calabash/calabash.sh -i xslt="$XSL" -i xpl="$MODIFY_XPL" -i external-sources="$HUB" "$XPL" file="$DOCX_TEMPLATE" debug=$DEBUG $DEBUG_DIR_PARAM
