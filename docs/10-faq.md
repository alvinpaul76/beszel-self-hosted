# Frequently Asked Questions

This FAQ answers common questions about Beszel. If you don't find your answer here, check the [Troubleshooting Guide](09-troubleshooting.md) or open an issue.

## General Questions

### What is Beszel?

Beszel is a self-hosted server monitoring system. It lets you monitor multiple servers from one central dashboard, tracking CPU, memory, disk usage, Docker containers, and more. Your data stays on your own servers - no cloud service required.

### Is Beszel free?

Yes! Beszel is completely free to use. It's open-source software, so there are no subscription fees or licensing costs. You just need your own server to run it on.

### What are the system requirements?

**Minimum:**
- 1 GB RAM
- 10 GB disk space
- Linux operating system
- Docker and Docker Compose

**Recommended:**
- 2 GB RAM or more
- 20 GB disk space or more
- Modern processor with multiple cores

See the [Prerequisites Guide](02-prerequisites.md) for details.

### Can I run Beszel on Windows or macOS?

Beszel is designed for Linux servers. While you might be able to run it on Windows or macOS using Docker, it's not officially supported and may not work correctly. We recommend using a Linux server or virtual machine.

### How many servers can I monitor?

There's no hard limit on the number of servers you can monitor. The practical limit depends on your hub server's resources and how frequently you collect data. A well-equipped hub server can easily monitor dozens of servers.

### Is my data secure?

Yes. Beszel keeps all your monitoring data on your own servers. Communication between agents and the hub is encrypted. You have complete control over your data and who can access it.

## Installation Questions

### Do I need to be a Linux expert to use Beszel?

No, but you should be comfortable with basic command-line operations. Our guides walk you through each step. If you can follow instructions and run commands in a terminal, you can use Beszel.

### Can I install Beszel on an existing server with other services?

Yes, as long as the server has enough resources and the port Beszel uses (8090 by default) isn't already in use. You may need to adjust the port if there's a conflict.

### Do I need to install Docker and Docker Compose manually?

Yes, Beszel requires Docker and Docker Compose to be installed on your server. See the [Prerequisites Guide](02-prerequisites.md) for installation instructions.

### Can I use a different port than 8090?

Yes. Edit the `.env` file and change `BESZEL_PORT` to your preferred port. Make sure to update your firewall rules accordingly.

### What if the create_volumes.sh script fails?

The script requires sudo privileges and a valid `.env` file. Make sure you're running it with `sudo` and that the `.env` file exists in the same directory. Check the error message for specific issues.

## Configuration Questions

### What's the difference between the hub and the agent?

The **hub** is the central dashboard where you view all monitoring data. The **agent** runs on each server you want to monitor, collecting data and sending it to the hub. You need one hub and one agent per server you monitor.

### Can I run the hub and agent on the same server?

Yes, this is a common setup. The default configuration installs both on the same server. This is perfect for monitoring the server that's also running the hub.

### Do I need to install the hub on every server?

No. You only need one hub. Install agents on the servers you want to monitor, all connecting to your single hub.

### How do I add a new server to monitor?

1. Log in to your hub web interface
2. Go to the Agents section
3. Click "Add New Agent"
4. Copy the KEY and TOKEN provided
5. Install the agent on the new server using those credentials
6. The server will appear in your hub once connected

### Can I monitor servers in different locations?

Yes, as long as the agent servers can reach your hub server over the network. This may require VPN, proper firewall configuration, or public internet access with security considerations.

### What's the HUB_URL setting?

This tells the agent where to find the hub. If the hub and agent are on the same server, use `http://localhost:8090`. If on different servers, use the hub's IP address or domain name.

## Usage Questions

### How often does Beszel collect data?

The default collection interval is typically every few minutes. You can adjust this in the hub settings. More frequent collection gives more detail but uses more resources.

### How long is historical data kept?

This is configurable in the hub settings. Default retention varies, but you can set it to keep data for days, weeks, or months depending on your needs and available storage.

### Can I export my monitoring data?

Yes, Beszel allows you to export data in various formats (CSV, JSON, etc.) for analysis or reporting. This is done through the web interface.

### Can I set up alerts?

Yes, you can configure alerts for various conditions like high CPU usage, low disk space, servers going offline, and more. Alerts can be sent via email or other notification methods.

### Can multiple people use Beszel?

Yes, you can create multiple user accounts with different permission levels. This lets team members view data or manage the system as needed.

### Does Beszel monitor Docker containers?

Yes, if your servers run Docker, Beszel automatically monitors all containers, showing their status and resource usage.

### Can I monitor additional disks or partitions?

Yes, you can configure the agent to monitor additional disks by adding volume mounts in the Docker Compose file. See the [Configuration Guide](04-configuration.md) for details.

## Technical Questions

### What happens if the hub goes offline?

If the hub is offline, agents will temporarily buffer data. When the hub comes back online, agents will sync their data. Historical data is preserved.

### What happens if an agent goes offline?

The hub will show the agent as "Offline." You can set up alerts to notify you when agents go offline. When the agent comes back online, it will resume sending data.

### Does Beszel work behind a firewall?

Yes, but you need to ensure the hub port (8090 by default) is accessible from your agent servers. You may need to configure firewall rules or use a VPN.

### Can I use a reverse proxy?

Yes, you can set up Nginx, Apache, or another reverse proxy to access Beszel through a domain name. This is useful for SSL/HTTPS setup.

### Can I use SSL/HTTPS?

Yes, by setting up a reverse proxy with an SSL certificate (like from Let's Encrypt). This provides secure access to your Beszel installation.

### How much data does Beszel store?

Data storage depends on:
- Number of servers being monitored
- Collection frequency
- Data retention settings
- Types of metrics collected

As a rough estimate, a single server with default settings might use a few hundred megabytes per month. Monitor your disk usage and adjust retention as needed.

## Backup and Recovery

### Do I need to backup my data?

Yes, we strongly recommend regular backups. This protects against hardware failure, accidental deletion, or other data loss scenarios.

### What do I need to backup?

The most important things to backup are:
- The `.env` configuration file
- The hub database files (`data.db`, `auxiliary.db`)
- The encryption key (`id_ed25519`)

Agent data can be regenerated by reconnecting agents to the hub.

### How do I backup Beszel?

The simplest method is to stop Beszel and copy the data directory to a backup location. You can also automate this with scripts. See the [Backup and Restore Guide](08-backup-and-restore.md) for detailed instructions.

### How do I restore from backup?

Stop Beszel, copy your backup files to the original locations, and restart Beszel. The [Backup and Restore Guide](08-backup-and-restore.md) provides step-by-step instructions.

### Can I move Beszel to a new server?

Yes. Install Beszel on the new server, stop it, restore your backup, and start it. You may need to update agent configurations if the hub IP address changes.

## Troubleshooting

### The web interface won't load. What should I do?

1. Check if the hub container is running: `docker ps`
2. Check the logs: `docker-compose logs beszel`
3. Verify the port is correct
4. Check your firewall settings
5. Try restarting: `docker-compose restart`

See the [Troubleshooting Guide](09-troubleshooting.md) for more help.

### My agent won't connect to the hub. What should I do?

1. Verify the HUB_URL is correct in the agent's `.env`
2. Check that the KEY and TOKEN match what's in the hub
3. Test network connectivity from agent to hub
4. Check firewall rules
5. Review agent logs: `docker-compose logs beszel-agent`

### Beszel is using too much memory. What can I do?

1. Reduce data retention settings
2. Increase the data collection interval
3. Reduce the number of metrics collected
4. Check for database issues
5. Consider upgrading your server

### I forgot my password. How do I reset it?

You'll need to access the database directly or recreate the admin account. The specific method depends on your Beszel version. Check the documentation or open an issue for assistance with your specific version.

## Advanced Questions

### Can I customize what metrics are collected?

Yes, through the hub configuration you can adjust which metrics are collected and how often. Some custom metrics may require additional configuration.

### Can I integrate Beszel with other tools?

Beszel provides data export capabilities and may support webhooks for alerts. Specific integrations depend on your needs and may require custom development.

### Is there an API?

Check the current documentation or repository for API information. API availability and features may vary by version.

### Can I run multiple hubs?

While technically possible, this is not recommended. A single hub can monitor many servers. Multiple hubs would require managing separate instances and would fragment your monitoring data.

### How do I update Beszel?

To update:
1. Pull the latest Docker images: `docker-compose pull`
2. Restart the services: `docker-compose up -d`
3. Verify everything is working

Always backup before updating!

## Community and Support

### Where can I get help?

- Check this FAQ and the [Troubleshooting Guide](09-troubleshooting.md)
- Search existing GitHub issues
- Open a new issue if your problem isn't documented
- Check the project repository for community discussions

### How do I report a bug?

Open an issue in the GitHub repository with:
- A clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs and system information
- Your Beszel version

### How do I request a feature?

Open an issue in the GitHub repository with a feature request. Describe what you want, why it would be useful, and how you envision it working.

### Can I contribute to Beszel?

Yes! Beszel is open-source. Check the repository for contribution guidelines, or open an issue to discuss your contribution ideas.

## Licensing

### What license is Beszel under?

Beszel is released under the MIT License. See the LICENSE file in the repository for details.

### Can I use Beszel commercially?

Yes, the MIT License permits commercial use. You can use Beszel for personal or commercial projects without restriction.

### Do I need to credit Beszel?

The MIT License doesn't require attribution, but we appreciate it if you mention using Beszel in your projects.

## Still Have Questions?

If you didn't find your answer here:

1. Review the other documentation guides
2. Check the [Troubleshooting Guide](09-troubleshooting.md)
3. Search the GitHub issues
4. Open a new issue with your question

We're continuously improving Beszel and its documentation. Your questions help us make it better for everyone!
