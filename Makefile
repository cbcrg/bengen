all:
    for x in $$(ls -d boxes*/*/Dockerfile); do \
      (\
      p=$$(dirname $$x); \
      pn=$$(echo $$p | sed 's/boxes.*\///g'); \
      cd $$p; \
      docker build -t bengen/$$pn .\
      ); \
    done
