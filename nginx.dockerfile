# Etapa 1: Compilación Angular
FROM node:20.16-alpine as build-stage

# Instala herramientas necesarias y crea directorio de trabajo
WORKDIR /app

# Copia solo package.json y package-lock.json para cache inteligente
COPY turnos_web/package*.json ./

# Instala dependencias
RUN npm install

# Copia el resto del proyecto Angular
COPY turnos_web/ .

# Construye la app Angular en modo producción
RUN npm run build -- --configuration production

# Etapa 2: Servidor NGINX
FROM nginx:alpine

# Limpia el contenido del nginx por defecto
RUN rm -rf /usr/share/nginx/html/*

# Copia configuración personalizada de nginx
COPY files/nginx/nginx.conf /etc/nginx/nginx.conf

# Copia certificados SSL
# COPY files/certificate/192.168.1.200-cert.pem /etc/nginx/ssl/cert.pem
# COPY files/certificate/192.168.1.200-key.pem /etc/nginx/ssl/privkey.pem

# Copia el build de Angular al contenedor nginx
COPY --from=build-stage /app/dist/turnos-web /usr/share/nginx/html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]

