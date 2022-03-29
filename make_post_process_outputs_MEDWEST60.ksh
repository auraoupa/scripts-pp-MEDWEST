mask_file=/mnt/meom/workdir/alberta/post-process-MEDWEST/grid/MEDWEST60_mask.nc4
coord_file=/mnt/meom/workdir/alberta/post-process-MEDWEST/grid/MEDWEST60_coordinates_v3.nc4

for file in $(ls /mnt/meom/workdir/alberta/post-process-MEDWEST/files/*001MEDWEST60-GSL19-ens01_1h_20100206_20100215*20100206-20100206.nc); do

	./script_post_process_MEDWEST60.ksh $file $coord_file $mask_file

done
