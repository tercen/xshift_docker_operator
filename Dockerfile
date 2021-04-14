FROM tercen/dartrusttidy:4.0.3-0

USER root
WORKDIR /operator

RUN git clone https://github.com/ginberg/xshift_operator.git

WORKDIR /operator/xshift_operator

RUN echo 0.0.1_ && git pull
#RUN git checkout 0.0.1

RUN R -e "renv::restore(confirm=FALSE)"

ENV TERCEN_SERVICE_URI https://tercen.com

ENTRYPOINT [ "R","--no-save","--no-restore","--no-environ","--slave","-f","main.R","--args"]
CMD [ "--taskId", "someid", "--serviceUri", "https://tercen.com", "--token", "sometoken"]

