.PHONY: update_submodules commit_submodules push_submodule

update_submodules:
	git submodule update --remote --merge

commit_submodules:
ifeq ($(strip $(MESSAGE)$(SUBMODULE)),)
	@echo "ERROR: Uso: make commit_submodules MESSAGE='Tu mensaje de commit' SUBMODULE='nombre_del_submodulo'"
	@exit 1
endif
	git add . && git commit -m "$(MESSAGE)"
	cd $(SUBMODULE) && git add . && git commit -m "$(MESSAGE)" && cd ..

push_submodule:
	cd $(SUBMODULE) && git push origin $(shell git symbolic-ref --short HEAD) && cd ..

.PHONY: commit_submodules update_and_commit push_submodule

commit_submodules: commit_submodules_push

update_and_commit: update_submodules commit_submodules_push

commit_submodules_push: push_submodule
