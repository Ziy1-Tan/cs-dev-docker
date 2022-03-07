![logo](https://raw.githubusercontent.com/mariadb-corporation/mariadb-community-columnstore-docker/master/MDB-HLogo_RGB.jpg)

# MariaDB 10.6 Community Server
## (with ColumnStore 6.x)

### Introduction

MariaDB Server is one of the most popular database servers in the world. It’s made by the original developers of MySQL and guaranteed to stay open source. Notable users include Wikipedia, WordPress.com and Google.

MariaDB turns data into structured information in a wide array of applications, ranging from banking to websites. Originally designed as enhanced, drop-in replacement for MySQL, MariaDB is used because it is fast, scalable and robust, with a rich ecosystem of storage engines, plugins and many other tools make it very versatile for a wide variety of use cases.

MariaDB is developed as open source software and as a relational database it provides an SQL interface for accessing data. The latest versions of MariaDB also include GIS and JSON features.

ColumnStore 6.x brings a high-performance, open source, distributed, SQL-compatible analytics solution to the market. Included as a pluggable storage engine with MariaDB Community Server 10.6, ColumnStore 6.x is a columnar storage engine that enables customers to easily perform fast and scalable analytics.

Earlier versions of ColumnStore have been available to the open source community as a separate fork of MariaDB, but with the 6.x release, ColumnStore is now fully integrated into the MariaDB stack and has been significantly upgraded from previous versions. It is easier to install and manage, data loading is among the fastest in the industry, and it works with cost-effective cloud-native object storage.

This docker image will startup a single server instance of MariaDB 10.6 (with ColumnStore) running on Rocky Linux 8.

### Run Single Instance Container

**Example 1**: To run with all engines and local storage:
```
docker run -d -p 3306:3306 --name mcs_container mariadb/columnstore
```
**Example 1a**: To run with all engines and local storage on ARM hardware:
```
docker run -d -p 3306:3306 --name mcs_container mariadb/columnstore:arm64
```

**Example 2**: To run with ColumnStore engine only and S3 object storage (storagemanager):
```
docker run -d -p 3306:3306 \
-e ANALYTICS_ONLY=1 \
-e USE_S3_STORAGE=1 \
-e S3_BUCKET=<bucket_name> \
-e S3_ENDPOINT=<endpoint_url> \
-e S3_ACCESS_KEY_ID=<access_key_id> \
-e S3_SECRET_ACCESS_KEY=<secret_access_key> \
--name mcs_container mariadb/columnstore
```

### To Use MariaDB Inside The Container

Launch bash in the container:

```
docker exec -it mcs_container bash
```

Launch the MariaDB client in the container:

```
docker exec -it mcs_container mariadb
```

### To Access DB From Host or Other Containers

First, create a container. Add -d if you don't want to observe its output.

```
docker run -p 3306:3306 --name mcs_container mariadb/columnstore
```

Create a user for example like so:

```
docker exec mcs_container mariadb -e "GRANT ALL PRIVILEGES ON *.* TO '<username>'@'%' IDENTIFIED BY '<password>';"
```

Now you can connect from outside the container - for instance with the MariaDB client from the host:

```
mariadb --protocol tcp --host localhost -u <username> --password=<password>
```

### Customization
The following environment variables can be utilized to configure behavior:

#### S3 Settings
*   USE_S3_STORAGE: Set to 1 to enable S3 storagemanager. (Default 0)
*   S3_BUCKET: Your S3 bucket name
*   S3_ENDPOINT: Your endpoint url
*   S3_ACCESS_KEY_ID: Your S3 access id
*   S3_SECRET_ACCESS_KEY: Your S3 access key
*   ASYNC_CONN: Set to 1 if using home broadband with storagemanager. (Default 0)

#### Other Settings
*   ANALYTICS_ONLY: Set to 1 to only allow Columnstore tables. (Default 0)

#### Build Examples

AMD64/x86_64 (*Default*):
```
docker build --rm --tag mariadb/columnstore . --build-arg ARCH=amd64
```

AARCH64/ARM64:
```
docker build --rm --tag mariadb/columnstore . --build-arg ARCH=arm64
```
