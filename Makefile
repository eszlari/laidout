###############################################
##############                  ###############
#############  Laidout Makefile  ##############
##############                  ###############
###############################################

 # Makefile-toinclude, generated by configure, 
 # defines LAXDIR, PREFIX, and LAIDOUTVERSION
include Makefile-toinclude


 # where the main executable goes
BINDIR=$(PREFIX)/bin
 # like /usr/local/share/, examples go here: $SHAREDIR/laidout
SHAREDIR=$(PREFIX)/share


 ### If you want to be sure that an install does not clobber anything that exists
 ### already, then uncomment the line with the '--backup=t' and comment out the other.
#INSTALL=install -D --backup=t 
INSTALL=install -D

INSTALLDIR=install -d

LAIDOUTNAME=laidout-$(LAIDOUTVERSION)

laidout: touchdepends
	cd src && $(MAKE)
	cd src/po && $(MAKE)

all: laidout docs

icons:
	cd src/icons && make

docs:
	cd docs && doxygen
	
alldocs:
	cd docs && doxygen Doxyfile-with-laxkit

quickref:
	src/laidout -H > QUICKREF.html

install: 
	echo 'Installing to $(BINDIR)/laidout which points to $(BINDIR)/$(LAIDOUTNAME)'
	$(INSTALL) -m755 src/laidout $(BINDIR)/$(LAIDOUTNAME)
	$(INSTALLDIR) $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/examples
	$(INSTALL) -m644 -t $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/examples examples/*
	$(INSTALLDIR) $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/icons
	$(INSTALL) -m644 -t $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/icons src/icons/*.png
	$(INSTALLDIR) $(SHAREDIR)/applications
	$(INSTALL) -m644 deb/laidout.desktop $(SHAREDIR)/applications
	$(INSTALLDIR) $(SHAREDIR)/icons/hicolor/48x48/apps
	$(INSTALL) -m644 src/icons/laidout-48x48.png $(SHAREDIR)/icons/hicolor/48x48/apps/laidout.png
	$(INSTALLDIR) $(SHAREDIR)/icons/hicolor/scalable/apps
	$(INSTALL) -m644 src/icons/laidout.svg $(SHAREDIR)/icons/hicolor/scalable/apps/laidout.svg
	$(INSTALLDIR)       $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/coop/processing
	$(INSTALL) -m644 -t $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/coop/processing coop/processing/*
	$(INSTALLDIR)       $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/coop/scribus
	$(INSTALL) -m644 -t $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/coop/scribus coop/scribus/*
	$(INSTALLDIR)       $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/coop/html/scrim
	$(INSTALL) -m644 -t $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/coop/html/scrim coop/html/scrim/*
	$(INSTALL) -m644 -t $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/coop/html/ coop/html/*html coop/html/*md
	#$(INSTALL) -m644 -t $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/coop/ coop/*
	$(INSTALLDIR)       $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/plugins
	$(INSTALL) -m755 -t $(SHAREDIR)/laidout/$(LAIDOUTVERSION)/plugins src/plugins/*.so

	rm -f $(BINDIR)/laidout
	ln -s $(LAIDOUTNAME) $(BINDIR)/laidout
	cd src/po && $(MAKE) install

# ****** TODO!!! this is very primitive make uninstall!!
# should only uninstall things that were actually installed. Any resource added by
# the user to the system wide directories should not be uninstalled. Should use
# config log perhaps. The $(BINDIR)/laidout should be removed only if it points to
# $(BINDIR)/$(LAIDOUTNAME)
uninstall: 
	echo 'Uninstalling laidout.'
	echo '  Removing $(BINDIR)/laidout'
	rm -f  $(BINDIR)/laidout
	echo '  Removing $(SHAREDIR)/laidout/$(LAIDOUTVERSION)'
	rm -fr $(SHAREDIR)/laidout/$(LAIDOUTVERSION)
	echo '  Removing $(BINDIR)/$(LAIDOUTNAME)'
	rm -f  $(BINDIR)/$(LAIDOUTNAME)
	cd src/po && $(MAKE) uninstall

#link debian to deb if not there.. Debian guidelines say don't put 
#a "debian" directory in upstream sources by default.
deb: touchdepends
	touch Makefile-toinclude
	if [ ! -e debian ] ; then ln -s deb debian; fi
	dpkg-buildpackage -rfakeroot

tar:
	sh deb/maketar.sh

hidegarbage: touchdepends
	cd src && $(MAKE) hidegarbage

unhidegarbage: touchdepends
	cd src && $(MAKE) unhidegarbage

depends: touchdepends
	cd src && $(MAKE) depends

SOURCEDIRS= \
	src \
	src/api \
	src/calculator \
	src/core \
	src/dataobjects \
	src/filetypes \
	src/impositions \
	src/interfaces \
	src/nodes \
	src/plugins \
	src/plugins/geglnodes \
	src/polyptych/src \
	src/printing \
	src/text \
	src/ui 

touchdepends:
	for NAME in $(SOURCEDIRS); do touch $$NAME/makedepend; done

# remove everything that is generated, but not in repo
dist-clean: clean
	for NAME in $(SOURCEDIRS); do rm -f $$NAME/makedepend $$NAME/makedepend.bak; done
	rm -f Makefile-toinclude config.log src/version.h src/configured.h
	rm -f src/po/*.mo

.PHONY: all icons laidout dist-clean clean docs install uninstall hidegarbage unhidegarbage depends touchdepends deb
clean:
	cd src && $(MAKE) clean
	cd src/polyptych && $(MAKE) clean

