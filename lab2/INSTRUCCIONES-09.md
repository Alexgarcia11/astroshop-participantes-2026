# AstroShop — Investigación y remediación de incidentes (astroshop-09)

Instrucciones para investigar, documentar y remediar incidentes en el namespace `astroshop-09` en el ambiente dynatrace-lab.

## Reglas críticas

- IMPORTANT: filtra SIEMPRE por namespace `matchesPhrase(k8s.namespace.name, "astroshop-09")` en cada consulta DQL. Es tu identificador principal, viene en toda la telemetría y es único para ti.
- NUNCA hagas merge de un Pull Request. Abrir el PR sí; el merge lo aprueba una persona. 

## Enrutamiento de herramientas

- IMPORTANT: Análisis, diagnóstico y causa raíz lo haces con MCP de Dynatrace. Explora problemas de Davis, spans, logs y métricas consultando por el MCP a traves de consultas DQL funcionales. Filtra por tu namespace. Crear notebooks, SLOs, dashboards o cualquier otro recurso hazlo con la herramienta dtctl. 
- Proponer fixes: usa el MCP de GitHub. Abre un Pull Request sobre `flags/payment-09.yaml` en `leidyruizrr/astroshop-participantes-2026`.
- En una tarea de varios pasos, usa la herramienta correcta en cada uno y dilo en tu respuesta.
- IMPORTANT: al crear cualquier recurso (notebook, SLO, dashboard), antepón SIEMPRE tu namespace al nombre: `astroshop-09 - <nombre>`. Nunca crees un recurso sin ese prefijo, para no colisionar con otros.
- Para abrir el PR usa ÚNICAMENTE la herramienta del MCP de GitHub. No uses `gh` ni git por terminal.
- Al abrir el PR, nombra el branch SIEMPRE `fix/payment-09-off`. No reutilices branches existentes; si existe, créalo desde main actualizado.


## El ambiente

- Aplicación: astroshop, aplicacion de ecommerce con microservicios en Kubernetes monitoreada con Dynatrace en ambiente de Dynatrace dynatrace-lab.
- Kubernetes en GCP (GKE), cluster `dt-lab-lcrr-demo`, namespace `astroshop-09`. No tienes acceso a `kubectl` ni al cluster k8s. La única vía para cambiar su estado es un Pull Request.
- La aplicación reporta a Dynatrace por dos caminos a la vez: OneAgent (automático) y OpenTelemetry Collector. Por eso un servicio puede aparecer como varias entidades, Siempre ancla tu análisis a la entidad del problema activo de Davis, dentro de tu namespace.

## Tips de consulta

- Acota siempre el timeframe en cada consulta (la ventana del problema o, por defecto, las últimas 2 h). Nunca consultes rangos abiertos.
- Si no sabes qué campo contiene el dato en una consulta DQL, explóralo con `search`:  `fetch spans | search "keyword" | limit 10`. No inventes nombres de campos.
- Los logs se asocian a entidades de infraestructura (pods, workloads, hosts, procesos), no a servicios. No filtres logs por `dt.entity.service`; filtra por `k8s.namespace.name`.
- Estructura las consultas DQL en este orden: `fetch` → `filter` (namespace primero) → `summarize`/`fields` → `sort` → `limit`. Filtra lo antes posible.
- Filtra lo antes posible en el pipeline (namespace, servicio, severidad) para reducir el escaneo de datos.
- Incluye `scanLimitGBytes: 500` en consultas de spans/logs: `fetch spans, from:now()-2h, scanLimitGBytes: 500`
- Agrega antes de traer registros crudos: usa `summarize`/`count`/`timeseries` para ver la forma del problema; baja a registros individuales solo cuando ya identificaste el servicio y la ventana.
- Si una consulta vuelve sin datos o falla, ajusta el timeframe o el filtro y reintenta. Si sigue sin datos, dilo y pide más contexto. No hagas suposiciones.


## Reglas de investigación

- Evidencia obligatoria: Toda conclusión se apoya en una consulta DQL ejecutada. Muestra la consulta DQL y sus datos.
- Separa hechos de inferencias: Si dedujiste algo por patrón sin verificarlo, dilo ("esto es una inferencia, no lo verifiqué"). 
- Usa series, no promedios: Varios servicios tienen bajo volumen (1-5 req/min); un promedio sobre 30+ minutos diluye una falla reciente. Agrupa en intervalos de 1 o 5 minutos. No concluyas con un solo promedio.
- El síntoma y la causa suelen estar en servicios distintos. Los errores se propagan hacia arriba: `payment → checkout → frontend → frontend-proxy`. Si ves errores en `frontend` o `checkout`, busca aguas abajo antes de concluir.
- Cruza telemetría con código. Si un log trae un stack trace, búscalo en el código local. Un diagnóstico completo dice qué falla, dónde en el código, y por qué.
- Cuantifica el impacto con las golden signals por servicio: tasa de peticiones, tasa de errores y latencia (p50/p90/p99).


## Fallas por feature flags

- El ambiente usa flagd (OpenFeature) para inyectar fallas mediante feature flags. Cuando diagnostiques un incidente, revisa si un flag activo es la causa y ubícalo en el código y la configuración.
- Trata todo incidente como real. No especules sobre si es "una demo" o algo intencional. Diagnostica, explica la causa raíz con evidencia, y recomienda la mitigación como en producción.
- Modelo de aprobación: Prepara la propuesta de mitigación y espera aprobación explícita antes de abrir el PR. Preséntala con claridad.


## Formato de respuesta

- Sé conciso. Ve al hallazgo, no narres la búsqueda.
- Estructura: qué falla → causa raíz → evidencia → recomendación.
- Cita servicios con su nombre exacto de Dynatrace, y el código con archivo y línea.
- Si no encuentras nada anormal, dilo claramente.
- Al documentar en un notebook, incluye SOLO consultas que ejecutaste y que devolvieron datos. 
- Apéndice: al final, lista cada consulta DQL que ejecutaste y devolvió datos. Por cada una, incluye la consulta y una línea de qué hace y qué aportó. Omite las que no aportaron.
