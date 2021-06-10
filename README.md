# ``A Matrix Factorization Approach for Learning Semidefinite-Representable Regularizers''
###  Numerical Experiments with Natural Images (corresponding to Section 4.2)

This folder replicates the experimental results of Section 4.2.

You need MATLAB and CVX installed on your machine.

These codes were written and executed on a cloud-computing service with 
multiple cores -- if you plan to run these codes on a single core machine 
please take a look at the [SINGLECORE].

To replicate the experiment in Section 4.2.1 (''Representing Natural 
Images Patches'') run
Script_compress.m

To replicate the experiment in Section 4.2.2 (''Denoising Natural Images 
Patches'') run the following scripts
Script_denoise_init.m
Script_denoise_sv.m
Script_denoise_lrm.m
Script_denoise_plot.m
** There appears to a problem with MATLAB if you attempt to execute these 
four scripts from a separate script.  This problem does not occur if you 
set ``parmode = 0'' (see [SINGLECORE]).

These scripts are intended to be run independently.  Please be cautioned 
that these experiments take a long time to complete -- the full suite of 
experiments took about 4 days on a 16-core cloud computing service.  

If you discover bugs in the code or have difficulty running the experiments
please contact me at
`` matsys @ nus.edu.sg ''

If you wish to have the output data from these experiments without running 
the entire process please contact me at my email.

The dataset used in this experiment is pre-computed and stored under 
'instances/gulls2set/data/data.mat'.  To view the code for generating the 
dataset from the raw images please use the following link
[LINK]

These codes are written as a proof-of-concept and are not suitable for 
running on significantly larger datasets.  Developing optimized code to run
on larger datasets is part of on-going work -- if you have interest in 
developing software related to this project please contact me.

### [SINGLECORE]
The code uses a ``parfor'' loop to parallelize the computation.  To 
deactivate this setting make the following changes
in ``/instances/gulls2set/lrm_denoise.'' set ''parmode = 0;'' in line 20
in ``/instances/gulls2set/sv_denoise.'' set ''parmode = 0;'' in line 20
