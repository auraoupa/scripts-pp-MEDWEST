#!/bin/bash
# This script computes the density from temperature and salinity outputs


#Collect the arguments
filet=$1
files=$2
vart=$3
vars=$4


fileo=$(echo $file | sed "s/gridT/density/g") #assumes T-file is gridT
if [ ! -f  $fileo ]; then

	echo $fileo
	cdfsig0 -t $filet -s $files -sal $vars -tem $vart -o $fileo
fi
