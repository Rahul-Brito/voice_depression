#!/bin/bash

#SBATCH -o log/%x-%A-%a.out
#SBATCH -e log/%x-%A-%a.err
#SBATCH --mail-user=dclb@mit.edu
#SBATCH --mail-type=ALL

#SBATCH -J heudiconv_submission_script

base=/mindhive/xnat/dicom_storage/voice/dicom

# go to dicom directory and grab all subjects we want to convert
#pushd ${base} > /dev/null
#subjs=($(ls voice* -d)) # just three for debugging
#popd > /dev/null

subjs=(voice875 voice994)

# take the length of the array
# this will be useful for indexing later
len=$(expr ${#subjs[@]} - 1)


ses=(1 2)

echo Spawning ${#subjs[@]} sub-jobs for each session.

# submit subject to heudiconv processing
for s in ${ses[@]}; do
	sbatch --array=0-$len ss_heudiconv.sh $base $s ${subjs[@]}
done
