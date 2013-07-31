#!/bin/bash
cygwin=false;
case "`uname`" in
  CYGWIN*) cygwin=true;
esac

DIR="$( cd -P "$(dirname $( readlink -f "${BASH_SOURCE[0]}" ))" && pwd )"
HUB="$( readlink -f "$1" )"
DOCX_TEMPLATE="$( readlink -f "$2" )"
XSL=$DIR/lib/xsl/hub2docx.xsl
XSL=$DIR/lib/xsl/hub2docx.xsl
MODIFY_XPL=$DIR/lib/xpl/hub2docx.xpl

if [ -z $HUB ]; then
    echo "Usage: [DEBUG=yes|no] [HEAP=xxxxm] hub2docx.sh HUB DOCX_TEMPLATE";
    exit 1;
fi

if [ -z $DOCX_TEMPLATE ]; then
    echo "Please supply a .docx template as second argument"
    exit 1
fi

if [ -z $DEBUG ]; then
    DEBUG=no
fi

if [ -z $HEAP ]; then
    HEAP=1024m
fi

if $cygwin; then
  HUB=file:/$(cygpath -ma $HUB)
  DOCX_TEMPLATE=$(cygpath -ma $DOCX_TEMPLATE)
  XSL=file:/$(cygpath -ma $XSL)
  MODIFY_XPL=file:/$(cygpath -ma $MODIFY_XPL)
fi

$DIR/calabash/calabash.sh -i xslt="$XSL" -i xpl="$MODIFY_XPL" "$XPL" file="$DOCX" debug=$DEBUG
