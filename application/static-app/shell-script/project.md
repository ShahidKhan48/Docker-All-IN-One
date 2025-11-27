🧠 1. System Health Monitoring Script

Goal: Automatically monitor system performance and alert the admin if thresholds are crossed.
Use Case: Helps in real-time monitoring of servers in production.

Features:

Checks CPU, memory, and disk usage.

Sends alerts (email or Slack message) if usage > threshold.

Logs all metrics with timestamps.
----------
#!/bin/bash
THRESHOLD=80
EMAIL="admin@example.com"

cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
mem=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
disk=$(df -h / | awk 'NR==2 {print $(NF-1)}' | sed 's/%//')

echo "CPU: $cpu%, Memory: $mem%, Disk: $disk%"

if (( ${cpu%.*} > THRESHOLD || ${mem%.*} > THRESHOLD || ${disk%.*} > THRESHOLD )); then
  echo "⚠️ High Usage Detected on $(hostname) at $(date)" | mail -s "System Alert" $EMAIL
fi

-------
