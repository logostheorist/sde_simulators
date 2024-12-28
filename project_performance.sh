#! /usr/lib zsh
# To amend for Linux or bash in general, replace zsh with the desired folder
# The following command assumes that you have compiled the c++ and rust files

code_folders=("c++" "rust" "ocaml" "octave" "python")
echo "Comparing the performance of a simple SDE simulation for the following languages: \n"
for folder in "${code_folders[@]}"
do
    csv_file="${folder}_simulation.csv"
    echo "\n\n\tIn $folder:"
    case "$folder" in
	"c++")
	    /usr/bin/time ./c++/sde_simulator > "$csv_file"
	    ;;
	"rust")
	    /usr/bin/time ./rust_sde_simulator/target/release/rust_sde_simulator  > "$csv_file"
	    ;;
	"ocaml")
	    /usr/bin/time ocaml ./ocaml/sde_simulator.ml > "$csv_file"
	    ;;
	"octave")
	    /usr/bin/time octave --silent ./octave/sde_simulator.m > "$csv_file"
	    ;;
	"python")
	    /usr/bin/time python3 ./python/sde_simulator.py > "$csv_file"
	    ;;
    esac
done
