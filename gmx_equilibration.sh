#!/bin/bash

equilibration() {
	gmx grompp -f minim.mdp -c solv_ions.gro -p topol.top -o em.tpr
	echo "###################################################################################################################################################"
	sleep 5
	echo
	echo
	gmx mdrun -v -deffnm em -nb gpu
	echo "###################################################################################################################################################"
	sleep 5
	echo
	echo
	gmx grompp -f nvt.mdp -c em.gro -r em.gro -p topol.top -o nvt.tpr
	echo "###################################################################################################################################################"
	sleep 5
	echo
	echo
	gmx mdrun -deffnm nvt -v -nb gpu -pme gpu -bonded gpu
	echo "###################################################################################################################################################"
	sleep 5
	echo
	echo
	gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -p topol.top -o npt.tpr
	echo "###################################################################################################################################################"
	sleep 5
	echo
	echo
	gmx mdrun -deffnm npt -v -nb gpu -pme gpu -bonded gpu
	return
}

equilibration_graph() {
	gmx energy -f em.edr -o "potential.xvg"
	gmx energy -f nvt.edr -o "temperature.xvg"
	gmx energy -f npt.edr -o "pressure.xvg"
	gmx energy -f npt.edr -o "density.xvg"
	gracebat potential.xvg -hdevice PNG -hardcopy -printfile "potential.png"
	gracebat temperature.xvg -hdevice PNG -hardcopy -printfile "temperature.png"
	gracebat pressure.xvg -hdevice PNG -hardcopy -printfile "pressure.png"
	gracebat density.xvg -hdevice PNG -hardcopy -printfile "density.png"
	return
}
