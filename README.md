# apaper_rtms_fmri_stroop

This repository provides scripts and code used in the following paper, 
which combines task-based fMRI (Stroop task) with rTMS modulation:

*  Beynel L, Gura H, Rezaee Z, Ekpo EC, Deng ZD, Joseph JO, Taylor P,
   Luber B, Lisanby SH (2024). Lessons learned from an fMRI-guided rTMS
   study on performance in a numerical Stroop task. PLoS One.
   19(5):e0302660. doi: 10.1371/journal.pone.0302660.

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

                
