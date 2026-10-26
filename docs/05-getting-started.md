# Getting Started

Congratulations on installing Beszel! This guide will help you take your first steps with the system and get the most out of it.

## First Steps After Installation

### Access the Web Interface

1. Open your web browser
2. Navigate to your Beszel hub URL:
   - If on the same server: `http://localhost:8090`
   - If on a different computer: `http://your-server-ip:8090`
3. You should see the Beszel login screen

### Create Your Admin Account

The first time you access Beszel, you'll need to create an admin account:

1. Click "Create Account" or "Sign Up"
2. Enter your email address
3. Choose a strong password
4. Confirm your password
5. Click "Create Account"

This account will have full administrative access to Beszel, so keep the credentials secure.

### Complete Initial Setup

After creating your account, you may be prompted to complete some initial setup:

1. **Set your timezone** - This ensures timestamps are correct for your location
2. **Configure data retention** - How long to keep historical monitoring data
3. **Set up basic alerts** - Optional but recommended for getting notified of issues

## Understanding the Dashboard

When you first log in, you'll see the main dashboard. Here's what you'll find:

### Overview Section

The overview gives you a quick snapshot of:
- Total number of servers being monitored
- Number of online vs offline servers
- Overall system health status
- Recent alerts or issues

### Server List

A list of all servers (agents) connected to your hub:
- Server name or hostname
- Current status (online/offline)
- Basic resource usage (CPU, memory, disk)
- Last update time

### Quick Actions

Common actions you might want to take:
- Add a new server/agent
- View detailed metrics for a server
- Configure alerts
- Access settings

## Adding Your First Server

If you're running the hub and agent on the same server, you should already see it listed. If not, or if you want to add additional servers:

### Step 1: Navigate to Agents Section

1. Click "Agents" in the navigation menu
2. You'll see a list of currently connected agents

### Step 2: Add a New Agent

1. Click "Add New Agent" or the "+" button
2. Enter a name for the agent (e.g., "web-server", "database-server")
3. The hub will generate a KEY and TOKEN
4. Copy these values - you'll need them on the agent server

### Step 3: Configure the Agent Server

On the server you want to monitor:

1. Install Beszel (if not already done) - see [Installation Guide](03-installation.md)
2. Edit the `.env` file
3. Set the `BESZEL_AGENT_KEY` to the key from the hub
4. Set the `BESZEL_AGENT_TOKEN` to the token from the hub
5. Set `BESZEL_AGENT_HUB_URL` to your hub's URL
6. Start the agent: `docker-compose up -d`

### Step 4: Verify Connection

Go back to the hub web interface and check the Agents section. Your new agent should appear as "Connected" within a few moments.

## Viewing Monitoring Data

Once you have servers connected, you can start viewing monitoring data.

### Server Overview

Click on any server in the list to see detailed information:

**System Information:**
- Operating system and version
- CPU model and specifications
- Total and available memory
- Disk information
- Network interfaces

**Real-Time Metrics:**
- Current CPU usage
- Memory usage
- Disk usage and I/O
- Network traffic

**Historical Data:**
- Graphs showing trends over time
- Compare current values to historical averages
- Identify patterns and anomalies

### Docker Container Monitoring

If your servers run Docker containers, Beszel will automatically monitor them:

1. Navigate to a server's detail page
2. Look for the "Containers" section
3. You'll see:
   - List of all running containers
   - Container resource usage
   - Container status (running, stopped, etc.)
   - Container images and tags

## Setting Up Basic Alerts

Alerts notify you when something needs attention. Here's how to set up basic alerts:

### CPU Usage Alert

1. Go to the server you want to monitor
2. Click "Alerts" or "Settings"
3. Find "CPU Usage" alert
4. Set the threshold (e.g., 80%)
5. Choose how you want to be notified (email, etc.)
6. Save the alert

### Disk Space Alert

Running out of disk space can cause serious problems:

1. Navigate to server settings
2. Find "Disk Usage" alert
3. Set threshold (e.g., 90% full)
4. Enable notification
5. Save

### Server Offline Alert

Get notified when a server goes offline:

1. Go to global settings or server settings
2. Find "Server Status" or "Connectivity" alert
3. Enable "Offline" notifications
4. Set how quickly to alert (e.g., after 5 minutes offline)
5. Save

## Exploring the Interface

Take some time to explore the different sections of Beszel:

### Dashboard

Your main view with an overview of everything. Check this regularly to get a quick sense of your infrastructure's health.

### Servers/Agents

Detailed view of each server you're monitoring. Click on any server to see more details.

### Metrics

Browse different types of metrics:
- CPU metrics
- Memory metrics
- Disk metrics
- Network metrics
- Custom metrics (if configured)

### Alerts

View and manage your alerts:
- Active alerts (things that need attention now)
- Alert history (past alerts)
- Alert configuration (set up new alerts)

### Settings

Configure Beszel:
- User accounts and permissions
- Data retention settings
- Notification preferences
- System configuration

## Common First Tasks

Here are some things you might want to do in your first session:

### Check Your Current Setup

1. Verify all your servers are showing as "Online"
2. Check that metrics are being collected
3. Look at the dashboard to see current resource usage

### Set Up Essential Alerts

Configure alerts for:
- High CPU usage
- Low disk space
- Servers going offline
- Docker container failures

### Explore Historical Data

Look at the historical graphs to understand:
- Normal resource usage patterns
- Peak usage times
- Trends over time

### Test Notifications

Make sure your alert notifications are working:
1. Temporarily set a very low alert threshold
2. Wait for the alert to trigger
3. Verify you receive the notification
4. Set the threshold back to a reasonable value

## Understanding What You're Seeing

### CPU Usage

- **Normal:** 0-30% for idle servers, 30-70% for active servers
- **High:** 80%+ for extended periods may indicate need for investigation
- **Very High:** 95%+ means the server is overloaded

### Memory Usage

- **Normal:** 40-70% usage is typical
- **High:** 85%+ means you're running low on memory
- **Critical:** 95%+ can cause swapping and performance issues

### Disk Usage

- **Normal:** 50-70% usage gives you room for growth
- **High:** 80%+ means you should plan to add more storage
- **Critical:** 90%+ is dangerous - clean up or add storage immediately

### Network Traffic

- Look for unusual spikes that might indicate:
  - Security issues
  - Misconfigured applications
  - Backup processes running
  - Legitimate traffic increases

## Tips for New Users

### Start Simple

Don't try to configure everything at once. Start with:
- Basic monitoring of your servers
- A few essential alerts
- Get comfortable with the interface

### Check Regularly

Make it a habit to check Beszel regularly:
- Daily: Quick scan of the dashboard
- Weekly: Review historical trends
- Monthly: Check data retention and storage usage

### Use Descriptive Names

When adding servers/agents, use clear, descriptive names:
- "production-web-server" instead of "server1"
- "database-primary" instead of "db"
- This makes it easier to identify servers quickly

### Document Your Setup

Keep notes on:
- Which servers are monitoring what
- What your alert thresholds are
- Any custom configurations you make

### Don't Ignore Alerts

When you get an alert:
- Investigate promptly
- Take action if needed
- Note what caused it for future reference

## Next Steps

Now that you're familiar with the basics, you can:

- Learn more about [Using the Hub](06-using-the-hub.md) for advanced features
- Set up [additional agents](07-using-the-agent.md) on more servers
- Configure [backup and restore](08-backup-and-restore.md) for your data
- Explore [troubleshooting](09-troubleshooting.md) if you encounter issues

## Getting Help

If you have questions or run into problems:

1. Check our [FAQ](10-faq.md) for common questions
2. Look at our [Troubleshooting Guide](09-troubleshooting.md) for solutions
3. Open an issue in the repository for bugs or feature requests

Welcome to Beszel! You're now ready to monitor your infrastructure effectively.
