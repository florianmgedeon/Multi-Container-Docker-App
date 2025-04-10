# "Inception"

A multi-container system built using Docker and Docker Compose, featuring a secure and modular web service architecture. This project was developed as part of the 42 curriculum.

## Project Overview

The goal of Inception is to build a secure and scalable infrastructure using Docker containers, without relying on pre-built images. Each service is containerized, isolated, and orchestrated using `docker-compose`.

## Services

| Service | Description |
|--------|-------------|
| Nginx | Reverse proxy with SSL |
| WordPress | CMS running with PHP-FPM |
| MariaDB | Relational database for WordPress |

## Tested Environment

This system was successfully deployed and tested on a virtual machine running **Debian Bookworm (Debian 12)**.  
Please note: **root privileges** (or `sudo`) are required to build and run the Docker containers, especially when creating volumes or binding to privileged ports. All services ran as expected using Docker and Docker Compose.

## Prerequisites

Before starting ensure to **fill out** the .env file in the srcs folder and all the other files in the secrets folder with your chosen credentials. Also, make sure to create these two folders for the volumes:

/home/inception/data/mariadb
/home/inception/data/wordpress

## Usage

After cloning the repository and adding the `.env` file and Docker secrets (see [🔧 Prerequisites](#-prerequisites)), simply run: make all
Access the WordPress site at: [https://inception.42.fr](https://inception.42.fr) from your host machine's browser.

