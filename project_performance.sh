#!/bin/zsh
# To amend for Linux or bash in general, update `zsh` in the previous line to `bash` 
# This file contains a function to track memory and runtime for the sde_simulator functions
# that are contained in this repo
track_memory_and_runtime() {
    local file_path=$1
    local file_extension=${file_path##*.}

    if [ ! -f "$file_path" ]; then
        echo "Error: File $file_path does not exist."
        exit 1
    fi

    # Determine the command to run based on the file extension
    case "$file_extension" in
        "rs")
            compile_cmd="rustc $file_path -o rust_sde_simulator"
            execute_cmd="./rust_sde_simulator"
            ;;
        "ml")
            execute_cmd="ocaml $file_path"
            ;;
        "m")
            execute_cmd="octave --silent $file_path"
            ;;
        "py")
            execute_cmd="python3 $file_path"
            ;;
        *)
            echo "Error: Unsupported file extension: $file_extension"
            exit 1
            ;;
    esac

    # Compile the file if necessary
    if [ -n "$compile_cmd" ]; then
        echo "Compiling $file_path..."
        eval "$compile_cmd"
        if [ $? -ne 0 ]; then
            echo "Compilation failed for $file_path"
            exit 1
        fi
    fi

    # Track memory and runtime using /usr/bin/time
    echo "Running $file_path..."
    /usr/bin/time -f "\nMemory (KB): %M\nRuntime (s): %e" bash -c "$execute_cmd"

    # Cleanup compiled file if it exists
    if [ -f "program_rust" ]; then
        rm program_rust
    fi
}

# Usage
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

track_memory_and_runtime "$1"
