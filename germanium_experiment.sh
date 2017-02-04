#!/bin/bash
#Written by Rohith Saradhy 27-9-16
energies=(1 100 500 1000 5000 7500 10000) # in MeV
stability=(false true)
mass=(1*MeV 100*MeV  1*GeV 10*GeV 100*GeV 500*GeV 1*TeV 100*TeV)
charge=(1 0.1 0.01 0.005 0.002 0.0001)
mu_src="/home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01/source/particles/leptons/src/G4MuonPlus.cc"  # name, 0.1056583715*GeV, 2.99598e-16*MeV,  +1.*eplus, @71 && false,      2196.98*ns,             NULL,	@75
run1_mac="/home/devbot/Geant4_Workspace/GermaniumDectector/run1.mac" #change line 31
event_file="/home/devbot/Geant4_Workspace/GermaniumDectector/src/B1EventAction.cc" # ofstream out("/home/devbot/Geant4_Workspace/GermaniumDectector/data/Proton.txt"); @ line 61


#case of stability charge energy mass
for stable in "${stability[@]}"
do
for chrge in "${charge[@]}"
do
for energ in "${energies[@]}"
do
for mas in "${mass[@]}"
do
if $stable; then
echo $stable "stability"
echo $chrge "-charge"
echo $energ" MeV -energy"
echo $mas"-Mass"
echo $mu_src
echo $run1_mac
echo $event_file
#editing the source file
sed -i '71s/.*/'"name, "$mas", 2.99598e-16*MeV,  +"$chrge"*eplus,"'/' $mu_src
sed -i '75s/.*/'$stable", 2196.98*ns,             NULL,"'/' $mu_src
#gedit $mu_src
#editing the event file
mkdir /home/devbot/Geant4_Workspace/GermaniumDectector/data_Shielding
file_name="/home/devbot/Geant4_Workspace/GermaniumDectector/data_Shielding/muon_S_t_E_"$energ"_M_"$mas"_C_"$chrge".txt"
#echo $file_name

touch "$file_name"
sed -i '61s@.*@'"ofstream out(\""$file_name"\");"'@' $event_file
#gedit $event_file
#editing run1.mac file
sed -i '28s/.*/'"\\/gun\\/energy "$energ" MeV"'/' $run1_mac
#gedit $run1_mac

#read -p "Press [Enter] key to start Continue..."
cd /home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01_build
#make clean
make -j 48
make install
#read -p "Press [Enter] key to CONTINUE..."
cd  ~/Geant4_Workspace/GermaniumDectector/
make
exampleB1 run1.mac
#read -p "Press [Enter] key to start Continue..."
fi




done

done

done

done
