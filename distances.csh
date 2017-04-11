#!/bin/bash
set column_X='$1'
set column_Y='$2'
set i=1
set k=1
set shortest_distance=12000
set memory=0
set file_name=locations.txt
set j = `wc -l $file_name | grep -Eo '[0-9]*' `
while (i<=j)
	set X_particle_I=`awk "FNR==$i {print $column_X}" $file_name | grep -Eo '[0-9]*' | head -1`
	set Y_particle_I=`awk "FNR==$i {print $column_Y}" $file_name | grep -Eo '[0-9]*' | tail -1`
	while ($k<$j)
		if ($i==$k) then
			#Do nothing
		else
			set X_particle_K=`awk "FNR==$k {print $column_X}" $file_name | grep -Eo '[0-9]*' | head -1`
			set Y_particle_K=`awk "FNR==$k {print $column_Y}" $file_name | grep -Eo '[0-9]*' | tail -1`
			set distance = `echo "X_particle_I   Y_particle_I   X_particle_K   Y_particle_K" | awk '{print sqrt((($1-$3)*($1-$3))+(($2-$4)*($2-$4)))}'`		
			if ($distance<$shortest_distance) then
				set shortest_distance=$distance
			end

		end
		@ k++	
	end
	echo "$shortest_distance">>shortest_distance.txt
	set shortest_distance=12000	
	set k=1
	@ i++
end
