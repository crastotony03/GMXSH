#!/bin/bash
gmxar_run_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$gmxar_run_dir/gmx_processing.sh"
source "$gmxar_run_dir/gmx_equilibration.sh"
source "$gmxar_run_dir/gmx_mdrun.sh"
source "$gmxar_run_dir/gmx_analysis.sh"

echo
echo
echo "####################################################################################################################################"
echo "# Welcome to GROMACS AutoRun (GMXAR)                                                                                               #"
echo "# Version 0.1 (pre-alpha)                                                                                                          #"
echo "#                                                                                                                                  #"
echo "#                                                                                                                                  #"
echo "# GMXAR is a shell script developed for the GROMACS pipeline that automates system setup, simulation execution, and data analysis. #"
echo "# It serves as a useful tool for users who are not yet proficient with UNIX environments.                                          #"
echo "# It also helps GROMACS users and commercial projects efficiently manage multiple molecular dynamics simulations.                  #"
echo "#                                                                                                                                  #"
echo "####################################################################################################################################"
echo
echo "-----------------------------------------------------------------------------------------------------------------"
echo "                                              GMXAR Main Menu                                                    "
echo "-----------------------------------------------------------------------------------------------------------------"
echo "Start a new simulation           : 1"
echo "Continue the simulation          : 2"
echo "Extend the simulation            : 3"
echo "Analysis                         : 4"
echo "Run a custom command in terminal : 5"
echo "______________________________________"
read -p "Enter your selection: " selection
echo "--------------------------------------"

case $selection in
	1) #Start a new simulation
	  script -c "source $gmxar_run_dir/gmx_processing.sh; processing" processing.log
	  script -c "source $gmxar_run_dir/gmx_equilibration.sh; equilibration" equilibration.log
	  script -c "source $gmxar_run_dir/gmx_equilibration.sh; equilibration_graph" equilibration_graph.log
	  read -p "Enter filename for the simulation output (Used as a default filename for all file options): " deffnm
	  MD_run
	  ;;

	2) #Continue the simulation
	  read -p "Enter filename of the simulation output (-deffnm): " deffnm
	  gmx mdrun -v -deffnm $deffnm -cpi $deffnm.cpt
	  ;;

	3) #Extend the simulation
	  read -p "Enter filename of the simulation output (-deffnm): " deffnm
	  read -p "Enter time to extend (in picoseconds): " extend
#	  Not yet completed
	  ;;

	4) #Analysis
	  echo "-----------------------------------------------------------------------------------------------------------------"
	  echo "                                              GMXAR Analysis                                                     "
	  echo "-----------------------------------------------------------------------------------------------------------------"
	  echo
	  echo -----------------------------------------------------------------------------------------------------------------
	  read -p "Enter simulation output filename (-deffnm): " deffnm
	  sleep 2
	  echo -----------------------------------------------------------------------------------------------------------------
	  
	  echo
	  #executes index() function
	  index
	  sleep 2
	  echo
	  
	  # while loop
	  while true; do
	  	echo -----------------------------------------------------------------------------------------------------------------
		echo "Trajectory correction :1"
		echo "RMSD                 : 2"
	  	echo "RMSF                 : 3"
	  	echo "Radius of gyration   : 4"
	  	echo "Hydrogen Bonds       : 5"
	  	echo "SASA                 : 6"
		echo "Run command          : 7"
	  	echo "Quit                 : 8"
	  	read -p "Enter your selection: " sele_a
		sleep 2
		echo -----------------------------------------------------------------------------------------------------------------
		echo
		case $sele_a in
			1)
			  # performs -trjconv command
			  convert_trajectory
			  sleep 3
			;;
			2)
			  # Root Mean Square Deviation
		  	  rmsd
			  sleep 3
			;;
			3)
			  # Root Mean Square Deviation
			  rmsf
			  sleep 3
			;;
                        4)
			  # Radius of gyration
			  gyration
			  sleep 3
                        ;;
                        5)
			  # Hydrogen Bond
			  hydrogenbond
			  sleep 3
                        ;;
                        6)
			  # Solvent Accessible Surface Areas
			  SASA
			  sleep 3
                        ;;
                        7)
			  # Run User input command
			  custom_command_4
			  sleep 3
			;;
			8)
			  # breaks while loop
			  break
                        ;;
  		esac
	  done

	;;

	5)
	  while true; do
	  echo --------------------------------------------------------------------------
          read -p "Enter your command: " command_custom
          echo --------------------------------------------------------------------------

	  if [ -n "$command_custom" ]; then
         	# Execute the command
          	$command_custom
	  else
		# Breaks while loop
	  	break
	  fi
	  done
	;;

	*)
	  echo invalid
	;;
esac
