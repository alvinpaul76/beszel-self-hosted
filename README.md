# Beszel Self-Hosted

Beszel Self-Hosted is a self-hosted implementation for secure, private data storage and management. This repository provides the necessary scripts and configuration to run Beszel using Docker Compose.

## Features
- Secure data storage
- Easy backup and restore
- Docker-based deployment
- Auxiliary database support

## Getting Started

### Prerequisites
- Docker
- Docker Compose


### Installation
1. Clone this repository:
  ```bash
  git clone https://github.com/alvinpaul76/beszel-self-hosted.git
  cd beszel-self-hosted
  ```
2. Create required Docker volumes:
  ```bash
  ./create_volumes.sh
  ```
3. Start the main services:
  ```bash
  docker-compose up -d
  ```

### Agent-Specific Deployment
For agent deployments, use the `docker-compose-agent.yml` file. This configuration is designed for running Beszel agents, which connect to a central hub and monitor specific filesystems or disks.

#### Usage
1. Ensure the required environment variables are set (see comments in `docker-compose-agent.yml`).
2. Start the agent service:
  ```bash
  docker-compose -f docker-compose-agent.yml up -d
  ```
3. The agent will use the `beszel_agent_data` volume and can monitor additional disks by mounting them as described in the compose file.

**Note:** The agent configuration uses `network_mode: host` and requires access to the Docker socket for monitoring containers.

### Data Directory Structure
- `beszel_data/`
  - `auxiliary.db` - Auxiliary database file
  - `data.db`, `data.db-shm`, `data.db-wal` - Main database files
  - `id_ed25519` - Private key for encryption
  - `backups/` - Directory for database backups

## Usage
- To view running containers:
  ```bash
  docker ps -a
  ```
- To stop the services:
  ```bash
  docker-compose down
  ```
- To backup data, copy files from `beszel_data/backups/`.

## License
This project is licensed under the terms of the LICENSE file in this repository.

## Support
For issues or feature requests, please open an issue in this repository.
