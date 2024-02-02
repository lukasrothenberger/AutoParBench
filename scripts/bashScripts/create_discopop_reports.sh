#!/bin/bash

#//******************************************************************************************************************//
#// Copyright (c) 2020, Lawrence Livermore National Security, LLC.
#// and Federal University of Minas Gerais
#// SPDX-License-Identifier: (BSD-3-Clause)
#//*****************************************************************************************************************//

# This script can run discopop in all benchmarks that do not need an input.

if [ "$#" -ne 0 ]; then
  echo "$# Illegal number of parameters"
  exit 1;
fi

# Step 1 : Create a copy of the benchmarks to run discopop
THIS=$(pwd)
cd ../
SCRIPTS=$(pwd)
REFERENCE_DIRECTORY="sequential"
cd ${THIS}

cd ${SCRIPTS}/../benchmarks/${REFERENCE_DIRECTORY}
INPUT_DIR=$(pwd)
cd ${THIS}

if [ -d "${SCRIPTS}/../benchmarks/DiscoPoP" ]; then
  rm -rvf "${SCRIPTS}/../benchmarks/DiscoPoP"
fi

cp -r "${INPUT_DIR}" "${SCRIPTS}/../benchmarks/DiscoPoP"

cd "${SCRIPTS}/../benchmarks/DiscoPoP"
OUTPUT_DIR=$(pwd)
cd ${SCRIPTS}

if [ -f "${THIS}/logs/discopop.log" ]; then
  rm ${THIS}/logs/discopop.log
fi
echo "Copied reference directory."

echo "Skipped compilation of NPB3."
#COMPILER="icc -qopenmp -w"
#if [ -d "${SCRIPTS}/../benchmarks/DiscoPoP/NPB3.0-omp-c/" ]; then
#  mkdir "${SCRIPTS}/../benchmarks/DiscoPoP/NPB3.0-omp-c/bin"
#  cd "${SCRIPTS}/../benchmarks/DiscoPoP/NPB3.0-omp-c/"
#  CLINK=${COMPILER} CC=${COMPILER} make suite
#  rm -r "${SCRIPTS}/../benchmarks/DiscoPoP/NPB3.0-omp-c/bin"
#fi
#cd "${THIS}"

cd $OUTPUT_DIR
DATARACEBENCH_BENCHS=$(find dataracebench -name "*.c" | sort)
#DATARACEBENCH_BENCHSCPP=$(find dataracebench -name "*.cpp" | sort)
RODINIA_BENCHS=$(ls rodinia_3.1/openmp)
cd ${SCRIPTS}

# Step 2 : Find all files with main function, and compile them

#
echo "-----------------------------------------------"
echo "---------------- DiscoPoP START ----------------"
echo "-----------------------------------------------"

echo "DataRaceBench Benchmarks..."
RETURNDIR=$(pwd)
cd ${SCRIPTS}/../benchmarks/DiscoPoP/dataracebench
echo "PWD: $(pwd)"

for f in $DATARACEBENCH_BENCHS; do
  f=$(basename $f)
  echo ""
  echo "  ###  $f ###"
  # Step 2.1 create and enter temporary directory for Benchmark
  mkdir dp_temp
  cp $f dp_temp
  cd dp_temp
  # Step 2.2 instrument and build
  discopop_cc *.c 
  ./a.out
  # Step 2.3 pattern analysis, optimization, patch generation and patch application
  cd .discopop
  discopop_explorer --enable-patterns doall,reduction --log INFO
  discopop_optimizer -p2 -o1 --log INFO
  discopop_patch_generator -a optimizer/patterns.json --only-maximum-id-pattern
  discopop_patch_applicator -v -a $(ls patch_generator)
  cd ..
  # Step 2.4 overwrite original with modified source code
  diff ../$f $f -y
  cp $f ..
  # Step 2.5 leave and remove temporary directory
  cd ..
  rm -r dp_temp  
done

exit 0

for f in $DATARACEBENCH_BENCHSCPP; do
  f=$(basename $f)
  echo ""
  echo "  ###  $f ###"
  # Step 2.1 create and enter temporary directory for Benchmark
  mkdir dp_temp
  cp $f dp_temp
  cd dp_temp
  # Step 2.2 create Makefile
  echo $'.DEFAULT_GOAL=all\n.PHONY: all\nCFLAGS=\"-c\"\nall: prog\n\nprog: prog.o\n\t$(CXX) prog.o -o prog\n\nprog.o:' ${f} $'\n\t$(CXX) $(CFLAGS) ' ${f} ' -o prog.o' > Makefile
  # Step 2.3 create and execute the instrumented program to generate parallelization suggestions
  $DP_BUILD_DIR/scripts/runDiscoPoP --gllvm $DP_GLLVM_DIR --project $(pwd) --executable-name prog --explorer-flags "--json patterns.json"  

  # Step 2.6 create modified source code
  discopop_code_generator --fmap $(pwd)/.discopop/FileMapping.txt --json $(pwd)/.discopop/patterns.json --outputdir ${OUTPUT_DIR_SIMPLE_GPU}/dataracebench --patterns=simple_gpu
  discopop_code_generator --fmap $(pwd)/.discopop/FileMapping.txt --json $(pwd)/.discopop/patterns.json --outputdir ${OUTPUT_DIR_COMBINED_GPU}/dataracebench --patterns=combined_gpu
  discopop_code_generator --fmap $(pwd)/.discopop/FileMapping.txt --json $(pwd)/.discopop/patterns.json --outputdir $(pwd) --patterns=do_all,reduction
  # Step 2.7 overwrite original with modified source code
  diff ../$f $f -y
  cp $f ..
  # Step 2.8 leave and remove temporary directory
  cd ..
  rm -r dp_temp  
done

cd $RETURNDIR
echo "DataRaceBench Benchmarks done."


echo "Starting Rodinia benchmarks..."
cd ${SCRIPTS}/../benchmarks/DiscoPoP/rodinia_3.1/openmp
#for f in $RODINIA_BENCHS; do
if false;
then 
  ## RODINIA BFS
  f=bfs
  echo "  $f"
  # enter benchmark directory
  cd $f
  # Step 2.3 create and execute the instrumented program
  $DP_BUILD_DIR/scripts/runDiscoPoP --gllvm $DP_GLLVM_DIR --project $(pwd) --executable-name bfs --make-target bfs --linker-flags -fopenmp --exit-after-compilation
  cp .discopop/* .
  # Step 2.4 execute the instrumented program
  ./bfs_dp 4 ../../data/bfs/graph65536.txt
  
  # Step 2.5 create parallelization suggestions
  discopop_explorer --dep-file=bfs_dp_dep.txt --json patterns.json
  

  # Step 2.6 create modified source code
  discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir ${OUTPUT_DIR_SIMPLE_GPU}/rodinia_3.1/openmp/${f} --patterns=simple_gpu
  discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir ${OUTPUT_DIR_COMBINED_GPU}/rodinia_3.1/openmp/${f} --patterns=combined_gpu
  discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir $(pwd) --patterns=do_all,reduction

  # leave benchmark directory
  cd ..
  #done
fi	

if false;
then
  # RODINIA B+TREE
    f="b+tree"
    echo "  $f"
    # enter benchmark directory
    cd $f
    # Step 2.3 create and execute the instrumented program
    $DP_BUILD_DIR/scripts/runDiscoPoP --gllvm $DP_GLLVM_DIR --project $(pwd) --executable-name b+tree.out --linker-flags -fopenmp --exit-after-compilation --verbose
    cp .discopop/* .
    # Step 2.4 execute the instrumented program
    ./b+tree.out_dp core 2 file ../../data/b+tree/mil_small.txt command ../../data/b+tree/command_small.txt
    
    # Step 2.5 create parallelization suggestions
    discopop_explorer --dep-file=b+tree.out_dp_dep.txt --json patterns.json
    
  
    # Step 2.6 create modified source code
    discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir ${OUTPUT_DIR_SIMPLE_GPU}/rodinia_3.1/openmp/${f} --patterns=simple_gpu
    discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir ${OUTPUT_DIR_COMBINED_GPU}/rodinia_3.1/openmp/${f} --patterns=combined_gpu
    discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir $(pwd) --patterns=do_all,reduction
  
    # leave benchmark directory
    cd ..
  #done	
fi

## RODINIA HOTSPOT
#  f=hotspot
#  echo "  $f"
#  # enter benchmark directory
#  cd $f
#  # Step 2.3 create and execute the instrumented program
#  $DP_BUILD_DIR/scripts/runDiscoPoP --gllvm $DP_GLLVM_DIR --project $(pwd) --executable-name hotspot --make-target hotspot --linker-flags -fopenmp --exit-after-compilation
#  cp .discopop/* .
#  # Step 2.4 execute the instrumented program
#  ./hotspot_dp 256 256 2 4 ../../data/hotspot/temp_1024 ../../data/hotspot/power_1024 output.out
#  
#  # Step 2.5 create parallelization suggestions
#  discopop_explorer --dep-file=hotspot_dp_dep.txt --json patterns.json
#  
#
#  # Step 2.6 create modified source code
#  discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir $(pwd) --patterns=do_all,reduction
#
#  # leave benchmark directory
#  cd ..
##done	

# RODINIA HEARTWALL
#  f=heartwall
#  echo "  $f"
#  # enter benchmark directory
#  cd $f
#  # Step 2.3 create and execute the instrumented program
#  $DP_BUILD_DIR/scripts/runDiscoPoP --gllvm $DP_GLLVM_DIR --project $(pwd) --executable-name heartwall --make-target heartwall --linker-flags "-fopenmp" --exit-after-compilation --make-flags "OUTPUT=Y"
#
#  echo "MANUAL BUILD"
#  cd .discopop
#  $DP_GLLVM_DIR/gclang main.o ./AVI/avilib.o ./AVI/avimod.o -lm -fopenmp -o heartwall
#  $DP_GLLVM_DIR/get-bc -b -m -v heartwall
#  llvm-dis-11 heartwall.bc -o heartwall.ll
#  opt-11 -S -load /home/lukas/git/discopop/build/libi/LLVMDiscoPoP.so -DiscoPoP heartwall.ll -o heartwall_dp.ll -fm-path FileMapping.txt
#  llvm-llc-11 -filetype=obj  heartwall_dp.ll -o  heartwall_dp.o
#  clang++-11 heartwall_dp.o -Wl,--export-dynamic -O0 -g -o heartwall_dp -L/home/lukas/git/discopop/build/rtlib -lDiscoPoP_RT -lpthread -fopenmp
#  echo "END OF MANUAL BUILD!"
#  
#  cp .discopop/* .
#  # Step 2.4 execute the instrumented program
#  ./heartwall_dp ../../data/heartwall/test.avi 5 4
#  
#  # Step 2.5 create parallelization suggestions
#  discopop_explorer --dep-file=heartwall_dp_dep.txt --json patterns.json
#  
#  # Step 2.6 create modified source code
#  discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir $(pwd) --patterns=do_all,reduction
# 
#  # invalidate HEARTWALL
#  rm *.c *.cpp heartwall
#
#  # leave benchmark directory
#  cd ..
#done	

## RODINIA HOTSPOT 3D
#  f=hotspot3D
#  echo "  $f"
#  # enter benchmark directory
#  cd $f
#  # Step 2.3 create and execute the instrumented program
#  $DP_BUILD_DIR/scripts/runDiscoPoP --gllvm $DP_GLLVM_DIR --project $(pwd) --executable-name 3D --linker-flags "-fopenmp" --exit-after-compilation
#  cp .discopop/* .
#  # Step 2.4 execute the instrumented program
#  ./3D_dp 64 8 100 ../../data/hotspot3D/power_64x8 ../../data/hotspot3D/temp_64x8 output.out
#  # Step 2.5 create parallelization suggestions
#  discopop_explorer --dep-file=3D_dp_dep.txt --json patterns.json
#
#  # Step 2.6 create modified source code
#  discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir $(pwd) --patterns=do_all,reduction
#
#  # leave benchmark directory
#  cd ..
##done	


cd $RETURNDIR
echo "Rodinia benchmarks done."


echo "Starting NASA benchmarks..."
cd ${SCRIPTS}/../benchmarks/DiscoPoP/NPB3.0-omp-c

echo "Prepare environment"
make veryclean
cd sys
make
cd ..
echo "Environment prepared"

if true;
then
    NPB_BENCHS="BT CG EP FT IS LU MG SP"
    for f in $NPB_BENCHS; do
      lowercase_f=$(echo "$f" | tr '[:upper:]' '[:lower:]')
      echo "### $f ###"
      # enter benchmark directory
      cd $f
      # prepare directory dependencies
      cp -r ../sys .
      cp -r ../config .
      cp -r ../common . 
      # Step 2.3 create and execute the instrumented program
      CLASS=S
      EXECUTABLE_NAME=${lowercase_f}.${CLASS}
      
      $DP_BUILD_DIR/scripts/runDiscoPoP --gllvm $DP_GLLVM_DIR --project $(pwd) --executable-name $EXECUTABLE_NAME --exit-after-compilation --make-flags "CLASS=${CLASS} BINDIR=. CLINK=clang++ CLINKFLAGS=\"\" " --memory-profiling-skip-function-arguments
      cp .discopop/* .
      # Step 2.4 execute the instrumented program
      ./${EXECUTABLE_NAME}_dp  
    
      # Step 2.5 create parallelization suggestions
      discopop_explorer --dep-file=${EXECUTABLE_NAME}_dp_dep.txt --json patterns.json
      # Step 2.6 create modified source code
      discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir ${OUTPUT_DIR_SIMPLE_GPU}/NPB3.0-omp-c/${f} --patterns=simple_gpu
      discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir ${OUTPUT_DIR_COMBINED_GPU}/NPB3.0-omp-c/${f} --patterns=combined_gpu
      discopop_code_generator --fmap $(pwd)/FileMapping.txt --json $(pwd)/patterns.json --outputdir $(pwd) --patterns=do_all,reduction # combined_gpu #simple_gpu
      # leave benchmark directory
      cd ..
      echo "### $f Done ###"
    done
fi


COMPILER="icc -qopenmp -w"
if [ -d "${SCRIPTS}/../benchmarks/DiscoPoP/NPB3.0-omp-c" ]; then
  cd "${SCRIPTS}/../benchmarks/DiscoPoP/NPB3.0-omp-c/"
  CLINK=${COMPILER} CC=${COMPILER} make clean
fi
cd "${THIS}"

#docker stop discopopCont
#docker container rm discopopCont

cd "${THIS}"

