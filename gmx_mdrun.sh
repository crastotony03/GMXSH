#!/bin/bash

MD_run() {
	gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o $deffnm.tpr
	sleep 5
	gmx mdrun -deffnm $deffnm -v -nb gpu -pme gpu -bonded gpu
	return
}

