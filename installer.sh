#!/bin/sh
INSTALLDIR="/Applications/KidsRuby"
CODEDIR="/usr/local/kidsruby"
RUBY_BIN=$CODEDIR/ruby/bin/ruby
GEM_HOME=$CODEDIR/ruby/lib/ruby/gems/1.9.1
RUBY_VERSION="1.9.2-p320"
QT_VERSION="4.7.3"

init_messages() {
  SHORTLANG=$(defaults read .GlobalPreferences AppleLanguages | tr -d [:space:] | cut -c2-3)
  KIDSRUBY_INSTALLER=$SHORTLANG".sh"
  if [ -f $KIDSRUBY_INSTALLER ]
  then
    source $KIDSRUBY_INSTALLER
  else
    source "en.sh"
  fi
}

check_osx_version() {
  TIGER=4
  LEOPARD=5
  SNOW_LEOPARD=6
  LION=7
  MOUNTAIN_LION=8
  osx_version=$(sw_vers -productVersion | awk 'BEGIN {FS="."}{print $2}')
  if [ $osx_version -eq $LEOPARD -o $osx_version -eq $SNOW_LEOPARD -o $osx_version -eq $LION -o $osx_version -eq $MOUNTAIN_LION ]; then
    echo $KIDSRUBY_START_INSTALL
  else
    echo $KIDSRUBY_ERROR_NOT_SUPPORTED
    exit
  fi
}

check_processor_architecture() {
  INTEL=i386
  processor_arch=$(uname -p)
  if [ $processor_arch != $INTEL ]; then
    echo $KIDSRUBY_ERROR_NOT_SUPPORTED
    exit
  fi
}

create_install_dir() {
	echo $KIDSRUBY_CREATE_INSTALL_DIRECTORY
	if [ ! -d "$INSTALLDIR" ]
	then
		mkdir "$INSTALLDIR"
	fi
}

install_qt() {
	echo $KIDSRUBY_INSTALLING_QT
	hdiutil attach qt-mac-opensource-4.7.3.dmg
	/usr/sbin/installer -verbose -pkg "/Volumes/Qt $QT_VERSION/Qt.mpkg" -target /
	hdiutil detach "/Volumes/Qt 4.7.3"
}

install_git() {
	echo $KIDSRUBY_INSTALLING_GIT
	hdiutil attach git-1.7.6-i386-snow-leopard.dmg
	/usr/sbin/installer -verbose -pkg "/Volumes/Git 1.7.6 i386 Snow Leopard/git-1.7.6-i386-snow-leopard.pkg" -target /
	hdiutil detach "/Volumes/Git 1.7.6 i386 Snow Leopard"
}

install_ruby() {
	echo $KIDSRUBY_INSTALLING_RUBY
	tar -xvzf "ruby-$RUBY_VERSION.universal.tar.gz" -C "$CODEDIR/"
	export PATH="$CODEDIR/ruby/bin:$PATH"
	chmod -R a+r "$CODEDIR"
	chmod -R go-w "$CODEDIR"
}

symlink_qtbindings() {
	export DYLD_LIBRARY_PATH=$CODEDIR:$DYLD_LIBRARY_PATH
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtcore/libsmokeqtcore.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtgui/libsmokeqtgui.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtxml/libsmokeqtxml.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtopengl/libsmokeqtopengl.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtsql/libsmokeqtsql.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtnetwork/libsmokeqtnetwork.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtsvg/libsmokeqtsvg.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/ruby/qtruby/src/libqtruby4shared.2.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/smokebase/libsmokebase.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtwebkit/libsmokeqtwebkit.3.dylib $CODEDIR/lib
	ln -s $CODEDIR/ruby/lib/ruby/gems/1.9.1/gems/qtbindings-$QT_VERSION-universal-darwin-10/ext/build/smoke/qtdbus/libsmokeqtdbus.3.dylib $CODEDIR/lib
}

install_kidsruby() {
	echo $KIDSRUBY_INSTALLING_EDITOR
	tar -xvzf kidsruby.tar.gz -C "$INSTALLDIR"
}

install_commands() {
	echo $KIDSRUBY_INSTALLING_COMMANDS
	tar -xvzf KidsRuby.app.tar.gz -C "$INSTALLDIR"
	cp kidsirb.sh "$INSTALLDIR"
}

check_lib_dir() {
	echo $KIDSRUBY_CREATE_CODE_DIRECTORY
	if [ ! -d "$CODEDIR" ]
	then
		mkdir "$CODEDIR"
	fi
	chmod -R a+r "$CODEDIR"
	if [ ! -d "$CODEDIR/lib" ]
	then
		mkdir "$CODEDIR/lib"
	fi
	chmod -R a+w "$CODEDIR/lib"
}

init_messages
check_processor_architecture
check_osx_version
create_install_dir

install_kidsruby
install_commands

install_qt
install_git
# # install libyaml here?

check_lib_dir
install_ruby
symlink_qtbindings

echo $KIDSRUBY_END_INSTALL
