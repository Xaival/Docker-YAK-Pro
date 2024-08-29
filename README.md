# Descripcion
Modifica el código para que sea más difícil de entender, reduciendo el riesgo de que un atacante pueda analizarlo y encontrar vulnerabilidades.
[YAK Pro - Php Obfuscator](https://www.php-obfuscator.com/?lang=english)


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


Construye la imagen de Docker con el siguiente comando `docker build -t yakpro-po .`
    
![image](https://github.com/user-attachments/assets/e8e7679b-f5ed-4364-99cc-f760a501d232)


Crear archivo para ejemplo `nano input/mi_script.php`

    <?php
    // Obtener el valor desde la URL
    $input = $_GET['input'];
    
    // Validar que el valor solo contenga letras y números
    if (preg_match('/^[a-zA-Z0-9]+$/', $input)) {
        // Procesar el valor
        echo "Entrada válida: " . htmlspecialchars($input);
    } else {
        // Mostrar un mensaje de error
        echo "Error: Entrada no válida.";
    }

![image](https://github.com/user-attachments/assets/a94b879a-4e88-4274-bfcc-012e8192580b)


Ofuscar todo lo que se encuentra en el directorio input y sacar el resultado por output

- `docker run` : Inicia un nuevo contenedor de Docker.
- `--rm` : El contenedor se eliminará automáticamente después de que termine su ejecución. Esto ayuda a mantener tu sistema limpio de contenedores que ya no necesitas.
- `-v $(pwd)/input:/workspace/input` : Monta el directorio `input` del host en el contenedor en el directorio `/workspace/input`. Esto permite que el contenedor acceda a los archivos en el directorio `input` de tu máquina local.
- `-v $(pwd)/output:/workspace/output/yakpro-po/obfuscated` : Monta el directorio `output` del host en el contenedor en `/workspace/output/yakpro-po/obfuscated`. Este es el directorio donde se guardarán los archivos obfuscados generados por `yakpro-po`.
- `-w /workspace/input` : Establece el directorio de trabajo dentro del contenedor como `/workspace/input`. Esto significa que cualquier comando ejecutado en el contenedor usará `/workspace/input` como su directorio de trabajo actual.
- `yakpro-po` : Es la imagen de Docker que has creado y que contiene el comando `yakpro-po`.
- `yakpro-po /workspace/input -o /workspace/output` : Es el comando que se ejecutará dentro del contenedor:
    - `yakpro-po` es el ejecutable que obfusca el código.
    - `/workspace/input` es el directorio de entrada que contiene los archivos PHP que deseas obfuscar.
    - `-o /workspace/output` indica el directorio de salida donde se guardarán los archivos obfuscados. El contenedor utilizará este directorio para guardar el resultado de la obfuscación.
```bash
    docker run --rm -v $(pwd)/input:/workspace/input -v $(pwd)/output:/workspace/output/yakpro-po/obfuscated -w /workspace/input yakpro-po yakpro-po /workspace/input -o /workspace/output
```
![image](https://github.com/user-attachments/assets/c4229a48-e5df-4651-aa06-d6e6e8cb2e0d)


Ya podremos ver el resultado en `output`
![image](https://github.com/user-attachments/assets/7dc8fad2-a42c-43c7-97dd-8c10c7b84b91)


Ver imágenes de Docker para saber el nombre `docker images`
![image](https://github.com/user-attachments/assets/6e02a5cd-8418-44d4-b67c-108aa8a2c19d)


Borrar imagen danto por echo que ya se han ofuscado todos los que se querian `docker rmi yakpro-po`
![image](https://github.com/user-attachments/assets/0bb571a3-3b4a-4cb1-8317-ab1a9e3fdf09)
