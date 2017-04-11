#!/bin/csh -f
if (! -e *.hed) then
  echo "There is no .hed file..." # LOOKS FOR THE .HED FILES AFTER YOU HAVE SELECTED THE BEST PARTICLES IF NO FILE IS FOUND BYE BYE
  sleep 1 # WAITS ONE SECOND
  echo "Goodbye"
else
mkdir files # FOLDER WHERE ALL FINAL DOCUMENTS WILL BE LOCATED
rksystem2 # SETS UP ENVIROMENT

EMAN # SETS UP ENVIROMENT

EMAN2
 foreach file (*.hed) # LOOKS FOR HED FILE
   set b=$file:r # EXTRACTS HED FILE NAME WITHOUT EXTENSION
   proc2d $file files/$b.spi acfcenter spidersingle # TRANSFORMS THE HED FILE INTO A SPI FILE
   iminfo files/$b.spi > files/boxsize.txt  # SAVES THE IMFORMATION OF THE NEW SPI FILE INTO A DOCUMENT FOR LATER USE
   
   set box=`sed -n 's/^.*\x\([0-9]*\)\x.*/\1/p' files/boxsize.txt` # EXTRACTS THE SIZE OF THE BOX FROM THE DATA SAVED INTO THE NEW DOCUMENT 
   echo ">>> The box size is: $box" # PRINTS OUT BOX SIZE
   echo $b > files/boxsize.txt # UPDATES DOCUMENT TO CONTAIN NAME OF THE SPI FILE WITHOUT THE EXTENSION .spi
   sed -i 's/\(classes\).*/optimiser.star/' files/boxsize.txt # CHANGES THE STRING IN THE DOCUMENT TO MATCH THE NAME OF THE LAST OPTIMISER FILE
   set line=`head -n 1 files/boxsize.txt` # COPIES THE FIRST LINE IN DOCUMENT INTO A VARIABLE
   sed -n 2p $line > files/boxsize.txt  # COPIES THE TWO FIRST LINES OF THE OPTIMISER FIEL INTO OUR BOXSIZE DOCUMENT
   sed -i 's/\(.*--angpix \)//' files/boxsize.txt # DELETES EVERYTHING BEFORE OUR PIXEL SIZE
   sed -i 's/\( --\).*//' files/boxsize.txt # DELETES EVERYTHING AFTER OUR PIXEL SIZE
   set smpd=`head -n 1 files/boxsize.txt` # SAVES THE PIXEL SIZE TO VARIABLE smpd
   echo ">>> The pixel size is: $smpd Angstroms" # PRINTS PIXEL SIZE VALUE OUT
   simple_rndrec stk=files/$b.spi box=$box smpd=$smpd nthr=16 # EXECUTES simple_rndrec WITH THE VALUES OBTAIN
   mv startvol_state1.spi files/ # MOVES THE FILE CREATED BY SIMPLE INTO files FOLDER
   mv rndoris.txt files/# SAVE AS ABOVE COMMENT ^
   cd files/ # TERMINAL MOVES INTO files FOLDER
   nohup simple_prime stk=$b.spi box=$box smpd=$smpd vol1=startvol_state1.spi dynlp=yes oritab=rndoris.txt nthr=16 # EXECUTES simple_prime
end
cd ../
rm boxsize.txt # REMOVES DOCUMENT USED IN THIS SCRIPT
echo "ALL DONE!"
echo "by BRYANT E. AVILA" 
