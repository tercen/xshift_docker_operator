FROM tercen/runtime-r40:4.0.4-0

USER root
WORKDIR /operator

RUN apt-get -y update && apt-get install -y \
   openjdk-11-jre openjdk-11-jdk \
   r-cran-rjava \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/

RUN git clone https://github.com/ginberg/xshift_operator.git

WORKDIR /operator/xshift_operator

RUN echo 0.0.2_ && git pull
RUN git checkout 0.0.2

RUN echo 'options("tercen.serviceUri"="http://tercen:5400/api/v1/")' >> /usr/local/lib/R/etc/Rprofile.site && \
    echo 'options("tercen.username"="admin")' >> /usr/local/lib/R/etc/Rprofile.site && \
    echo 'options("tercen.password"="admin")' >> /usr/local/lib/R/etc/Rprofile.site && \
    echo 'options(renv.consent = TRUE)' >> /usr/local/lib/R/etc/Rprofile.site && \
    echo 'options(repos=c(TERCEN="https://cran.tercen.com/api/v1/rlib/tercen",\
     CRAN="https://cran.tercen.com/api/v1/rlib/CRAN", \
     BioCsoft="https://cran.tercen.com/api/v1/rlib/BioCsoft-3.12", \
     BioCann="https://cran.tercen.com/api/v1/rlib/BioCann-3.12", \
     BioCexp="https://cran.tercen.com/api/v1/rlib/BioCexp-3.12", \
     BioCworkflows="https://cran.tercen.com/api/v1/rlib/BioCworkflows-3.12" \
     ))' >> /usr/local/lib/R/etc/Rprofile.site

RUN wget https://github.com/nolanlab/vortex/releases/download/26-Apr-2018/VorteX.26-Apr-2018.zip
RUN unzip -j VorteX.26-Apr-2018.zip
RUN rm VorteX.26-Apr-2018.zip

RUN R -e "renv::restore(confirm=FALSE)"

ENV TERCEN_SERVICE_URI https://tercen.com

ENTRYPOINT [ "R","--no-save","--no-restore","--no-environ","--slave","-f","main.R","--args"]
CMD [ "--taskId", "someid", "--serviceUri", "https://tercen.com", "--token", "sometoken"]

