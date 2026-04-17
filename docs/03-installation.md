# Installation Guide

This guide will walk you through installing Beszel on your server step by step. We'll cover both installing the hub (the central dashboard) and agents (for monitoring additional servers).

## Installing the Hub

The hub is the central part of Beszel where you view all your monitoring data. You'll install this on your main server.

### Step 1: Download the Beszel Files

First, you need to get the Beszel files onto your server. The easiest way is using Git.

**Using Git (Recommended):**

```bash
git clone https://github.com/alvinpaul76/beszel-self-hosted.git
cd beszel-self-hosted
```

**Manual Download:**

If you don't have Git or prefer manual download:

1. Go to https://github.com/alvinpaul76/beszel-self-hosted
2. Click the green "Code" button
3. Select "Download ZIP"
4. Upload the ZIP file to your server
5. Extract it: `unzip beszel-self-hosted.zip`
6. Navigate to the folder: `cd beszel-self-hosted`

### Step 2: Set Up the Configuration File

Beszel uses a configuration file called `.env` to store settings. We provide an example file that you'll copy and customize.

**Copy the Example File:**

```bash
cp .env.example .env
```

**Edit the Configuration File:**

Open the `.env` file in your favorite text editor:

```bash
nano .env
```

You'll see several configuration options. Here's what each one means:

**Shared Docker Network:**
```
SHARED_DOCKER_NETWORK=cloudflared_shared-network
```
This is the name of the Docker network Beszel will use. You can keep the default or change it to something else.

**Default Storage Folder:**
```
DEFAULT_STORAGE_FOLDER=/storage/beszel
```
This is where Beszel will store its data. You can change this to any location on your server where you have enough disk space.

**Beszel Service Settings:**
```
BESZEL_IMAGE=henrygd/beszel
BESZEL_CONTAINER_NAME=beszel
BESZEL_RESTART=unless-stopped
BESZEL_PORT=8090
```
- `BESZEL_IMAGE`: The Docker image to use (keep this as is)
- `BESZEL_CONTAINER_NAME`: The name of the container (keep this as is)
- `BESZEL_RESTART`: When to restart the container (keep "unless-stopped")
- `BESZEL_PORT`: The port Beszel will use (8090 is the default, you can change if needed)

**Beszel Agent Settings:**
```
BESZEL_AGENT_IMAGE=henrygd/beszel-agent
BESZEL_AGENT_CONTAINER_NAME=beszel-agent
BESZEL_AGENT_RESTART=unless-stopped
BESZEL_AGENT_PORT=45876
BESZEL_AGENT_KEY=<put beszel agent key>
BESZEL_AGENT_TOKEN=<put beszel agent token>
BESZEL_AGENT_HUB_URL=http://localhost:8090
```
- `BESZEL_AGENT_IMAGE`: The Docker image for the agent (keep as is)
- `BESZEL_AGENT_CONTAINER_NAME`: The name of the agent container (keep as is)
- `BESZEL_AGENT_RESTART`: When to restart the agent (keep "unless-stopped")
- `BESZEL_AGENT_PORT`: The port the agent uses (keep as is)
- `BESZEL_AGENT_KEY`: You'll get this from the hub after you start it (leave as is for now)
- `BESZEL_AGENT_TOKEN`: You'll get this from the hub after you start it (leave as is for now)
- `BESZEL_AGENT_HUB_URL`: The URL of the hub (keep as is if hub is on same server)

**Save and Exit:**
- In nano: Press Ctrl+X, then Y, then Enter
- In vim: Press Esc, type `:wq`, then Enter

### Step 3: Create Required Directories

Beszel needs some directories to store its data. We provide a script to create these automatically.

**Run the Setup Script:**

```bash
sudo ./create_volumes.sh
```

This script will:
- Create the base storage directory
- Create all required subdirectories
- Set the correct permissions

**What the Script Does:**

The script reads your `.env` file and creates directories based on your configuration. It sets permissions so Docker can access these directories.

**If the Script Fails:**

If you see errors, make sure:
- You're running the script with sudo (it requires administrator privileges)
- The `.env` file exists in the same directory
- The directory path in `DEFAULT_STORAGE_FOLDER` is valid

### Step 4: Start the Beszel Services

Now you're ready to start Beszel!

**Start the Hub and Agent:**

```bash
docker-compose up -d
```

This command:
- Downloads the Docker images (if not already downloaded)
- Creates and starts the containers
- Runs them in the background (the `-d` flag)

**What to Expect:**

You'll see output showing Docker downloading images and starting containers. When it's done, you should see something like:

```
Creating beszel ... done
Creating beszel-agent ... done
```

### Step 5: Verify the Installation

Check that everything is running correctly.

**Check Running Containers:**

```bash
docker ps
```

You should see two containers running:
- `beszel` (the hub)
- `beszel-agent` (the agent)

**Check the Logs:**

If you want to see what's happening:

```bash
docker-compose logs -f
```

Press Ctrl+C to stop watching the logs.

### Step 6: Access the Web Interface

Once everything is running, you can access the Beszel web interface.

**Open Your Browser:**

Go to: `http://your-server-ip:8090`

Replace `your-server-ip` with your server's actual IP address. If you're on the same server, you can use `http://localhost:8090`.

**First-Time Setup:**

When you first access the web interface, you'll need to:
1. Create an admin account
2. Set up your initial configuration

Follow the on-screen instructions to complete the setup.

## Installing Agents on Additional Servers

If you want to monitor other servers, you'll need to install the Beszel agent on each one.

### Step 1: Get Agent Connection Details

From the Beszel hub web interface:

1. Log in to your hub
2. Navigate to the "Agents" section
3. Click "Add New Agent"
4. The hub will generate a KEY and TOKEN for you
5. Copy these values - you'll need them for the agent configuration

### Step 2: Install Beszel on the Agent Server

Repeat the same installation steps as above on the agent server:

1. Download the files
2. Copy `.env.example` to `.env`
3. Edit the `.env` file with the agent details

**Important Configuration for Agents:**

When editing the `.env` file on the agent server, make sure to:

- Set `BESZEL_AGENT_KEY` to the key you got from the hub
- Set `BESZEL_AGENT_TOKEN` to the token you got from the hub
- Set `BESZEL_AGENT_HUB_URL` to the URL of your hub server

For example, if your hub is at `192.168.1.100:8090`, set:
```
BESZEL_AGENT_HUB_URL=http://192.168.1.100:8090
```

### Step 3: Create Directories and Start the Agent

On the agent server, run:

```bash
sudo ./create_volumes.sh
docker-compose up -d
```

Or if you only want the agent (not the hub):

```bash
sudo ./create_volumes.sh
docker-compose -f docker-compose-agent.yml up -d
```

### Step 4: Verify the Agent Connection

Go back to your hub web interface and check the "Agents" section. You should see your new agent listed as "Connected."

## Agent-Only Installation

If you're setting up a server that will only run an agent (not the hub), you can use the agent-specific compose file.

**Using docker-compose-agent.yml:**

```bash
docker-compose -f docker-compose-agent.yml up -d
```

This file only includes the agent service, which is useful for:
- Servers that don't need the hub
- Reducing resource usage on agent servers
- Running multiple agents on different servers

## Troubleshooting Installation

### Container Won't Start

**Check the logs:**
```bash
docker-compose logs beszel
docker-compose logs beszel-agent
```

**Common issues:**
- Port already in use: Change `BESZEL_PORT` in `.env`
- Permission denied: Make sure directories exist and have correct permissions
- Docker not running: Check if Docker is installed and running

### Can't Access Web Interface

**Check if the container is running:**
```bash
docker ps
```

**Check your firewall:**
Make sure port 8090 is allowed through your firewall.

**Check the server IP:**
Make sure you're using the correct IP address in your browser.

### Agent Won't Connect to Hub

**Check the HUB_URL:**
Make sure `BESZEL_AGENT_HUB_URL` in the agent's `.env` file is correct and reachable from the agent server.

**Check the KEY and TOKEN:**
Make sure you copied the KEY and TOKEN correctly from the hub.

**Check network connectivity:**
From the agent server, try to access the hub:
```bash
curl http://hub-server-ip:8090
```

## Next Steps

Congratulations! You've installed Beszel. Now it's time to configure it and start monitoring.

Continue to the [Configuration Guide](04-configuration.md) to learn how to set up Beszel for your needs.

If you ran into any issues during installation, check our [Troubleshooting Guide](09-troubleshooting.md) for more help.
