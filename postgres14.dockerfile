FROM postgres:14.6-alpine

RUN apk add tzdata

#COPY files/postgres/postgresql.conf /var/lib/postgresql/data/postgresql.conf

RUN cp /usr/share/zoneinfo/America/Mexico_City /etc/localtime

RUN echo "Mexico_City" >  /etc/timezone