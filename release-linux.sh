VERSION=4.4.4.2
rm -rf ./release-linux
mkdir release-linux

cp ./src/kawkawd ./release-linux/
cp ./src/kawkaw-cli ./release-linux/
cp ./src/qt/kawkaw-qt ./release-linux/
cp ./KAWKAWCOIN_small.png ./release-linux/

cd ./release-linux/
strip kawkawd
strip kawkaw-cli
strip kawkaw-qt

#==========================================================
# prepare for packaging deb file.

mkdir kawkawcoin-$VERSION
cd kawkawcoin-$VERSION
mkdir -p DEBIAN
echo 'Package: kawkawcoin
Version: '$VERSION'
Section: base 
Priority: optional 
Architecture: all 
Depends:
Maintainer: Kawkaw
Description: Kawkaw coin wallet and service.
' > ./DEBIAN/control
mkdir -p ./usr/local/bin/
cp ../kawkawd ./usr/local/bin/
cp ../kawkaw-cli ./usr/local/bin/
cp ../kawkaw-qt ./usr/local/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../KAWKAWCOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
#!/usr/bin/env xdg-open

[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/local/bin/kawkaw-qt
Name=kawkawcoin
Comment= kawkaw coin wallet
Icon=/usr/share/icons/KAWKAWCOIN_small.png
' > ./usr/share/applications/kawkawcoin.desktop

cd ../
# build deb file.
dpkg-deb --build kawkawcoin-$VERSION

#==========================================================
# build rpm package
rm -rf ~/rpmbuild/
mkdir -p ~/rpmbuild/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}

cat <<EOF >~/.rpmmacros
%_topdir   %(echo $HOME)/rpmbuild
%_tmppath  %{_topdir}/tmp
EOF

#prepare for build rpm package.
rm -rf kawkawcoin-$VERSION
mkdir kawkawcoin-$VERSION
cd kawkawcoin-$VERSION

mkdir -p ./usr/bin/
cp ../kawkawd ./usr/bin/
cp ../kawkaw-cli ./usr/bin/
cp ../kawkaw-qt ./usr/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../KAWKAWCOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/kawkaw-qt
Name=kawkawcoin
Comment= kawkaw coin wallet
Icon=/usr/share/icons/KAWKAWCOIN_small.png
' > ./usr/share/applications/kawkawcoin.desktop
cd ../

# make tar ball to source folder.
tar -zcvf kawkawcoin-$VERSION.tar.gz ./kawkawcoin-$VERSION
cp kawkawcoin-$VERSION.tar.gz ~/rpmbuild/SOURCES/

# build rpm package.
cd ~/rpmbuild

cat <<EOF > SPECS/kawkawcoin.spec
# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing

Summary: Kawkaw wallet rpm package
Name: kawkawcoin
Version: $VERSION
Release: 1
License: MIT
SOURCE0 : %{name}-%{version}.tar.gz
URL: https://www.kawkawcoin.net/

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
%{summary}

%prep
%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

# in builddir
cp -a * %{buildroot}


%clean
rm -rf %{buildroot}


%files
/usr/share/applications/kawkawcoin.desktop
/usr/share/icons/KAWKAWCOIN_small.png
%defattr(-,root,root,-)
%{_bindir}/*

%changelog
* Tue Aug 24 2021  Kawkaw Project Team.
- First Build

EOF

rpmbuild -ba SPECS/kawkawcoin.spec



