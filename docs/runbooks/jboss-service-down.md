# Runbook: JBoss/WildFly Not Responding

## Symptoms
- Application returns 503 or times out
- Health check fails: `scripts/check_http.sh` returns CRITICAL

## Quick checks
1. Check the application port (8080 is the default HTTP port):
   ```bash
   ./scripts/check_port.sh <host> 8080
   ```
2. Check the JBoss process:
   ```bash
   ps -ef | grep -i jboss
   ```
3. Check the service status (service name varies by install):
   ```bash
   systemctl status jboss
   ```

## Investigation
1. Read the server log (path varies, commonly under `standalone/log/server.log`):
   ```bash
   tail -200 <JBOSS_HOME>/standalone/log/server.log
   ```
2. Look for these common causes:
   - `OutOfMemoryError`: heap or metaspace exhausted
   - Deployment failures after a release
   - Datasource connection errors
   - Port conflicts at startup
3. Check disk space and memory:
   ```bash
   df -h
   free -m
   ```

## Resolution
1. Restart the service:
   ```bash
   systemctl restart jboss
   ```
2. Watch the log until startup completes, then re-run the health check:
   ```bash
   ./scripts/check_http.sh http://<host>:8080/ 200 5
   ```

## Escalate if
- JBoss fails to start after a restart
- OutOfMemoryError repeats (needs heap tuning or a leak analysis)
- A recent deployment caused the failure (consider rollback)

## After the incident
- Record the root cause and the fix in the ticket
