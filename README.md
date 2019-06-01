# Crylog
[![Build Status](https://travis-ci.org/Blacksmoke16/crylog.svg?branch=master)](https://travis-ci.org/Blacksmoke16/crylog)
[![Latest release](https://img.shields.io/github/release/Blacksmoke16/crylog.svg?style=flat-square)](https://github.com/Blacksmoke16/crylog/releases)

Flexible logging framework based on [Monolog](https://github.com/Seldaek/monolog).


## Roadmap
Currently, the base functionality is complete.  

If someones wishes to make a PR and "own" a specific handler (or formatter/processor), I would welcome the PR.  Maintainers, with their handlers, will be listed at the bottom.  Otherwise, feel free to create an issue.

## Core Concepts

- Logger - An instance of `Crylog::Logger` that logs messages, optionally with context. 
- Handler - Writes the log message to somewhere/something.
- Processor - Adds metadata to each logged message.
- Formatter - Determines how a logged message appears.

### Severity

`Crylog` uses the log levels as described in [RFC 5424](https://tools.ietf.org/html/rfc5424#section-6.2.1):

- Emergency: system is unusable
- Alert: action must be taken immediately
- Critical: critical conditions
- Error: error conditions
- Warning: warning conditions
- Notice: normal but significant condition
- Informational: informational messages
- Debug: debug-level messages

Convenience methods are defined for each i.e. `logger.info`, `logger.alert`, etc.

### Additional Documentation

[Documentation](./docs)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  crylog:
    github: Blacksmoke16/crylog
```

## Contributing

1. Fork it (<https://github.com/Blacksmoke16/crylog/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Blacksmoke16](https://github.com/Blacksmoke16) Blacksmoke16 - creator, maintainer

### Handlers

Those that created/maintain handlers for a specific service/system will be listed here.
