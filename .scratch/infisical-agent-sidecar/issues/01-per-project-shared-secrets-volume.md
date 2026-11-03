# Per-project shared_secrets volume

Status: resolved

Declared `shared_secrets` in `agent/docker-compose.yml` as a plain Docker-managed volume (`shared_secrets: {}`) instead of a fixed global `name: shared_secrets`. Compose now creates `<project>_shared_secrets`, so secrets and agent tokens no longer collide across compose projects on the same host, and `down -v` no longer reports "Volume belongs to project". Docs note the new volume name.
