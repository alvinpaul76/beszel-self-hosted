# Drop fixed container_name on infisical-agent

Status: resolved

Removed `container_name: infisical-agent` from `agent/docker-compose.yml`. The fixed name conflicted with an `infisical-agent` container from another compose project on the same host (`docker compose up` failed with "container name already in use"). Compose now generates a per-project name (`agent-infisical-agent-1`). Service name is unchanged, so `depends_on` and `docker compose logs infisical-agent` still work.

Docs: `docs/07-using-the-agent.md` notes that each stack keeps its own helper and that the name is generated; `docs/09-troubleshooting.md` covers the "project not found" (placeholders left in the template) and "container name already in use" errors.
