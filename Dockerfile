FROM tomcat:8.0.39-jre8-alpine

LABEL maintainer="cse.sumit@gmail.com"

ADD petclinic.war /usr/local/tomcat/webapps/

EXPOSE 8080

COPY execute.sh execute.sh

RUN chmod +x execute.sh

RUN apk update && apk add wget \
    && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
    && chmod +x cloud_sql_proxy \
    && mkdir /cloudsql;

ADD key.json /cloudsql
EXPOSE 3306

CMD ["./execute.sh"]