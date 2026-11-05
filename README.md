# Middleware Health Checks

Simple shell scripts to check the health of common enterprise middleware: Apache HTTP Server, JBoss/WildFly, IBM WebSphere (WAS) and IBM MQ.

Built from 12+ years of middleware platform operations experience.

## Status

Early stage. Scripts are added one at a time as they are written and tested.

| Component | Script | Status |
|---|---|---|
| Apache / JBoss / WAS (HTTP) | `scripts/check_http.sh` | Available |
| IBM MQ queue manager | `scripts/check_mq.sh` | Planned |
| Port check | `scripts/check_port.sh` | Planned |

## Usage

```bash
chmod +x scripts/check_http.sh
./scripts/check_http.sh http://localhost:8080/ 200 5
```

Arguments: URL, expected HTTP status (default 200), timeout in seconds (default 5).

Exit codes: `0` = OK, `2` = CRITICAL. This follows the Nagios convention, so it can plug into monitoring tools.

## Contributing

Issues and pull requests are welcome.

## License

MIT
