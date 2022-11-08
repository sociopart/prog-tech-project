UNAME := $(shell uname -s)
DOCKER_VERSION := 2.12.2

setup:
ifeq ($(UNAME),Linux)
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
	sudo apt update && sudo apt install docker-ce
	sudo curl -L "https://github.com/docker/compose/releases/download/v$(DOCKER_VERSION)/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
	sudo groupadd docker
	sudo gpasswd -a $USER docker
	newgrp docker
endif

ifeq ($(UNAME),Darwin)
	brew install docker-compose
endif
	sudo chmod +x /usr/local/bin/docker-compose

preinstall:
	docker-compose create 
	docker-compose build 
	docker-compose start
	docker-compose exec web rake db:drop db:create db:migrate
	docker-compose stop

install:
	docker-compose start
	docker-compose exec web rake db:migrate
	docker-compose run web sh

runserver:
	docker-compose up

dockerclean:
# TRUE is needed to bypass every step of deletion 
# (in case something is already clean)
	docker-compose stop || true
	docker-compose down || true
	docker container stop $(docker container list -q) || true
	docker ps -aq | xargs docker stop | xargs docker rm || true
	docker volume rm $(docker volume ls -q) || true
	docker volume prune -f
	docker system prune -a -f

dockerstatus:
	docker system df