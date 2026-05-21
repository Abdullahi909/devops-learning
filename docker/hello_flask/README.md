# Multi-Container Flask + MySQL Application

A containerised Flask application connected to a MySQL database container over a Docker bridge network. Built as a practical exercise in multi-container networking — two containers talking to each other without Docker Compose.

---

## What It Does

Flask connects to a running MySQL container, queries the database version and returns it in the browser. Simple by design — the point was to get two containers communicating over a shared network.

```
http://localhost:5001 → Hello, World! MySQL version: 8.x.x
```

---

## Project Structure

```
project/
├── app.py
├── Dockerfile
└── README.md
```

---

## How to Run

Make sure Docker is installed and running.

**Step 1 — Create a Docker network**
```bash
docker network create my-network
```

**Step 2 — Start the MySQL container on that network**
```bash
docker run -d \
  --name mydb1 \
  --network my-network \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  mysql:latest
```

**Step 3 — Build the Flask image**
```bash
docker build -t flask-app .
```

**Step 4 — Run the Flask container on the same network**
```bash
docker run -d \
  --name flask-app \
  --network my-network \
  -p 5001:5001 \
  flask-app
```

**Step 5 — Visit the app**
```
http://localhost:5001
```

---

## How the Network Works

Both containers are on the same Docker bridge network. Flask connects to MySQL using the container name `mydb1` as the hostname — Docker handles the DNS resolution internally.

```python
db = MySQLdb.connect(
    host="mydb1",
    user="root",
    passwd="my-secret-pw",
    db="mysql"
)
```

No hardcoded IPs. No localhost. Just the container name.

---

## Dockerfile

```dockerfile
FROM python:3.8-slim
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libmariadb-dev \
    pkg-config
RUN pip install flask mysqlclient
EXPOSE 5001
CMD ["python", "app.py"]
```

---

## What I Learned

- How to create and use a Docker bridge network manually
- How containers resolve each other by name using Docker's internal DNS
- How to install system-level dependencies inside a container during the build
- The difference between container networking and host networking
- Why you never connect to localhost when linking containers

---

## Tech Stack

- Python / Flask
- MySQL
- Docker
- Docker bridge networking
- Linux
