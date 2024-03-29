# -*- rpm-spec -*-
# Copyright (C) 2004-2008 Daniel Berrange <dan@berrange.com>

use strict;
use warnings;

die unless (scalar @ARGV == 1);

open SRC, "lib/Net/DBus/GLib.pm"
    or die "lib/Net/DBus/GLib.pm: $!";

our $VERSION;
while (<SRC>) {
    if (/\$VERSION\s*=\s*'(.*)'/) {
	$VERSION=$1;
    }
}
close SRC;

local $/ = undef;
$_ = <DATA>;
s/\@VERSION\@/$VERSION/g;

open SPEC, ">$ARGV[0]" or die "$!";
print SPEC $_;
close SPEC;
__DATA__
# Automatically generated by Net-DBus-GLib.spec.PL


%define appname Net-DBus-GLib
%define _extra_release %{?extra_release:%{extra_release}}

Summary: Perl API to the DBus GLib extensions
Name: perl-%{appname}
Version: @VERSION@
Release: 1%{_extra_release}
License: GPLv2+ or Artistic
Group: Development/Libraries
URL:            http://search.cpan.org/dist/%{appname}
Source0:        http://www.cpan.org/modules/by-module/Net/%{appname}-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires:       perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))
Requires: dbus-glib >= 0.33
BuildRequires: dbus-glib-devel >= 0.33
BuildRequires: perl(Net::DBus)
BuildRequires: perl(Glib)
BuildRequires:  perl(Test::More)
BuildRequires:  perl(Test::Pod)
BuildRequires:  perl(Test::Pod::Coverage)

%description
Provides a Perl API to the DBus GLib extensions

%prep
%setup -q -n %{appname}-%{version}


%build
if [ -z "$DBUS_HOME" ]; then
  %{__perl} Makefile.PL INSTALLDIRS=vendor
else
  %{__perl} Makefile.PL INSTALLDIRS=vendor DBUS_HOME=$DBUS_HOME
fi
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT

make pure_install PERL_INSTALL_ROOT=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name perllocal.pod -exec rm -f {} \;
find $RPM_BUILD_ROOT -name .packlist -exec rm -f {} \;

%{_fixperms} $RPM_BUILD_ROOT/*

%check
make test

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc README CHANGES AUTHORS LICENSE examples/*.pl
%{_mandir}/man3/*
%{perl_vendorarch}/Net/DBus/GLib.pm
%{perl_vendorarch}/auto/Net/DBus/GLib

%changelog
* Mon Jan  7 2008 Daniel P. Berrange <dan@berrange.com> - 0.33.0-1
- Initial build

