# Docker Project - Flask, PostgreSQL and Nginx

I put together a Docker project for a Flask app that stores messages in PostgreSQL, with Nginx as a reverse proxy in front of the app.

I wrote a two-stage Dockerfile for Flask, using a Python slim image for the build stage and a Python Alpine image for the runtime stage. I set the app to listen on port `5005` and configured Nginx to accept requests on port `80` and forward them to `web:5005`.

I used `dockercompose.yml` to define the container setup and pass the database connection details through environment variables. Flask uses `postgres` as the database hostname. I added a named volume called `postgres_data` for the PostgreSQL data directory so the database files could be kept when the container was replaced.

The Flask app creates a `messages` table with an ID, message content and a timestamp. The home page explains the two message routes: `POST /add` accepts a JSON message and saves it to PostgreSQL, and `GET /list` returns the stored messages with the newest first.
