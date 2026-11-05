# Configuration Guide

This guide explains how to configure Beszel to work best for your needs. You'll learn about the different settings available and how to customize them.

## Understanding the .env File

Configuration is done through two `.env` files: `hub/.env` for the hub and `agent/.env` for the agent. Each is copied from the `.env.example` in the same folder. This file contains all the settings that control how Beszel runs.

### Opening the Configuration File

To edit your configuration:

```bash
nano hub/.env     # or agent/.env
```

Or use your preferred text editor.

### Configuration Options Explained

#### Shared Docker Network (hub only)

```
SHARED_DOCKER_NETWORK=cloudflared_shared-network
```

**What it does:** Defines the name of the external Docker network the hub joins. The network must already exist (`docker network create <name>`). The agent runs with `network_mode: host`, so it has no network setting.

The default name comes from the author's Cloudflare Tunnel setup; change it to a network you have, or create one with that name.

**When to change it:** 
- If you're using other Docker services that need to connect to Beszel
- If the default network name conflicts with existing networks
- If you want to organize your Docker networks differently

**Default:** `cloudflared_shared-network`

#### Storage Location

```
DEFAULT_STORAGE_FOLDER=/storage/beszel
```

**What it does:** Sets the main directory where Beszel stores all its data, including databases and backups.

**When to change it:**
- If you want to store data on a different disk or partition
- If you have limited space on the default location
- If you want to use a mounted network drive for storage

**Important:** Make sure the directory you specify exists and has enough disk space. After changing this, you'll need to run `sudo ./create_volumes.sh hub` (or `agent`) again.

**Default:** `/storage/beszel`

#### Hub Service Settings

```
BESZEL_IMAGE=henrygd/beszel:0.21.1
BESZEL_CONTAINER_NAME=beszel
BESZEL_RESTART=unless-stopped
BESZEL_PORT=8090
```

**BESZEL_IMAGE:** The Docker image used for the hub. It is pinned to a specific version and is required; the compose file fails if it is unset. Change the tag deliberately when upgrading.

**BESZEL_CONTAINER_NAME:** The name of the hub container. Keep this as is for consistency.

**BESZEL_RESTART:** Controls when the container restarts automatically.
- `unless-stopped` (recommended): Restarts automatically unless you manually stop it
- `always`: Always restarts, even after manual stops
- `on-failure`: Only restarts if it crashes

**BESZEL_PORT:** The port where the hub web interface is accessible.
- Change this if port 8090 is already in use on your server
- Make sure to update your firewall rules if you change the port
- Remember to use the new port when accessing the web interface

**Default:** `8090`

#### Agent Service Settings

```
BESZEL_AGENT_IMAGE=henrygd/beszel-agent:0.21.1-alpine
BESZEL_AGENT_CONTAINER_NAME=beszel-agent
BESZEL_AGENT_RESTART=unless-stopped
BESZEL_AGENT_PORT=45876
BESZEL_AGENT_KEY=<put beszel agent key> # Moved to Infisical but kept for debugging purposes
BESZEL_AGENT_TOKEN=<put beszel agent token> # Moved to Infisical but kept for debugging purposes
BESZEL_AGENT_HUB_URL=http://localhost:8090
INFISICAL_CLI_IMAGE=infisical/cli:0.44.8
```

**BESZEL_AGENT_IMAGE:** The Docker image for the agent, pinned to a specific version (required; the compose file fails if it is unset). Change the tag deliberately when upgrading.

**BESZEL_AGENT_CONTAINER_NAME:** The name of the agent container. Keep as is.

**BESZEL_AGENT_RESTART:** Same restart policy options as the hub.

**BESZEL_AGENT_PORT:** The port the agent uses to listen for connections from the hub. Keep this as is unless you have specific networking requirements.

**BESZEL_AGENT_KEY:** A unique key that identifies this agent to the hub.
- You get this from the hub web interface when adding a new agent
- Each agent needs a unique key
- Store it in Infisical. The compose file does not read this line in `agent/.env`; it is kept only for debugging.
- Do not share this key publicly

**BESZEL_AGENT_TOKEN:** A security token that authenticates the agent with the hub.
- You get this from the hub web interface when adding a new agent
- Each agent has its own token
- Store it in Infisical. The compose file does not read this line in `agent/.env`; it is kept only for debugging.
- Keep this secret

**INFISICAL_CLI_IMAGE:** The Infisical CLI image for the helper container that fetches the KEY and TOKEN.
- Set it to a specific version, such as `infisical/cli:<version>`. Do not use `latest`.
- The compose file will not start if this is unset.
- The rest of the Infisical setup is in [Connecting the Agent to Infisical](07-using-the-agent.md#connecting-the-agent-to-infisical).

**BESZEL_AGENT_HUB_URL:** The URL where the agent can reach the hub.
- For hub and agent on the same server: `http://localhost:8090`
- For agent on a different server: `http://hub-server-ip:8090`
- Make sure the agent can reach this URL (check firewall and network settings)

## Configuring the Hub

### Accessing Hub Settings

1. Open your browser and go to your hub URL (e.g., `http://localhost:8090`)
2. Log in with your admin account
3. Navigate to the Settings section

### Common Hub Configuration Tasks

#### Changing the Data Collection Interval

How often the hub collects data from agents can be adjusted in the web interface:
- More frequent collection = more detailed data but more resource usage
- Less frequent collection = less detail but lighter resource usage

#### Setting Up Alerts

Configure notifications for:
- High CPU usage
- Low disk space
- Server going offline
- Container failures

You can set alert thresholds and notification methods in the web interface.

#### Managing Users

If you have multiple people who need access:
- Add user accounts in the web interface
- Set appropriate permissions for each user
- Users can be restricted to view only specific servers or metrics

## Configuring Agents

### Adding a New Agent to the Hub

1. Log in to the hub web interface
2. Go to the Agents section
3. Click "Add New Agent"
4. The hub will generate a KEY and TOKEN
5. Copy these values to use on the agent server

### Setting Up an Agent Server

On the server where you want to run the agent:

1. Install Beszel following the [Installation Guide](03-installation.md)
2. Copy `agent/.env.example` to `agent/.env` and edit it
3. Save the KEY and TOKEN from the hub as `BESZEL_AGENT_KEY` and `BESZEL_AGENT_TOKEN` in Infisical, and create `agent/.env.agent` ([how](07-using-the-agent.md#connecting-the-agent-to-infisical))
4. Set `BESZEL_AGENT_HUB_URL` to point to your hub
5. Run `sudo ./create_volumes.sh agent`, then start the agent: `cd agent && docker compose up -d`

### Monitoring Additional Disks

If you want to monitor additional disks or partitions on an agent server:

1. Edit `agent/docker-compose.yml`
2. Find the volumes section under the beszel-agent service
3. Uncomment and modify the extra-filesystems line:
   ```
   - /mnt/disk/.beszel:/extra-filesystems/sda1:ro
   ```
4. Replace `/mnt/disk/.beszel` with the path to your disk
5. Replace `sda1` with a name for your disk
6. Restart the agent:
   ```bash
   docker compose restart beszel-agent
   ```

The `:ro` at the end means "read-only" - the agent can read from the disk but cannot write to it, which is safer.

## Network Configuration

### Firewall Settings

Make sure your firewall allows the necessary connections:

**For the Hub:**
```bash
sudo ufw allow 8090/tcp
```

**For Agent Communication:**
The agent uses the hub's port (8090 by default) to communicate. If the hub and agent are on different servers, ensure:
- The hub server allows incoming connections on port 8090
- The agent server can reach the hub server's IP address

### Using a Reverse Proxy

If you want to access Beszel through a domain name instead of an IP address, you can set up a reverse proxy (like Nginx or Apache).

**Example Nginx Configuration:**

```nginx
server {
    listen 80;
    server_name beszel.yourdomain.com;

    location / {
        proxy_pass http://localhost:8090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

After setting up the reverse proxy, you can access Beszel at `http://beszel.yourdomain.com`.

### SSL/HTTPS Configuration

For secure access, you should enable HTTPS. This requires:
- A reverse proxy (like Nginx)
- An SSL certificate (from Let's Encrypt or another provider)

**Example with Let's Encrypt (using Certbot):**

```bash
sudo certbot --nginx -d beszel.yourdomain.com
```

This will automatically configure SSL for your Beszel installation.

## Performance Tuning

### Reducing Resource Usage

If Beszel is using too many resources:

1. **Increase data collection intervals** in the hub settings
2. **Reduce the number of metrics collected** if you don't need all of them
3. **Limit historical data retention** in the hub settings
4. **Use the agent-only compose file** on servers that don't need the hub

### Increasing Data Retention

If you want to keep more historical data:

1. Check available disk space
2. Adjust data retention settings in the hub web interface
3. Monitor disk usage to ensure you don't run out of space

### Optimizing for High-Volume Monitoring

If you're monitoring many servers with high-frequency data collection:

1. Use a server with more RAM and CPU
2. Consider using faster storage (SSD instead of HDD)
3. Adjust the Docker container resource limits in `docker-compose.yml`

## Applying Configuration Changes

After changing a `.env` file, recreate the containers from that folder (`hub/` or `agent/`):

```bash
docker compose down
docker compose up -d
```

If you only changed agent settings, you can restart just the agent:

```bash
cd agent
docker compose restart beszel-agent
```

The same restart applies after you change `BESZEL_AGENT_KEY` or `BESZEL_AGENT_TOKEN` in Infisical. The agent reads them only when it starts.

## Backup Your Configuration

It's a good idea to keep a backup of your `.env` files:

```bash
cp hub/.env hub/.env.backup
cp agent/.env agent/.env.backup
cp agent/.env.agent agent/.env.agent.backup
```

You can also version control it with Git (but be careful not to commit sensitive values like keys and tokens). `agent/.env.agent` (your Infisical credentials, address, project ID and environment) is already in `.gitignore`. Only `agent/.env.agent.example` is committed. The Infisical config and template contain placeholders only.

## Common Configuration Scenarios

### Scenario 1: Hub and Agent on the Same Server

This is the simplest setup. Use the default settings:
- `BESZEL_AGENT_HUB_URL=http://localhost:8090`
- Both hub and agent run on the same machine
- No special network configuration needed

### Scenario 2: Hub on One Server, Agent on Another

- On the hub server: Keep default settings, ensure firewall allows port 8090
- On the agent server: Set `BESZEL_AGENT_HUB_URL=http://hub-server-ip:8090`
- Ensure the agent server can reach the hub server's IP address
- Save the KEY and TOKEN from the hub in Infisical (see [Connecting the Agent to Infisical](07-using-the-agent.md#connecting-the-agent-to-infisical))

### Scenario 3: Multiple Agents, One Hub

- Set up the hub once on your central server
- For each agent server:
  - Install the agent
  - Get a unique KEY and TOKEN from the hub for that agent and save them in that server's Infisical project or environment
  - Configure the agent to point to the hub
  - Start the agent
- All agents will report to the same hub

### Scenario 4: Agent-Only Servers

For servers that only run agents (not the hub):
- Use the files in the `agent/` folder instead of `hub/`
- This reduces resource usage by not running the hub
- Configure the agent to point to your hub server

## Next Steps

Now that you've configured Beszel, it's time to start using it!

Continue to the [Getting Started Guide](05-getting-started.md) to learn your first steps with Beszel.

For more specific information about using the hub or agents, see:
- [Using the Hub](06-using-the-hub.md)
- [Using the Agent](07-using-the-agent.md)
