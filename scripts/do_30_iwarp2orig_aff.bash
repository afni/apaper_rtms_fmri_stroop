#!/bin/bash

# ===========================================================================
# Name:       do_30_invwarp2orig_aff.bash
# Author:     LB
# Date:       7/12/22

# Syntax:     bash do_30_invwarp2orig.bash SUBJ
# Arguments:  SUBJ: subject ID

# Desc:       This invert the affine part of anatomical-to-template alignment,
#             and apply it to map standard space data approximately back to
#             subject space
# Req:        1) AFNI
# Notes:      See also accompanying version that inverts full nonlinear
#             warp, for more detailed mapping back to orig subj space:
#               do_04_iwarp2orig_full.bash
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
### Step 1: Reverse the linear affine transformation matrix (get template2orig
### affine transform)

cat_matvec                                                                  \
    ${apresdir}/anatQQ.${subj}.aff12.1D -I                                  \
    > ${apresdir}/reversematrix_${subj}.aff12.1D

# ---------------------------------------------------------------------------
### Step 2: Apply template2orig affine transform: Convert one stats
### volume into orig (anatomical) space, done in this way for later
### specific use case with a software viewing system

3dAllineate                                                                 \
    -master         ${apresdir}/anatSS.${subj}+orig.HEAD                    \
    -input          ${apresdir}/stats.${subj}_REML+tlrc.HEAD'[11]'          \
    -prefix         ${apresdir}/${subj}_IncongruentVsCongruent_inNative     \
    -1Dmatrix_apply ${apresdir}/reversematrix_${subj}.aff12.1D              \
    -final          wsinc5

# ---------------------------------------------------------------------------
### Step 3: Copy output stats volume to brainsight folder (as NIFTI
### with no extensions, for that specific viewing system

# NB: the '-pure' option strips extensions from the NIFTI header;
# probably only to be used in very specific cases, to use in specific
# other software
3dAFNItoNIFTI                                                              \
    -pure                                                                  \
    -prefix ${forbrainsightdir}/${subj}_IncongruentVsCongruentinNAtive     \
    ${apresdir}/${subj}_IncongruentVsCongruent_inNative+orig.HEAD

exit 0
