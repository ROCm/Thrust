#!/bin/bash

Working_dir=$(pwd)

mkdir -p ThrustPackage
cd ThrustPackage
git clone --recursive https://github.com/ROCmSoftwarePlatform/Thrust.git
cd Thrust

commit_id=$(git log -1 --format=%h)
TAR_FILE="Thrust-1.8.3"

find . -maxdepth 1 -type d ! -name 'thrust' | xargs rm -rf

find . -maxdepth 1 -type f ! -name 'thrust' | xargs rm -rf

mkdir -p  $HOME/rpmbuild/SOURCES/$TAR_FILE/opt/rocm/include
cp -R thrust/ $HOME/rpmbuild/SOURCES/$TAR_FILE/opt/rocm/include/

cd $HOME/rpmbuild/SOURCES/
tar -cvzf $TAR_FILE.tar.gz $TAR_FILE/

cd ../SPECS/
cat > Thrust-1.8.3-2.spec<<EOF
Name:           Thrust
Version:        1.8.3                 
Release:        2   
Summary:        Thrust HIP Port 

Group:          ROCm               
License:        GPL 
Source0:        $TAR_FILE.tar.gz    
BuildArch:      noarch 
BuildRoot:      %{_tmppath}/%{name}-buildroot 

%description
Thrust RPM installation package

%prep
%setup -q

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}
cp -R * %{buildroot}


%files
%defattr(-,root,root,-)
/opt/rocm/include/thrust

EOF

#create rpm build 
cd  ../
rpmbuild  -ba SPECS/Thrust-1.8.3-2.spec
sleep 10s
final_name=Thrust-1.8.3-2-$commit_id-noarch.rpm
mv $HOME/rpmbuild/RPMS/noarch/Thrust-1.8.3-2.noarch.rpm $Working_dir
mv $Working_dir/Thrust-1.8.3-2.noarch.rpm  $Working_dir/$final_name
rm -rf $Working_dir/ThrustPackage
