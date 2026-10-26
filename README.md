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

The repo has two independent deployments, each in its own folder with its own `docker-compose.yml` and `.env`:

- `hub/` – the Beszel hub (web UI and database)
- `agent/` – the Beszel agent, run on every host you want to monitor

### Environment files
Each folder reads the `.env` in the directory you run `docker compose` from, so the hub and agent are configured separately:

- `hub/.env` is only needed on the machine running the hub.
- `agent/.env` is only needed on each machine you want to monitor.
- `.env` files are gitignored because they hold the agent `KEY` and `TOKEN`. Only `.env.example` is committed.
- On a fresh clone, create each one with `cp .env.example .env` and fill in the values.
- `DEFAULT_STORAGE_FOLDER` sets where the volumes are stored (default `/storage/beszel`). `create_volumes.sh` reads it from `<hub|agent>/.env`, so create the `.env` before running the script.

### Hub
1. Create the volume directories and the env file:
  ```bash
  cp hub/.env.example hub/.env
  sudo ./create_volumes.sh hub
  cd hub
  ```
2. Start the hub:
  ```bash
  docker compose up -d
  ```
3. Open the hub UI, add a system, and copy the agent `KEY` and `TOKEN`.

### Agent
Run this on every host you want to monitor.

1. Create the volume directories and the env file:
  ```bash
  cp agent/.env.example agent/.env
  sudo ./create_volumes.sh agent
  cd agent
  ```
2. Set `BESZEL_AGENT_KEY`, `BESZEL_AGENT_TOKEN` and `BESZEL_AGENT_HUB_URL` in `agent/.env`.
3. Start the agent:
  ```bash
  docker compose up -d
  ```

Additional disks can be monitored by mounting them under `/extra-filesystems` (see comments in `agent/docker-compose.yml`).

**Note:** The agent uses `network_mode: host` and needs read access to the Docker socket for monitoring containers.

### Monitoring the hub's own host
The hub does not monitor the machine it runs on. To do that, run the agent there too:

1. Start the hub (`cd hub && docker compose up -d`).
2. Add a system in the hub UI to get the `KEY` and `TOKEN`.
3. Put them in `agent/.env` and keep `BESZEL_AGENT_HUB_URL=http://localhost:8090`.
4. Start the agent (`cd agent && docker compose up -d`).

The two stacks are independent, so either can be restarted or stopped without affecting the other.

### Monitoring other hosts
Run only the agent on those machines. Set `BESZEL_AGENT_HUB_URL` to an address that reaches your hub, such as `https://beszel.example.com` or `http://<hub-ip>:8090`, not `localhost`.

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
  docker compose down   # run inside hub/ or agent/
  ```
- To backup data, copy files from `beszel_data/backups/`.

## License
This project is licensed under the terms of the LICENSE file in this repository.

## Support
For issues or feature requests, please open an issue in this repository.
