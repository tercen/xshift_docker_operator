FROM tercen/dartrusttidy:4.0.3-0

USER root
WORKDIR /operator

RUN apt-get -y update && apt-get install -y \
   openjdk-11-jre openjdk-11-jdk \
   r-cran-rjava \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/

RUN echo 0.0.1 && git clone https://github.com/ginberg/xshift_operator.git

WORKDIR /operator/xshift_operator

RUN echo 0.0.1 && git pull
#RUN git checkout 0.0.1

RUN R -e "renv::restore(confirm=FALSE)"

ENV TERCEN_SERVICE_URI https://tercen.com

RUN wget https://github.com/nolanlab/vortex/releases/download/26-Apr-2018/VorteX.26-Apr-2018.zip
RUN unzip -j VorteX.26-Apr-2018.zip
RUN rm VorteX.26-Apr-2018.zip

COPY input/BM2_cct_normalized_01_non-Neutrophils.fcs BM2_cct_normalized_01_non-Neutrophils.fcs

ENTRYPOINT [ "R","--no-save","--no-restore","--no-environ","--slave","-f","main.R","--args"]
CMD [ "--taskId", "someid", "--serviceUri", "https://tercen.com", "--token", "sometoken"]

