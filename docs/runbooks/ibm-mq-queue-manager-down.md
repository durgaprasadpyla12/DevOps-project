# Runbook: IBM MQ Queue Manager Down or Queue Backlog

## Symptoms
- Applications cannot connect to MQ (e.g. MQRC 2059 "queue manager not available")
- Messages are not being processed, or queue depth keeps growing
- Port 1414 (default listener) is not reachable

## Quick checks
1. Check the listener port:
   ```bash
   ./scripts/check_port.sh <host> 1414
   ```
2. Check the queue manager status:
   ```bash
   dspmq
   ```
   Look for `STATUS(Running)`.
3. Check the MQ processes:
   ```bash
   ps -ef | grep -i amqz
   ```

## Investigation
1. Read the error logs (under `/var/mqm/qmgrs/<QMGR_NAME>/errors/`):
   ```bash
   tail -100 AMQERR01.LOG
   ```
2. Check queue depth and channel status inside `runmqsc`:
   ```bash
   runmqsc <QMGR_NAME>
   DISPLAY QLOCAL(<QUEUE_NAME>) CURDEPTH MAXDEPTH
   DISPLAY CHSTATUS(*)
   DISPLAY LSSTATUS(*)
   ```
3. Look for these common causes:
   - File system full (`df -h` on `/var/mqm`)
   - Queue full (CURDEPTH equals MAXDEPTH)
   - Channel stopped or in retry state
   - Listener not running
   - Consumer application is down

## Resolution
1. If the queue manager is stopped, start it:
   ```bash
   strmqm <QMGR_NAME>
   ```
2. If the listener is not running, start it inside `runmqsc`:
   ```bash
   START LISTENER(<LISTENER_NAME>)
   ```
3. If a channel is stopped:
   ```bash
   START CHANNEL(<CHANNEL_NAME>)
   ```
4. For a backlog, find out why consumers stopped before clearing anything. Do not delete messages without business approval.

## Escalate if
- The queue manager will not start
- Log files show corruption or persistent errors
- The backlog involves business-critical messages
- The file system is full and cannot be cleaned safely

## After the incident
- Record the root cause and the fix in the ticket
