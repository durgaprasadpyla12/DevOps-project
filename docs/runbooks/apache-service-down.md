# Runbook: Apache HTTP Server Not Responding

## Symptoms
- Website or application returns a 503 error or times out
- Health check fails: `scripts/check_http.sh` returns CRITICAL

## Quick checks
1. Check whether the web port is reachable:
   ```bash
   ./scripts/check_port.sh <host> 443
   ```
2. Check the Apache process:
   ```bash
   ps -ef | grep -i httpd
   ```
3. Check the service status:
   ```bash
   systemctl status httpd
   ```

## Investigation
1. Read the error log (path varies by install, commonly `/var/log/httpd/error_log`):
   ```bash
   tail -100 /var/log/httpd/error_log
   ```
2. Check disk space, since a full disk can stop Apache:
   ```bash
   df -h
   ```
3. Validate the configuration before restarting:
   ```bash
   apachectl configtest
   ```

## Resolution
1. If the config test passes, restart:
   ```bash
   systemctl restart httpd
   ```
2. Re-run the health check to confirm recovery:
   ```bash
   ./scripts/check_http.sh https://<host>/ 200 5
   ```

## Escalate if
- Apache will not start after a restart
- The same failure repeats within 24 hours
- Backend (JBoss/WAS) is also down

## After the incident
- Record the root cause and the fix in the ticket
