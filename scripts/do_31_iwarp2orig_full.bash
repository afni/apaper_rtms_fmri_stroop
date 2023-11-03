#!/bin/bash

# ===========================================================================
# Name:       do_31_iwarp2orig_full.bash
# Author:     LB
# Date:       7/12/22

# Syntax:     bash do_31_iwarp2orig_full.bash SUBJ
# Arguments:  SUBJ: subject ID

# Desc:       This invert the affine part of anatomical-to-template
#             alignment, and apply it to map standard space data
#             approximately back to subject space
# Req:        1) AFNI
# Notes:      version that includes nonlinear info
# ===========================================================================

module load afni

# ------------------------------ get inputs ---------------------------------

if [ "$#" -eq 1 ]; then
   subj=$1
else
   echo "Specify participant ID Please"
   exit 1
fi

# ------------------------------ define paths ---------------------------------

pwd_dir=`pwd`
proj_dir=${pwd_dir%/*}

### Set up the directories+template

anatdir=${proj_dir}/Anat/${subj}           # dir with T1w anatomical
funcdir=${proj_dir}/Func/${subj}           # dir with FMRI/EPI
stimdir=${proj_dir}/Behav/${subj}          # dir with stim timing files
analysisdir=${proj_dir}/Analysis/${subj}   # dir with SSW results; output here
apresdir=${analysisdir}/${subj}.results    # dir with AP results
forbrainsightdir=${proj_dir}/forBrainsight/${subj}

# ----------------------------------------------------------------------------
### Step 1: Calc+apply inverse of full nonlinear warp (including the
### affine part) to map stats volume to original/native subject
### anatomical space.

# NB: this warp procedure preserves AFNI extension information, with
# statistical DFs, p2stat conversions, etc.
3dNwarpApply                                                        \
    -overwrite                                                      \
    -nwarp    "${apresdir}/anatQQ.${subj}_WARP.nii ${apresdir}/anatQQ.${subj}.aff12.1D" \
    -iwarp                                                          \
    -ainterp  wsinc5                                                \
    -master   ${apresdir}/anatSS.${subj}+orig.HEAD                  \
    -source   ${apresdir}/stats.${subj}_REML+tlrc.HEAD              \
    -prefix   ${apresdir}/stats.${subj}_REML_inNative.nii.gz

# ---------------------------------------------------------------------------
### Step 3: Copy one stats volume to brainsight folder (as NIFTI
### with no extensions, for that specific viewing system

# NB: the '-pure' option strips extensions from the NIFTI header;
# probably only to be used in very specific cases, to use in specific
# other software
3dAFNItoNIFTI                                                                \
    -pure                                                                    \
    -prefix ${forbrainsightdir}/${subj}_IncongruentVsCongruentinNAtive_full  \
    ${apresdir}/stats.${subj}_REML_inNative.nii.gz'[11]'

exit 0
