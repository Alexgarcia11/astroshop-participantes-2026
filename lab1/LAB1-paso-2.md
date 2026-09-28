# Instrucciones para el análisis de astroshop

Trabajas con el ambiente Dynatrace Playground para analizar la observabilidad de astroshop (e-commerce sobre Kubernetes). Los datos están en Grail y se consultan con DQL. Tu objetivo es diagnosticar problemas con el mínimo de consultas necesarias.

## Herramientas
- IMPORTANT: Consulta datos ÚNICAMENTE con las herramientas del servidor MCP `dynatrace-playground`. No uses el servidor MCP `dynatrace-lab` ni sus herramientas. No uses `dtctl`.

## Ambiente
- Aplicación: astroshop (microservicios) en Kubernetes.
- IMPORTANT: Filtra SIEMPRE por `matchesPhrase(k8s.namespace.name, "astroshop")` para acotar a la app.

## Método de análisis (síguelo en orden)
1. Empieza por lo ya detectado: revisa problemas y eventos detectados por Davis (la IA de Dynatrace) antes de explorar a ciegas.
2. Identifica las entidades afectadas (servicio, workload, pod, applicacion).
3. Cuantifica el impacto con las golden signals por servicio: tasa de peticiones, tasa de errores y latencia (p50/p90/p99).
4. Aísla el origen: compara la ventana del problema contra el estado previo y baja de servicio → span → log.
5. Confirma la causa raíz con evidencia concreta (spans fallidos, logs de error, saturación de CPU/memoria, etc).

## Fuentes de datos (confirma los nombres exactos en tu Playground)
- Problemas/eventos detectados: `dt.davis.problems`, `dt.davis.events`
- Trazas, latencia y errores por request: `spans`
- Logs de aplicación: `logs`
- Métricas de recursos/infra (CPU, memoria, saturación): `timeseries` sobre métricas
- Series temporales a partir de registros: `makeTimeseries` o `bin`


## Tips de consulta
- Acota siempre el timeframe en cada consulta (la ventana del problema o, por defecto, las últimas 2 h). Nunca consultes rangos abiertos.
- Si no sabes qué campo contiene el dato en una consulta DQL, explóralo con `search`:  `fetch spans | search "keyword" | limit 10`. No inventes nombres de campos.
- Los logs se asocian a entidades de infraestructura (pods, workloads, hosts, procesos), no a servicios. No filtres logs por `dt.entity.service`; filtra por `k8s.namespace.name`.
- Estructura las consultas DQL en este orden: `fetch` → `filter` (namespace primero) → `summarize`/`fields` → `sort` → `limit`. Filtra lo antes posible.
- Filtra lo antes posible en el pipeline (namespace, servicio, severidad) para reducir el escaneo de datos.
- Incluye `scanLimitGBytes: 500` en consultas de spans/logs: `fetch spans, from:now()-2h, scanLimitGBytes: 500`
- Agrega antes de traer registros crudos: usa `summarize`/`count`/`timeseries` para ver la forma del problema; baja a registros individuales solo cuando ya identificaste el servicio y la ventana.
- Si una consulta vuelve sin datos o falla repetidamente, ajusta el timeframe o el filtro y reintenta. Si sigue sin datos, dilo y pide más contexto. No hagas suposiciones.
- Añade `limit` (y `sort` cuando aplique) a toda consulta que devuelva registros.


## Reglas de investigación
- Evidencia obligatoria: Toda conclusión se apoya en una consulta DQL ejecutada. Muestra la consulta DQL y sus datos.
- Separa hechos de inferencias: Si dedujiste algo por patrón sin verificarlo, dilo ("esto es una inferencia, no lo verifiqué"). 
- Usa series, no promedios: Varios servicios tienen bajo volumen (1-5 req/min); un promedio sobre 30+ minutos diluye una falla reciente. Agrupa en intervalos de 1 o 5 minutos. No concluyas con un solo promedio.
- Cuantifica el impacto con las golden signals por servicio: tasa de peticiones, tasa de errores y latencia (p50/p90/p99).


## Rigor (para que el análisis sea verificable)
- IMPORTANT: Basa cada conclusión solo en datos que una consulta haya devuelto. Si un dato no aparece, dilo; no lo asumas ni lo inventes.
- Muestra siempre la consulta DQL que ejecutaste.

## Formato de cada hallazgo
- Sé conciso. Ve al hallazgo, no narres la búsqueda.
- Estructura: qué falla → causa raíz → evidencia → recomendación.
- Síntoma: qué se observa, con el valor/métrica.
- Evidencia: la consulta DQL y su resultado clave.
- Entidad afectada: servicio / workload / pod / frontend.
- Causa raíz (hipótesis).
- Recomendación / siguiente paso.
- Apéndice: al final, lista cada consulta DQL que ejecutaste y devolvió datos. Por cada una, incluye la consulta y una línea de qué hace y qué aportó. Omite las que no aportaron.