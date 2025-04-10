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

This Docker-based system was successfully deployed and tested on a virtual machine running **Debian Bookworm** (Debian 12). All services ran as expected using Docker and Docker Compose.

## Prerequisites

Before starting ensure to fill out the .env file in the srcs folder and all the other files in the secrets folder with your chosen credentials.
