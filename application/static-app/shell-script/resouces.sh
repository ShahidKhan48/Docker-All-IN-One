#!/bin/bash

# Thresholds (percentage)
CPU_T=80
MEM_T=80
DISK_T=85

# Get usages (macOS compatible)
CPU=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $3}' | sed 's/%//' | cut -d'.' -f1)
MEM=$(vm_stat | awk '/Pages free/ {free=$3} /Pages active/ {active=$3} /Pages inactive/ {inactive=$3} /Pages speculative/ {spec=$3} /Pages wired/ {wired=$3} END {total=(free+active+inactive+spec+wired)*4096/1024/1024; used=(active+inactive+spec+wired)*4096/1024/1024; print int(used/total*100)}')
DISK=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

echo "CPU: ${CPU}% | MEM: ${MEM}% | DISK: ${DISK}%"

# Check thresholds
[ ! -z "$CPU" ] && [ "$CPU" -gt "$CPU_T" ] && echo "⚠️ CPU usage high: ${CPU}%"
[ ! -z "$MEM" ] && [ "$MEM" -gt "$MEM_T" ] && echo "⚠️ Memory usage high: ${MEM}%"
[ ! -z "$DISK" ] && [ "$DISK" -gt "$DISK_T" ] && echo "⚠️ Disk usage high: ${DISK}%"