all:
	for x in $$(ls -d */Dockerfile); do \
	  (\
	  p=$$(dirname $$x); \
	  cd $$p; \
	  docker build -t bengen/$$p .\
	  ); \
	done
