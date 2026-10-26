# Troubleshooting Guide

This guide helps you solve common problems you might encounter with Beszel. If you're having issues, start here.

## General Troubleshooting Steps

Before diving into specific issues, try these general steps:

### 1. Check if Containers Are Running

```bash
docker ps
```

You should see `beszel` and `beszel-agent` containers listed with "Up" status.

### 2. Check the Logs

Logs often tell you exactly what's wrong:

```bash
# Hub logs
docker-compose logs beszel

# Agent logs
docker-compose logs beszel-agent

# Both at once
docker-compose logs
```

### 3. Restart the Services

Sometimes a simple restart fixes the issue:

```bash
docker-compose restart
```

### 4. Verify Configuration

Check your `.env` file for errors:

```bash
cat .env
```

Make sure there are no typos and all values are set correctly.

## Installation Issues

### Docker Not Found

**Problem:** You get "docker: command not found" error.

**Solution:**
- Docker isn't installed. Follow the [Prerequisites Guide](02-prerequisites.md) to install Docker.

### Docker Compose Not Found

**Problem:** You get "docker-compose: command not found" error.

**Solution:**
- Docker Compose isn't installed. Follow the [Prerequisites Guide](02-prerequisites.md) to install it.

### Permission Denied

**Problem:** You get "permission denied" when running Docker commands.

**Solution:**
- Add your user to the docker group:
  ```bash
  sudo usermod -aG docker $USER
  ```
- Log out and log back in for changes to take effect
- Or use sudo with your commands

### create_volumes.sh Script Fails

**Problem:** The volume creation script fails with errors.

**Possible causes and solutions:**

**Not running as root:**
- Run with sudo: `sudo ./create_volumes.sh`

**.env file not found:**
- Make sure you're in the correct directory
- Check that `.env` exists: `ls -la .env`

**Directory permissions:**
- Check you have permission to create directories
- Verify the `DEFAULT_STORAGE_FOLDER` path is valid

**Variable not defined:**
- Check that all required variables are in `.env`
- Compare with `.env.example` to see what's missing

## Hub Issues

### Can't Access Web Interface

**Problem:** You can't open `http://localhost:8090` or your server's IP.

**Solutions:**

**Check if hub is running:**
```bash
docker ps | grep beszel
```

If not running, start it:
```bash
docker-compose up -d
```

**Check the port:**
- Verify `BESZEL_PORT` in `.env` is set to 8090 (or your chosen port)
- Try the correct port in your browser

**Check firewall:**
```bash
sudo ufw status
```

If port is blocked, allow it:
```bash
sudo ufw allow 8090/tcp
```

**Check hub logs:**
```bash
docker-compose logs beszel
```
Look for errors in the output.

### Web Interface Shows Error

**Problem:** The web interface loads but shows an error message.

**Solutions:**

**Check hub logs:**
```bash
docker-compose logs beszel
```
Look for specific error messages.

**Restart the hub:**
```bash
docker-compose restart beszel
```

**Check disk space:**
```bash
df -h
```
Make sure you have enough free space.

**Recreate the container:**
```bash
docker-compose down
docker-compose up -d
```

### Data Not Updating

**Problem:** The dashboard shows old data or metrics aren't updating.

**Solutions:**

**Check if agents are connected:**
- Go to the Agents section in the web interface
- Verify agents show as "Connected"

**Check agent status:**
```bash
docker ps | grep beszel-agent
```

**Check hub logs for connection errors:**
```bash
docker-compose logs beszel
```

**Restart both hub and agent:**
```bash
docker-compose restart
```

### Hub Using Too Much Memory

**Problem:** The hub container is consuming excessive RAM.

**Solutions:**

**Check data retention settings:**
- Reduce how long historical data is kept
- Archive old data

**Reduce collection frequency:**
- Increase the interval between data collections
- This reduces the amount of data being processed

**Check for database issues:**
- Large databases can cause high memory usage
- Consider backing up and starting fresh if database is corrupted

**Restart the hub:**
```bash
docker-compose restart beszel
```

## Agent Issues

### Agent Won't Connect to Hub

**Problem:** Agent shows as "Offline" in the hub interface.

**Solutions:**

**Check HUB_URL in agent's .env:**
- Verify the IP address or domain name is correct
- Make sure the hub is accessible from the agent server
- Try: `curl http://hub-ip:8090` from the agent server

**Check KEY and TOKEN:**
- Verify they match what's shown in the hub
- Regenerate credentials from the hub if needed
- Ensure no extra spaces or characters

**Check if agent is running:**
```bash
docker ps | grep beszel-agent
```

If not running:
```bash
docker-compose up -d beszel-agent
```

**Check agent logs:**
```bash
docker-compose logs beszel-agent
```

**Check network connectivity:**
- Can the agent server reach the hub server?
- Are there firewall rules blocking the connection?

### Agent Shows as Offline After Update

**Problem:** Agent was working but shows offline after updating.

**Solutions:**

**Restart the agent:**
```bash
docker-compose restart beszel-agent
```

**Check if credentials changed:**
- Some updates might require regenerating credentials
- Get new KEY and TOKEN from the hub
- Update the agent's `.env` file
- Restart the agent

**Reconnect the agent:**
- Remove the agent from the hub
- Add it again with new credentials
- Update the agent configuration
- Restart the agent

### Agent Using High CPU

**Problem:** The agent is using more CPU than expected.

**Solutions:**

**Check what's being monitored:**
- Are you monitoring many disks?
- Are there many Docker containers?
- Is data collection frequency too high?

**Reduce collection frequency:**
- Adjust settings in the hub to collect data less often

**Check for errors:**
```bash
docker-compose logs beszel-agent
```
Errors can sometimes cause high CPU usage.

**Restart the agent:**
```bash
docker-compose restart beszel-agent
```

### Docker Socket Permission Errors

**Problem:** Agent can't monitor Docker containers due to permission errors.

**Solutions:**

**Check the socket mount:**
In `docker-compose.yml`, verify this line exists:
```yaml
- /var/run/docker.sock:/var/run/docker.sock:ro
```

**Check Docker socket permissions:**
```bash
ls -la /var/run/docker.sock
```

The socket should be accessible. If not, you may need to adjust permissions or add the container to the docker group.

**Restart the agent:**
```bash
docker-compose restart beszel-agent
```

## Network Issues

### Can't Reach Hub from Agent

**Problem:** Agent server cannot connect to hub server.

**Solutions:**

**Test connectivity from agent:**
```bash
ping hub-server-ip
curl http://hub-server-ip:8090
```

**Check firewall on hub:**
```bash
sudo ufw status
```

Allow the port if needed:
```bash
sudo ufw allow 8090/tcp
```

**Check firewall on agent:**
- Some firewalls block outgoing connections
- Temporarily disable firewall for testing
- Configure firewall to allow connections to hub

**Check if servers are on same network:**
- If on different networks, you may need routing or VPN
- Verify network configuration

**Use IP address instead of hostname:**
- Sometimes DNS resolution fails
- Try using the IP address directly in HUB_URL

### Port Already in Use

**Problem:** Beszel won't start because the port is already in use.

**Solutions:**

**Check what's using the port:**
```bash
sudo lsof -i :8090
```

**Change the port:**
- Edit `.env` and change `BESZEL_PORT` to a different port
- Restart Beszel: `docker-compose restart`
- Update firewall rules for the new port

**Stop the conflicting service:**
- Stop whatever is using port 8090
- Then start Beszel

## Database Issues

### Database Locked

**Problem:** Errors about database being locked.

**Solutions:**

**Restart Beszel:**
```bash
docker-compose restart
```

**Check for stuck processes:**
```bash
docker ps
```
Look for multiple Beszel containers running.

**Recreate the container:**
```bash
docker-compose down
docker-compose up -d
```

### Database Corruption

**Problem:** Database errors suggesting corruption.

**Solutions:**

**Restore from backup:**
- Follow the [Backup and Restore Guide](08-backup-and-restore.md)
- Use a backup from before the corruption occurred

**Start fresh:**
- Warning: This loses all historical data
- Stop Beszel: `docker-compose down`
- Remove database files: `rm /storage/beszel/data/beszel_data/*.db`
- Start Beszel: `docker-compose up -d`
- Reconnect agents

## Performance Issues

### Slow Web Interface

**Problem:** The web interface loads slowly.

**Solutions:**

**Check server resources:**
```bash
free -h
df -h
```
Ensure you have enough RAM and disk space.

**Reduce data retention:**
- Less historical data means faster queries
- Adjust in hub settings

**Reduce collection frequency:**
- Less data means better performance
- Adjust in hub settings

**Check browser:**
- Try a different browser
- Clear browser cache
- Disable browser extensions

### High Disk Usage

**Problem:** Beszel is using too much disk space.

**Solutions:**

**Check what's taking space:**
```bash
du -sh /storage/beszel/*
```

**Reduce data retention:**
- Keep less historical data
- Adjust in hub settings

**Clean old backups:**
- Remove old backup files
- Keep only recent backups

**Archive old data:**
- Export important data
- Delete old data from the database

**Monitor growth:**
- Set up alerts for disk usage
- Regularly review disk space

## Configuration Issues

### Changes Not Taking Effect

**Problem:** You changed settings but nothing changed.

**Solutions:**

**Restart Beszel:**
```bash
docker-compose restart
```

**Check the .env file:**
- Verify your changes were saved
- No typos or syntax errors

**Recreate containers:**
```bash
docker-compose down
docker-compose up -d
```

### Wrong Timezone

**Problem:** Timestamps are in the wrong timezone.

**Solutions:**

**Set timezone in hub settings:**
- Go to Settings in the web interface
- Set the correct timezone
- Save the changes

**Set system timezone:**
```bash
sudo timedatectl set-timezone Your/Timezone
```

**Restart Beszel:**
```bash
docker-compose restart
```

## Getting Help

If you can't solve the problem:

### 1. Check the FAQ

Look at our [FAQ](10-faq.md) for common questions and solutions.

### 2. Collect Information

Before asking for help, gather this information:

- What you were trying to do
- What happened (error messages, unexpected behavior)
- What you've already tried
- Relevant log output:
  ```bash
  docker-compose logs > beszel-logs.txt
  ```
- Your system information:
  ```bash
  uname -a
  docker --version
  docker-compose --version
  ```

### 3. Search Existing Issues

Check if someone else has had the same problem:
- Search the GitHub issues
- Look for similar error messages

### 4. Open an Issue

If you can't find a solution:
- Open an issue in the repository
- Include all the information you collected
- Be specific about what you need help with

## Preventing Issues

### Regular Maintenance

- Keep Beszel updated
- Monitor disk space
- Review logs periodically
- Test backups regularly

### Best Practices

- Don't modify database files directly
- Always backup before making changes
- Use descriptive names for servers
- Document your configuration
- Set up alerts for critical issues

### Monitor System Health

- Check the dashboard regularly
- Watch for unusual resource usage
- Review alerts promptly
- Keep an eye on agent connections

## When All Else Fails

If nothing works:

1. **Backup your data** - Follow the [Backup Guide](08-backup-and-restore.md)
2. **Reinstall Beszel** - Follow the [Installation Guide](03-installation.md)
3. **Restore your data** - Follow the [Restore Guide](08-backup-and-restore.md)
4. **Reconfigure** - Set up your agents again

This gives you a fresh start while preserving your data.
