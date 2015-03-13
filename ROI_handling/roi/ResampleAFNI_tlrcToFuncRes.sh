#!/bin/bash

afiles=$( find ./afni_tlrc -maxdepth 1 -type f -name "*.HEAD" )
master="${HOME}/Documents/MATLAB/JLP/funcs/01train_pp1+orig.HEAD"
for afile in $afiles; do
	afuncres="./afni_tlrc/funcres/${afile##*/}"
	afuncres="${afuncres%+*}"
	3dresample -master $master -prefix $afuncres -inset $afile
done
