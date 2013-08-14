FTPMODE=auto
MAIL=/var/mail/${LOGNAME:?}
MANPATH=@IMAGE_PREFIX@/gcc47/man:@IMAGE_PREFIX@/java/sun6/man
MANPATH=${MANPATH}:@IMAGE_PREFIX@/lib/perl5/man:@IMAGE_PREFIX@/lib/perl5/vendor_perl/man
MANPATH=${MANPATH}:@IMAGE_MANDIRS@
PAGER=less
PATH=@IMAGE_PATH@

export FTPMODE MAIL MANPATH PAGER PATH

# hook man with groff properly
if [ -x @IMAGE_PREFIX@/bin/groff ]; then
	alias man='TROFF="groff -T ascii" TCAT="cat" PAGER="less -is" /usr/bin/man -T -mandoc'
fi

# help ncurses programs determine terminal size
export COLUMNS LINES

HOSTNAME=`/usr/bin/hostname`
HISTSIZE=1000
