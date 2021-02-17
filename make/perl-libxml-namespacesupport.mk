###########################################################
#
# perl-libxml-namespacesupport
#
###########################################################

PERL-LIBXML_NAMESPACESUPPORT_SITE=http://$(PERL_CPAN_SITE)/CPAN/authors/id/P/PE/PERIGRIN
PERL-LIBXML_NAMESPACESUPPORT_VERSION=1.11
PERL-LIBXML_NAMESPACESUPPORT_SOURCE=XML-NamespaceSupport-$(PERL-LIBXML_NAMESPACESUPPORT_VERSION).tar.gz
PERL-LIBXML_NAMESPACESUPPORT_DIR=XML-NamespaceSupport-$(PERL-LIBXML_NAMESPACESUPPORT_VERSION)
PERL-LIBXML_NAMESPACESUPPORT_UNZIP=zcat
PERL-LIBXML_NAMESPACESUPPORT_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-LIBXML_NAMESPACESUPPORT_DESCRIPTION=Perl module for supporting simple generic namespaces
PERL-LIBXML_NAMESPACESUPPORT_SECTION=util
PERL-LIBXML_NAMESPACESUPPORT_PRIORITY=optional
PERL-LIBXML_NAMESPACESUPPORT_DEPENDS=perl
PERL-LIBXML_NAMESPACESUPPORT_SUGGESTS=
PERL-LIBXML_NAMESPACESUPPORT_CONFLICTS=

PERL-LIBXML_NAMESPACESUPPORT_IPK_VERSION=2

PERL-LIBXML_NAMESPACESUPPORT_CONFFILES=

PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR=$(BUILD_DIR)/perl-libxml-namespacesupport
PERL-LIBXML_NAMESPACESUPPORT_SOURCE_DIR=$(SOURCE_DIR)/perl-libxml-namespacesupport
PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR=$(BUILD_DIR)/perl-libxml-namespacesupport-$(PERL-LIBXML_NAMESPACESUPPORT_VERSION)-ipk
PERL-LIBXML_NAMESPACESUPPORT_IPK=$(BUILD_DIR)/perl-libxml-namespacesupport_$(PERL-LIBXML_NAMESPACESUPPORT_VERSION)-$(PERL-LIBXML_NAMESPACESUPPORT_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-LIBXML_NAMESPACESUPPORT_SOURCE):
	$(WGET) -P $(@D) $(PERL-LIBXML_NAMESPACESUPPORT_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(FREEBSD_DISTFILES)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

perl-libxml-namespacesupport-source: $(DL_DIR)/$(PERL-LIBXML_NAMESPACESUPPORT_SOURCE) $(PERL-LIBXML_NAMESPACESUPPORT_PATCHES)

$(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-LIBXML_NAMESPACESUPPORT_SOURCE) $(PERL-LIBXML_NAMESPACESUPPORT_PATCHES) make/perl-libxml-namespacesupport.mk
	rm -rf $(BUILD_DIR)/$(PERL-LIBXML_NAMESPACESUPPORT_DIR) $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)
	$(PERL-LIBXML_NAMESPACESUPPORT_UNZIP) $(DL_DIR)/$(PERL-LIBXML_NAMESPACESUPPORT_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PERL-LIBXML_NAMESPACESUPPORT_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PERL-LIBXML_NAMESPACESUPPORT_DIR) -p1
	mv $(BUILD_DIR)/$(PERL-LIBXML_NAMESPACESUPPORT_DIR) $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)
	(cd $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl:$(@D)" \
		$(PERL_HOSTPERL) Makefile.PL \
		PREFIX=$(TARGET_PREFIX) \
	)
	touch $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.configured

perl-libxml-namespacesupport-unpack: $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.configured

$(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.built: $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.configured
	rm -f $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.built
	$(MAKE) -C $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR) \
	PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl"
	touch $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.built

perl-libxml-namespacesupport: $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.built

$(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.staged: $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.built
	rm -f $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.staged
	$(MAKE) -C $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.staged

perl-libxml-namespacesupport-stage: $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.staged

$(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: perl-libxml-namespacesupport" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-LIBXML_NAMESPACESUPPORT_PRIORITY)" >>$@
	@echo "Section: $(PERL-LIBXML_NAMESPACESUPPORT_SECTION)" >>$@
	@echo "Version: $(PERL-LIBXML_NAMESPACESUPPORT_VERSION)-$(PERL-LIBXML_NAMESPACESUPPORT_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-LIBXML_NAMESPACESUPPORT_MAINTAINER)" >>$@
	@echo "Source: $(PERL-LIBXML_NAMESPACESUPPORT_SITE)/$(PERL-LIBXML_NAMESPACESUPPORT_SOURCE)" >>$@
	@echo "Description: $(PERL-LIBXML_NAMESPACESUPPORT_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-LIBXML_NAMESPACESUPPORT_DEPENDS)" >>$@
	@echo "Suggests: $(PERL-LIBXML_NAMESPACESUPPORT_SUGGESTS)" >>$@
	@echo "Conflicts: $(PERL-LIBXML_NAMESPACESUPPORT_CONFLICTS)" >>$@

$(PERL-LIBXML_NAMESPACESUPPORT_IPK): $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR)/.built
	rm -rf $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR) $(BUILD_DIR)/perl-libxml-namespacesupport_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR) DESTDIR=$(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR) install
	find $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR)$(TARGET_PREFIX) -name 'perllocal.pod' -exec rm -f {} \;
	(cd $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR)$(TARGET_PREFIX)/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	find $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR)$(TARGET_PREFIX) -type d -exec chmod go+rx {} \;
	$(MAKE) $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR)/CONTROL/control
	echo $(PERL-LIBXML_NAMESPACESUPPORT_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR)

perl-libxml-namespacesupport-ipk: $(PERL-LIBXML_NAMESPACESUPPORT_IPK)

perl-libxml-namespacesupport-clean:
	-$(MAKE) -C $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR) clean

perl-libxml-namespacesupport-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-LIBXML_NAMESPACESUPPORT_DIR) $(PERL-LIBXML_NAMESPACESUPPORT_BUILD_DIR) $(PERL-LIBXML_NAMESPACESUPPORT_IPK_DIR) $(PERL-LIBXML_NAMESPACESUPPORT_IPK)
#
#
# Some sanity check for the package.
#
perl-libxml-namespacesupport-check: $(PERL-LIBXML_NAMESPACESUPPORT_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
