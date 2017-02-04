#!/bin/bash
#Written by Rohith Saradhy 27-9-16
energies=(1 100 500 750 1000 2500 5000 7500 10000) # Projectile Energy in MeV
CO_Conc=(5 10 15 20 25 30 35 40) # Carbon Dioxide concentration in percentage
Gap_distance=(1 1.5 2 2.5 3 4 5 7 10) # Gap distance in *mm
particle=("proton") #choose all the particles to incident on the detector

run1_mac="/home/devbot/Geant4_Workspace/RPCDetector/run1.mac" #change line 31
event_file="/home/devbot/Geant4_Workspace/RPCDetector/src/B1EventAction.cc" # ofstream out("/home/devbot/Geant4_Workspace/GermaniumDectector/data/Proton.txt"); @ line 61
cstruct_file="/home/devbot/Geant4_Workspace/RPCDetector/src/B1DetectorConstruction.cc"
data_fold="/home/devbot/Geant4_Workspace/RPCDetector/data_new"


#case of stability charge energy mass
for ptcl in "${particle[@]}"
do
for CO in "${CO_Conc[@]}"
do
for dist in "${Gap_distance[@]}"
do
for energ in "${energies[@]}"
do

# editing the source file
sed -i '53s/.*/'"co2_percent = "$CO";"'/' $cstruct_file
sed -i '77s/.*/'"thickness = "$dist";"'/' $cstruct_file
#gedit $mu_src
#editing the event file
mkdir $data_fold
file_name=$data_fold"/Particle="$ptcl"_CO2conc="$CO"_Energy="$energ"MeV_Thickness_"$dist"mm.txt"
#echo $file_name

touch "$file_name"
sed -i '61s@.*@'"ofstream out(\""$file_name"\");"'@' $event_file
#gedit $event_file
# editing run1.mac file
sed -i '24s/.*/'"\\/gun\\/particle "$ptcl'/' $run1_mac
sed -i '25s/.*/'"\\/gun\\/energy "$energ" MeV"'/' $run1_mac
# setting runs to 100000
sed -i '31s/.*/'"\\/run\\/beamOn 100000"'/' $run1_mac
#gedit $run1_mac

# read -p "Press [Enter] key to start Continue..."

# cd /home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01_build
# #make clean
# make -j 48
# make install
#read -p "Press [Enter] key to CONTINUE..."
cd  ~/Geant4_Workspace/RPCDetector/
make clean
make
# echo "Currently Running..."
# echo $stable "-stability"
# echo $chrge "-charge"
# echo $energ" MeV -energy"
# echo $mas"-Mass"
exampleB1 run1.mac
# echo "Run Finished"
#read -p "Press [Enter] key to start Continue..."





done

done

done

done
# replacing with the  backup file
# cp /home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01/source/particles/leptons/src/G4MuonPlus.cc_bak /home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01/source/particles/leptons/src/G4MuonPlus.cc
