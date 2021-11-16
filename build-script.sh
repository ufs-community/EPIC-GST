#!/bin/bash

  
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/contrib/GST/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/contrib/GST/openmpi/lib64:$LD_LIBRARY_PATH
export CC=mpicc
export FC=mpifort
export CXX=mpicxx

#apt -y install build-essential gfortran git openmpi-bin vim cmake python3 wget libexpat1-dev lmod
cd /contrib/GST
git clone -b feature/singularity https://github.com/noaa-emc/hpc-stack.git
cd hpc-stack
sed -i 's/3.9.4/3.7.9/g' config/config_custom.sh
#sed -i 's/usr\/lib\/x86_64-linux-gnu/contrib\/openmpi/g' config/config_custom.sh
#sed -i 's/lib/lib64/g' config/config_custom.sh
sed -i 's/NTHREADS=4/NTHREADS=40/g' config/config_custom.sh
#module load gcc/9.3.0
module use  /contrib/Mark.Potts/spack/share/spack/modules/linux-amzn2-skylake_avx512
module load gcc-9.3.0-gcc-7.3.1-bsb74qk 
export PATH=/contrib/hpc-modules/core/cmake/3.20.1/bin:$PATH
yes | ./setup_modules.sh -p /contrib/GST/hpc-modules -c config/config_custom.sh  
#sed -i "10 a source /usr/share/lmod/6.6/init/bash" ./build_stack.sh
sed -i "10 a export PATH=/usr/local/sbin:/usr/local/bin:$PATH" ./build_stack.sh
sed -i "10 a export LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH" ./build_stack.sh
sed -i 's/-lmpi_cxx//g' libs/build_esmf.sh 
./build_stack.sh -p /contrib/GST/hpc-modules -c config/config_custom.sh -y stack/stack_noaa.yaml -m 
cd /contrib/GST
git clone https://github.com/ufs-community/ufs-srweather-app.git
cd ufs-srweather-app 
./manage_externals/checkout_externals 
module purge
module load gcc-9.3.0-gcc-7.3.1-bsb74qk 
module use /contrib/GST/hpc-modules/modulefiles/stack
module load hpc hpc-gnu hpc-openmpi
module load cmake
module load jasper
module load zlib
module load png
module load hdf5
module load netcdf
module load pio
module load esmf
module load fms/2020.04.03
module load bacio
module load crtm
module load g2
module load g2tmpl
module load ip
module load nemsio
module load sp
module load w3emc
module load w3nco
module load upp
module load gfsio
module load sfcio
module load sigio
module load landsfcutil
module load nemsiogfs
module load wgrib2
export CMAKE_C_COMPILER=mpicc
export CMAKE_CXX_COMPILER=mpicxx
export CMAKE_Fortran_COMPILER=mpif90
export CMAKE_Platform=singularity.gnu
sed -i 's/wgrib2_lib/wgrib2/g' ./src/UFS_UTILS/sorc/chgres_cube.fd/CMakeLists.txt
sed -i '/wgrib2_api/d' ./src/UFS_UTILS/sorc/chgres_cube.fd/CMakeLists.txt
export LIBRARY_PATH=$LIBRARY_PATH:/contrib/GST/openmpi/lib64
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=.. ..
make -j 8 install

