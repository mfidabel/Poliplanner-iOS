# PoliPlanner iOS

![Jazzy Docs](https://github.com/mfidabel/Poliplanner-iOS/workflows/Jazzy%20Docs/badge.svg?branch=main) ![Swift](https://github.com/mfidabel/Poliplanner-iOS/workflows/Swift/badge.svg?branch=main)

 📱 Organiza tus clases de la FP-UNA desde un dispositivo iOS o iPadOS

## 👌 Caracteristicas

- [x] 🛠 Totalmente para iOS escrito en Swift
- [x] 🤘 Utiliza el [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [x] 📑 Clases ordenadas por día
- [x] 📅 Calendario de exámenes y revisiones
- [x] 📝 Secciones
- [x] 📂 Importación de horarios de clases en Excel
- [x] 🗂 Soporte de multiple horarios de clases
- [ ] 👥 Carga de multiple carreras en un mismo horario
- [ ] 🧮 Calculadora de notas
- [ ] 📥 Descarga de horarios online
- [x] 📲 iOS/iPadOS 14.0 >=
- [x] 🧩 Licencia MIT

## 

## 🛠 Compilar la aplicación localmente

### 🔧 Requisitos

* Xcode 12.3
* Cocoapods 1.10.1

### 👣 Pasos

1. Instalar los pods (librerias) del proyecto ejecutando el siguiente comando:

    ```
    pod install
    ```
2. Abrir en Xcode el  `Poliplanner.xcworkspace` en la raíz del proyecto.
3. Cambiar el **bundle identifier** en Poliplanner -> Signing & Capabilities -> Signing por un identificador único.


## 📓 Documentación

Puedes revisar la autodocumentación de la rama `main` en [Github Pages](https://mfidabel.github.io/Poliplanner-iOS/) o...

### 🎶 Generar documentación con Jazzy

#### 🔧 Requisitos

* Cocoapods 1.10.1
* Xcode 12.3
* Jazzy 0.13.6  `[sudo] gem install jazzy`

#### 👣 Pasos

1. Instalar los pods (librerias) del proyecto ejecutando el siguiente comando:
```
pod install
```
2. Ejecutar jazzy:
```
jazzy
```
3. Abrir el `index.html` generado en la carpeta `docs/`

## 🧩 Licencia

Este proyecto corre sobre la licencia MIT. Revisar la [LICENCIA](LICENSE) para más detalles

