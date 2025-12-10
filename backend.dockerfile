FROM node:21-alpine3.18

WORKDIR /usr/src/

COPY turnos_back/package*.json ./

RUN npm install

COPY turnos_back/ ./

RUN apk add tzdata

RUN cp /usr/share/zoneinfo/America/Mexico_City /etc/localtime

RUN echo "Mexico_City" >  /etc/timezone

EXPOSE 3008 3009

CMD ["npm","run","dev"]