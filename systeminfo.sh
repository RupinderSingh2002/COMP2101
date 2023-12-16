#!/bin/bash

# This is a system report script.
# Most of the things are already created in the library file.
# So i will Source the function library

source reportfunctions.sh

# now i will make a simple function which will give me 3 different options to run the script.
# With all the options, this script can be run as a whole, only disk part, or only network part.
different_running_options() {
    echo "different_running_options: $0 [-h] [-v] [-system] [-disk] [-network]"
}

# Now a loop will check which options is selected and it will then run the script accordingly.

while options ":hvn" option; do
    case "$option" in
        h)
            different_running_options
            exit 0
            ;;
        v)
            VERBOSE=true
            ;;
        system) 
            SYSTEM_REPORT=true
            ;;
        disk)
            DISK_REPORT=true
            ;;
        network)
            NETWORK_REPORT=true
            ;;
        \?) 
            different_running_options
            exit 1
            ;;
    esac
done

# now to run full script, all functions will be used. 
run_full_report() {
    computerreport
    osreport
    cpureport
    ramreport
    videoreport
    diskreport
    networkreport
}


# Then we will make use of our functions and options to look how much to show.
if [ "$SYSTEM_REPORT" = true ]; then
    run_full_report
elif [ "$DISK_REPORT" = true ]; then
    diskreport
elif [ "$NETWORK_REPORT" = true ]; then
    networkreport
else
    run_full_report
fi


# End of the script...