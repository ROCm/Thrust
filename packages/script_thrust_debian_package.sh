#!/bin/bash

mkdir -p Thrust-1.8.2-1.el7/DEBIAN ; 
cd Thrust-1.8.2-1.el7/DEBIAN ;

cat > control << "EOF"
Package: Thrust-1.8.2-1.el7 
Version: 1.8.2 
Maintainer: AMD 
Priority: optional
Section: base 
Architecture: all 
Description: Thrust HIP Port 
EOF

cat > prerm << "EOF"
sudo rm -r /opt/rocm/include/thrust
EOF

chmod +x prerm

cd ../

mkdir -p opt/rocm/include/

git clone --recursive https://github.com/ROCmSoftwarePlatform/Thrust.git

cd Thrust/

find . -maxdepth 1 -type d ! -name 'thrust' | xargs rm -rf

find . -maxdepth 1 -type f ! -name 'thrust' | xargs rm -rf

#tar -zcvf Thrust-1.8.2-1.el7.tar.gz thrust/

mv thrust/ ../opt/rocm/include

cd ../

rm -rf Thrust/
#tar -zxvf Thrust-1.8.2-1.el7.tar.gz 

cd ../ 

dpkg --build Thrust-1.8.2-1.el7
