# Usamos la imagen base de Ubuntu
FROM ubuntu:20.04

# Evitamos las interacciones durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Instalamos los paquetes necesarios
RUN apt-get update && \
    apt-get install -y \
    git \
    php-cli \
    php-mysql \
    && apt-get clean

# Definimos el directorio de trabajo
WORKDIR /usr/local

# Clonamos el repositorio de yakpro-po
RUN git clone https://github.com/pk-fr/yakpro-po.git

# Cambiamos al directorio de yakpro-po
WORKDIR /usr/local/yakpro-po

# Clonamos el repositorio de PHP-Parser en la rama 4.x
RUN git clone https://github.com/nikic/PHP-Parser.git --branch 4.x

# Damos permisos de ejecución al archivo yakpro-po.php
RUN chmod a+x yakpro-po.php

# Creamos un enlace simbólico en /usr/local/bin
RUN ln -s /usr/local/yakpro-po/yakpro-po.php /usr/local/bin/yakpro-po

# Definimos el directorio de trabajo final
WORKDIR /usr/local/yakpro-po

# Comando por defecto al iniciar el contenedor
CMD ["yakpro-po", "--help"]
