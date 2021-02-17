###########################################################
#
# perl-module-refresh
#
###########################################################

PERL-MODULE-REFRESH_SITE=http://$(PERL_CPAN_SITE)/CPAN/authors/id/A/AL/ALEXMV
PERL-MODULE-REFRESH_VERSION=0.17
PERL-MODULE-REFRESH_SOURCE=Module-Refresh-$(PERL-MODULE-REFRESH_VERSION).tar.gz
PERL-MODULE-REFRESH_DIR=Module-Refresh-$(PERL-MODULE-REFRESH_VERSION)
PERL-MODULE-REFRESH_UNZIP=zcat
PERL-MODULE-REFRESH_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PERL-MODULE-REFRESH_DESCRIPTION=Refresh %INC files when updated on disk.
PERL-MODULE-REFRESH_SECTION=util
PERL-MODULE-REFRESH_PRIORITY=optional
PERL-MODULE-REFRESH_DEPENDS=perl
PERL-MODULE-REFRESH_SUGGESTS=
PERL-MODULE-REFRESH_CONFLICTS=

PERL-MODULE-REFRESH_IPK_VERSION=3

PERL-MODULE-REFRESH_CONFFILES=

PERL-MODULE-REFRESH_BUILD_DIR=$(BUILD_DIR)/perl-module-refresh
PERL-MODULE-REFRESH_SOURCE_DIR=$(SOURCE_DIR)/perl-module-refresh
PERL-MODULE-REFRESH_IPK_DIR=$(BUILD_DIR)/perl-module-refresh-$(PERL-MODULE-REFRESH_VERSION)-ipk
PERL-MODULE-REFRESH_IPK=$(BUILD_DIR)/perl-module-refresh_$(PERL-MODULE-REFRESH_VERSION)-$(PERL-MODULE-REFRESH_IPK_VERSION)_$(TARGET_ARCH).ipk

$(DL_DIR)/$(PERL-MODULE-REFRESH_SOURCE):
	$(WGET) -P $(@D) $(PERL-MODULE-REFRESH_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(FREEBSD_DISTFILES)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

perl-module-refresh-source: $(DL_DIR)/$(PERL-MODULE-REFRESH_SOURCE) $(PERL-MODULE-REFRESH_PATCHES)

$(PERL-MODULE-REFRESH_BUILD_DIR)/.configured: $(DL_DIR)/$(PERL-MODULE-REFRESH_SOURCE) $(PERL-MODULE-REFRESH_PATCHES) make/perl-module-refresh.mk
	rm -rf $(BUILD_DIR)/$(PERL-MODULE-REFRESH_DIR) $(PERL-MODULE-REFRESH_BUILD_DIR)
	$(PERL-MODULE-REFRESH_UNZIP) $(DL_DIR)/$(PERL-MODULE-REFRESH_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PERL-MODULE-REFRESH_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(PERL-MODULE-REFRESH_DIR) -p1
	mv $(BUILD_DIR)/$(PERL-MODULE-REFRESH_DIR) $(PERL-MODULE-REFRESH_BUILD_DIR)
	(cd $(PERL-MODULE-REFRESH_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS)" \
		PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl:$(@D)" \
		$(PERL_HOSTPERL) Makefile.PL \
		PREFIX=$(TARGET_PREFIX) \
	)
	touch $(PERL-MODULE-REFRESH_BUILD_DIR)/.configured

perl-module-refresh-unpack: $(PERL-MODULE-REFRESH_BUILD_DIR)/.configured

$(PERL-MODULE-REFRESH_BUILD_DIR)/.built: $(PERL-MODULE-REFRESH_BUILD_DIR)/.configured
	rm -f $(PERL-MODULE-REFRESH_BUILD_DIR)/.built
	$(MAKE) -C $(PERL-MODULE-REFRESH_BUILD_DIR) \
	PERL5LIB="$(STAGING_LIB_DIR)/perl5/site_perl"
	touch $(PERL-MODULE-REFRESH_BUILD_DIR)/.built

perl-module-refresh: $(PERL-MODULE-REFRESH_BUILD_DIR)/.built

$(PERL-MODULE-REFRESH_BUILD_DIR)/.staged: $(PERL-MODULE-REFRESH_BUILD_DIR)/.built
	rm -f $(PERL-MODULE-REFRESH_BUILD_DIR)/.staged
	$(MAKE) -C $(PERL-MODULE-REFRESH_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $(PERL-MODULE-REFRESH_BUILD_DIR)/.staged

perl-module-refresh-stage: $(PERL-MODULE-REFRESH_BUILD_DIR)/.staged

$(PERL-MODULE-REFRESH_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(PERL-MODULE-REFRESH_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: perl-module-refresh" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PERL-MODULE-REFRESH_PRIORITY)" >>$@
	@echo "Section: $(PERL-MODULE-REFRESH_SECTION)" >>$@
	@echo "Version: $(PERL-MODULE-REFRESH_VERSION)-$(PERL-MODULE-REFRESH_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PERL-MODULE-REFRESH_MAINTAINER)" >>$@
	@echo "Source: $(PERL-MODULE-REFRESH_SITE)/$(PERL-MODULE-REFRESH_SOURCE)" >>$@
	@echo "Description: $(PERL-MODULE-REFRESH_DESCRIPTION)" >>$@
	@echo "Depends: $(PERL-MODULE-REFRESH_DEPENDS)" >>$@
	@echo "Suggests: $(PERL-MODULE-REFRESH_SUGGESTS)" >>$@
	@echo "Conflicts: $(PERL-MODULE-REFRESH_CONFLICTS)" >>$@

$(PERL-MODULE-REFRESH_IPK): $(PERL-MODULE-REFRESH_BUILD_DIR)/.built
	rm -rf $(PERL-MODULE-REFRESH_IPK_DIR) $(BUILD_DIR)/perl-module-refresh_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(PERL-MODULE-REFRESH_BUILD_DIR) DESTDIR=$(PERL-MODULE-REFRESH_IPK_DIR) install
	find $(PERL-MODULE-REFRESH_IPK_DIR)$(TARGET_PREFIX) -name 'perllocal.pod' -exec rm -f {} \;
	(cd $(PERL-MODULE-REFRESH_IPK_DIR)$(TARGET_PREFIX)/lib/perl5 ; \
		find . -name '*.so' -exec chmod +w {} \; ; \
		find . -name '*.so' -exec $(STRIP_COMMAND) {} \; ; \
		find . -name '*.so' -exec chmod -w {} \; ; \
	)
	find $(PERL-MODULE-REFRESH_IPK_DIR)$(TARGET_PREFIX) -type d -exec chmod go+rx {} \;
	$(MAKE) $(PERL-MODULE-REFRESH_IPK_DIR)/CONTROL/control
	echo $(PERL-MODULE-REFRESH_CONFFILES) | sed -e 's/ /\n/g' > $(PERL-MODULE-REFRESH_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PERL-MODULE-REFRESH_IPK_DIR)

perl-module-refresh-ipk: $(PERL-MODULE-REFRESH_IPK)

perl-module-refresh-clean:
	-$(MAKE) -C $(PERL-MODULE-REFRESH_BUILD_DIR) clean

perl-module-refresh-dirclean:
	rm -rf $(BUILD_DIR)/$(PERL-MODULE-REFRESH_DIR) $(PERL-MODULE-REFRESH_BUILD_DIR) $(PERL-MODULE-REFRESH_IPK_DIR) $(PERL-MODULE-REFRESH_IPK)
