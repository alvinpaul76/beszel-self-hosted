# Prerequisites

Before you can install and run Beszel, you'll need to make sure your system meets a few requirements. Don't worry - these are straightforward and most modern systems already have what you need.

## What You Need

### A Server to Run the Hub

You need a server where you'll run the Beszel hub (the central dashboard). This can be:

- A physical server in your home or office
- A virtual private server (VPS) from a cloud provider
- Any computer that stays on and connected to the internet

**Minimum Requirements:**

- **Operating System:** Linux (Ubuntu, Debian, CentOS, or similar)
- **RAM:** At least 1 GB (2 GB recommended)
- **Disk Space:** At least 10 GB free space
- **Internet Connection:** Stable internet connection

**Recommended Requirements:**

- **RAM:** 2 GB or more
- **Disk Space:** 20 GB or more
- **CPU:** Any modern processor (multi-core preferred)

### Servers to Monitor (Optional)

If you want to monitor other servers, you'll need those servers too. Each server you want to monitor will need:

- Linux operating system
- At least 512 MB RAM free
- Internet connection to reach the hub server
- Docker installed (if you want to monitor Docker containers)

### Docker

Beszel runs using Docker, which is a tool that lets you run applications in containers. You'll need Docker installed on your hub server.

**What is Docker?**

Docker is like a lightweight virtual machine. It lets you run applications in isolated containers that include everything they need to work. This makes it easy to install and run Beszel without worrying about conflicts with other software on your server.

**How to Check if You Have Docker**

Open a terminal on your server and run:

```bash
docker --version
```

If you see a version number (like "Docker version 20.10.7"), you already have Docker installed.

If you see an error message like "command not found," you'll need to install Docker.

**How to Install Docker**

The easiest way to install Docker is using their official installation script. Run these commands:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

After installation, verify it worked:

```bash
docker --version
```

**Note:** You may need to add your user to the docker group to run Docker without sudo. If you get permission errors, run:

```bash
sudo usermod -aG docker $USER
```

Then log out and log back in for the changes to take effect.

### Docker Compose

Docker Compose is a tool that helps you manage multi-container Docker applications. Beszel uses it to make setup easier.

**How to Check if You Have Docker Compose**

Run this command:

```bash
docker-compose --version
```

If you see a version number, you're good to go. If not, you'll need to install it.

**How to Install Docker Compose**

Run these commands:

```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Verify the installation:

```bash
docker-compose --version
```

### Basic Command Line Knowledge

You'll need to be comfortable using the command line (terminal) to install and manage Beszel. You should know how to:

- Open a terminal
- Navigate to directories (`cd` command)
- Run commands
- Edit text files (using nano, vim, or another editor)

If you're new to the command line, don't worry - our installation guide will walk you through each step.

### Git (Optional but Recommended)

Git is a tool for downloading code from repositories. While not strictly required (you can download files manually), it makes installation much easier.

**How to Check if You Have Git**

```bash
git --version
```

**How to Install Git**

On Ubuntu/Debian:
```bash
sudo apt update
sudo apt install git
```

On CentOS/RHEL:
```bash
sudo yum install git
```

### Sudo Access (Linux)

Some of the installation steps require administrator privileges. You'll need:

- Either access to the root user account
- Or a user account with sudo privileges

Most Linux distributions set this up automatically when you create the first user account during installation.

### Network Access

Your hub server needs to be able to:

- Accept incoming connections on port 8090 (or another port you choose)
- Connect to the internet to download Docker images
- Reach your agent servers (if they're on different networks)

If you have a firewall running, you'll need to allow connections on the port you choose for Beszel.

### Storage Space

Beszel stores monitoring data on your server. The amount of space you need depends on:

- How many servers you're monitoring
- How frequently data is collected
- How long you keep historical data

As a starting point, plan for at least 10 GB of free space. You can always add more storage later if needed.

## Checking Your System

Before you start the installation, it's a good idea to verify everything is ready. Run these checks:

### Check Operating System

```bash
uname -a
```

This will show you your operating system and kernel version.

### Check Available Memory

```bash
free -h
```

This shows your available RAM. Look for the "available" column.

### Check Disk Space

```bash
df -h
```

This shows your disk usage. Make sure you have enough free space.

### Check Docker

```bash
docker --version
docker ps
```

The second command should show running containers (or be empty if Docker is working but no containers are running).

### Check Docker Compose

```bash
docker-compose --version
```

## Common Issues

### "Permission Denied" Errors

If you get permission denied errors when running Docker commands, you may need to add your user to the docker group (see the Docker installation section above).

### "Command Not Found" Errors

If commands aren't found, make sure you've installed the required software. Double-check the installation steps for Docker, Docker Compose, or Git.

### Firewall Issues

If you're having trouble accessing the Beszel web interface, check your firewall settings. You may need to allow traffic on port 8090.

On Ubuntu/Debian with ufw:
```bash
sudo ufw allow 8090/tcp
```

On CentOS/RHEL with firewalld:
```bash
sudo firewall-cmd --permanent --add-port=8090/tcp
sudo firewall-cmd --reload
```

## What's Next?

Once you've verified your system meets all the prerequisites, you're ready to install Beszel!

Continue to the [Installation Guide](03-installation.md) to get started.

If you run into any issues during installation, check our [Troubleshooting Guide](09-troubleshooting.md) for solutions.
