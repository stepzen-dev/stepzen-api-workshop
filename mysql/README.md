# Setting up MySQL

## Creating a local database

The best way to run this MySQL Database is by using our Docker. This requires you to have Docker installed (no prior knowledge needed) and using ngrok to create a TCP tunnel so you can link it to StepZen.

### Prerequisites

- [Docker (Mac/Windows)](https://www.docker.com/products/docker-desktop)
- [ngrok account](https://ngrok.com/)
- [ngrok installed (Mac/Window)](https://ngrok.com/download)

### Getting Started:

Make sure you have an account for [ngrok](<(https://ngrok.com/)>) and have linked your authtoken by running:

```bash
ngrok authtoken [YOUR_AUTH_TOKEN]
```

After doing so start the Docker container with the MySQL database from this directory:

```bash
cd mysql
docker-compose up -d
```

This will start the container with the MySQL server, makes it available on port `3306` and prepopulates it with the data from `./mysql/init.sql`.

To make this database available to other services outside your private network, you need to create a TCP tunnel. For this ngrok will be used:

```bash
ngrok tcp 3306
```

Ngrok will return the forwarding address for the local MySQL database, which will looks something like this: `tcp://0.tcp.ngrok.io:15650`.

You need to add this to the file `./config.yaml` where you need to replace `NGROK_TUNNEL` with (in example) `0.tcp.ngrok.io:15650`:

```yaml
configurationset:
  - configuration:
      name: mysql_config
      dsn: stepzen:stepzenpasswd@tcp(0.tcp.ngrok.io:15650)/stepzen_demo
```

## Create a database in the cloud

Alternatively you can create a MySQL database in the cloud, for this you can choose from a whole range of cloud providers
