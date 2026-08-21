#!/bin/bash -l
# Batch script to run a serial job on Legion with the upgraded
# software stack under SGE.
# 1. Force bash as the executing shell.
#$ -S /bin/bash
# 2. Request ten minutes of wallclock time (format hours:minutes:seconds). 48 hours
#$ -l h_rt=78:00:0
# 3. Request 1 gigabyte of RAM  ## 64
#$ -l mem=64G
# 4. Request 15 gigabyte of TMPDIR space (default is 10 GB)
#$ -l tmpfs=15G
# 5. Set the name of the job.  
#$ -N boot_s_27
# 6. Set the working directory to somewhere in your scratch space.  This is
# a necessary step with the upgraded software stack as compute nodes cannot
# write to $HOME.
# Replace "<your_UCL_id>" with your UCL user ID :)
#$ -wd /home/uctpmt1/uctpmt1/PACE/Bootstrap_replication
# 7. Your work *must* be done in $TMPDIR 
# cd $TMPDIR
# 8. Run the application. 
export JULIA_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
/shared/ucl/apps/julia/1.11.1/julia-1.11.1/bin/julia --project="/home/uctpmt1/uctpmt1/PACE/Bootstrap_replication" --startup-file=no --threads=1 "/home/uctpmt1/uctpmt1/PACE/Bootstrap_replication/Estimation_s_bootstrap27.jl"
# 9. Preferably, tar-up (archive) all output files onto the shared scratch area
tar zcvf $HOME/Scratch/files_from_job_$JOB_ID.tar.gz $TMPDIR
# Make sure you have given enough time for the copy to complete!
