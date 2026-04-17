# Using the Agent

The Beszel agent is the component that runs on each server you want to monitor. It collects data and sends it to the hub. This guide explains how to set up and manage agents.

## What is the Agent?

The agent is a lightweight program that:
- Runs on servers you want to monitor
- Collects system metrics (CPU, memory, disk, network)
- Monitors Docker containers if present
- Sends data to the central hub
- Requires minimal system resources

## Agent Installation

### Installing on a New Server

If you haven't installed the agent yet, follow the [Installation Guide](03-installation.md) for detailed instructions.

**Quick Summary:**

1. Download Beszel files to the server
2. Copy `.env.example` to `.env`
3. Edit `.env` with your hub details
4. Run `sudo ./create_volumes.sh`
5. Start with `docker-compose up -d`

### Agent-Only Installation

For servers that only need the agent (not the hub):

```bash
docker-compose -f docker-compose-agent.yml up -d
```

This uses less resources since it only runs the agent.

## Configuring the Agent

### Setting the Hub Connection

The agent needs to know how to reach your hub. Edit the `.env` file:

```
BESZEL_AGENT_HUB_URL=http://your-hub-ip:8090
```

Replace `your-hub-ip` with your hub server's actual IP address or domain name.

### Setting Agent Credentials

Each agent needs unique credentials from the hub:

1. Log in to your hub web interface
2. Go to the Agents section
3. Click "Add New Agent"
4. The hub will generate a KEY and TOKEN
5. Copy these to your agent's `.env` file:

```
BESZEL_AGENT_KEY=your-unique-key
BESZEL_AGENT_TOKEN=your-unique-token
```

### Port Configuration

The agent listens on a specific port for connections from the hub:

```
BESZEL_AGENT_PORT=45876
```

You generally don't need to change this unless you have specific networking requirements.

## Monitoring Additional Disks

If your server has multiple disks or partitions you want to monitor:

### Edit the Docker Compose File

Open `docker-compose.yml` or `docker-compose-agent.yml`:

```bash
nano docker-compose.yml
```

### Add Volume Mounts

Find the volumes section under `beszel-agent` and add your disks:

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock:ro
  - beszel_agent_data:/var/lib/beszel-agent
  # Monitor additional disks
  - /mnt/data:/extra-filesystems/data:ro
  - /mnt/backup:/extra-filesystems/backup:ro
```

**Explanation:**
- `/mnt/data` - The path to your disk on the server
- `/extra-filesystems/data` - How it appears in Beszel
- `:ro` - Read-only (safer, agent can't write to your disk)

### Restart the Agent

After adding disk mounts:

```bash
docker-compose restart beszel-agent
```

Or if using the agent-only file:

```bash
docker-compose -f docker-compose-agent.yml restart beszel-agent
```

## Managing the Agent

### Checking Agent Status

**Check if the agent is running:**

```bash
docker ps | grep beszel-agent
```

You should see the container listed with a status of "Up".

**Check the agent logs:**

```bash
docker-compose logs beszel-agent
```

This shows what the agent is doing and any errors.

### Restarting the Agent

If you need to restart the agent:

```bash
docker-compose restart beszel-agent
```

Or stop and start:

```bash
docker-compose stop beszel-agent
docker-compose start beszel-agent
```

### Stopping the Agent

To temporarily stop monitoring:

```bash
docker-compose stop beszel-agent
```

The hub will show the server as offline.

### Starting the Agent

To start monitoring again:

```bash
docker-compose start beszel-agent
```

### Removing the Agent

To completely remove the agent from a server:

```bash
docker-compose down
```

This stops and removes the container but keeps the data.

To also remove the data volumes:

```bash
docker-compose down -v
```

**Warning:** This will delete all collected data for this agent.

## Updating the Agent

When a new version of Beszel is available:

### Pull the Latest Image

```bash
docker-compose pull beszel-agent
```

### Restart with the New Image

```bash
docker-compose up -d beszel-agent
```

The agent will restart with the updated version.

## Agent Resource Usage

The agent is designed to be lightweight:

### Typical Resource Usage

- **CPU:** 1-5% when idle, up to 10% during data collection
- **Memory:** 50-100 MB
- **Disk:** Minimal, mostly for temporary cache

### Monitoring Agent Performance

If you're concerned about resource usage:

1. Check the agent's resource usage:
   ```bash
   docker stats beszel-agent
   ```

2. Adjust data collection frequency in the hub settings
3. Reduce the number of metrics collected if needed

## Troubleshooting Agent Issues

### Agent Won't Connect to Hub

**Check the HUB_URL:**
- Verify the IP address or domain name is correct
- Ensure the hub is accessible from the agent server
- Try accessing the hub from the agent: `curl http://hub-ip:8090`

**Check the KEY and TOKEN:**
- Verify they match what's in the hub
- Make sure there are no extra spaces or characters
- Try generating new credentials from the hub

**Check network connectivity:**
- Ensure the agent server can reach the hub server
- Check firewall rules on both servers
- Verify the hub port (8090) is accessible

### Agent Shows as Offline in Hub

**Check if the agent is running:**
```bash
docker ps | grep beszel-agent
```

**Check the agent logs:**
```bash
docker-compose logs beszel-agent
```

**Check the hub logs:**
```bash
docker-compose logs beszel
```

**Verify network connectivity:**
- Can the agent reach the hub?
- Is the hub accepting connections?

### High Agent Resource Usage

If the agent is using more resources than expected:

**Check what's being monitored:**
- Are you monitoring many disks?
- Are there many Docker containers?
- Is data collection frequency too high?

**Adjust settings:**
- Reduce data collection interval in hub settings
- Remove unnecessary disk monitors
- Reduce the number of collected metrics

**Check for errors:**
```bash
docker-compose logs beszel-agent
```

Errors can sometimes cause high resource usage.

### Docker Socket Errors

The agent needs access to the Docker socket to monitor containers. If you see permission errors:

**Check the socket mount:**
In `docker-compose.yml`, ensure this line exists:
```yaml
- /var/run/docker.sock:/var/run/docker.sock:ro
```

**Check permissions:**
The agent container needs read access to the Docker socket. This is usually handled automatically, but check if the socket has unusual permissions.

### Data Not Updating in Hub

If metrics aren't updating:

**Check the agent is running:**
```bash
docker ps
```

**Check agent logs for errors:**
```bash
docker-compose logs beszel-agent
```

**Check hub logs:**
```bash
docker-compose logs beszel
```

**Verify the connection:**
- Is the agent connected to the hub?
- Are the credentials correct?
- Is the network working?

## Best Practices

### Use Agent-Only Configuration on Monitoring Servers

For servers that only need to run the agent (not the hub):

- Use `docker-compose-agent.yml`
- This reduces resource usage
- Simpler configuration
- Easier to manage

### Secure Agent Communication

- Keep agent credentials (KEY and TOKEN) secure
- Don't commit them to version control
- Use HTTPS if accessing hub over public internet
- Consider using VPN for remote agents

### Monitor Agent Health

- Regularly check that agents are connected
- Set up alerts for offline agents
- Review agent logs periodically
- Keep agents updated

### Plan for Network Issues

- Agents buffer data temporarily if hub is unreachable
- Data syncs when connection is restored
- Consider hub redundancy for critical monitoring
- Document recovery procedures

### Regular Maintenance

- Update agents when new versions are available
- Review resource usage periodically
- Clean up old data if storage is limited
- Test agent connectivity after network changes

## Advanced Configuration

### Custom Metrics

You can configure the agent to collect custom metrics specific to your needs. This is done through the hub interface and agent configuration.

### Data Collection Intervals

Adjust how often the agent sends data:

- More frequent = more detailed data, more resource usage
- Less frequent = less detail, lighter resource usage

Configure this in the hub settings, not the agent.

### Filtering Containers

If you have many Docker containers but only want to monitor some:

- Configure container filters in the hub
- Use container naming conventions
- Set up labels to identify important containers

## Multiple Agents on One Server

While not typical, you can run multiple agents on one server if needed:

- Each agent needs a unique container name
- Each agent needs unique credentials from the hub
- Each agent needs a different port
- Use separate compose files or configurations

This is rarely needed and can cause confusion, so avoid unless you have a specific reason.

## Next Steps

Now that you understand how to use the agent:

- Learn about [Backup and Restore](08-backup-and-restore.md) for your data
- Check the [Troubleshooting Guide](09-troubleshooting.md) if you encounter issues
- Review the [FAQ](10-faq.md) for common questions
