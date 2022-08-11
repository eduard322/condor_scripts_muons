#!/bin/bash
#source $SHIP_CVMFS_SETUP_FILE
#source $FAIRSHIP_DIR/config.sh
#source $SHIP_CVMFS_SETUP_FILE
source /cvmfs/ship.cern.ch/SHiP-2021/latest/setUp.sh
#source /afs/cern.ch/user/e/edursov/private/SIMULATIONS/my_FairShip/start_ali.sh
#cd /afs/cern.ch/user/e/edursov/private/SIMULATIONS/my_FairShip/
source /afs/cern.ch/user/e/edursov/private/SIMULATIONS/my_FairShip/start_ali.sh
Condor_folder=/afs/cern.ch/user/e/edursov/private/SIMULATIONS/my_FairShip/muon/run_processing
#cd "$Condor_folder"
#alienv enter FairShip/latest
set -ux
echo "Starting script."
DIR=$1
SUB=$6
ProcId=$2
LSB_JOBINDEX=$((ProcId+1))
MUONS=$4
NTOTAL=$5
NJOBS=$3
GEOFILE=$7

TANK=6
ISHIP=3
MUSHIELD=8

echo $MUONS
echo $DIR
echo $SUB
N=$(( NTOTAL/NJOBS + ( LSB_JOBINDEX == NJOBS ? NTOTAL % NJOBS : 0 ) ))
FIRST=$(((NTOTAL/NJOBS)*(LSB_JOBINDEX-1)))
if eos stat "$EOS_DATA"/"$DIR"/"$SUB"/"$LSB_JOBINDEX"/ship.conical.MuonBack-TGeant4.root; then
	echo "Target exists, nothing to do."
	exit 0
else
	#echo "Total and number: ${NTOTAL} and ${N}, ${FIRST}" > "$EOS_DATA"/"$DIR"/"$SUB"/"$LSB_JOBINDEX"/output
	#mkdir "$EOS_DATA"/"$DIR"/"$SUB"/"$LSB_JOBINDEX"/
	#cd "$EOS_DATA"/"$DIR"/"$SUB"/"$LSB_JOBINDEX"/
	python "$FAIRSHIP"/macro/run_simScript.py --muShieldDesign $MUSHIELD --MuonBack --nEvents $N --firstEvent $FIRST -f $MUONS --FastMuon -g $Condor_folder/$GEOFILE 
	#python "$FAIRSHIP"/macro/run_simScript.py --muShieldDesign 7 --MuonBack --nEvents $N --firstEvent $FIRST -f $MUONS --FastMuon 
	xrdcp ship.conical.MuonBack-TGeant4.root root://eospublic.cern.ch/"$EOS_DATA"/"$DIR"/"$SUB"/"$LSB_JOBINDEX"/ship.conical.MuonBack-TGeant4.root
	#python flux_map_custom.py "$EOS_DATA"/"$DIR"/"$SUB"/"$LSB_JOBINDEX"/ship.conical.MuonBack-TGeant4.root -o "$EOS_DATA"/"$DIR"/"$SUB"/"$LSB_JOBINDEX"/flux_map.root -n "$EOS_DATA"/"$DIR"/"$SUB"/"$LSB_JOBINDEX"  
	if [ "$LSB_JOBINDEX" -eq 1 ]; then
	xrdcp geofile_full.conical.MuonBack-TGeant4.root\
        root://eospublic.cern.ch/"$EOS_DATA"/"$DIR"/"$SUB"/geofile_full.conical.MuonBack-TGeant4.root
	fi
fi
