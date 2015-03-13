#!/bin/bash

hdrfiles=$( find ./raw/ -type f -name "*.hdr" )

for hdr in $hdrfiles; do
	afile=${hdr%.hdr}
	afile=${afile##*/}
	3dWarp -mni2tta -prefix afni_tlrc/${afile} ${hdr} 
done
