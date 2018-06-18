---
title: Porqué usar contenedores
date: 2018-04-08T01:14:00-04:00
description: Básicamente, le permiten a los programadores y administradores de sistemas desarrollar e implementar aplicaciones de una manera mucho más sencilla.
categories:
  - tecnología
tags:
  - entornos-de-desarrollo
  - contenedores
  - backend
  - devops
  - sysadmin
math: true
---

Básicamente, le permiten a los programadores y administradores de sistemas
desarrollar e implementar aplicaciones de una manera mucho más sencilla. Antes
de entrar en detalles sobre el tema y para poder notar las ventajas de usar
contenedores, haré un ejemplo de como se implementaría una aplicación web (no
es que los contenedores solo sirvan para aplicaciones web, es un ejemplo) con
otros métodos:

#### Con servidores físicos (bare-metal)

1\. El programador escribe la aplicación en su computadora.

2\. El programador se asegura de que la aplicación funciona en su computadora.

3\. El programador sube el código fuente al repositorio Git.

4\. El administrador de sistemas clona/actualiza el repositorio en el servidor
de pruebas.

5\. El administrador de sistemas inicia la instalación de la aplicación y sus
dependencias (otras aplicaciones, archivos, carpetas y cualquier otra cosa que
necesite la aplicación para instalarse y ejecutarse) en el servidor siguiendo
las instrucciones o corriendo algún script del programador.

6\. Todos los integrantes del equipo hacen una plegaria al dios de su creencia
y esperan que todo salga bien.

7\. Existen dos posibilidades en este punto:

&nbsp; 7.1. La instalación finaliza correctamente, se ejecutan las pruebas y
se generan dos nuevas posibilidades:

&nbsp;&nbsp;&nbsp; 7.1.1. La aplicación funciona correctamente y se migra al
servidor de producción.

&nbsp;&nbsp;&nbsp; 7.1.2. Ocurre un error durante las pruebas porque las
dependencias de ejecución no se cumplen y el programador dice *«Que raro, en
mi máquina sí funciona»*. Existen dos posibilidades por las que falló:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7.1.2.1. Al programador se le olvidó que la
aplicación durante su ejecución necesitaba X dependencia, pero como en su
máquina ya estaba antes de empezar a desarrollar, nunca se generó el error.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7.1.2.2. El administrador de sistemas se salto
accidentalmente una de las instrucciones del programador y dice *«Esto no es 
mi culpa, díganle al programador ese que aprenda a programar bien 😒»*.

&nbsp; 7.2. Ocurre un error durante la instalación porque las dependencias de
 instalación no se cumplen y el programador dice *«Que raro, en mi máquina
 sí se instala»*. Existen dos posibilidades por las que falló:

&nbsp;&nbsp;&nbsp; 7.2.1. Al programador se le olvidó que la aplicación
durante la instalación necesitaba X dependencia, pero como en su máquina ya
estaba antes de empezar a desarrollar, nunca se generó el error.

&nbsp;&nbsp;&nbsp; 7.2.2. El administrador de sistemas se saltó
accidentalmente una de las instrucciones del programador y dice *«Esto no es 
es mi culpa, díganle al programador ese que haga bien su trabajo y explique 
mejor como se debe instalar 😒»* (solo aplica si no se usa un script de
instalación).

Sin contar que cada programador que forme parte del equipo tendrá que hacer lo
mismo que el administrador de sistemas, solo que en su computadora.

**Ventajas:**

1. La aplicación trabajará al máximo rendimiento posible.

2. La aplicación tiene acceso directo al hardware (para algunas aplicaciones
   esto puede ser una desventaja).

**Desventajas:**

[Mr. Robot]: http://www.usanetwork.com/mrrobot

1. Las probabilidades de fallo son muy altas.

2. El equipo debe estar muy organizado para evitar otro tipo de fallas (las de
   la aplicación no son las únicas que podrían generarse).

3. Si alguien rompe la seguridad de la aplicación (que no es que sea fácil de
   hacer, solo es en el caso de que logre hacerlo), tendrá acceso directo al
   servidor y no es que haga falta ser super usuario o
   [<img alt="Mr. Robot" src="/uploads/mr-robot.png" style="height: 1.25em;"/>][Mr. Robot]
   para afectarlo, con solo correr un
   `while true; do; echo 'Soy un come CPU Muajaja! 😈'; done`
   ya habrá un consumo relevante de CPU que podría aumentar su temperatura, o
   con otros truquitos que afecten la RAM, el espacio de almacenamiento, etc...

El resultado, una estructura parecida a:

<p align="center">
  <img alt="Arquitectura de una aplicación en un servidor físico"
    src="/uploads/containers/architectures-bare-metal-es.svg"/>
</p>

#### Con máquinas virtuales

1. El administrador de sistemas le asigna una imagen base de una máquina
   virtual al programador para que la replique en su computadora o en el peor
   de los casos, le crea una máquina virtual en donde podrá conectarse de
   manera remota.

2. El programador escribe la aplicación en su computadora.

3. El programador se asegura de que la aplicación funciona en la máquina
   virtual.

4. El programador sube el código fuente al repositorio Git.

5. El programador genera una imagen con la aplicación funcionando y la entrega
   al administrador de sistemas para que la implemente o si se tiene
   automatizado, se crea una nueva máquina virtual de pruebas basada en la
   imagen. En caso de que se le haya asignado una máquina virtual, deberá
   avisar al administrador de sistemas para que inicie la auditoría.

6. El administrador de sistemas, y probablemente otros miembros del equipo,
   auditan la aplicación y si todo funciona correctamente se implementa en
   producción.

**Ventajas:**

1. Las probabilidades de fallo son muy bajas (o hasta nulas).

2. Es bastante fácil replicar el entorno de desarrollo (si se usan imágenes).

3. Si alguien rompe la seguridad de la aplicación, solo tendrá acceso a la
   máquina virtual y no afectará a otros servicios.

4. No hace falta que el equipo esté tan organizado para implementar una versión
   de la aplicación.

**Desventajas:**

1. El host (que es la máquina real, donde están ejecutándose las máquinas
   virtuales) estará corriendo múltiples sistemas operativos, lo que se traduce
   en muchas más tareas para el CPU y un mayor consumo de RAM.

2. La aplicación no tiene acceso al hardware (dependiendo de la aplicación,
   esto puede ser irrelevante e incluso una ventaja), según el software de
   virtualización que se use, pueden hacerse algunas configuraciones especiales
   que le otorguen acceso, pero en este caso sería mucho mejor usar otra
   alternativa para implementar la aplicación, si quieren acceso al hardware
   para que virtualizarlo 😒😂 (a menos que se necesite exclusivamente un
   sistema operativo diferente al del host).

Se generan dos estructuras, la primera para el entorno de producción y la otra
en la computadora de cada programador:

<p align="center">
  <img alt="Arquitectura de una aplicación en máquinas virtuales"
    src="/uploads/containers/architectures-vm-es.svg"/>
</p>

#### Con contenedores (¡¡POR FIN!!)

{{% note %}}

Ya se que todo lo que escribí arriba depende de la técnica de trabajo de cada
equipo, pero es un ejemplo.. no hay que ser fastidiosos 😒😂, imaginen que
están viendo una de esas publicidades exageradas de productos como *«La
aspiradora que también lava, hace la comida y le canta canciones de cuna»*,
igual que ellos, yo también tengo que vender mí producto 😄 (en este caso,
el título del artículo porque yo no inventé los contenedores 😂).

{{% /note %}}

Ahora que ya hay algo de contexto, los contenedores pueden definirse como
entornos aislados y previamente configurados en los que se ejecutará
determinado software sin tener que preocuparse por cumplir sus dependencias
(son los *Plug & Play* del software). Su funcionalidad es muy parecida a la de
las máquinas virtuales, solo que en este caso no se virtualiza el hardware y
comparten el sistema operativo del host (esto quiere decir que los contenedores
no tienen sistema operativo, sino que usan el del host), lo que los hace mucho
más ligeros y fáciles de compartir con el equipo de trabajo.

No se debe confundir sistema operativo con distribuciones. El sistema operativo
es Linux (el kernel) y Alpine, Arch, CentOS, Debian, Deepin, Elementary,
Fedora, Mind, Ubuntu, \\(etc \times 10e^\infty\\) 😂 son distribuciones, que
se encargan de agregar aplicaciones sobre Linux para facilitar su uso. Todos
los contenedores corren el mismo sistema operativo, pero pueden tener
diferentes distribuciones.

<p align="center">
  <img alt="Sistema operativo"
    src="/uploads/containers/os-definition-es.svg"/>
</p>

Existen muchas herramientas para manipular contenedores y cada una tiene
métodos específicos de trabajar con ellos, pero normalmente todas tienen un
ciclo de trabajo parecido a este:

1. Se crea o descarga una imagen de contenedor, que es una especie de plantilla
   que contiene todas las configuraciones y la estructura del sistema de
   archivos (las carpetas y esas cosas).

2. Se implementa la imagen (que es lo mismo que crear un contenedor con la
   imagen, solo que en un lenguaje más pompudo 😂).

3. Se inicia y ejecutan los procesos del contenedor.

4. Si el contenedor terminó de ejecutar sus procesos u ocurrió un error, se
   detiene.

5. Si se (re)quiere, se reinicia el contenedor.

6. Si el contenedor ya no es de utilidad, se elimina.

Algunas de las herramientas más conocidas son:

* [Docker](https://www.docker.com/)

* [rkt](https://coreos.com/rkt/)

* [runC](https://github.com/opencontainers/runc)

* [systemd-nspawn](https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html)

Por la gran popularidad que se han ganado y lo bien que hacen su trabajo,
muchas empresas han estado preparando sus plataformas para trabajar con esta
tecnología, y durante ese proceso se han ido generando nuevas herramientas
llamadas orquestadores de contenedores, que automatizan gran parte de las
tareas repetitivas al momento de llevar los contenedores a entornos de
producción (sí, a producción, no me equivoqué escribiendo), algunas de estos
orquestadores son:

* [Docker Swarm](https://docs.docker.com/engine/swarm/)

* [Kubernetes](https://kubernetes.io/)

* [Mesos](http://mesos.apache.org/)

* [Mesosphere](https://mesosphere.com/product/)

* [Nomad](https://www.nomadproject.io/)

Haré un ejemplo de implementación con contenedores igual a los anteriores para
ver sus ventajas y desventajas:

1. El administrador de sistemas le asigna una imagen base de un contenedor al
   programador para que la replique en su computadora.

2. El programador escribe la aplicación en su computadora.

3. El programador se asegura de que la aplicación funciona en el contenedor.

4. El programador sube el código fuente al repositorio Git.

5. El programador genera una imagen con la aplicación funcionando y la entrega
   al administrador de sistemas para que la implemente, o si se tiene
   automatizado, se crea un nuevo contenedor de pruebas basado en la imagen.

6. El administrador de sistemas, y probablemente otros miembros del equipo,
   auditan la aplicación y si todo funciona correctamente se implementa en
   producción.

Los pasos son casi iguales a como se harían usando máquinas virtuales.

**Ventajas:**

1. Las probabilidades de fallo son muy bajas (o hasta nulas).

2. Es bastante fácil replicar el entorno de desarrollo.

3. Si alguien rompe la seguridad de la aplicación, solo tendrá acceso al
   contenedor y no afectará a otros servicios.

4. La aplicación puede tener acceso al hardware según se configure.

5. No hace falta que el equipo esté tan organizado para implementar una versión
   de la aplicación.

**Desventajas:**

1. El host estará corriendo múltiples distribuciones, lo que se traduce en
   más tareas para el CPU, pero la sobrecarga es mínima si se compara con un
   servidor físico.

2. La barrera de seguridad entre el host y los contenedores no es tan grande
   como la de una máquina virtual.

En este caso, las estructuras del entorno de desarrollo y de producción son
iguales, con la excepción de los programadores que usen Windows o macOS, pero
dudo que les importe el consumo desproporcionado de recursos, normalmente
tienen un hardware potente, por algo usan Windows o macOS no? 😅.

<p align="center">
  <img alt="Arquitectura de una aplicación en contenedores"
    src="/uploads/containers/architectures-container-es.svg"/>
</p>

# En conclusión

A pesar de que todo lo que escribí pareciera una charla de Herbalife y que la
única solución a todos los problemas (hasta el hambre y la pobreza mundial) se
solucionan con contenedores, cada uno de los métodos de implementación que usé
de ejemplo tienen propósitos y enfoques diferentes, por lo que al usarlos como
y donde deben, pueden mitigarse sus desventajas y obtener más ventajas que
usando contenedores. Lo importante es siempre usar la herramienta correcta, y
conocer una nueva que hace muy bien su trabajo nunca está de más 😄.

<p align="center">
  <img alt="Arquitectura de una aplicación en contenedores"
    src="/uploads/containers/architectures-es.svg"/>
</p>

# Atribuciones

**OCI Team.** *OCI Runtime Specification.* <https://github.com/opencontainers/runtime-spec>

**Docker Team.** *Get Started, Part 1: Orientation and setup.* <https://docs.docker.com/get-started/#containers-and-virtual-machines>

**Wikipedia Authors.** *Operating system.* <https://en.wikipedia.org/wiki/Operating_system>

