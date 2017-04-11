#!/bin/csh -f
rm *.csv

set k=0

set diameterStep=0.2

set minDiameter=150.0

set maxDiameter=180.0


set j = `echo "$diameterStep $minDiameter $maxDiameter" | awk '{printf ("%.0f\n", ($3 - $2)/$1)}'`

echo "This will have $j steps"

set file="Falcon_2012_06_12-14_33_35_0.mrc" 

set fileName=$file:r

set infoExtention="_automatch.star"

set starFile=$fileName$infoExtention

sleep 3

while ( $k <= $j )

        /opt/EM_suite/Gautomatch_v0.53/bin/Gautomatch-v0.53_sm_20_cu6.5_x86_64 --apixM 3.54 --diameter $minDiameter $file >/dev/null
	
	awk '/_rlnAutopickFigureOfMerit #5/ {p=1;next}p' $starFile > temp.txt && mv temp.txt $starFile 

	set var = `wc -l $starFile | grep -o '[0-9]*' | head -n 1`

	set avrg_ccc=`awk -v N=5 '{ sum += $N } END { if (NR > 0) print sum / NR }' $starFile | xargs echo` #Calculates the Average of the Column N

	echo "$minDiameter  $avrg_ccc  $var" >> excel.csv

	@ k++

	echo "$minDiameter"

	set minDiameter = `echo "$minDiameter $diameterStep" | awk '{print ($1 +$2)}'`
end

