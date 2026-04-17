# Introduction to Beszel

## What is Beszel?

Beszel is a self-hosted server monitoring system that gives you complete control over your infrastructure monitoring. Instead of relying on cloud-based monitoring services that store your data on their servers, Beszel lets you run everything on your own hardware.

Think of Beszel as your own private command center for keeping an eye on all your servers, applications, and Docker containers.

## Why Use Beszel?

### Keep Your Data Private

When you use cloud-based monitoring services, your server data - including information about your applications, performance metrics, and system configurations - is stored on someone else's servers. With Beszel, all your monitoring data stays on your own infrastructure. You have complete control over who sees it and how it's stored.

### No Monthly Fees

Most commercial monitoring solutions charge monthly fees that can add up quickly, especially as you add more servers. Beszel is completely free to use - you just need your own server to run it on. Once you've set it up, there are no ongoing subscription costs.

### Monitor Everything in One Place

If you have multiple servers spread across different locations, keeping track of them all can be challenging. Beszel gives you a single dashboard where you can view the status and performance of all your servers at once.

### Docker Container Monitoring

If you use Docker to run your applications, Beszel can monitor all your containers automatically. You'll be able to see which containers are running, how much resources they're using, and spot any issues quickly.

### System Resource Tracking

Beszel keeps track of important system metrics like:
- CPU usage
- Memory usage
- Disk space and performance
- Network activity

This helps you identify problems before they become serious - like a server running out of disk space or an application using too much memory.

## How Beszel Works

Beszel uses a simple two-part system:

### The Hub

The hub is the central part of Beszel. It's the dashboard where you view all your monitoring data. You run the hub on one server, and it collects data from all your agents.

The hub provides:
- A web interface to view your monitoring data
- Centralized storage for all monitoring information
- Alerting and notifications
- Historical data and trends

### Agents

Agents are small programs that you install on each server you want to monitor. The agent runs quietly in the background, collecting information about the server and sending it back to the hub.

Each agent monitors:
- System resources (CPU, memory, disk, network)
- Docker containers (if Docker is installed)
- File system health and disk usage
- Custom metrics you configure

You can install as many agents as you need - one for each server you want to monitor. They all report back to your central hub.

## Typical Use Cases

### Home Lab Monitoring

If you run a home lab with multiple servers for testing, development, or personal projects, Beszel gives you a single view of everything. You can quickly spot which server needs attention without logging into each one individually.

### Small Business Infrastructure

Small businesses often have a few servers running their websites, applications, and databases. Beszel provides enterprise-grade monitoring without the enterprise price tag. You'll know immediately if a server goes down or if an application is having problems.

### Development Environment Monitoring

Developers often need to monitor multiple development and testing environments. Beszel lets you keep an eye on resource usage across all your environments, helping you optimize performance and catch issues early.

### Remote Server Management

If you have servers in different locations (like cloud servers, colocation facilities, or remote offices), Beszel gives you a centralized view of everything. You can monitor all your remote servers from one dashboard without needing to log into each one.

## What Makes Beszel Different?

### Self-Hosted

Unlike commercial monitoring services, Beszel runs entirely on your own infrastructure. You don't need to create accounts with third-party services or worry about their data retention policies.

### Lightweight

Beszel is designed to be lightweight and efficient. The agents use minimal system resources, so they won't impact the performance of the servers they're monitoring.

### Docker-Native

Beszel is built with Docker in mind from the ground up. If you're already using Docker containers, Beszel integrates seamlessly and provides detailed container monitoring out of the box.

### Easy to Set Up

You don't need to be a monitoring expert to use Beszel. Our documentation guides you through everything step by step, and the system is designed to be straightforward to configure.

### Secure

All communication between agents and the hub is encrypted. Your monitoring data is stored securely, and you have full control over access to your monitoring system.

## Next Steps

Ready to get started with Beszel? Here's what to do next:

1. **[Check the Prerequisites](02-prerequisites.md)** - Make sure your system is ready to run Beszel
2. **[Follow the Installation Guide](03-installation.md)** - Install Beszel on your server
3. **[Configure Your System](04-configuration.md)** - Set up your hub and agents
4. **[Get Started](05-getting-started.md)** - Begin monitoring your servers

If you run into any issues along the way, check our [Troubleshooting Guide](09-troubleshooting.md) or [FAQ](10-faq.md) for help.
