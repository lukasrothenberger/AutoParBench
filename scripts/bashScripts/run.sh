#!/bin/bash

#//******************************************************************************************************************//
#// Copyright (c) 2020, Lawrence Livermore National Security, LLC.
#// and Federal University of Minas Gerais
#// SPDX-License-Identifier: (BSD-3-Clause)
#//*****************************************************************************************************************//

# Creates a sequential version
bash create_sequential_versions.sh

# Generates reports to Autopar
#bash create_autopar_reports.sh

# Generate reports to DawnCC
#bash create_dawncc_reports.sh

# Generate reports to ICC
#bash create_icc_reports.sh

# Generate JSONs to ICC
#bash create_icc_jsons.sh

# Generate reports to Cetus
#bash create_cetus_reports.sh

# Generate reports to DiscoPoP
bash create_discopop_reports.sh

# Generate JSONs to represent source codes 
bash create_source_jsons.sh

# Collect files after classification
bash collect_classification_files.sh

# Produce the reports to be used
bash create_reports.sh

