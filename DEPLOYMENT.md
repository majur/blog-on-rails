# Deployment Guide

This application is configured to be deployed using [Kamal](https://kamal-deploy.org/) with SQLite as the database.

## Prerequisites

1. Docker installed on your local machine
2. Docker registry account (e.g., Docker Hub)
3. Server with Docker installed
4. SSH access to the server

## Configuration

Before deployment, make sure to update the `config/deploy.yml` file with your server information:

```yaml
servers:
  - YOUR_SERVER_IP_OR_HOSTNAME  # Replace with your actual server IP or hostname
```

Also, set up your Docker registry credentials in the same file or via environment variables.

## Environment Variables

Create a `.env` file in the project root with the following variables:

```
RAILS_MASTER_KEY=your_rails_master_key
KAMAL_REGISTRY_PASSWORD=your_docker_registry_password
```

## Deployment Steps

1. Make sure you have Kamal installed:
   ```
   gem install kamal
   ```

2. Initialize Kamal environment variables:
   ```
   kamal env push
   ```

3. Deploy the application:
   ```
   bin/deploy
   ```

   OR run each step manually:
   ```
   kamal build
   kamal push
   kamal deploy
   ```

## Data Persistence

The SQLite database is stored in the `/rails/storage` directory inside the container, which is configured as a persistent volume. This ensures your data will persist across deployments.

## Troubleshooting

- If you encounter permission issues with the SQLite database, the pre-deploy hook should handle this, but you can also run:
  ```
  kamal exec "chmod -R 777 /rails/storage"
  ```

- To view logs:
  ```
  kamal logs
  ```

- To ssh into the server:
  ```
  kamal app exec bash
  ``` 