FROM rocker/tidyverse

 
RUN sudo apt-get update
RUN sudo apt-get -y install libssl-dev 
RUN sudo apt-get -y install libxml2
RUN sudo apt-get -y install libxml2-dev
RUN sudo apt-get -y install curl
RUN sudo apt-get -y install r-base-core libssl-dev libcurl4-openssl-dev
RUN sudo apt-get -y install libpq-dev 
RUN sudo apt-get -y install libjq-dev
 
 
# install R packages
RUN install2.r \
   plumber \ 
   Rook \ 
   tidyverse \ 
   data.table \ 
   ggplot2 \
   plotly \
   readr \
   htmlwidgets \
   swagger \
   janitor \
   RPostgreSQL \
   config \ 
   rmarkdown \ 
   DT \
   kableExtra \
   here \
   HARtools \
   jqr \
   tictoc

#RUN Rscript -e "install.packages('janitor')"
#RUN Rscript -e "remotes::install_github('trestletech/plumber')"
RUN R -e 'remotes::install_cran("randomNames")'
RUN R -e 'remotes::install_cran("fts")'
RUN R -e 'remotes::install_cran("stringr")'
RUN R -e 'remotes::install_cran("ggiraph")'
RUN R -e 'remotes::install_github("Ather-Energy/ggTimeSeries")'
RUN R -e 'remotes::install_cran("httr")'
RUN R -e 'remotes::install_cran("conflr")'
RUN R -e 'remotes::install_cran("formattable")'
 
 
# setup nginx
#RUN apt-get update && \
#    apt-get install -y nginx apache2-utils && \
#    htpasswd -bc /etc/nginx/.htpasswd test test
     
#RUN openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 \
#        -keyout /etc/ssl/private/server.key \
#        -out /etc/ssl/private/server.crt


#ADD docker.key /etc/ssl/private/
#ADD docker_signed.crt /etc/ssl/private/
#ADD ./nginx.conf /etc/nginx/nginx.conf

ENV TEST_ENV = "HELLO_WORLD_from_test_env"

RUN echo 'CONFLUENCE_URL="https://company.atlassian.net/wiki"\nCONFLUENCE_USERNAME="user@company.com"\nCONFLUENCE_PASSWORD="********"' >> /usr/local/lib/R/etc/Renviron

 
EXPOSE 80 443 8000
 
ADD . /app
WORKDIR /app
 
#CMD service nginx start && R -e "source('run_api.R')"
CMD R -e "source('run_api.R')"

