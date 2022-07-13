#!/bin/bash
#SBATCH -p gablab
#SBATCH --time=12:00:00
#SBATCH --mem=100GB
#SBATCH -J heudiconv
#SBATCH -o log/%x-%A-%a.out
#SBATCH -e log/%x-%A-%a.err
#SBATCH --mail-user=dclb@mit.edu
#SBATCH --mail-type=ALL

# grab these from submission script
base=$1
ses=$2
args=($@)
subjs=(${args[@]:2})

# set output for conversion
outdir=/nese/mit/group/sig/projects/voice

# index slurm array to grab subject
subject=${subjs[${SLURM_ARRAY_TASK_ID}]}

echo Submitted subject: ${subject}

module add openmind/singularity/3.6.3
SING_IMG=/om2/user/dclb/containers/imaging/heudiconv_0.9.0.sif

# default command
cmd="singularity run -B /mindhive -B ${outdir}:/out ${SING_IMG} -d /mindhive/xnat/dicom_storage/voice/dicom/{subject}/session00${ses}*/dicom/Trio*/*.dcm -o /out -f /out/code/bids_conversion/heuristic.py -c dcm2niix -s ${subject} -ss ${ses} --datalad -b --minmeta -g accession_number"

# dry run command
#cmd="singularity run -B /mindhive -B ${outdir}:/out ${SING_IMG} -d /mindhive/xnat/dicom_storage/voice/dicom/{subject}/session00${ses}*/dicom/Trio*/*.dcm -o /out -f convertall -c none -s ${subject} -ss ${ses} --minmeta -g accession_number"

printf "Command:\n${cmd}\n"

# run it
eval $cmd
