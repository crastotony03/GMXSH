Bash script designed to simplify and automate protein simulation using GROMACS.

This is experimental project developed to support a specific research workflow. It may require modifications to run reliably across different systems.

To use execute gromacs_autorun.sh 

File structure:
gromacs_autorun.sh -> Execution file
gmx_processing.sh -> input parameters (boxtype, dimensions, water model)
gmx_equilibration.sh -> NVT and NPT simulations and graph generation using GRACE
gmx_mdrun.sh -> Executes simulation
gmx_analysis.sh -> file and graph generation for RMSD, RMSF, H.Bonds, index file, gyration etc.
