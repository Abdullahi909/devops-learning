# Docker Projects

## [Flask and MySQL](hello_flask/README.md)

I ran a Flask app and a MySQL database in separate containers and connected them over a Docker bridge network. The app queries the MySQL version and displays it in the browser.

## [Flask, PostgreSQL and Nginx](docker%20project%3Aassignment/README.md)

I put together a Docker project for a Flask app that stores messages in PostgreSQL, with Nginx as a reverse proxy. I wrote a two-stage Dockerfile and used environment variables for the database connection details, with a named volume for the database files.
