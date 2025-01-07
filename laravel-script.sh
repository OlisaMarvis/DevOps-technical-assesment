#!/bin/bash

# Configuration
THRESHOLD=80
SERVICE_NAME="laravel.service"
LOG_FILE="/var/log/laravel-monitor.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

get_cpu_usage() {
    # Get CPU usage for all PHP-FPM processes
    cpu_usage=$(ps aux | grep php-fpm | grep -v grep | awk '{sum+=$3} END {print sum}')
    echo "${cpu_usage%.*}"  # Remove decimal places
}

restart_service() {
    log "Attempting to restart $SERVICE_NAME due to high CPU usage: $1%"
    
    # Save current state
    systemctl status "$SERVICE_NAME" > /tmp/service_state
    
    # Attempt graceful restart
    if systemctl restart "$SERVICE_NAME"; then
        log "Service restart successful"
        
        # Verify service is running
        if systemctl is-active --quiet "$SERVICE_NAME"; then
            log "Service is running after restart"
            return 0
        else
            log "Service failed to start after restart"
            return 1
        fi
    else
        log "Failed to restart service"
        return 1
    fi
}

notify_admin() {
    local cpu_usage=$1
    local message="High CPU alert: ${cpu_usage}% - Laravel service restarted"
    
    # Send email to admin (configure SMTP settings as needed)
    echo "$message" | mail -s "Laravel CPU Alert" admin@example.com
    
    # If using Slack (requires curl and configured webhook)
    # curl -X POST -H 'Content-type: application/json' \
    #     --data "{\"text\":\"${message}\"}" \
    #     "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
}

# Main monitoring loop
while true; do
    cpu_usage=$(get_cpu_usage)
    
    if [ "$cpu_usage" -gt "$THRESHOLD" ]; then
        log "CPU usage is high: ${cpu_usage}%"
        
        if restart_service "$cpu_usage"; then
            notify_admin "$cpu_usage"
        else
            log "Failed to resolve high CPU usage situation"
        fi
    fi
    
    sleep 60  # Check every minute
done