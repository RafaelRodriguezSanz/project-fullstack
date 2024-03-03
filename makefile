.PHONY: start update commit add push pull checkout build run stop clean 
.SILENT: start update commit add push pull checkout build run stop clean 

start:
	powershell -Command "Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'"

update:
	git submodule update --remote --merge

commit:
ifeq ($(strip $(MESSAGE)$(SUBMODULE)),)
	@echo "ERROR: Uso: make commit MESSAGE='Tu mensaje de commit' SUBMODULE='nombre_del_submodulo'"
	@exit 1
endif
	cd $(SUBMODULE) && git commit -m "$(MESSAGE)"

add:
ifeq ($(strip $(SUBMODULE)),)
	@echo "ERROR: Uso: make add SUBMODULE='nombre_del_submodulo'"
	@exit 1
endif
	cd $(SUBMODULE) && git add .

push:
ifeq ($(strip $(SUBMODULE)),)
	@echo "ERROR: Uso: make push SUBMODULE='nombre_del_submodulo'"
	@exit 1
endif
	cd $(SUBMODULE) && git push --set-upstream origin $(shell cd $(SUBMODULE) && git symbolic-ref --short HEAD) || \
	cd $(SUBMODULE) && git push origin $(shell cd $(SUBMODULE) && git symbolic-ref --short HEAD) 

checkout:
ifeq ($(strip $(SUBMODULE)$(BRANCH)),)
	@echo "ERROR: Uso: make checkout SUBMODULE='nombre_del_submodulo'"
	@exit 1
endif
	cd $(SUBMODULE) && git checkout $(BRANCH)

pull:
ifeq ($(strip $(SUBMODULE)),)
	@echo "ERROR: Uso: make pull SUBMODULE='nombre_del_submodulo'"
	@exit 1
endif
	cd $(SUBMODULE) && git pull

build:
ifeq ($(strip $(SUBMODULE)$(VERSION)),)
	@echo "ERROR: Uso: make build SUBMODULE='nombre_del_submodulo' VERSION='tag_de_la_imagen'"
	@exit 1
endif
	cd $(SUBMODULE) && if exist makefile (make build VERSION=$(VERSION))
	cd $(SUBMODULE) && docker build -t $(SUBMODULE):$(VERSION) .

run:
ifeq ($(strip $(SUBMODULE)$(VERSION)$(PORT)),)
	@echo "ERROR: Uso: make run SUBMODULE='nombre_del_submodulo' VERSION='tag_de_la_imagen' PORT='puerto_del_contenedor'"
	@exit 1
endif
	cd $(SUBMODULE) &&  docker run -p $(PORT):$(PORT) -d $(SUBMODULE):$(VERSION)

stop:
ifeq ($(strip $(SUBMODULE)$(VERSION)),)
	@echo "ERROR: Uso: make stop SUBMODULE='nombre_del_submodulo'"
	@exit 1
endif
	cd $(SUBMODULE) docker stop $(shell docker ps --quiet --filter ancestor=$(SUBMODULE))

clean:
	-@docker system prune -af
	-@cd virtualization\docker\docker-compose && docker-compose down -v --remove-orphans
	-@docker volume rm $(shell docker volume ls -q)

compose:
ifeq ($(strip $(TAG)),)
	@echo "ERROR: Uso: make compose TAG='tag'"
	@exit 1
endif
	cd virtualization/docker/docker-compose && set TAG=$(TAG) && docker compose build --no-cache && docker-compose up


#ifeq ($(OS),Windows_NT)
#    Windows
#else
#    Mac
#endif