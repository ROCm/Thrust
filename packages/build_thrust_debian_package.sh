#!/bin/bash



mkdir -p Thrust-1.8.3-2
cd Thrust-1.8.3-2
git clone --recursive https://github.com/ROCmSoftwarePlatform/Thrust.git
cd Thrust
commit_id=$(git log -1 --format=%h)
commit_id="Thrust-1.8.3-2-$commit_id"

cd ..
mkdir -p DEBIAN ;
mkdir -p opt/rocm/include/

cd DEBIAN/
cat > control << EOF
Package: $commit_id
Essential: yes
Version: 1.8.3 
Maintainer: AMD 
Priority: required
Section: base 
Architecture: all 
Description: Thrust HIP Port 
EOF

cat > prerm << EOF
sudo rm -r /opt/rocm/include/thrust
EOF

chmod +x prerm

cd ../

mkdir -p opt/rocm/include/
cd Thrust/

find . -maxdepth 1 -type d ! -name 'thrust' | xargs rm -rf

find . -maxdepth 1 -type f ! -name 'thrust' | xargs rm -rf


mv thrust/ ../opt/rocm/include

cd ../

rm -rf Thrust/

cd ../ 
mv Thrust-1.8.3-2/ $commit_id/

dpkg --build $commit_id

sleep 20s

rm -rf $commit_id/
