# Copyright (C) 2018-2020 Ruilin Peng (Nick) <pymumu@gmail.com>.
#
# smartdns is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# smartdns is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

PKG_CONFIG := pkg-config
DESTDIR :=
PREFIX := /usr
SBINDIR := $(PREFIX)/sbin
SYSCONFDIR := /etc
RUNSTATEDIR := /var/run
SYSTEMDSYSTEMUNITDIR := $(shell ${PKG_CONFIG} --variable=systemdsystemunitdir systemd)
SMARTDNS_SYSTEMD = systemd/smartdns.service

.PHONY: all clean install SMARTDNS_BIN
all: SMARTDNS_BIN 

SMARTDNS_BIN: $(SMARTDNS_SYSTEMD)
	$(MAKE) $(MFLAGS) -C src all 

$(SMARTDNS_SYSTEMD): systemd/smartdns.service.in
	cp $< $@
	sed -i 's|@SBINDIR@|$(SBINDIR)|' $@
	sed -i 's|@SYSCONFDIR@|$(SYSCONFDIR)|' $@
	sed -i 's|@RUNSTATEDIR@|$(RUNSTATEDIR)|' $@

clean:
	$(MAKE) -C src clean $(MFLAGS) 
	$(RM) $(SMARTDNS_SYSTEMD)

install: SMARTDNS_BIN 
	install -v -m 0755 -d $(DESTDIR)$(SYSCONFDIR)/smartdns
	install -v -m 0640 -t $(DESTDIR)$(SYSCONFDIR)/default etc/default/smartdns
	install -v -m 0755 -t $(DESTDIR)$(SYSCONFDIR)/init.d etc/init.d/smartdns 
	install -v -m 0640 -t $(DESTDIR)$(SYSCONFDIR)/smartdns etc/smartdns/smartdns.conf
	install -v -m 0755 -t $(DESTDIR)$(SBINDIR) src/smartdns
	install -v -m 0644 -t $(DESTDIR)$(SYSTEMDSYSTEMUNITDIR) systemd/smartdns.service 

