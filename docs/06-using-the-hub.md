# Using the Hub

The Beszel hub is your central command center for monitoring all your servers. This guide explains how to use the hub effectively.

## Accessing the Hub

### Web Interface

The hub provides a web-based interface that you can access from any computer:

1. Open your web browser
2. Navigate to your hub URL:
   - `http://localhost:8090` if on the same server
   - `http://your-server-ip:8090` from another computer
   - Your custom domain if you've set up a reverse proxy

3. Log in with your admin credentials

### Dashboard Overview

When you first log in, you'll see the main dashboard. This gives you an at-a-glance view of your entire infrastructure.

**Key Dashboard Elements:**

- **Status Summary** - Quick overview of online/offline servers
- **Resource Overview** - Aggregate resource usage across all servers
- **Recent Alerts** - Latest alerts that need attention
- **Quick Actions** - Common tasks like adding servers

## Managing Servers

### Viewing Server List

The hub shows all connected servers (agents) in a list view:

- Server name/hostname
- Online status
- Current resource usage
- Last update time
- Quick actions menu

### Server Details

Click on any server to see detailed information:

**System Information:**
- Operating system and kernel version
- CPU information (model, cores, speed)
- Memory (total, used, available)
- Disk information (size, usage, file system type)
- Network interfaces and IP addresses

**Real-Time Metrics:**
- Current CPU usage percentage
- Memory usage
- Disk I/O (read/write rates)
- Network traffic (in/out)
- Docker container status (if applicable)

**Historical Graphs:**
- CPU usage over time
- Memory usage trends
- Disk space changes
- Network traffic patterns
- Custom metrics

### Adding New Servers

To monitor a new server:

1. Click "Add Server" or the "+" button in the Servers section
2. Enter a descriptive name for the server
3. The hub will generate a unique KEY and TOKEN
4. Copy these credentials
5. Use them when configuring the agent on the new server
6. The server will appear in the list once the agent connects

See [Using the Agent](07-using-the-agent.md) for detailed agent setup instructions.

### Removing Servers

To stop monitoring a server:

1. Go to the Servers section
2. Find the server you want to remove
3. Click the menu (three dots) next to the server
4. Select "Remove" or "Delete"
5. Confirm the removal

**Note:** This only removes the server from the hub. It doesn't uninstall the agent from the server.

## Monitoring Metrics

### CPU Metrics

View CPU-related information:

- **Current Usage** - Real-time CPU utilization
- **Core Usage** - Usage per CPU core
- **Load Average** - System load over 1, 5, and 15 minutes
- **Process Count** - Number of running processes

**What to Look For:**
- Consistently high CPU usage (>80%) may indicate need for optimization or more resources
- Spikes in usage might correlate with scheduled tasks
- Load average higher than number of cores means the system is overloaded

### Memory Metrics

Monitor memory usage:

- **Total Memory** - Physical RAM installed
- **Used Memory** - Memory currently in use
- **Available Memory** - Free memory plus cache/buffers
- **Swap Usage** - Disk space used as virtual memory
- **Cache/Buffers** - Memory used for caching

**What to Look For:**
- Available memory consistently below 20% means you need more RAM
- High swap usage (>50%) indicates memory pressure
- Sudden drops in available memory might indicate memory leaks

### Disk Metrics

Track disk usage and performance:

- **Disk Space** - Used vs free space per mount point
- **Disk I/O** - Read and write rates
- **I/O Wait** - Time CPU waits for disk operations
- **Mount Points** - List of mounted filesystems

**What to Look For:**
- Disks over 80% full need attention or cleanup
- High I/O wait indicates slow storage
- Sudden increases in disk usage might indicate log files growing

### Network Metrics

Monitor network activity:

- **Traffic In/Out** - Data transfer rates
- **Connections** - Number of active network connections
- **Errors** - Network errors or dropped packets
- **Interfaces** - Status of each network interface

**What to Look For:**
- Unusual traffic spikes might indicate security issues or backup jobs
- High error rates suggest network problems
- Sudden drops in traffic might mean connectivity issues

### Docker Container Metrics

If your servers run Docker:

- **Container List** - All containers with status
- **Container Resources** - CPU, memory usage per container
- **Container Health** - Health check status
- **Image Information** - Container images and tags

**What to Look For:**
- Containers using excessive resources
- Containers frequently restarting
- Stopped containers that should be running

## Setting Up Alerts

Alerts notify you when something needs attention.

### Creating Alerts

1. Navigate to the Alerts section
2. Click "Create New Alert"
3. Choose the type of alert:
   - CPU usage
   - Memory usage
   - Disk space
   - Server status (online/offline)
   - Custom metric
4. Set the threshold value
5. Choose notification method (email, etc.)
6. Select which servers to monitor
7. Save the alert

### Alert Types

**CPU Alert:**
- Triggers when CPU usage exceeds threshold
- Useful for detecting overloaded servers
- Set threshold based on your workload (typically 80-90%)

**Memory Alert:**
- Triggers when memory usage is too high
- Helps prevent out-of-memory situations
- Set at 85-90% typically

**Disk Space Alert:**
- Triggers when disk space is low
- Critical for preventing servers from filling up
- Set at 80-90% to give time to respond

**Server Offline Alert:**
- Triggers when a server stops reporting
- Essential for detecting server failures
- Set delay (e.g., alert after 5 minutes offline)

**Custom Alerts:**
- Monitor specific metrics important to you
- Can be based on any collected metric
- Flexible thresholds and conditions

### Managing Alerts

**View Active Alerts:**
- Check the Alerts section for current issues
- Active alerts are highlighted
- Click to see details and suggested actions

**Alert History:**
- Review past alerts to identify patterns
- Useful for understanding recurring issues
- Can help with capacity planning

**Modify Alerts:**
- Edit existing alerts to adjust thresholds
- Change notification settings
- Add or remove monitored servers

**Disable Alerts:**
- Temporarily disable alerts during maintenance
- Permanently remove alerts no longer needed

## User Management

If multiple people need access to Beszel:

### Adding Users

1. Go to Settings > Users
2. Click "Add User"
3. Enter email address
4. Set password or let user set it
5. Choose user role:
   - Admin - Full access to everything
   - Viewer - Can only view data, no changes
   - Custom - Specific permissions
6. Save the user

### Managing Permissions

Control what users can see and do:

- **Server Access** - Restrict to specific servers
- **Alert Access** - Control alert management
- **Settings Access** - Restrict configuration changes
- **Data Access** - Control access to historical data

### Removing Users

1. Go to Settings > Users
2. Find the user to remove
3. Click "Delete" or "Remove"
4. Confirm the action

## Data Management

### Viewing Historical Data

The hub stores historical data for analysis:

- **Time Range Selection** - Choose time periods (hour, day, week, month)
- **Metric Comparison** - Compare different metrics
- **Server Comparison** - Compare metrics across servers
- **Export Data** - Export data for external analysis

### Data Retention

Configure how long to keep data:

1. Go to Settings > Data Retention
2. Set retention periods for different metric types
3. Consider storage space vs. analysis needs
4. Save settings

**Typical Retention:**
- Detailed metrics: 7-30 days
- Summarized metrics: 90-365 days
- Alerts: 1 year or more

### Exporting Data

Export data for reports or analysis:

1. Navigate to the metric or server you want
2. Click "Export" or "Download"
3. Choose format (CSV, JSON, etc.)
4. Select time range
5. Download the file

## System Settings

### General Settings

Access global configuration:

1. Go to Settings > General
2. Configure:
   - System name
   - Timezone
   - Date/time format
   - Language
3. Save changes

### Notification Settings

Configure how you receive alerts:

1. Go to Settings > Notifications
2. Set up notification methods:
   - Email
   - Webhooks
   - Other integrations
3. Test notifications
4. Save settings

### Performance Settings

Tune hub performance:

1. Go to Settings > Performance
2. Adjust:
   - Data collection interval
   - Graph resolution
   - Database optimization
3. Monitor impact
4. Save changes

## Tips for Effective Hub Use

### Regular Dashboard Checks

Make it a habit to:
- Check the dashboard daily for quick overview
- Review alerts regularly
- Look at trends weekly
- Plan capacity monthly

### Use Descriptive Names

Name your servers clearly:
- "prod-web-01" instead of "server1"
- "staging-db" instead of "db-server"
- Makes it easier to identify servers quickly

### Set Meaningful Alerts

Configure alerts that matter:
- Don't set too many (alert fatigue)
- Focus on critical issues
- Adjust thresholds based on experience
- Review and update regularly

### Document Your Setup

Keep records of:
- Alert thresholds and why you chose them
- Server naming conventions
- Custom configurations
- Backup procedures

## Troubleshooting Hub Issues

### Can't Access Web Interface

**Check if the hub is running:**
```bash
docker ps | grep beszel
```

**Check the logs:**
```bash
docker-compose logs beszel
```

**Verify the port:**
- Make sure port 8090 isn't blocked by firewall
- Check if another service is using the port

### Data Not Updating

**Check agent connections:**
- Verify agents are running
- Check network connectivity
- Review agent logs

**Check hub logs:**
```bash
docker-compose logs -f beszel
```

### Slow Performance

**Check system resources:**
- Ensure hub server has enough RAM/CPU
- Check disk space on hub server
- Consider reducing data retention

**Optimize settings:**
- Increase data collection interval
- Reduce graph resolution
- Archive old data

## Next Steps

Now that you understand how to use the hub, you might want to:

- Learn about [Using the Agent](07-using-the-agent.md) for monitoring specific servers
- Set up [Backup and Restore](08-backup-and-restore.md) for your data
- Check the [Troubleshooting Guide](09-troubleshooting.md) if you encounter issues
