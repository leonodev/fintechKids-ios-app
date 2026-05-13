---
name: design-system
description: Gestiona y crea componentes de diseño del sistema FHKDesignSystem. Guía al usuario en la selección de componentes existentes y genera código de SwiftUI para nuevos componentes, asegurando el uso correcto de Tipografías, Colores y Espaciados.  
---

1. **Guidelines**:
- usa este ejemplo [creacion de componente](example-component.swift) para que te guies como crear un nuevo componente.


2. **Domain Business Rules (Rules of Gold)**:
* **Constraint 1:** cada componente que crees, ejemplo, un boton, debe soportar estos estados internos (`.skeleton`, `.error`, `.disabled`, `.loaded`). de esta manera cada componente podra reaccionar a cada uno de estos casos.
* **Constraint 2:**  cada componente debe tener su Preview para poder ver como se ve el componente en los 4 estados.    
* **Constraint 3:** los componentes no deben recibir ningun objeto de dominio, simplemente deben recibir propiedades primitivas para evitar acoplamientos.
* **Constraint 4:**  debes tener en cuenta que cuando crees una nueva struct para un nuevo componente, debera ser public y debere tener un metodo init public para inicializar todos sus propiedades, esto porque todos estos componentes sin usados desde otro modulo externo.
* **Constraint 5:** si te ordeno que añadas un nuevo lottie tu solo te encargaras de instanciar el nuevo lottie en el manager `Lotties.swift` yo manualmente lo pondre en el proyecto, tu solo encargate de que este declarada en este archivo, deberas preguntarme que nombre le pongo, yo te lo indicare.  
* **Constraint 6:** si te pido que añadas un nuevo avatar, debes preguntarme que nombre le pongo, yo te lo indicare. tu deberas añadirlo en el archivo `AvatarType.swift` yo pondre la imagen manualmente en los assets.

3. **UI & Design System (FHK Identity)**
* **Design Tokens:** Always use `FHKColor`, `FHKSpace`, and `FHKSize`.
* **Hardcoding Rule:** Zero hardcoded colors or paddings allowed.



4. **AI Interaction Protocol**
* **Behavior:** Sé interactivo y pregunta paso a paso / Sé directo y ejecuta el código de una vez.


* **Checklist:** 
    - [ ] Todos las Componentes deben soportar estos 4 estados (`.skeleton`, `.error`, `.disabled`, `.loaded`)
    - [ ] Todos los componentes creados deberan tener su Preview con sus cuatro estados