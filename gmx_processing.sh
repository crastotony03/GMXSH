#!/bin/bash

# Gather input Parameters
processing() {
	echo "------------------------------------------------"
	echo "                 System Preparation             "
	echo "------------------------------------------------"
	echo "Please enter input file name (example file.pdb)"
	read -p "File name :" input_file
	echo
	echo
	echo "Please select water_model: "
	echo "1 (spce)"
	echo "2 (spc)"
	echo "3 (tip3p)"
	read -p "water_model: " water_model
	case $water_model in
        	1)
          	echo "Selected 1: spce"
          	water_model="spce"
          	;;
        	2)
          	echo "Selected 2: spc"
          	water_model="spc"
          	;;
        	3)
          	echo "Selected 3: tip3p"
          	water_model="tip3p"
          	;;
		*)
          	echo "Invalid Input"
          	;;
	esac
	echo
	echo
	echo "Please select Box Type: "
	echo "1 (cubic)"
	echo "2 (triclinic)"
	echo "3 (dodecahedron)"
	echo "4 (octahedron)"
	read -p "Box type: " box_type
	case $box_type in
		1)
          	echo "Selected 1: 'cubic'"
	  	box_type="cubic"
          	;;
		2)
          	echo "Selected 2: 'triclinic'"
          	box_type="triclinic"
          	;;
		3)
          	echo "Selected 3: 'dodecahedron'"
          	box_type="dodecahedron"
          	;;
		4)
          	echo "Selected 4: 'octahedron'"
          	box_type="octahedron"
          	;;
		*)
          	echo "Invalid Input"
          	;;
	esac
	echo
	echo
	echo "Please enter solvation box dimension (Min: 1.0)"
	read -p "Dimension: " box_dimension
	echo
	echo
	# Print input parameters
	echo '*************** INPUT PARAMETERS *********************'
	echo Inputfile: $input_file
	echo water_model: $water_model
	echo solvation box: $box_type
	echo dimension: $box_dimension
	echo '*****************************************************'
	sleep 5

	# Defining base command
	cmd_pdb2gmx=(gmx pdb2gmx -f $input_file -o processed.gro -water $water_model -ignh)
	cmd_editconf=(gmx editconf -f processed.gro -o newbox.gro -c -d $box_dimension -bt $box_type)
	cmd_solvate=(gmx solvate -cp newbox.gro -cs spc216.gro -o solv.gro -p topol.top)
	cmd_grompp=(gmx grompp -f ions.mdp -c solv.gro -p topol.top -o ions.tpr)
	cmd_genion=(gmx genion -s ions.tpr -o solv_ions.gro -p topol.top -pname NA -nname CL -neutral)

	# Command preview and add additional flags
	while true; do
	echo
	echo
	echo
	echo '**************** COMMAND PREVIEW *********************'
	echo 1: ${cmd_pdb2gmx[@]}
	echo 2: ${cmd_editconf[@]}
	echo 3: ${cmd_solvate[@]}
	echo 4: ${cmd_grompp[@]}
	echo 5: ${cmd_genion[@]}
	echo '******************************************************'
	echo
	echo "NOTE: Removing flags is under development. Use selection 5 in main menu instead"
	echo
	echo "To execute the command press Enter"
	echo "Or choose a command to add flags"
	read -p "Enter input: " add_flags

	if [ -n "$add_flags" ]; then
		case $add_flags in
			1) # Add flags to pdb2gmx command
			read -p "Enter flags to add: " flags_pdb2gmx
			cmd_pdb2gmx+=($flags_pdb2gmx)
			;;
			2) # Add flags to editconf command
			read -p "Enter flags to add: " flags_editconf
                	cmd_editconf+=($flags_editconf)
			;;
			3) # Add flags to solvate command
			read -p "Enter flags to add: " flags_solvate
                	cmd_solvate+=($flags_solvate)
                	;;
			4) # Add flags to grompp command
                	read -p "Enter flags to add: " flags_grompp
                	cmd_grompp+=($flags_grompp)
                	;;
			5) # Add flags to genion command
                	read -p "Enter flags to add: " flags_genion
                	cmd_genion+=($flags_genion)
                	;;
			*)
                	echo "Invalid input"
                	;;
		esac
	else
		# Breaks while loop
		break
	fi
	done

	echo
	echo
	${cmd_pdb2gmx[@]}
	echo "###################################################################################################################################################"	
	sleep 5
	echo
	echo
	${cmd_editconf[@]}
	echo "###################################################################################################################################################"
	sleep 5
	echo
	echo
	${cmd_solvate[@]}
	echo "###################################################################################################################################################"
	sleep 5
	echo
	echo
	${cmd_grompp[@]}
	echo "###################################################################################################################################################"
	sleep 5
	echo
	echo
	${cmd_genion[@]}
	echo "###################################################################################################################################################"
	sleep 5
	return
}
