#!/bin/bash
#SBATCH -J cdfsig_medwest
#SBATCH -n 1                                               # nb of nodes, but only one is available on cal1
#SBATCH -o cdfsig_medwest_%J.out
#SBATCH -e cdfsig_medwest_%J.err
#SBATCH --time=00:11:00                         # hh:mm:ss
#SBACTH --mem=5000                              # memory = 4Gb
#SBACTH --account=fortran                      # needed to be precise, either "python" or "fortran" (Mondher has to add you to these groups !)

filet=/mnt/meom/workdir/alberta/post-process-MEDWEST/files/001MEDWEST60-GSL19-ens01_1h_20100206_20100215_gridT_20100206-20100206_pp.nc
files=/mnt/meom/workdir/alberta/post-process-MEDWEST/files/001MEDWEST60-GSL19-ens01_1h_20100206_20100215_gridS_20100206-20100206_pp.nc

./script_compute_density.ksh $filet $files votemper vosaline
