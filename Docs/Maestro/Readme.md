Este repositorio contiene la suite de pruebas de automatización End-to-End (E2E) utilizando **Maestro**, el framework de testing mobile de alto rendimiento. Esta guía detalla la instalación, configuración, ejecución local y despliegue automatizado en la infraestructura de CI mediante GitHub Actions.

---

## 📌 Requisitos Previos Comunes
Antes de iniciar con la instalación de Maestro, asegúrate de contar con las siguientes herramientas instaladas en tu sistema de desarrollo:
* **macOS** (Requerido para simulación de iOS).
* **Node.js** v18 o superior.
* **Xcode** instalado y configurado con sus herramientas de línea de comandos (`xcode-select --install`).
* **Homebrew** instalado en la terminal.

---

## 💻 1. Configuración del Entorno Local

Sigue estos pasos en orden secuencial para aprovisionar tu estación de trabajo local:

### Instalar Maestro CLI
Ejecuta el script oficial de instalación provisto por Mobile.dev:
```bash
curl -FsSL [https://get.maestro.mobile.dev](https://get.maestro.mobile.dev) | bash
```

Una vez finalizada la descarga, añade la ruta de Maestro a las variables de entorno de tu terminal (.zshrc o .bash_profile):

```bash
export PATH="$PATH:$HOME/.maestro/bin"
```

Recarga tu terminal para aplicar los cambios

```bash
source ~/.zshrc
```

Verifica la instalación exitosa imprimiendo la versión de Maestro:

```bash
maestro --version
```

## Paso 1.1: Configurar el Simulador de iOS
Maestro interactúa de forma nativa con los simuladores de Apple a través de idb (iOS Development Bridge), pero para entornos locales simplificados, se apoya en los comandos estándar de Xcode.

Abre Xcode y ve a Settings > Platforms. Asegúrate de tener instalado al menos un runtime de iOS (por ejemplo, iOS 17 o iOS 18).

Abre un simulador de destino desde la terminal:

```bash
xcrun simctl boot "iPhone 15"
```

## Estructura del Proyecto de Pruebas
El árbol de directorios de pruebas E2E está organizado dentro de la raíz del proyecto móvil de la siguiente forma:


```Plaintext
fintechKids/
├── .maestro/
│   ├── flows/
│   │   ├── select-language.yaml    <-- Validación language app
│   │   ├── make-login.yaml         <-- Flujo de autenticación
│   │   └── create-new-member.yaml  <-- Registro del miembro 'user1'
│   ├── screenshots/
│   │   ├── image_start.png          <-- first screenshots of app
│   │   ├── image_after-5-seconds.png<-- second screenshots of app after 5 seconds
│   ├── run-e2e.sh                  <-- Script de inicialización y ejecución en local   
├── .github/   
│   ├── workflows/  
│   │   ├── maestro-tests.yaml      <-- yaml de Ejecucion del CI  
└── Docs/Maestro/README.md          <-- Esta guía de configuración y uso
```

## Paso 1.2 Ejecución de Pruebas en Local

```bash
maestro .maestro/run-e2e.sh
```

Ejemplo de pruenas en local desde la terminal:

```Plaintext
➜  fintechKids-ios-app git:(main) ✗ .maestro/run-e2e.sh
🚀 Limpiando sesiones previas de automatización...
🧹 Desinstalando aplicación previa para limpiar entorno...
🔍 Localizando el archivo .app compilado más reciente...
📦 App encontrada en: /Users/fleon/Library/Developer/Xcode/DerivedData/fintechKids-dsopuhmvrkrhrqebyjoferdtzefg/Build/Products/Release-iphonesimulator/fintechKids.app
📥 Instalando versión limpia de la app en el simulador...
⏳ Esperando a que el sistema operativo registre la app...
⚙️ Configurando entorno...
🛢️ Limpiando usuario de pruebas en Supabase...
🏃 Ejecutando pruebas de Maestro en orden estricto...

Waiting for flows to complete...
[Passed] select-language (43s)
[Passed] make-login (36s)
[Passed] create-new-member (20s)

3/3 Flows Passed in 1m 39s

📊 Abriendo el reporte detallado en tu navegador...
✅ ¡Proceso terminado exitosamente!
➜  fintechKids-ios-app git:(main) ✗ 
```