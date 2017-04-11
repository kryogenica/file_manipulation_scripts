#!/bin/csh -f

mkdir files #creates new folder
echo "Hello"

#creation of header
echo ""> files/header.txt
echo "data_">> files/header.txt
echo "" >> files/header.txt
echo "loop_" >> files/header.txt
echo "_rlnCoordinateX #1" >> files/header.txt
echo "_rlnCoordinateY #2" >> files/header.txt

foreach file (*.mrc)
  set b=$file:r
  
  if ( -e $b.star) then
    sed '1,/filament.z/d' $b.star | sed '/^loop_$/,$d' > files/$b-crap.star #finds unique character '_particle.select' and it erases everything from there to the top, then find 'loop_' and erases everthyimg from there to the bottom
    awk '{print $3" "$4}' files/$b-crap.star > /dev/null #extracts columns 3 and 4 from file and prints them out.
    awk '{printf "%d %d\n", $3,$4}' files/$b-crap.star > /dev/null #converts the numbers founf in the cloumns into integers. 
    awk '{printf "%d %d\n", $3,$4}' files/$b-crap.star > files/$b-crap2.star #saves the integers cloumns.
    sed -i '$d' files/$b-crap2.star #deletes last line.
    sed -i '/0 0/d' files/$b-crap2.star #delted the '0 0' found at the end of the file.
    cat files/header.txt files/$b-crap2.star > files/$b-bshow2relion.star #adds header to new file.
    
  endif
end

mv files/*-bshow2relion.star .
rm -r files/

echo "Done transforming Bshow star files into Relion star files."
echo "By Bryant E. Avila"
