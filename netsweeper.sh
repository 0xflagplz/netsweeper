#!/bin/bash

if [[ "$#" -lt 3 ]]; then
  echo -e "[*] - ERROR: Wrong Format\n**Only Scans /24**"
  echo -e "\tUsage: ./netsweep.sh output.txt THREADS 192.168.0 10.0.0 ..."
  exit 1
fi

# Extract output file, thread limit, and subnets
output_file="$1"
thread_limit="$2"
shift 2
subnets=("$@")

# Clear or create the output file
> "$output_file"

# Function to scan a single IP
ping_host() {
  local ip="$1"
  if ping -c 1 "$ip" | grep -q "64 bytes"; then
    echo "$ip" | tee -a "$output_file"
  fi
}

# Function to scan a subnet
scan_subnet() {
  local subnet="$1"
  echo "Scanning subnet: $subnet" | tee -a "$output_file"
  seq 1 255 | xargs -P "$thread_limit" -I {} bash -c "ping_host $subnet.{}"
}

# Loop through each subnet and scan
for subnet in "${subnets[@]}"; do
  scan_subnet "$subnet"
done

echo "Scan complete. Results saved in $output_file"
