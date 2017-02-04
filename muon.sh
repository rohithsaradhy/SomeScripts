#!/bin/bash
#Written by Rohith Saradhy 27-9-16
energies=(1 100 500 1000 10000) # in MeV
stability=(false true)
mass=(105*MeV) #250*MeV 500*MeV) # 10.1*GeV 100*GeV 500*GeV 1*TeV 100*TeV) # 100*MeV  1*GeV 10.1*GeV 100*GeV 500*GeV 1*TeV 100*TeV) #for some reason 10GeV is not working. hence we put 10.1GeV mass!
charge=(1 0.1 0.01 0.005 0.002 0.0001)
mu_src="/home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01/source/particles/leptons/src/G4MuonPlus.cc"  # name, 0.1056583715*GeV, 2.99598e-16*MeV,  +1.*eplus, @71 && false,      2196.98*ns,             NULL,	@75
run1_mac="/home/devbot/Geant4_Workspace/GermaniumDectector/run1.mac" #change line 31
event_file="/home/devbot/Geant4_Workspace/GermaniumDectector/src/B1EventAction.cc" # ofstream out("/home/devbot/Geant4_Workspace/GermaniumDectector/data/Proton.txt"); @ line 61
data_fold="/home/devbot/Geant4_Workspace/GermaniumDectector/data_muon/test"


#case of stability charge energy mass
for stable in "${stability[@]}"
do
for mas in "${mass[@]}"
do
for chrge in "${charge[@]}"
do
for energ in "${energies[@]}"
do
if $stable; then
# echo $stable "stability"
# echo $chrge "-charge"
# echo $energ" MeV -energy"
# echo $mas"-Mass"
# echo $mu_src
# echo $run1_mac
# echo $event_file
# editing the source file
sed -i '71s/.*/'"name, "$mas", 2.99598e-16*MeV,  +"$chrge"*eplus,"'/' $mu_src
sed -i '75s/.*/'$stable", 2196.98*ns,             NULL,"'/' $mu_src
#read -p "Press [Enter] key to start Continue..."
#gedit $mu_src
#editing the event file
mkdir $data_fold
file_name=$data_fold"/Muon_Stable="$stable"_Energy="$energ"MeV_Mass_"$mas"_Charge="$chrge".txt"
#echo $file_name

touch "$file_name"
sed -i '61s@.*@'"ofstream out(\""$file_name"\");"'@' $event_file
#gedit $event_file
# editing run1.mac file
sed -i '23s/.*/'"\\/gun\\/particle mu+"'/' $run1_mac
sed -i '24s/.*/'"\\/gun\\/energy "$energ" MeV"'/' $run1_mac
# setting runs to 100000
sed -i '29s/.*/'"\\/run\\/beamOn 100000"'/' $run1_mac
#gedit $run1_mac

# read -p "Press [Enter] key to start Continue..."

cd /home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01_build
#make clean
make -j 48
make install
#read -p "Press [Enter] key to CONTINUE..."
cd  ~/Geant4_Workspace/GermaniumDectector/
make clean
make
# echo "Currently Running..."
# echo $stable "-stability"
# echo $chrge "-charge"
# echo $energ" MeV -energy"
# echo $mas"-Mass"
exampleB1 run1.mac
# echo "Run Finished"
# read -p "Press [Enter] key to start Continue..."
fi




done

done

done

done
# replacing with the  backup file
cp /home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01/source/particles/leptons/src/G4MuonPlus.cc_bak /home/devbot/Softwares/G4.10.02.p01/geant4.10.02.p01/source/particles/leptons/src/G4MuonPlus.cc
