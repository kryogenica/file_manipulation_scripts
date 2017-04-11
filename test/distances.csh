#!/bin/csh -f

set column_X='$1'
set column_Y='$2'
set i=1
set k=1
set shortest_distance=12000
mv shortest_distance.txt previous_shortest_distance.txt

set file_name="16dec07b_b_00043gr_00007sq_v01_00012hl_v01_00004en_automatch.star"

set j = `wc -l $file_name | grep -Eo '[0-9]*' `

while ("$i" <= "$j")
	
	set X_particle_I=`awk "FNR==$i {print $column_X}" $file_name | grep -Eo '[0-9]*' | head -1`
	set Y_particle_I=`awk "FNR==$i {print $column_Y}" $file_name | grep -Eo '[0-9]*' | tail -1`
	while ($k<$j)
		
		set var = `echo "$k $i" | awk '{print ($1 == $2)}'`
		if ( "$var" == 1 ) then
			#Do nothing
		else
			set X_particle_K=`awk "FNR==$k {print $column_X}" $file_name | grep -Eo '[0-9]*' | head -1`
			set Y_particle_K=`awk "FNR==$k {print $column_Y}" $file_name | grep -Eo '[0-9]*' | tail -1`
			set distance = `echo "$X_particle_I   $Y_particle_I   $X_particle_K   $Y_particle_K" | awk '{print sqrt((($1-$3)*($1-$3))+(($2-$4)*($2-$4)))}'`		
			set var = `echo "$distance $shortest_distance" | awk '{print ($1 <= $2)}'`
			if ( "$var" == 1 ) then
				set shortest_distance=$distance
			endif
			echo "$i $k $shortest_distance $distance"
		endif
		@ k++	
	end
	echo "$shortest_distance">>shortest_distance.txt
	set shortest_distance=12000	
	set k=1
	@ i++
end
