# Guía paso a paso de Laravel 9

## ¿Qué aprenderás?
El curso tiene un **enfoque muy práctico** para que comiences construyendo una aplicación básica paso a paso e ir añadiendo funcionalidades de forma progresiva. 

## Índice de contenidos
 1. [Introducción](/01-introduccion): qué es Laravel, características principales y su ecosistema. 
 2. [Preparar el entorno de desarrollo](/02-entorno)
 3. [Tu primera aplicación en 7 pasos](/03-primeros-pasos)
 4. [Laravel nivel intermedio](/04-Nivel-intermedio)
 5. Próximos pasos (en construcción)

## ¿Cómo puedes contribuir?
### Issues
Siénte libre de abrir un *issue* de Github para reportar errores o sugerir modificaciones.

### Contribuir
Sigue los siguientes pasos:

1. Haz un `fork` del repositorio en GitHub
2. `Clone` el proyecto en tu entorno local
3. Haz `commit` de los cambios en tu propia branch
4. Haz `push` de los cambios a tu fork
5. Envía una `Pull request` para que pueda revisar tus cambios

### Notas
La documentación está íntegramente escrita en Markdown y compilada a página estática utilizando [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).

Si deseas desplegar la página en local te interesarán los siguientes comandos (consulta la documentación oficial [aquí](https://squidfunk.github.io/mkdocs-material/getting-started/)):

Crear un nuevo proyecto
```bash
docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material new .
```

Lanzar el servidor local para previsualizar los cambios realizados`automáticamente:
```bash
docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material
```


Compilar el proyecto generando los archivos estáticos:
```bash
docker run --rm -it -v ${PWD}:/docs squidfunk/mkdocs-material build
```
