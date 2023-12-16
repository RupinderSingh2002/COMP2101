#!/bin/bash
# This is not a script but just a file which will save all my functions which i will use in any of my scripts. 
# In this way, i will not need to make the functions again, or use the commands again in scripts.
# The first function i will make is for the error message.

errormessage() {
    # it will check when the error was reported first.
    local timestamp
    # we will store it in this variable.
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local error_message=$1
    # Now this portion just displays the message.
    echo "$timestamp - $error_message" >> /var/log/systeminfo.log
    echo "Error: $error_message" >&2
}

# The next Function will be to generate CPU report.
# to generate cpu reports, i will use lscpu commands.
cpureport() {
    # i will provide heading
    echo "CPU Report: "
    echo "CPU Model: $(lscpu | grep "Model name: " | cut -d':' -f2)"
    echo "CPU Architect: $(lscpu | grep "Architect: " | cut -d':' -f2)"
    echo "CPU Core: $(lscpu | grep "Core(s) per socket: " | cut -d':' -f2)"
    echo "CPU Max Speed: $(lscpu | grep "Max Speed: " | cut -d':' -f2)"
    echo "Cache Sizes:"
    echo "Cache: $(lscpu | grep "Cache:" | cut -d':' -f2)"
}

# After making the cpu report, next function can be for general computer information.
# Function to generate Computer report will be like this
computerreport() {
    echo "Computer Report: "
    echo "Manufacturer: $(dmidecode -s system-manufacturer)"
    echo "Model: $(dmidecode -s system-product-name)"
    echo "Serial Number: $(dmidecode -s system-serial-number)"
}

# Now for the operationg system, i will make another Function. 
osreport() {
    echo "OS Report: "
    echo "Linux Distro: $(lsb_release -d | cut -d':' -f2)"
    echo "Distro Version: $(lsb_release -r | cut -d':' -f2)"
}
# Now we will create function for ram report. 
# i will be using free command for the info.
ramreport() {
    echo "RAM Report: "
    echo "Memory Components:"
    echo "Manufacturer | Model | Size | Speed | Location"
    echo "------------------------------------------------"
    dmidecode -t memory | grep -A6 "Memory Device" | awk 'NR%7==1 {manufacturer=$2} NR%7==2 {model=$2} NR%7==3 {size=$2} NR%7==4 {speed=$2} NR%7==6 {print manufacturer" | "model" | "size" | "speed" | "$2}' | column -t
    echo "Total Installed RAM: $(free -h | grep "Mem:" | awk '{print $2}')"
}

# the next function will make a report on the graphic card installed in the machine.

videoreport() {
    echo "Video/Graphic Card Report:"
    echo "Manufacturer: $(lspci | grep VGA | cut -d':' -f3)"
    echo "Video Card/Chipset Description or Model: $(lspci | grep VGA | cut -d':' -f3)"
}

# This Function will generate the next required thing which is Disk report.
diskreport() {
    echo "Disk Report:"
    echo "Installed Drives:"
    echo "Manufacturer | Model | Size | Partition | Mount Point | Filesystem Size | Filesystem Free Space"
    echo "---------------------------------------------------------------------------------------------"
    lsblk -o NAME,MODEL,SIZE,FSTYPE,MOUNTPOINT | awk '$1~/^sd/ {print $2" | "$3" | "$4" | "$1" | "$5" | "$6}' | column -t
}

# Now we will make the network report. For this we will use ip link commands.
networkreport() {
    echo "=== Network Report ==="
    echo "Installed Network Interfaces:"
    echo "Manufacturer | Model/Description | Link State | Current Speed | IP Addresses | Bridge Master | DNS Servers | Search Domains"
    echo "-----------------------------------------------------------------------------------------------------------------------"
    ip -o link show | awk '$2!="lo:" {print $2}' | xargs -n1 ip -o addr show | \
        awk '{print $2" | "$3" | "$9" | "$10" | "$4}' | \
        column -t -s "|" | xargs -n8 bash -c 'echo $0 | grep -q "master" && echo " | Yes" || echo " | No"'
}

# these are all the functions which we created during our understanding of the course and which are required by the script.
# End of File..



    