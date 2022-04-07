# Project Structure

## Prerequisites

- Hasura GraphQL Engine 2.0
- Golang 1.15+
- Docker + docker-compose

## Database design and migration

Use Hasura 2.0 CLI: https://docs.hasura.io/1.0/graphql/manual/hasura-cli/install-hasura-cli.html#install

```sh
# rename the CLI to hasura2 to avoid conflict if using Hasura v1 in parallel
sudo wget https://github.com/hasura/graphql-engine/releases/download/v2.0.9/cli-hasura-linux-amd64 -O /usr/local/bin/hasura2
sudo chmod +x /usr/local/bin/hasura2
```

- Design

```
hasura2 console
```

- Migrate:

```
hasura2 migrate apply --all-databases
hasura2 metadata apply
```
