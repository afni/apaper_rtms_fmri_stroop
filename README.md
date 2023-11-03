# apaper_rtms_fmri_stroop

This repository provides scripts and code used in the following paper, 
which combines task-based fMRI (Stroop task) with rTMS modulation:

  Beynel L, Gura H, Rezaee Z, Ekpo E, DengZ-D, Joseph J, Taylor P, 
  Luber B, Lisanby, SH (2023)What is the best way to target rTMS?  
  Lessons learned from a replication attempt on fMRI-guided rTMS 
  modulation of the numerical Stroop task. (*submitted*)

The MRI dataset processing here primarily uses AFNI (Cox, 1996).

-----------------------

The scripts/ directory contains the set of processing scripts used here.

scripts/

  do_12*.bash:  perform skullstripping and nonlinear warping of the 
                T1w anatomical to template space (using AFNI's @SSwarper)

  do_20*.bash:  create an FMRI pipeline script and execute it (using
                AFNI's afni_proc.py)

  do_30*.bash:  create an inverse warp from the standard template to 
                each individual subject's T1w anatomical
                
  do_31*.bash:  create an inverse warp from the standard template to 
                each individual subject's T1w anatomical (an alternative
                approach to do_30*bash).

                
