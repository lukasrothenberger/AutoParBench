#!/bin/bash

#//******************************************************************************************************************//
#// Copyright (c) 2020, Lawrence Livermore National Security, LLC.
#// and Federal University of Minas Gerais
#// SPDX-License-Identifier: (BSD-3-Clause)
#//*****************************************************************************************************************//

set_environment() {
# Set environment variables
COMPILER="/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/bin/clang -fopenmp=libomp -lc"
COMPILERCPP="/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/bin/clang++ -fopenmp=libomp -lc"
COMPLINK="/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/bin/clang++ -fopenmp=libomp -lc"
COMPICC="/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/bin/clang -fopenmp=libomp -lc"
DIRECTORY="CPU_reference -w"

# Map directoies inside this repository.
THIS=$(pwd)
cd "../"
SCRIPTS=$(pwd)
cd "${THIS}"
cd "../../benchmarks"
TOPDIR=$(pwd)
cd "../"

# Create a directory to store the outputs.
OUTPUTS="${THIS}/Outputs"
if [ -d "${OUTPUTS}" ]; then
  rm -r "${OUTPUTS}"
fi
mkdir "${OUTPUTS}"
}

clean_environment() {
# Delete the directory containing the outputs.
#if [ -d "${OUTPUTS}" ]; then
#  rm -r "${OUTPUTS}"
#fi
cd "${TOPDIR}/sequential"
for f in $(find . -name "*.optrpt"); do
  rm "$f"
done
cd "${TOPDIR}/original"
for f in $(find . -name "*.optrpt"); do
  rm "$f"
done
cd "${TOPDIR}/baseline"
for f in $(find . -name "*.optrpt"); do
  rm "$f"
done
cd "${TOPDIR}/reference_cpu_threading"
for f in $(find . -name "*.optrpt"); do
  rm "$f"
done
cd "${TOPDIR}/../"
for f in ${tmp_files[@]}; do
  if [ -f "${f}" ]; then
    rm "${f}"
  fi
done
cd "${THIS}"
}

run_NAS() {
# Run NAS Benchmarks to check the outputs.
CLASS=S
OUTREF=${1}
cd "${TOPDIR}/${DIRECTORY}/NPB3.0-omp-c"
NASDIR=$(pwd)
cd "${SCRIPTS}"

if [ -d bin ]; then
  rm -r bin
fi
cd "${NASDIR}"
make CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} veryclean
mkdir bin
make suite CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CFLAGS="${COMPILER_FLAGS_ONLY}"
#make bt CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CLASS=${CLASS}
#make cg CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CLASS=${CLASS}
#make ep CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CLASS=${CLASS}
#make ft CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CLASS=${CLASS}
#make is CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CLASS=${CLASS}
#make lu CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CLASS=${CLASS}
#make mg CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CLASS=${CLASS}
#make sp CLINK=${COMPILER_ONLY} CLINKFLAGS="${COMPILER_FLAGS_ONLY}" CC=${COMPILER_ONLY} CLASS=${CLASS}
cd "${NASDIR}/bin"
chmod +x bt.${CLASS}
echo "./bt.${CLASS}"
./bt.${CLASS} &> ${OUTPUTS}/bt_${OUTREF}_out.txt
chmod +x cg.${CLASS}
echo "./cg.${CLASS}"
./cg.${CLASS} &> ${OUTPUTS}/cg_${OUTREF}_out.txt
chmod +x ep.${CLASS} 
echo "./ep.${CLASS}"
./ep.${CLASS} &> ${OUTPUTS}/ep_${OUTREF}_out.txt
chmod +x ft.${CLASS}
echo "./ft.${CLASS}"
./ft.${CLASS} &> ${OUTPUTS}/ft_${OUTREF}_out.txt
chmod +x is.${CLASS}
echo "./is.${CLASS}"
./is.${CLASS} &> ${OUTPUTS}/is_${OUTREF}_out.txt
chmod +x lu.${CLASS}
echo "./lu.${CLASS}"
./lu.${CLASS} &> ${OUTPUTS}/lu_${OUTREF}_out.txt
chmod +x mg.${CLASS} 
echo "./mg.${CLASS}"
./mg.${CLASS} &> ${OUTPUTS}/mg_${OUTREF}_out.txt
chmod +x sp.${CLASS} 
echo "./sp.${CLASS}"
./sp.${CLASS} &> ${OUTPUTS}/sp_${OUTREF}_out.txt
cd "${SCRIPTS}"
}

run_Rodinia() {
# Run Rodinia Benchmarks to check the outputs.
OUTREF=${1}
cd "${TOPDIR}/${DIRECTORY}/rodinia_3.1"
RODINIADIR=$(pwd)
cd "${SCRIPTS}"
cd "${RODINIADIR}"
#make OMP_clean
#LINK=${COMPLINK} ICC=${COMPICC} CXX=${COMPILERCPP} CC=${COMPILER} make OMP
echo "b+tree"
cd "${RODINIADIR}/openmp/b+tree"
make clean
LINK=${COMPLINK} ICC=${COMPICC} CXX=${COMPILERCPP} CC=${COMPILER} make -f Makefile_without_openmp
chmod +x b+tree.out
./b+tree.out core 2 file ../../data/b+tree/mil.txt command ../../data/b+tree/command.txt &> ${OUTPUTS}/btree_${OUTREF}_out.txt
cp output.txt ${OUTPUTS}/btree_${OUTREF}_out.txt
echo "bfs"
cd "${RODINIADIR}/openmp/bfs"
make clean
LINK=${COMPLINK} ICC=${COMPICC} CXX=${COMPILERCPP} CC=${COMPILER} make -f Makefile_without_openmp
chmod +x bfs
## NOTE: Identical input values must be used to DiscoPoP instrumentation run due to memory mapping
#timeout 30 ./bfs 4 ../../data/bfs/graph1MW_6.txt &> ${OUTPUTS}/bfs_${OUTREF}_out.txt
./bfs 4 ../../data/bfs/graph65536.txt &> ${OUTPUTS}/bfs_${OUTREF}_out.txt

cp result.txt ${OUTPUTS}/bfs_${OUTREF}_out.txt
#echo "cfd"
#cd "${RODINIADIR}/openmp/cfd"
#chmod +x euler3d_cpu
#./euler3d_cpu ../../data/cfd/fvcorr.domn.097K &> ${OUTPUTS}/euler3d_${OUTREF}_out.txt
#cp density ${OUTPUTS}/euler3d_density_${OUTREF}_out.txt
#cp density_energy ${OUTPUTS}/euler3d_density_energy_${OUTREF}_out.txt
#cp momentum ${OUTPUTS}/euler3d_momentum_${OUTREF}_out.txt
#chmod +x euler3d_cpu_double
#./euler3d_cpu_double ../../data/cfd/fvcorr.domn.097K &> ${OUTPUTS}/euler3d_${OUTREF}_out.txt
#cp density ${OUTPUTS}/euler3d_double_density_${OUTREF}_out.txt
#cp density_energy ${OUTPUTS}/euler3d_double_density_energy_${OUTREF}_out.txt
#cp momentum ${OUTPUTS}/euler3d_double_momentum_${OUTREF}_out.txt
#echo "heartwall"
#cd "${RODINIADIR}/openmp/heartwall"
#chmod +x heartwall
#./heartwall ../../data/heartwall/test.avi 20 4 &> ${OUTPUTS}/heartwall_${OUTREF}_out.txt
#cp result.txt ${OUTPUTS}/heartwall_${OUTREF}_out.txt
#echo "hotspot"
#cd "${RODINIADIR}/openmp/hotspot"
#chmod +x hotspot
#./hotspot 1024 1024 2 4 ../../data/hotspot/temp_1024 ../../data/hotspot/power_1024 ${OUTPUTS}/hotspot_${OUTREF}_out.txt
#echo "hotspot3D"
#cd "${RODINIADIR}/openmp/hotspot3D"
#chmod +x 3D
#./3D 512 8 100 ../../data/hotspot3D/power_512x8 ../../data/hotspot3D/temp_512x8 ${OUTPUTS}/3d_${OUTREF}_out.txt
}

create_lists() {

SCRIPTS=$(pwd)
if [ -f "${THIS}/Correctness_Report.md" ]; then
  rm ${THIS}/Correctness_Report.md
fi

NAS=(
./bt_ref_out.txt
./cg_ref_out.txt
./ep_ref_out.txt
./ft_ref_out.txt
./is_ref_out.txt
./lu_ref_out.txt
./mg_ref_out.txt
./sp_ref_out.txt
)

DATARACEBENCH=(
./DRB001-antidep1-orig-yes.txt
./DRB002-antidep1-var-yes.txt
./DRB003-antidep2-orig-yes.txt
./DRB004-antidep2-var-yes.txt
./DRB005-indirectaccess1-orig-yes.txt
./DRB006-indirectaccess2-orig-yes.txt
./DRB007-indirectaccess3-orig-yes.txt
./DRB008-indirectaccess4-orig-yes.txt
./DRB009-lastprivatemissing-orig-yes.txt
./DRB010-lastprivatemissing-var-yes.txt
./DRB011-minusminus-orig-yes.txt
./DRB012-minusminus-var-yes.txt
./DRB013-nowait-orig-yes.txt
./DRB016-outputdep-orig-yes.txt
./DRB017-outputdep-var-yes.txt
./DRB018-plusplus-orig-yes.txt
./DRB019-plusplus-var-yes.txt
./DRB020-privatemissing-var-yes.txt
./DRB021-reductionmissing-orig-yes.txt
./DRB022-reductionmissing-var-yes.txt
./DRB024-simdtruedep-orig-yes.txt
./DRB025-simdtruedep-var-yes.txt
./DRB026-targetparallelfor-orig-yes.txt
./DRB028-privatemissing-orig-yes.txt
./DRB029-truedep1-orig-yes.txt
./DRB030-truedep1-var-yes.txt
./DRB031-truedepfirstdimension-orig-yes.txt
./DRB032-truedepfirstdimension-var-yes.txt
./DRB033-truedeplinear-orig-yes.txt
./DRB034-truedeplinear-var-yes.txt
./DRB035-truedepscalar-orig-yes.txt
./DRB036-truedepscalar-var-yes.txt
./DRB037-truedepseconddimension-orig-yes.txt
./DRB038-truedepseconddimension-var-yes.txt
./DRB039-truedepsingleelement-orig-yes.txt
./DRB040-truedepsingleelement-var-yes.txt
./DRB041-3mm-parallel-no.txt
./DRB043-adi-parallel-no.txt
./DRB044-adi-tile-no.txt
./DRB045-doall1-orig-no.txt
./DRB046-doall2-orig-no.txt
./DRB047-doallchar-orig-no.txt
./DRB048-firstprivate-orig-no.txt
./DRB049-fprintf-orig-no.txt
./DRB050-functionparameter-orig-no.txt
./DRB052-indirectaccesssharebase-orig-no.txt
./DRB053-inneronly1-orig-no.txt
./DRB054-inneronly2-orig-no.txt
./DRB055-jacobi2d-parallel-no.txt
./DRB056-jacobi2d-tile-no.txt
./DRB057-jacobiinitialize-orig-no.txt
./DRB058-jacobikernel-orig-no.txt
./DRB059-lastprivate-orig-no.txt
./DRB060-matrixmultiply-orig-no.txt
./DRB061-matrixvector1-orig-no.txt
./DRB062-matrixvector2-orig-no.txt
./DRB063-outeronly1-orig-no.txt
./DRB064-outeronly2-orig-no.txt
./DRB065-pireduction-orig-no.txt
./DRB066-pointernoaliasing-orig-no.txt
./DRB067-restrictpointer1-orig-no.txt
./DRB068-restrictpointer2-orig-no.txt
./DRB070-simd1-orig-no.txt
./DRB071-targetparallelfor-orig-no.txt
./DRB073-doall2-orig-yes.txt
./DRB084-threadprivatemissing-orig-yes.txt
./DRB085-threadprivate-orig-no.txt
./DRB090-static-local-orig-yes.txt
./DRB091-threadprivate2-orig-no.txt
./DRB092-threadprivatemissing2-orig-yes.txt
./DRB093-doall2-collapse-orig-no.txt
./DRB094-doall2-ordered-orig-no.txt
./DRB095-doall2-taskloop-orig-yes.txt
./DRB096-doall2-taskloop-collapse-orig-no.txt
./DRB097-target-teams-distribute-orig-no.txt
./DRB098-simd2-orig-no.txt
./DRB099-targetparallelfor2-orig-no.txt
./DRB104-nowait-barrier-orig-no.txt
./DRB109-orderedmissing-orig-yes.txt
./DRB110-ordered-orig-no.txt
./DRB111-linearmissing-orig-yes.txt
./DRB112-linear-orig-no.txt
./DRB113-default-orig-no.txt
./DRB114-if-orig-yes.txt
)

RODINIA=(
./3d_ref_out.txt
./bfs_ref_out.txt
./btree_ref_out.txt
./euler3d_density_energy_ref_out.txt
./euler3d_density_ref_out.txt
./euler3d_double_density_energy_ref_out.txt
./euler3d_double_density_ref_out.txt
./euler3d_double_momentum_ref_out.txt
./euler3d_momentum_ref_out.txt
./heartwall_ref_out.txt
./hotspot_ref_out.txt
)

dataracebench_micro_list=(
./DRB001-antidep1-orig-yes.c
./DRB002-antidep1-var-yes.c
./DRB003-antidep2-orig-yes.c
./DRB004-antidep2-var-yes.c
./DRB005-indirectaccess1-orig-yes.c
./DRB006-indirectaccess2-orig-yes.c
./DRB007-indirectaccess3-orig-yes.c
./DRB008-indirectaccess4-orig-yes.c
./DRB009-lastprivatemissing-orig-yes.c
./DRB010-lastprivatemissing-var-yes.c
./DRB011-minusminus-orig-yes.c
./DRB012-minusminus-var-yes.c
./DRB013-nowait-orig-yes.c
./DRB016-outputdep-orig-yes.c
./DRB017-outputdep-var-yes.c
./DRB018-plusplus-orig./DRB001-antidep1-orig-yes.c
./DRB002-antidep1-var-yes.c
./DRB003-antidep2-orig-yes.c
./DRB004-antidep2-var-yes.c
./DRB005-indirectaccess1-orig-yes.c
./DRB006-indirectaccess2-orig-yes.c
./DRB007-indirectaccess3-orig-yes.c
./DRB008-indirectaccess4-orig-yes.c
./DRB009-lastprivatemissing-orig-yes.c
./DRB010-lastprivatemissing-var-yes.c
./DRB011-minusminus-orig-yes.c
./DRB012-minusminus-var-yes.c
./DRB013-nowait-orig-yes.c
./DRB016-outputdep-orig-yes.c
./DRB017-outputdep-var-yes.c
./DRB018-plusplus-orig-yes.c
./DRB019-plusplus-var-yes.c
./DRB020-privatemissing-var-yes.c
./DRB021-reductionmissing-orig-yes.c
./DRB022-reductionmissing-var-yes.c
./DRB024-simdtruedep-orig-yes.c
./DRB025-simdtruedep-var-yes.c
./DRB026-targetparallelfor-orig-yes.c
./DRB028-privatemissing-orig-yes.c
./DRB029-truedep1-orig-yes.c
./DRB030-truedep1-var-yes.c
./DRB031-truedepfirstdimension-orig-yes.c
./DRB032-truedepfirstdimension-var-yes.c
./DRB033-truedeplinear-orig-yes.c
./DRB034-truedeplinear-var-yes.c
./DRB035-truedepscalar-orig-yes.c
./DRB036-truedepscalar-var-yes.c
./DRB037-truedepseconddimension-orig-yes.c
./DRB038-truedepseconddimension-var-yes.c
./DRB039-truedepsingleelement-orig-yes.c
./DRB040-truedepsingleelement-var-yes.c
./DRB041-3mm-parallel-no.c
./DRB043-adi-parallel-no.c
./DRB044-adi-tile-no.c
./DRB045-doall1-orig-no.c
./DRB046-doall2-orig-no.c
./DRB047-doallchar-orig-no.c
./DRB048-firstprivate-orig-no.c
./DRB049-fprintf-orig-no.c
./DRB050-functionparameter-orig-no.c
./DRB052-indirectaccesssharebase-orig-no.c
./DRB053-inneronly1-orig-no.c
./DRB054-inneronly2-orig-no.c
./DRB055-jacobi2d-parallel-no.c
./DRB056-jacobi2d-tile-no.c
./DRB057-jacobiinitialize-orig-no.c
./DRB058-jacobikernel-orig-no.c
./DRB059-lastprivate-orig-no.c
./DRB060-matrixmultiply-orig-no.c
./DRB061-matrixvector1-orig-no.c
./DRB062-matrixvector2-orig-no.c
./DRB063-outeronly1-orig-no.c
./DRB064-outeronly2-orig-no.c
./DRB065-pireduction-orig-no.c
./DRB066-pointernoaliasing-orig-no.c
./DRB067-restrictpointer1-orig-no.c
./DRB068-restrictpointer2-orig-no.c
./DRB070-simd1-orig-no.c
./DRB071-targetparallelfor-orig-no.c
./DRB073-doall2-orig-yes.c
./DRB084-threadprivatemissing-orig-yes.c
./DRB085-threadprivate-orig-no.c
./DRB090-static-local-orig-yes.c
./DRB091-threadprivate2-orig-no.c
./DRB092-threadprivatemissing2-orig-yes.c
./DRB093-doall2-collapse-orig-no.c
./DRB094-doall2-ordered-orig-no.c
./DRB095-doall2-taskloop-orig-yes.c
./DRB096-doall2-taskloop-collapse-orig-no.c
./DRB097-target-teams-distribute-orig-no.c
./DRB098-simd2-orig-no.c
./DRB099-targetparallelfor2-orig-no.c
./DRB104-nowait-barrier-orig-no.c
./DRB109-orderedmissing-orig-yes.c
./DRB110-ordered-orig-no.c
./DRB111-linearmissing-orig-yes.c
./DRB112-linear-orig-no.c
./DRB113-default-orig-no.c
./DRB114-if-orig-yes.c-yes.c
./DRB019-plusplus-var-yes.c
./DRB020-privatemissing-var-yes.c
./DRB021-reductionmissing-orig-yes.c
./DRB022-reductionmissing-var-yes.c
./DRB024-simdtruedep-orig-yes.c
./DRB025-simdtruedep-var-yes.c
./DRB026-targetparallelfor-orig-yes.c
./DRB028-privatemissing-orig-yes.c
./DRB029-truedep1-orig-yes.c
./DRB030-truedep1-var-yes.c
./DRB031-truedepfirstdimension-orig-yes.c
./DRB032-truedepfirstdimension-var-yes.c
./DRB033-truedeplinear-orig-yes.c
./DRB034-truedeplinear-var-yes.c
./DRB035-truedepscalar-orig-yes.c
./DRB036-truedepscalar-var-yes.c
./DRB037-truedepseconddimension-orig-yes.c
./DRB038-truedepseconddimension-var-yes.c
./DRB039-truedepsingleelement-orig-yes.c
./DRB040-truedepsingleelement-var-yes.c
./DRB041-3mm-parallel-no.c
./DRB043-adi-parallel-no.c
./DRB044-adi-tile-no.c
./DRB045-doall1-orig-no.c
./DRB046-doall2-orig-no.c
./DRB047-doallchar-orig-no.c
./DRB048-firstprivate-orig-no.c
./DRB049-fprintf-orig-no.c
./DRB050-functionparameter-orig-no.c
./DRB052-indirectaccesssharebase-orig-no.c
./DRB053-inneronly1-orig-no.c
./DRB054-inneronly2-orig-no.c
./DRB055-jacobi2d-parallel-no.c
./DRB056-jacobi2d-tile-no.c
./DRB057-jacobiinitialize-orig-no.c
./DRB058-jacobikernel-orig-no.c
./DRB059-lastprivate-orig-no.c
./DRB060-matrixmultiply-orig-no.c
./DRB061-matrixvector1-orig-no.c
./DRB062-matrixvector2-orig-no.c
./DRB063-outeronly1-orig-no.c
./DRB064-outeronly2-orig-no.c
./DRB065-pireduction-orig-no.c
./DRB066-pointernoaliasing-orig-no.c
./DRB067-restrictpointer1-orig-no.c
./DRB068-restrictpointer2-orig-no.c
./DRB070-simd1-orig-no.c
./DRB071-targetparallelfor-orig-no.c
./DRB073-doall2-orig-yes.c
./DRB084-threadprivatemissing-orig-yes.c
./DRB085-threadprivate-orig-no.c
./DRB090-static-local-orig-yes.c
./DRB091-threadprivate2-orig-no.c
./DRB092-threadprivatemissing2-orig-yes.c
./DRB093-doall2-collapse-orig-no.c
./DRB094-doall2-ordered-orig-no.c
./DRB095-doall2-taskloop-orig-yes.c
./DRB096-doall2-taskloop-collapse-orig-no.c
./DRB097-target-teams-distribute-orig-no.c
./DRB098-simd2-orig-no.c
./DRB099-targetparallelfor2-orig-no.c
./DRB104-nowait-barrier-orig-no.c
./DRB109-orderedmissing-orig-yes.c
./DRB110-ordered-orig-no.c
./DRB111-linearmissing-orig-yes.c
./DRB112-linear-orig-no.c
./DRB113-default-orig-no.c
./DRB114-if-orig-yes.c	
)

dataracebench_poly_list=(
./DRB041-3mm-parallel-no.c
./DRB043-adi-parallel-no.c
./DRB044-adi-tile-no.c
./DRB055-jacobi2d-parallel-no.c
./DRB056-jacobi2d-tile-no.c
)

tmp_files=(
./benchmarks/original/NPB3.0-omp-c/BT/npbparams.h
./benchmarks/original/NPB3.0-omp-c/CG/npbparams.h
./benchmarks/original/NPB3.0-omp-c/EP/npbparams.h
./benchmarks/original/NPB3.0-omp-c/FT/npbparams.h
./benchmarks/original/NPB3.0-omp-c/IS/npbparams.h
./benchmarks/original/NPB3.0-omp-c/LU/npbparams.h
./benchmarks/original/NPB3.0-omp-c/MG/npbparams.h
./benchmarks/original/NPB3.0-omp-c/SP/npbparams.h
./benchmarks/original/rodinia_3.1/openmp/b+tree/output.txt
./benchmarks/original/rodinia_3.1/openmp/bfs/bfs
./benchmarks/original/rodinia_3.1/openmp/bfs/bfs_offload
./benchmarks/original/rodinia_3.1/openmp/bfs/result.txt
./benchmarks/original/rodinia_3.1/openmp/cfd/density
./benchmarks/original/rodinia_3.1/openmp/cfd/density_energy
./benchmarks/original/rodinia_3.1/openmp/cfd/euler3d_cpu
./benchmarks/original/rodinia_3.1/openmp/cfd/euler3d_cpu_double
./benchmarks/original/rodinia_3.1/openmp/cfd/momentum
./benchmarks/original/rodinia_3.1/openmp/hotspot/hotspot
./benchmarks/original/rodinia_3.1/openmp/hotspot3D/3D
./benchmarks/sequential/NPB3.0-omp-c/sys/setparams
./benchmarks/sequential/rodinia_3.1/openmp/b+tree/output.txt
./benchmarks/sequential/rodinia_3.1/openmp/bfs/bfs
./benchmarks/sequential/rodinia_3.1/openmp/bfs/bfs_offload
./benchmarks/sequential/rodinia_3.1/openmp/bfs/result.txt
./benchmarks/sequential/rodinia_3.1/openmp/cfd/density
./benchmarks/sequential/rodinia_3.1/openmp/cfd/density_energy
./benchmarks/sequential/rodinia_3.1/openmp/cfd/euler3d_cpu
./benchmarks/sequential/rodinia_3.1/openmp/cfd/euler3d_cpu_double
./benchmarks/sequential/rodinia_3.1/openmp/cfd/momentum
./benchmarks/sequential/rodinia_3.1/openmp/heartwall/heartwall
./benchmarks/sequential/rodinia_3.1/openmp/hotspot/hotspot
./benchmarks/sequential/rodinia_3.1/openmp/hotspot3D/3D
./benchmarks/original/NPB3.0-omp-c/sys/setparams
./benchmarks/original/rodinia_3.1/openmp/heartwall/heartwall
./benchmarks/reference_cpu_threading/NPB3.0-omp-c/sys/setparams
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/cfd/density
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/cfd/density_energy
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/cfd/momentum
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/b+tree/output.txt
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/bfs/bfs
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/bfs/bfs_offload
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/bfs/result.txt
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/cfd/euler3d_cpu
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/cfd/euler3d_cpu_double
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/heartwall/heartwall
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/hotspot/hotspot
./benchmarks/reference_cpu_threading/rodinia_3.1/openmp/hotspot3D/3D
./benchmarks/baseline/NPB3.0-omp-c/sys/setparams
./benchmarks/baseline/rodinia_3.1/openmp/heartwall/heartwall
./benchmarks/baseline/NPB3.0-omp-c/sys/setparams
./benchmarks/baseline/rodinia_3.1/openmp/cfd/density
./benchmarks/baseline/rodinia_3.1/openmp/cfd/density_energy
./benchmarks/baseline/rodinia_3.1/openmp/cfd/momentum
./benchmarks/baseline/rodinia_3.1/openmp/bfs/bfs
./benchmarks/baseline/rodinia_3.1/openmp/bfs/bfs_offload
./benchmarks/baseline/rodinia_3.1/openmp/bfs/result.txt
./benchmarks/baseline/rodinia_3.1/openmp/cfd/euler3d_cpu
./benchmarks/baseline/rodinia_3.1/openmp/cfd/euler3d_cpu_double
./benchmarks/baseline/rodinia_3.1/openmp/b+tree/output.txt
./benchmarks/baseline/rodinia_3.1/openmp/hotspot/hotspot
./benchmarks/baseline/rodinia_3.1/openmp/hotspot3D/3D
)
}

run_dataracebench() {
# Run DataRaceBench Benchmarks to check the outputs.
OUTREF=${1}
cd "${TOPDIR}/${DIRECTORY}/dataracebench"
DATARACEBENCHDIR=$(pwd)
cd "${SCRIPTS}"
cd "${DATARACEBENCHDIR}"
for f in ${dataracebench_micro_list[@]}; do
  echo "${DATARACEBENCHDIR}/${f/.c/.out}"
  echo "${COMPILER} -std=c99 "${DATARACEBENCHDIR}/${f}" -o "${DATARACEBENCHDIR}/${f/.c/.out}" -lm"
  ${COMPILER} -std=c99 "${DATARACEBENCHDIR}/${f}" -o "${DATARACEBENCHDIR}/${f/.c/.out}" -lm
  eval "${DATARACEBENCHDIR}/${f/.c/.out}" &> ${OUTPUTS}/${f/.c/}_${OUTREF}_out.txt
  if [ "$?" != "0" ]; then 
    echo "Benchmark breaks < #? >" &>> ${OUTPUTS}/${f/.c/}_${OUTREF}_out.txt
  fi
  if [ -f "${DATARACEBENCHDIR}/${f/.c/.out}" ]; then
    rm "${DATARACEBENCHDIR}/${f/.c/.out}"
  fi
  if [ -f "${DATARACEBENCHDIR}/${f/.c/.optrpt}" ]; then
    rm "${DATARACEBENCHDIR}/${f/.c/.optrpt}"
  fi
done

(${COMPILER} -std=c99 -c utilities/polybench.c -o polybench.o -lm)
for f in ${dataracebench_poly_list[@]}; do
  echo "${f/.c/.out}"
  (${COMPILER} -std=c99 -c ${f} -o ${f/.c/.o} -lm)

  echo "${COMPILER} -std=c99 polybench.o ${f/.c/.o} -o ${f/.c/.out} -lm"
  ls "${DATARACEBENCHDIR}/polybench.o"
  ls "${DATARACEBENCHDIR}/${f/.c/.o}"
  (${COMPILER} -o ${f/.c/.out} -std=c99 polybench.o ${f/.c/.o} -lm)

  echo "${COMPILER} -std=c99 ${POLY_FILES} ${DATARACEBENCHDIR}/${f} -o ${DATARACEBENCHDIR}/${f/.c/.out} -lm"
  chmod +x "${DATARACEBENCHDIR}/${f/.c/.out}"
  eval "${DATARACEBENCHDIR}/${f/.c/.out}" &> ${OUTPUTS}/${f/.c/}_${OUTREF}_out.txt
  if [ "$?" != "0" ]; then
    echo "Benchmark breaks < #? >" &>> ${OUTPUTS}/${f/.c/}_${OUTREF}_out.txt
  fi
  if [ -f "${DATARACEBENCHDIR}/${f/.c/.out}" ]; then
    rm "${DATARACEBENCHDIR}/${f/.c/.out}"
  fi
  if [ -f "${DATARACEBENCHDIR}/${f/.c/.optrpt}" ]; then
    rm "${DATARACEBENCHDIR}/${f/.c/.optrpt}"
  fi
  rm ${f/.c/.o}
done
rm polybench.o

cd "${THIS}"
}

check_dataracebench() {
cd "${OUTPUTS}"
echo "<tr><th colspan='3'> DataRaceBench </th></tr>" &>> ${THIS}/reports/Correctness_Report.md
for f in ${DATARACEBENCH[@]}; do
  ground_truth_file=${f/.txt/_ground_truth_out.txt}

  # check reference output
  ref_file=${f/.txt/_ref_out.txt}
  DIFF_GT=$(diff "${OUTPUTS}/${ref_file}" "${OUTPUTS}/${ground_truth_file}")

  REPORT="<tr><td>${ref_file/_ref_out.txt/}</td>"
  if [ "$DIFF_GT" != "" ]
  then
    REPORT="${REPORT}<td>No</td>"
  else
    REPORT="${REPORT}<td>Yes</td>"
  fi

  # check DiscoPoP output for different versions
  for DISCOPOP_VERSION in $DISCOPOP_VERSIONS; do
      discopop_file=${f/.txt/_${DISCOPOP_VERSION}_out.txt}
      echo "DP FILE: ${discopop_file}"
      echo "DIFF FILE: ${OUTPUTS}/${ref_file}"
      DIFF_GT=$(diff "${OUTPUTS}/${discopop_file}" "${OUTPUTS}/${ref_file}")

      if [ "$DIFF_GT" != "" ]
      then
        REPORT="${REPORT}<td>No</td>"
      else
        REPORT="${REPORT}<td>Yes</td>"
      fi
  done
  
  
  REPORT="${REPORT}</tr>"
  echo "$REPORT" &>> ${THIS}/reports/Correctness_Report.md
done
cd "${THIS}"
}

check_rodinia() {
echo "<tr><th colspan='3'> Rodinia </th></tr>" &>> ${THIS}/reports/Correctness_Report.md
for f in ${RODINIA[@]}; do
  ref_file=${f}
  ground_truth_file=${f/_ref_out.txt/_ground_truth_out.txt}

  DIFF_GT=$(diff "${OUTPUTS}/${ref_file}" "${OUTPUTS}/${ground_truth_file}")

  REPORT="<tr><td>${ref_file/_ref_out.txt/}</td>"
  if [ "$DIFF_GT" != "" ]
  then
    REPORT="${REPORT}<td>No</td>"
  else
    REPORT="${REPORT}<td>Yes</td>"
  fi 
  
  # check DiscoPoP output
  discopop_file=${f/_ref_out.txt/_DiscoPoP_out.txt}
  echo "DP FILE: ${discopop_file}"
  echo "DIFF FILE: ${OUTPUTS}/${ground_truth_file}"
  DIFF_GT=$(diff "${OUTPUTS}/${discopop_file}" "${OUTPUTS}/${ground_truth_file}")

  if [ "$DIFF_GT" != "" ]
  then
    REPORT="${REPORT}<td>No</td>"
  else
    REPORT="${REPORT}<td>Yes</td>"
  fi
  
  REPORT="${REPORT}</tr>"
  echo "$REPORT" &>> ${THIS}/reports/Correctness_Report.md
done
}

check_nas() {
echo "<tr><th colspan='3'> NAS Parallel Benchmarks </th></tr>" &>> ${THIS}/reports/Correctness_Report.md
for f in ${NAS[@]}; do
  ref_file=${f}
  ground_truth_file=${f/_ref_out.txt/_ground_truth_out.txt}

  VALID="true"
  # If none word SUCCESSFUL or UNSUCCESSFUL were found, invalidate the result
  DIFF_GT=$(cat "${OUTPUTS}/${ground_truth_file}" | grep "SUCCESSFUL")
  if [ "$DIFF_GT" == "" ]; then
     VALID="false"
  fi
  # If the word UNSUCCESSFUL were found, invalidate the result
  DIFF_GT=$(cat "${OUTPUTS}/${ground_truth_file}" | grep "UNSUCCESSFUL")
  if [ "$DIFF_GT" != "" ]; then
     VALID="false"
  fi
  echo "DIFF OF (${OUTPUTS}/${ground_truth_file}) : $DIFF_GT"
  REPORT="<tr><td>${ref_file/_ref_out.txt/}</td>"
  if [ "$VALID" != "true" ]
  then
    REPORT="${REPORT}<td>No</td>"
  else
    REPORT="${REPORT}<td>Yes</td>"
  fi
  
  # check DiscoPoP output
  discopop_file=${f/_ref_out.txt/_DiscoPoP_out.txt}

  VALID="true"
  # If none word SUCCESSFUL or UNSUCCESSFUL were found, invalidate the result
  DIFF_GT=$(cat "${OUTPUTS}/${discopop_file}" | grep "SUCCESSFUL")
  if [ "$DIFF_GT" == "" ]; then
     VALID="false"
  fi
  # If the word UNSUCCESSFUL were found, invalidate the result
  DIFF_GT=$(cat "${OUTPUTS}/${discopop_file}" | grep "UNSUCCESSFUL")
  if [ "$DIFF_GT" != "" ]; then
     VALID="false"
  fi
  echo "DIFF OF (${OUTPUTS}/${discopop_file}) : $DIFF_GT"
  if [ "$VALID" != "true" ]
  then
    REPORT="${REPORT}<td>No</td>"
  else
    REPORT="${REPORT}<td>Yes</td>"
  fi 
  
  REPORT="${REPORT}</tr>"
  echo "$REPORT" &>> ${THIS}/reports/Correctness_Report.md
done
}

check_outputs() {
  echo "" &> ${THIS}/reports/Correctness_Report.md
  echo "# Correctness Report" &>> ${THIS}/reports/Correctness_Report.md
  echo "" &>> ${THIS}/reports/Correctness_Report.md
  echo "This report was produced comparing if the output parallel programs are equal or different from the sequential one. Yes or No are the possible values, the next step is a manual inspection." &>> ${THIS}/reports/Correctness_Report.md
  echo "" &>> ${THIS}/reports/Correctness_Report.md
  DISCOPOP_HEADERS=""
  for DISCOPOP_VERSION in $DISCOPOP_VERSIONS; do
    DISCOPOP_HEADERS="${DISCOPOP_HEADERS}<th>${DISCOPOP_VERSION}</th>"
  done
  echo "<table><tr><th>Benchmark</th><th>Ground Truth</th>${DISCOPOP_HEADERS}</tr>" &>> ${THIS}/reports/Correctness_Report.md
#  check_dataracebench
#  check_rodinia
  check_nas
  echo "</table>" &>> ${THIS}/reports/Correctness_Report.md
}

export PATH="/opt/intel/compilers_and_libraries_2019.4.243/linux/bin/intel64/:$PATH"
export LD_LIBRARY_PATH=/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src

set_environment
create_lists

CLANG_COMPILE_STRING="/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/bin/clang -fopenmp=libomp -I/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -L/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -fopenmp-targets=nvptx64 --libomptarget-nvptx-bc-path=/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/libomptarget/libomptarget-nvptx-sm_61.bc -I/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -L/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src --ptxas-path=/usr/local/cuda-11.4/bin/ptxas --cuda-path-ignore-env --cuda-path=/usr/local/cuda-11.4"

CLANGPP_COMPILE_STRING="/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/bin/clang++ -fopenmp=libomp -I/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -L/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -fopenmp-targets=nvptx64 --libomptarget-nvptx-bc-path=/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/libomptarget/libomptarget-nvptx-sm_61.bc -I/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -L/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src --ptxas-path=/usr/local/cuda-11.4/bin/ptxas --cuda-path-ignore-env --cuda-path=/usr/local/cuda-11.4"

COMPILER_ONLY="/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/bin/clang"
COMPILER_FLAGS_ONLY="-fopenmp=libomp -I/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -L/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -fopenmp-targets=nvptx64 --libomptarget-nvptx-bc-path=/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/libomptarget/libomptarget-nvptx-sm_61.bc -I/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src -L/home/lukasrothenberger/Software/clang-16_gpu/llvm-project/build/runtimes/runtimes-bins/openmp/runtime/src --ptxas-path=/usr/local/cuda-11.4/bin/ptxas --cuda-path-ignore-env --cuda-path=/usr/local/cuda-11.4"

COMPILER=$CLANG_COMPILE_STRING
COMPILERCPP=$CLANGPP_COMPILE_STRING
COMPLINK=$CLANGPP_COMPILE_STRING
COMPICC=$CLANG_COMPILE_STRING
DIRECTORY="sequential"
run_NAS "ref"
#run_Rodinia "ref"
#run_dataracebench "ref"

COMPILER=$CLANG_COMPILE_STRING
COMPILERCPP=$CLANGPP_COMPILE_STRING
COMPLINK=$CLANGPP_COMPILE_STRING
COMPICC=$CLANG_COMPILE_STRING
DIRECTORY="reference_cpu_threading"
run_NAS "ground_truth"
#run_Rodinia "ground_truth"
#run_dataracebench "ground_truth"

COMPILER=$CLANG_COMPILE_STRING
COMPILERCPP=$CLANGPP_COMPILE_STRING
COMPLINK=$CLANGPP_COMPILE_STRING
COMPICC=$CLANG_COMPILE_STRING

DISCOPOP_VERSIONS="DiscoPoP DiscoPoP_simple_gpu DiscoPoP_combined_gpu"
for DISCOPOP_VERSION in $DISCOPOP_VERSIONS; do
    DIRECTORY=$DISCOPOP_VERSION
    run_NAS $DISCOPOP_VERSION
    #run_Rodinia $DISCOPOP_VERSION
    #run_dataracebench $DISCOPOP_VERSION
done

check_outputs
clean_environment
exit 0;





