#!/bin/bash

set_environment() {
# Step 1: Define flags to be used in the scripts
THIS=$(pwd)
cd ../
SCRIPTS=$(pwd)
cd "${THIS}"
}

create_detailed_header() {
BENCHMARK=${1}
if [ -f "${THIS}/reports/Detailed-Report-${BENCHMARK}.md" ]; then
  rm "${THIS}/reports/Detailed-Report-${BENCHMARK}.md"
fi

echo "# Detailed report" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
echo "" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
echo "## Evaluation platform" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
echo "" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
echo "Intel(R) Xeon(R) CPU E5-2686 v4" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
echo "" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
}

add_common_info() {
  input=${1}
  reference=${2}
  while read line; do
    # info="${line//*|}"
    #file="${line%|*}"

    ## Parser all info of a single line
    correct="${line##*| }"
    line_r="${line%|*}"
    info="${line_r##*| }"
    line_r="${line_r%|*}" 
    loop_nl="${line_r##*| }" 
    index="${line_r}"
    line_r="${line_r%|*}"
    loop_id="${line_r##*| }"
    line_r="${line_r%|*}"
    file="${line_r##*| }"

    ## Parser the index, to be able to use it on bash scripts
    index="${file//\./_}"
    index="${index}_${loop_id}_${loop_nl}"
 
    ## Parser the file name, to make possible to find it inside the repo
    filename="${file}"
    filename=${filename/.json/}
    filename=${filename/.\/CPU\//}
    filename=${filename/.\/GPU\//}
    filename=${filename/.\/CPU_VECTORIZATION\//}
    filename=${filename// /} 

    filename_id="${file}"
    filename_id=${filename_id/.json/}
    filename_id=${filename_id/.\//}
    filename_id=${filename_id// /}
   
    if echo "$filename_id" | grep -q "rodinia_3.1/data"; then
      continue
    fi

    link_orig="[Original](../../benchmarks/original/${filename})"
    link_seq="[Sequential](../../benchmarks/sequential/${filename})"
    link_ref="[Reference JSON](../../benchmarks/${reference}/${filename/.c/.c.json})" 
    link_ground_truth="(../../benchmarks/${reference}/${filename})"
    ## Add common info for all benchamrks
    common_info="${filename_id} | ${loop_id}| ${loop_nl}| [${correct}]${link_ground_truth/ /} | ${link_ref} | ${link_orig} | ${link_seq}"
    map[$index]="${common_info}"
  done < "${input}"
}

read_file() {
  input=${1}
  TOOL_DIR=${2}

  declare -A map_used=()
  for index in "${!map[@]}"; do
    map_used[$index]="false"
  done

  while read line; do
    # info="${line//*|}"
    #file="${line%|*}"

    ## Parser all info of a single line
    correct="${line##*| }"
    line_r="${line%|*}"
    info="${line_r##*| }"
    line_r="${line_r%|*}" 
    loop_nl="${line_r##*| }" 
    index="${line_r}"
    line_r="${line_r%|*}"
    loop_id="${line_r##*| }"
    line_r="${line_r%|*}"
    file="${line_r##*| }"

    ## Parser the index, to be able to use it on bash scripts
    #index="${index/\./}"
    #index="${index//\./_}"
    #index="${index// /_}"
    #index="${index//|/_}"
    #index="${index//\//_}"
    index="${file//\./_}"
    index="${index}_${loop_id}_${loop_nl}"

    filename=${file}
    filename=${filename/.json/}
    filename=${filename/.\/CPU\//}
    filename=${filename/.\/GPU\//}
    filename=${filename/.\/CPU_VECTORIZATION\//}
    filename=${filename// /}

    if echo "$filename_id" | grep -q "rodinia_3.1/data"; then
      continue
    fi

    link_tool="[out](../../benchmarks/${TOOL_DIR}/${filename})"
    if echo "$input" | grep -q "ICC"; then
      link_tool="[out](../../benchmarks/${TOOL_DIR}/${filename}.optrpt)"
    fi
    link_tool_json="[json](../../benchmarks/${TOOL_DIR}/${filename/.c/.c.json})"

    ## Add common info for all benchamrks

    row="${map[$index]} | ${info} ${link_tool} ${link_tool_json}"
    map[$index]="${row}"
    map_used[$index]="true"
  done < "${input}"

  for index in "${!map[@]}"; do
    if [ "${map_used[$index]}" == "false" ]; then
      row="${map[$index]} | Not Available - -"
      map[$index]="${row}"
    fi
  done

  unset map_used
}

print_map() {
  BENCHMARK="${1}"

  for index in "${!map[@]}"; do
    echo "${index}" &>> "${SCRIPTS}/list_index.txt"
  done
  
  sort "${SCRIPTS}/list_index.txt" > "${SCRIPTS}/list_ordered.txt"
  
  COUNTER=1;
  while IFS= read -r index
  do
    # Skip rows of rotinia's data
    if echo "${map[$index]}" | grep -q "rodinia_3.1/data"; then
      continue
    fi
    
    # Print the data
    echo "${COUNTER} | ${map[$index]}" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
    COUNTER=$((COUNTER+1))
  done < "${SCRIPTS}/list_ordered.txt"

  rm "${SCRIPTS}/list_index.txt" "${SCRIPTS}/list_ordered.txt"
}

create_detailed_report() {
  declare -A map=()
  add_common_info "${THIS}/reports/detailed/detailed_report_Ground_Truth_DataRaceBench.txt" "reference_cpu_threading" 
  read_file "${THIS}/reports/detailed/detailed_report_Autopar_DataRaceBench.txt" "Autopar"
  read_file "${THIS}/reports/detailed/detailed_report_ICC_Full_DataRaceBench.txt" "ICC_Full"
  read_file "${THIS}/reports/detailed/detailed_report_ICC_Cost_DataRaceBench.txt" "ICC_Cost"
  read_file "${THIS}/reports/detailed/detailed_report_Cetus_DataRaceBench.txt" "Cetus"

  BENCHMARK="CPU_Dataracebench"
  create_detailed_header "${BENCHMARK}"
  echo "### DataRaceBench Report" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo "" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " ID | Filename | Loop ID | Line Number | Ground Truth | JSON Reference | Original | Sequential | Autopar | ICC Full | ICC Cost | Cetus " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md

  print_map "${BENCHMARK}" 
  unset map

  declare -A map=()
  add_common_info "${THIS}/reports/detailed/detailed_report_Ground_Truth_NPB.txt" "reference_cpu_threading" 
  read_file "${THIS}/reports/detailed/detailed_report_Autopar_NPB.txt" "Autopar"
  read_file "${THIS}/reports/detailed/detailed_report_ICC_Full_NPB.txt" "ICC_Full"
  read_file "${THIS}/reports/detailed/detailed_report_ICC_Cost_NPB.txt" "ICC_Cost"
  read_file "${THIS}/reports/detailed/detailed_report_Cetus_NPB.txt" "Cetus"

  BENCHMARK="CPU_NPB"
  create_detailed_header "${BENCHMARK}"
  echo "### NPB Report" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo "" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " ID | Filename | Loop ID | Line Number | Ground Truth | JSON Reference | Original | Sequential | Autopar | ICC Full | ICC Cost | Cetus " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md

  print_map "${BENCHMARK}" 
  unset map

  declare -A map=()
  add_common_info "${THIS}/reports/detailed/detailed_report_Ground_Truth_Rodinia.txt" "reference_cpu_threading"
  read_file "${THIS}/reports/detailed/detailed_report_Autopar_Rodinia.txt" "Autopar"
  read_file "${THIS}/reports/detailed/detailed_report_ICC_Full_Rodinia.txt" "ICC_Full"
  read_file "${THIS}/reports/detailed/detailed_report_ICC_Cost_Rodinia.txt" "ICC_Cost"
  read_file "${THIS}/reports/detailed/detailed_report_Cetus_Rodinia.txt" "Cetus"

  BENCHMARK="CPU_Rodinia"
  create_detailed_header "${BENCHMARK}"
  echo "### Rodinia Report" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo "" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " ID | Filename | Loop ID | Line Number | Ground Truth | JSON Reference | Original | Sequential | Autopar | ICC Full | ICC Cost | Cetus " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md

  print_map "${BENCHMARK}"
  unset map

  declare -A map=()
  add_common_info "${THIS}/reports/detailed/detailed_report_Dawncc.txt" "reference_gpu_target"
  read_file "${THIS}/reports/detailed/detailed_report_Dawncc.txt" "Dawncc"

  BENCHMARK="GPU_Target"
  create_detailed_header "${BENCHMARK}"
  echo "### DataRaceBench Report" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo "" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " ID | Filename | Loop ID | Line Number | Ground Truth | JSON Reference | Original | Sequential | DawnCC " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " --- | --- | --- | --- | --- | --- | --- | --- | ---  " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md

  print_map "${BENCHMARK}"
  unset map

  declare -A map=()
  add_common_info "${THIS}/reports/detailed/detailed_report_ICC_Simd.txt" "reference_cpu_simd"
  read_file "${THIS}/reports/detailed/detailed_report_ICC_Simd.txt" "ICC_Simd"
  BENCHMARK="CPU_Vectorization"
  create_detailed_header "${BENCHMARK}"
  echo "### DataRaceBench Report" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo "" &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " ID | Filename | Loop ID | Line Number | Ground Truth | JSON Reference | Original | Sequential | ICC Simd " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md
  echo " --- | --- | --- | --- | --- | --- | --- | --- | ---  " &>> ${THIS}/reports/Detailed-Report-${BENCHMARK}.md

  print_map "${BENCHMARK}"
  unset map
}

set_environment

create_detailed_report

