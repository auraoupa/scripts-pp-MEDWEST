#!/bin/bash
# This script post processes outputs from MEDWEST60 in 3 steps :
#    - mask all the land points in ocean/land processors that are at 0
#    - remove the coordinate attribute to the variables
#    - replace nav_lat nav_lon that are masked by nav_lat nav_lon from coord file
# It will duplicate the initail file and add _pp at the end of the name


#Collect the arguments
file=$1
coord_file=$2
mask_file=$3

#Get the type of file
typ=$( echo $file | awk -F_ '{print $5}')

#Get the variables name
case $typ in
        gridT) vars="votemper";;
	gridS) vars="vosaline";;
	gridT-2D) vars="sosstsst sosaline sossheig somxl010";;
        gridU) vars="vozocrtx";;
        gridV) vars="vomecrty";;
        gridW) vars="vovecrtz";;
esac

#Attribute the mask according to the types
case $typ in
	gridT|gridS) mask=tmask; dep=deptht;;
	gridT-2D) mask=tmaskutil;;
	gridU) mask=umask; dep=depthu;;
	gridV) mask=vmask; dep=deptv;;
	gridW) mask=fmask; dep=depthw;;
esac

fileo=$(echo $file | sed "s/.nc/_pp.nc/g")
if [ ! -f  $fileo ]; then

	echo $fileo
	#Create the output file
	cp $file $fileo

	#Create a mask file with the same number of time_steps
	if [ ! -f  ${mask}.nc ]; then
		ncks -v $mask $mask_file ${mask}.nc
		ncrename -O -d t,time_counter ${mask}.nc ${mask}.nc
		case $typ in
			gridT-2D);;
			*) ncrename -O -d z,$dep ${mask}.nc ${mask}.nc;;
		esac
		for k in $(seq 1 24); do
			cp ${mask}.nc ${mask}_${k}.nc
		done
		ncrcat -O ${mask}_?.nc ${mask}_??.nc ${mask}.nc
		rm ${mask}_?.nc ${mask}_??.nc
	fi
	#Add the mask to the file
	ncks -A -v $mask ${mask}.nc $fileo
	
	#Put fill value where mask says it is on land
	for var in $vars; do
		ncrename -O -v $var,var $fileo
		ncrename -O -v $mask,mask $fileo
		ncap2 -O -s 'where(mask!=1) var=var@_FillValue' $fileo $fileo
		ncrename -O -v var,$var $fileo
		ncrename -O -v mask,$mask $fileo
	done

	#Clean the file
	ncks -O -x -v $mask $fileo $fileo

	#Remove coordinates attribute so that nav_lat and nav_lon can be removed
	for var in $vars; do
		ncatted -a coordinates,$var,d,, $fileo
	done
	#Remove masked nav_lat nva_lon from file
	ncks -O -x -v nav_lat,nav_lon $fileo $fileo
	#Add good nav_lat nav_lon from coord file
	ncks -A -v nav_lat,nav_lon $coord_file $fileo
fi
