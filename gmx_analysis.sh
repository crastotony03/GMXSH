#!/bin/bash

index() {
	echo --------------------------------------------------------------------------
	echo "Use default index file   :1"
	echo "Create new index file    :2"
	echo "Use existing index file :3"
	read -p "Enter your selection: " sele
	echo --------------------------------------------------------------------------
	case $sele in
		1) #Uses default gromacs generated file
		does_index=false
		;;
		2) #Create a new index file
		gmx make_ndx -f $deffnm.gro -o index.ndx
		index=index.ndx
		does_index=true
		;;
		3) #Use existing index file
		read -p "Enter file name (e.g: index.ndx): " index
		does_index=true
		;;
		*)
		echo "Invalid option"
		;;
	esac
	return
}

convert_trajectory() { # gmx -trjconv
	echo --------------------------------------------------------------------------
	read -p "Select -pbc treatment (mol, nojump, res, atom, cluster, whole): " pbc
	read -p "Enter converted trajectory file (without extension): " trjconv_out
	echo --------------------------------------------------------------------------
	gmx trjconv -s $deffnm.tpr -f $deffnm.xtc -o $trjconv_out.xtc -pbc $pbc -center
	return
}

rmsd() { # Root Mean Square Deviation
	echo --------------------------------------------------------------------------
	read -p "Enter name for the output file: " rmsd_out
	echo --------------------------------------------------------------------------

	# Check whether $trjconv_out is set and prompt user to enter if not set.
	# Initialize the base rmsd command.
	if [ -n "$trjconv_out" ]; then
	  cmd_rmsd=(gmx rms -s $deffnm.tpr -f $trjconv_out.xtc -o $rmsd_out.xvg -tu ns)
	else
	  echo --------------------------------------------------------------------------
	  read -p "Enter converted trajectory file (without extension): " trjconv_out
	  echo --------------------------------------------------------------------------
	  cmd_rmsd=(gmx rms -s $deffnm.tpr -f $trjconv_out.xtc -o $rmsd_out.xvg -tu ns)
	fi

	# Conditionally add index file if does_index is true
	if [ "$does_index" = "true" ]; then
		cmd_rmsd+=(-n $index)
	fi
	
	# Execute the command
	"${cmd_rmsd[@]}"

	# Plot graph using xmgrace
	gracebat $rmsd_out.xvg -hdevice PNG -hardcopy -printfile "$rmsd_out.png"
	return
}

rmsf() {
        echo --------------------------------------------------------------------------
        read -p "Enter name for the output file: " rmsf_out
        echo --------------------------------------------------------------------------

        # Check whether $trjconv_out is set and prompt user to enter if not set.
        # Initialize the base rmsf command.
        if [ -n "$trjconv_out" ]; then
          cmd_rmsf=(gmx rmsf -s $deffnm.tpr -f $trjconv_out.xtc -o $rmsf_out.xvg -res -dir $rmsf_out.log)
        else
          echo --------------------------------------------------------------------------
          read -p "Enter converted trajectory file (without extension): " trjconv_out
          echo --------------------------------------------------------------------------
          cmd_rmsf=(gmx rmsf -s $deffnm.tpr -f $trjconv_out.xtc -o $rmsf_out.xvg -res -dir $rmsf_out.log)
        fi

        # Conditionally add index file if does_index is true
        if [ "$does_index" = "true" ]; then
                cmd_rmsf+=(-n $index)
        fi

        # Execute the command
        "${cmd_rmsf[@]}"

        # Plot graph using xmgrace
        gracebat $rmsf_out.xvg -hdevice PNG -hardcopy -printfile "$rmsf_out.png"
        return
}


gyration() { #Radius of gyration
	echo --------------------------------------------------------------------------
        read -p "Enter name for the output file: " gyrate_out
        echo --------------------------------------------------------------------------
        
	# Check whether $trjconv_out is set and prompt user to enter if not set.
        # Initialize the base gyration command.
	if [ -n "$trjconv_out" ]; then
          cmd_gyrate=(gmx gyrate -s $deffnm.tpr -f $trjconv_out.xtc -o $gyrate_out.xvg -tu ns)
        else
          echo --------------------------------------------------------------------------
          read -p "Enter converted trajectory file (without extension): " trjconv_out
          echo --------------------------------------------------------------------------
          cmd_gyrate=(gmx gyrate -s $deffnm.tpr -f $trjconv_out.xtc -o $gyrate_out.xvg -tu ns)
        fi

	# Conditionally add -n index file if does_index is true
        if [ "$does_index" = "true" ]; then
                cmd_gyrate+=(-n $index)
        fi

	# Execute the command
        "${cmd_gyrate[@]}"

	# Plot graph using xmgrace
        gracebat $gyrate_out.xvg -hdevice PNG -hardcopy -printfile "$gyrate_out.png"
        return
}

hydrogenbond() { # Hydrogen Bond Analysis
        echo --------------------------------------------------------------------------
        read -p "Enter name for the output .xvg file: " hbond_out
	read -p "Enter name for the output .ndx file: " hbond
        echo --------------------------------------------------------------------------

	# Check whether $trjconv_out is set and prompt user to enter if not set.
        # Initialize the base gyration command.
        if [ -n "$trjconv_out" ]; then
          cmd_hbond=(gmx hbond -s $deffnm.tpr -f $trjconv_out.xtc -num $hbond_out.xvg -o $hbond.ndx -tu ns)
        else
          echo --------------------------------------------------------------------------
          read -p "Enter converted trajectory file (without extension): " trjconv_out
          echo --------------------------------------------------------------------------
          cmd_hbond=(gmx hbond -s $deffnm.tpr -f $trjconv_out.xtc -num $hbond_out.xvg -o $hbond.ndx -tu ns)
        fi

        # Conditionally add -n index file if does_index is true
        if [ "$does_index" = "true" ]; then
                cmd_hbond+=(-n $index)
        fi

	# Execute the command
        "${cmd_hbond[@]}"

        # Plot graph using xmgrace
        gracebat $hbond_out.xvg -hdevice PNG -hardcopy -printfile "$hbond_out.png"
        return
}

SASA() { # solvent accessible surface areas
        echo --------------------------------------------------------------------------
        read -p "Enter name for the output .xvg file: " sasa_out
        echo --------------------------------------------------------------------------

        # Check whether $trjconv_out is set and prompt user to enter if not set.
        # Initialize the base gyration command.
        if [ -n "$trjconv_out" ]; then
          cmd_sasa=(gmx sasa -s $deffnm.tpr -f $trjconv_out.xtc -o $sasa_out.xvg -tu ns)
        else
          echo --------------------------------------------------------------------------
          read -p "Enter converted trajectory file (without extension): " trjconv_out
          echo --------------------------------------------------------------------------
          cmd_sasa=(gmx sasa -s $deffnm.tpr -f $trjconv_out.xtc -o $sasa_out.xvg -tu ns)
        fi

        # Conditionally add -n index file if does_index is true
        if [ "$does_index" = "true" ]; then
                cmd_sasa+=(-n $index)
        fi

        # Execute the command
        "${cmd_sasa[@]}"

        # Plot graph using xmgrace
        gracebat $sasa_out.xvg -hdevice PNG -hardcopy -printfile "$sasa_out.png"
        return
}

custom_command_4() {
	echo --------------------------------------------------------------------------
        read -p "Enter your command: " command_analysis
        echo --------------------------------------------------------------------------

        # Execute the command
	$command_analysis
}
