# Project Structure

## Prerequisites

- Hasura GraphQL Engine 2.0
- Golang 1.15+
- Docker + docker-compose

## Database design and migration

Use Hasura 2.0 CLI: https://docs.hasura.io/1.0/graphql/manual/hasura-cli/install-hasura-cli.html#install

```sh
# rename the CLI to hasura2 to avoid conflict if using Hasura v1 in parallel
sudo wget https://github.com/hasura/graphql-engine/releases/download/v2.0.9/cli-hasura-linux-amd64 -O /usr/local/bin/hasura
sudo chmod +x /usr/local/bin/hasura
```

- Design

```
hasura console
```

- Migrate:

```
hasura migrate apply
hasura metadata apply
hasura seed apply
```
