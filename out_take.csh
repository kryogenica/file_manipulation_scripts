#!/bin/csh -f
foreach f (spacing*/)
	cd $f
	echo "$f" > tittle
	cat tittle | sed 's/spacing-//' | sed 's/-fraction-/ /' | sed 's/.$//' > temporary
	set val=`cat temporary`
	rm tittle
	rm temporary	
	foreach archivo ([0-9]*.[0-9]*)	
		cd $archivo		
		awk '/Final / {p=1;next}p' 0_phenix.refine.realspace_all.log > temp
		sed -i '1d' temp
		sed -i '/rmsd/,$d' temp
		cat temp | grep -oh '0.[0-9]*' > temp1
		tail -1 temp1 > temp
		sed -i '$d' temp1
		paste temp1 temp | awk '{print $1 " " $2}' > TEMP
		rm temp1
		rm temp
		set val2=`cat TEMP`
		echo "$archivo $val $val2" | awk '{print $1" "$2" "$3" "$4" "$5}' > TEMP
		cd ..
	end
	cd ..
end
foreach f (spacing*/)
	rm temporary
	foreach archivo ([0-9]*.[0-9]*)	
		cd $archivo		
		set val3=`cat TEMP`
		cd ..
		echo "$val3" >> temporary
	end
	set val4=`cat temporary`
	cd ..
	echo "$val4" >> LIST
end

