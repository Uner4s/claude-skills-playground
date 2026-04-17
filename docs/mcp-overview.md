# Guía MCP — Model Context Protocol

> Documentación basada en explicación conversacional — del restaurante al código real

---

## ¿Qué es MCP?

MCP (Model Context Protocol) es un protocolo que permite que modelos de lenguaje
como Claude se comuniquen con herramientas y servicios externos de forma
estandarizada. Tiene dos piezas principales: el **Client** y el **Server**.

---

## La analogía del restaurante

| Elemento    | En la vida real                           | En MCP                                               |
| ----------- | ----------------------------------------- | ---------------------------------------------------- |
| Cliente     | Quiere que le resuelvan algo              | Tu app (NestJS, script Python, etc.)                 |
| Chef        | Piensa, decide qué preparar y cómo       | **Claude** — decide qué tools invocar y cuándo       |
| Mesero      | Toma el pedido y lo lleva a la cocina    | **MCP Client** — hace de puente y habla el protocolo |
| Restaurante | Tiene cocineros y sabe preparar los platos | **MCP Server** — tiene las tools y capacidades      |

> El restaurante por sí solo **no hace nada** si nadie le ordena algo. El server
> solo _expone_ herramientas y espera instrucciones. Es Claude quien decide cuándo
> usarlas y en qué orden.

---

## El actor central: Claude

Claude no es solo "el que responde". En el flujo MCP, Claude es quien:

- Lee el contexto de la conversación
- Decide cuándo invocar una tool (y cuál)
- Interpreta el resultado y decide si invocar otra o responder directamente
- Orquesta múltiples tools en secuencia cuando lo necesita

Ejemplo:

> "Tuve una reunión con el cliente sobre el bug de pagos, hay que hacer seguimiento"

Claude decide solo:
1. Invocar `create_jira_issue("Bug pagos - seguimiento cliente")`
2. Invocar `create_calendar_event("Follow-up pagos", próximo lunes)`
3. Invocar `send_email(cliente, "Próximos pasos...")`

Esa lógica de orquestación no la programás vos — la razona Claude en tiempo real.

---

## MCP Server

### ¿Para qué sirve?

El MCP Server **expone herramientas (tools)** que pueden ser invocadas. Es el
componente que contiene la lógica real: conectarse a una base de datos, llamar
una API externa, procesar archivos, etc.

### ¿Dónde vive?

**Siempre como una aplicación separada**, su propio proceso independiente. Así
puede ser reutilizado por múltiples clients al mismo tiempo.

```
┌──────────────────────┐
│     MCP Server       │  <- App separada, proceso independiente
│  - Tool: buscarUser  │
│  - Tool: crearOrden  │
│  - Tool: enviarEmail │
└──────────────────────┘
```

---

## MCP Client

### ¿Para qué sirve?

El MCP Client es la **capa de traducción** que sabe cómo:

1. Conectarse al MCP Server
2. Hacer el handshake inicial del protocolo
3. Listar las tools disponibles
4. Invocarlas correctamente y recibir la respuesta

Tu app no habla MCP de forma nativa (NestJS habla HTTP, un script Python habla
lo que vos programes, etc). El client resuelve eso.

### ¿Dónde vive?

**Dentro de tu aplicación**, como un módulo o servicio más. No es una app
separada.

```
┌─────────────────────────────────────────┐
│            Tu App NestJS                │
│                                         │
│  ┌────────────────┐  ┌───────────────┐  │
│  │    Claude      │◄►│  MCP Client   │  │  <- Client va AQUI ADENTRO
│  │  (el chef,     │  │  (el mesero,  │  │
│  │   decide qué   │  │   habla el    │  │
│  │   tools usar)  │  │   protocolo)  │  │
│  └────────────────┘  └───────────────┘  │
│                                         │
│  ProductsService, AuthService...        │
└───────────────────────┬─────────────────┘
                        │  stdio / SSE / HTTP
                        ▼
┌─────────────────────────────────────────┐
│           MCP Server                    │  <- App separada
│           (proceso aparte)              │
└─────────────────────────────────────────┘
```

---

## Regla de oro: ¿Dónde va cada uno?

| Componente     | ¿Dónde construirlo?                        | ¿Es una app separada? |
| -------------- | ------------------------------------------ | --------------------- |
| **MCP Client** | Dentro de tu app (módulo, servicio, clase) | No                    |
| **MCP Server** | Siempre como proceso independiente         | Sí                    |

### Ejemplos concretos

- **Script Python en terminal** — el client vive dentro del script
- **API NestJS** — el client vive como un módulo interno de NestJS
- **App React con backend** — el client vive en el backend, no en el frontend

---

## ¿Por qué siempre necesito definir el Client?

Podrías intentar llamar al MCP Server directamente con HTTP crudo... pero
tendrías que reimplementar a mano:

- El handshake del protocolo MCP
- El formato de mensajes
- El manejo de errores del protocolo
- El listado de tools disponibles

El **SDK del MCP Client ya hace todo eso por ti**. En tu NestJS puede ser
simplemente el SDK importado en un módulo, unas pocas líneas que se inicializan
y ya hablan con tu server.

---

## ¿En qué lenguaje construir el MCP Server?

### SDKs oficiales disponibles

| Lenguaje                 | SDK oficial                 | Madurez                   |
| ------------------------ | --------------------------- | ------------------------- |
| **TypeScript / Node.js** | `@modelcontextprotocol/sdk` | Más completo y usado      |
| **Python**               | `mcp` (de Anthropic)        | Muy completo              |
| **Kotlin / Java**        | SDK oficial                 | Más nuevo, menos ejemplos |

---

### ¿Cuándo usar Python?

Cuando tu server necesita trabajar con:

- Machine Learning / AI (numpy, pandas, sklearn, torch)
- Procesamiento de datos, ETLs
- Herramientas científicas o análisis estadístico
- Prototipado rápido de lógica compleja

```python
# Ejemplo: MCP Server en Python con tool de ML
@mcp.tool()
def predecir_categoria(texto: str) -> str:
    resultado = modelo.predict([texto])
    return resultado[0]
```

---

### ¿Cuándo usar TypeScript / Node.js?

Cuando tu server necesita:

- Integraciones con APIs web
- Ya tenés ecosistema JS en el equipo
- Aprovechar el ecosistema npm
- Es el más usado en la comunidad MCP hoy en día

```typescript
// Ejemplo: MCP Server en TypeScript
server.tool("buscarProducto", async ({ id }) => {
  const producto = await api.get(`/productos/${id}`);
  return { content: [{ type: "text", text: JSON.stringify(producto) }] };
});
```

---

### ¿Cuándo usar otros lenguajes (Go, Rust, Java)?

- Alto rendimiento requerido
- Ya tenés infraestructura en ese lenguaje en la empresa
- Los SDKs son menos maduros — menos ejemplos y comunidad

---

### Regla de oro para elegir lenguaje

> **Usa el lenguaje donde ya viven las librerías que tu server necesita consumir.**
>
> El server es un **puente**, así que que esté cerca de lo que va a usar.

- ¿Va a hacer cosas de datos o ML? — **Python sin dudarlo**
- ¿Va a integrar APIs web y ya usas NestJS? — **TypeScript, te quedás en el mismo ecosistema**
- ¿No tenés una razón técnica específica? — **TypeScript gana hoy por comunidad y madurez del SDK**

---

## Resumen visual completo

```
┌──────────────────────────────────────────────────────────────┐
│                   Tu Aplicación / Host                       │
│  (NestJS / Script Python / App React Backend / lo que sea)   │
│                                                              │
│  ┌──────────────────┐        ┌──────────────────────────┐   │
│  │      Claude      │◄──────►│       MCP Client         │   │
│  │  (decide qué     │        │  (módulo interno / SDK)  │   │
│  │   tools usar     │        │  habla el protocolo MCP  │   │
│  │   y cuándo)      │        └──────────────────────────┘   │
│  └──────────────────┘                    │                   │
└─────────────────────────────────────────┼────────────────────┘
                                          │  stdio / SSE / HTTP
                                          ▼
┌──────────────────────────────────────────────────────────────┐
│                      MCP Server                              │
│              (proceso separado / app aparte)                 │
│                                                              │
│  Lenguaje según lo que necesite:                             │
│  - Python  — ML, datos, ciencia                              │
│  - TS/Node — APIs web, ecosistema JS                         │
│  - Go/Rust — alto rendimiento                                │
└──────────────────────────────────────────────────────────────┘
```

---
