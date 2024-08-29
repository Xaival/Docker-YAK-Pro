# Descripcion
Modifica el código para que sea más difícil de entender, reduciendo el riesgo de que un atacante pueda analizarlo y encontrar vulnerabilidades.

# Paso a paso de instalacion
Preparacion previa

    mkdir YAK-Pro YAK-Pro/input YAK-Pro/output
    cd YAK-Pro
    nano Dockerfile

![image](https://github.com/user-attachments/assets/dddad212-be41-4ceb-8c96-2cbe23e49afd)

Configurar el archivo de creación de imagen Dockerfile

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

![image](https://github.com/user-attachments/assets/c9fed9c4-8b94-4cb3-8aa9-234cf6fd3472)


Construye la imagen de Docker con el siguiente comando ´´docker build -t yakpro-po .´´
![image](https://github.com/user-attachments/assets/e8e7679b-f5ed-4364-99cc-f760a501d232)

