# Runbook: IBM WebSphere Application Server (WAS) Not Responding

## Symptoms
- Application returns 503 or times out
- Health check fails: `scripts/check_http.sh` returns CRITICAL

## Quick checks
1. Check the application port (commonly 9080 HTTP / 9443 HTTPS, varies by profile):
   ```bash
   ./scripts/check_port.sh <host> 9080
   ```
2. Check the server process:
   ```bash
   ps -ef | grep -i websphere
   ```
3. Check the server status:
   ```bash
   <PROFILE_HOME>/bin/serverStatus.sh <server_name> -username <user> -password <password>
   ```

## Investigation
1. Read the logs (under `<PROFILE_HOME>/logs/<server_name>/`):
   ```bash
   tail -200 SystemOut.log
   tail -200 SystemErr.log
   ```
2. Look for these common causes:
   - `OutOfMemoryError`: JVM heap exhausted
   - Hung or stuck threads (look for `WSVR0605W`)
   - Datasource or connection pool errors
   - Failed application deployment or startup
3. Check disk space and memory:
   ```bash
   df -h
   free -m
   ```

## Resolution
1. Restart the server:
   ```bash
   <PROFILE_HOME>/bin/stopServer.sh <server_name>
   <PROFILE_HOME>/bin/startServer.sh <server_name>
   ```
2. Watch `SystemOut.log` until it reports the server is open for e-business, then re-run the health check:
   ```bash
   ./scripts/check_http.sh http://<host>:9080/ 200 5
   ```

## Escalate if
- The server fails to start after a restart
- Hung threads or OutOfMemoryError keep repeating
- A recent deployment caused the failure (consider rollback)

## After the incident
- Record the root cause and the fix in the ticket
