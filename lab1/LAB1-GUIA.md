# Lab 1 - Guia del Participante

* **Ambiente:** Dynatrace Playground (AstroShop) — MCP `dynatrace-playground`
* **Objetivo:** aprender a construir un instruction file que convierte a un agente genérico en un analista de observabilidad riguroso y eficiente.


## La idea del lab

Un agente de IA sin contexto es como un analista nuevo brillante que no conoce tu
ambiente: sabe DQL en general, pero no sabe TU aplicación, ni tu método, ni tus
reglas. El instruction file es el manual que le das.

En este lab construyes ese manual en **4 pasos de checkpoint**. En cada paso agregas una capa y
observas cómo el agente analiza mejor: más enfocado, más eficiente y más honesto.

#
---
#

## Habilitar el entorno

## Repositorios

* [Repo con Copilot](https://github.com/leidyruizrr/astroshop-participantes-2026) 


## Paso 1 - token de Github
* Crear Token de Github en la ruta [Link](https://github.com/settings/personal-access-tokens)
* Ir a la seccion `Developer settings → Personal access tokens → Fine-grained tokens`
* Generate new token
* Repository access: `All repositories`
* Permissions → Repository: `Contents` (Read/write) y `Pull requests` (Read/write)
* Generate token → copiar el token y guardarlo

## Paso 2 - Habilitar el Flag de Fallos
* Ir al repositorio [Repo con Copilot](https://github.com/leidyruizrr/astroshop-participantes-2026) 
* Click en el directorio de `flags` 
* Identificar su archivo con su ID de participante
* Click en editar (Lapiz de lado derecho)
* Cambiar `off` por `on`
* Click en el boton verde de `Commit changes`
* Dejarlo en `Commit directly to the main branch` y aceptar

## Paso 3 - Crear el Codespace

1. Entrar al link del repositorio [Repo con Copilot](https://github.com/leidyruizrr/astroshop-participantes-2026) 
2. Haz clic en el botón verde **Code**.
3. Selecciona la pestaña **Codespaces**.
4. Haz clic en **Create codespace on main**.
5. Espera 2-3 minutos mientras GitHub prepara el entorno (se abrirá VS Code en el navegador).


## Paso 4  - Iniciar el Workspace & Iniciar el MCP server

1. Ubicar el archivo  `.vscode/mcp.json` y agregar el Token de Github creado previamente
2. Abrir la terminal y ejecutar el siguiente comando: esto creará el archivo de instrucciones base
```
cp lab1/LAB1-paso-0.md .github/copilot-instructions.md
```
3. Abrir la paleta de comandos (`Ctrl+Shift+P`) buscar por MCP y click en **MCP: List Servers**.
4. Selecciona `dynatrace-playground` → **Start Server**.
5. verificar que el servidor este en estado `running`
6. Abrir Copilot Chat → cambiar a Agent mode `Ctrl+Alt+I`
7. Preguntar algo como: 
```
¿A qué tenant de Dynatrace estoy conectado?
```
8. Si la respuesta entregada usó herramientas del MCP el entorno está listo.

> IMPORTANTE sobre Copilot: cada vez que edites `.github/copilot-instructions.md`,
> **abre un chat NUEVO** para que relea el archivo d einstrucciones. Si no, sigue usando la versión
> anterior.

#
---
#

## Laboratorio de Checkpoints - Instruction Files

# Ejercico 1 - (Herramientas + Ambiente)

`Prompt de Referencia`:
```
Analiza los problemas que ha tenido la aplicación astroshop en las últimas 2 horas, identifica el problema más crítico, explícame la causa raíz, muestra las consultas realizadas y sus resultados.
```

---

## Ejercico 2 — Método de análisis, fuentes de datos & Tips de consulta

* Reemplaza tu instruction file por el del paso 1:
```
cp lab1/LAB1-paso-1.md .github/copilot-instructions.md
```
(O agrega tú mismo las secciones "Método de análisis" y "Fuentes de datos".)

* Abre un chat nuevo, lanza el prompt de referencia.



---

## Ejercico 3 — Reglas de Investigación, Rigor y Formato de salida

* Reemplaza tu instruction file por el del paso 2:
```
cp lab1/LAB1-paso-2.md .github/copilot-instructions.md
```

* Abre un chat nuevo, lanza el prompt de referencia.


---


## Si te quedas atrás

Copia el paso correspondiente y continúa:
```
cp lab1/LAB1-paso-0.md .github/copilot-instructions.md
cp lab1/LAB1-paso-1.md .github/copilot-instructions.md
cp lab1/LAB1-paso-2.md .github/copilot-instructions.md
cp lab1/LAB1-paso-3.md .github/copilot-instructions.md
```