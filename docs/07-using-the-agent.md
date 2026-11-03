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
2. Copy `agent/.env.example` to `agent/.env`
3. Edit `agent/.env` with your hub URL and a pinned Infisical image version
4. Create the Infisical config files and fill in your values (see [Connecting the Agent to Infisical](#connecting-the-agent-to-infisical))
5. Run `sudo ./create_volumes.sh agent`
6. Start with `cd agent && docker compose up -d`

### Agent-Only Installation

For servers that only need the agent (not the hub):

```bash
cd agent
docker compose up -d
```

The `agent/` folder only runs the agent, so it uses fewer resources than the hub.

## Configuring the Agent

### Setting the Hub Connection

The agent needs to know how to reach your hub. Edit `agent/.env`:

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
5. Save them as two secrets in your Infisical project, named exactly `BESZEL_AGENT_KEY` and `BESZEL_AGENT_TOKEN`

The agent does not read the key and token from `agent/.env`. The compose file ignores the `BESZEL_AGENT_KEY` and `BESZEL_AGENT_TOKEN` lines in `agent/.env.example`, which are kept only for debugging. A helper container called `infisical-agent` fetches the two secrets from Infisical every time the stack starts.

### Connecting the Agent to Infisical

This section is the one place that explains the Infisical setup. Other pages link here.

**Before you start, you need:**
- An Infisical project that holds `BESZEL_AGENT_KEY` and `BESZEL_AGENT_TOKEN`
- A machine identity in Infisical that uses Universal Auth. Give it read-only access to that one project, environment and path.
- A specific version of the Infisical CLI image, for example `infisical/cli:<version>`. Do not use `latest`, so a reboot or pull cannot change how the helper behaves.

**Steps:**

1. In `agent/.env`, set the image version:
   ```
   INFISICAL_CLI_IMAGE=infisical/cli:<version>
   ```
2. Create your local config files from the examples:
   ```bash
   cd agent
   cp .env.agent.example .env.agent
   chmod 600 .env.agent
   cp infisical/agent-config.example.yaml infisical/agent-config.yaml
   cp infisical/templates/beszel-agent.example.tpl infisical/templates/beszel-agent.tpl
   ```
3. Fill in each file:

   | File | What to set |
   |------|-------------|
   | `agent/.env.agent` | `INFISICAL_UNIVERSAL_AUTH_CLIENT_ID` and `INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET` from your machine identity |
   | `agent/infisical/agent-config.yaml` | `address`: the URL of your Infisical server |
   | `agent/infisical/templates/beszel-agent.tpl` | Your Infisical project ID and environment slug (the short name of the environment, such as `prod`) |

4. Start the agent from `agent/`:
   ```bash
   docker compose up -d
   docker compose logs infisical-agent
   ```
   The logs should show a successful login. `docker compose ps` should show `infisical-agent` as healthy before `beszel-agent` starts.

**Why the real files are not in Git:** the Infisical address, project ID and environment slug are specific to your deployment. The repository only contains the `*.example` files. The real files are listed in `.gitignore`, so your values are never committed. `.env.agent` holds the only secret left on disk, so keep it private.

**Good to know:**
- Changed a secret in Infisical? Run `docker compose restart beszel-agent`. The agent reads its secrets only when it starts.
- If Infisical is down, the agent starts from the last copy that was fetched. That copy is stored in the Docker volume `<project>_shared_secrets` (for example `agent_shared_secrets`). Avoid `docker compose down -v`, which deletes it.
- Other Docker stacks on the same server can run their own `infisical-agent` helper. Each stack keeps its own helper, machine identity and volume, so one stack cannot read another's secrets. The helper has no fixed container name, so the names do not clash (Compose calls this one `agent-infisical-agent-1`). Use the service name in commands, such as `docker compose logs infisical-agent`.
- Running the Infisical CLI at the repo root is optional. If you do, copy `.infisical.example.yaml` to `.infisical.yaml` and set your project ID.

### Port Configuration

The agent listens on a specific port for connections from the hub:

```
BESZEL_AGENT_PORT=45876
```

You generally don't need to change this unless you have specific networking requirements.

## Monitoring Additional Disks

If your server has multiple disks or partitions you want to monitor:

### Edit the Docker Compose File

Open `agent/docker-compose.yml`:

```bash
nano agent/docker-compose.yml
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
cd agent
docker compose restart beszel-agent
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
- Verify the `BESZEL_AGENT_KEY` and `BESZEL_AGENT_TOKEN` secrets in Infisical match what's in the hub
- Make sure there are no extra spaces or characters
- Try generating new credentials from the hub, update them in Infisical, then run `docker compose restart beszel-agent`
- Run `docker compose logs infisical-agent`. The helper must be healthy, or the agent will not start.

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
In `agent/docker-compose.yml`, ensure this line exists:
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

- Use the `agent/` folder
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
