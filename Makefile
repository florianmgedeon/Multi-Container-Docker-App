COMPOSE_FILE := ./srcs/docker-compose.yml

all: build up

up:
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

clean:
	docker compose -f $(COMPOSE_FILE) down

fclean:
	docker compose -f $(COMPOSE_FILE) down --volumes --remove-orphans --rmi all
	docker system prune -af --volumes
	sudo find /home/fgedeon/data/mariadb -mindepth 1 -exec rm -rf {} + 2>/dev/null || true
	sudo find /home/fgedeon/data/wordpress -mindepth 1 -exec rm -rf {} + 2>/dev/null || true

re: fclean all

build:
	docker compose -f $(COMPOSE_FILE) build

start:
	docker compose -f $(COMPOSE_FILE) start

stop:
	docker compose -f $(COMPOSE_FILE) stop

status:
	docker compose -f $(COMPOSE_FILE) ps

.PHONY: all up down start stop status build clean fclean re
