# Docker Project - Flask and MySQL

I ran a Flask app and a MySQL database in separate Docker containers and connected them over a shared bridge network.

I built the Flask image using the Dockerfile in this folder. I used `python:3.8-slim` as the base image and installed Flask, `mysqlclient`, and the system packages needed to build the MySQL client.

I created a Docker network called `my-network`, started a MySQL container named `mydb1`, and ran the Flask container on the same network. In `app.py`, I used `mydb1` as the database hostname so Flask could find the database through Docker's internal DNS. I set up the network and started both containers using Docker commands.

I mapped port `5001` on my machine to port `5001` in the Flask container and opened `http://localhost:5001` in the browser. The app connected to MySQL, ran `SELECT VERSION()`, and displayed the database version alongside “Hello, World!”. This confirmed that the two containers could communicate over the network.
