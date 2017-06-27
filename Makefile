SHELL := /bin/bash

all:
	for x in $$(cat *_docker); do \
	(\
	docker pull $$x; \
	); \
	done \

	[[ -d benchmark_datasets ]] || mkdir benchmark_datasets; \

	for x in $$(cat *db_docker); do \
	(\
	id=$$(docker create $$x); \
	localPath=$$(pwd); \
	docker cp $$id:/usr/toCopy/. $$localPath/benchmark_datasets;\
	); \
	done \
