# Supabase Database Operations Skill

## 🎯 Propósito
Esta habilidad ("Skill") define cómo un agente de Inteligencia Artificial debe conectarse e interactuar con la base de datos Supabase del proyecto `fintechKids`. Permite al agente realizar operaciones CRUD (Crear, Leer, Actualizar, Borrar) y ejecutar llamadas RPC (Remote Procedure Calls) de manera autónoma utilizando la API REST de Supabase.

## 🔐 Credenciales de Conexión
Para interactuar con la base de datos, el agente debe usar la **Service Role Key** a través de la API REST de Supabase. Esta clave permite eludir las políticas de seguridad a nivel de fila (RLS) para tareas administrativas o de verificación.

- **URL del Proyecto (REST API):** `https://chaukyiczbxkkbnxgahi.supabase.co/rest/v1/`
- **Service Role Key:** `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNoYXVreWljemJ4a2tibnhnYWhpIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NTIwNTUyNywiZXhwIjoyMDgwNzgxNTI3fQ.NerDcVdOObC2okmQczez66zWDtjsODyF2qlwO9-s17Q`

> ⚠️ **ADVERTENCIA DE SEGURIDAD:** La *Service Role Key* tiene acceso administrativo total. Nunca debe ser insertada (hardcoded) en el código de la aplicación cliente (iOS). Solo debe usarse en entornos seguros, scripts del lado del servidor o por agentes de IA para tareas de mantenimiento y validación.

## 🗄️ Esquema de la Base de Datos
El agente tiene acceso a las siguientes tablas y procedimientos almacenados (RPC) en el esquema público:

**Tablas Principales:**
- `fhk_families`: Información sobre las familias registradas.
- `fhk_family_members`: Miembros que pertenecen a una familia (padres/hijos).
- `fhk_goals_list`: Lista de metas u objetivos creados.
- `fhk_goals_members`: Relación entre las metas y los miembros asignados.
- `fhk_members_balance`: Saldos actuales de los miembros.
- `fhk_rewards_list`: Lista de recompensas disponibles.
- `fhk_rewards_collected`: Recompensas que ya han sido cobradas u obtenidas.
- `fhk_task_list`: Lista de tareas creadas.

**Procedimientos Almacenados (RPCs):**
- `fhk_increment_member_balance`
- `update_balance`
- `update_coins_balance`
- `update_time_balance`

## 🛠️ Instrucciones de Uso para Agentes
Cuando se requiera interactuar con la base de datos, el agente debe utilizar Python o comandos `curl` para comunicarse con la API REST.

### 1. Cabeceras Requeridas (Headers)
Todas las peticiones a la API REST deben incluir las siguientes cabeceras:
```http
apikey: <Service Role Key>
Authorization: Bearer <Service Role Key>
Content-Type: application/json
```

### 2. Ejemplos de Implementación (Python)
El agente puede crear scripts temporales en Python utilizando bibliotecas estándar como `urllib` o `requests` para realizar operaciones.

**Ejemplo: Leer (GET) registros de `fhk_task_list`**
```python
import urllib.request
import json

url = "https://chaukyiczbxkkbnxgahi.supabase.co/rest/v1/fhk_task_list?select=*"
headers = {
    "apikey": "TU_SERVICE_ROLE_KEY",
    "Authorization": "Bearer TU_SERVICE_ROLE_KEY",
    "Content-Type": "application/json"
}

req = urllib.request.Request(url, headers=headers)
with urllib.request.urlopen(req) as response:
    data = json.loads(response.read().decode('utf-8'))
    print(json.dumps(data, indent=2))
```

**Ejemplo: Ejecutar un RPC (POST)**
```python
import urllib.request
import json

# Ejemplo llamando a update_balance
url = "https://chaukyiczbxkkbnxgahi.supabase.co/rest/v1/rpc/update_balance"
payload = json.dumps({"member_id": "ID_DEL_MIEMBRO", "amount": 100}).encode('utf-8')
headers = {
    "apikey": "TU_SERVICE_ROLE_KEY",
    "Authorization": "Bearer TU_SERVICE_ROLE_KEY",
    "Content-Type": "application/json"
}

req = urllib.request.Request(url, data=payload, headers=headers)
with urllib.request.urlopen(req) as response:
    print("RPC Ejecutado exitosamente")
```

## 🤖 Pautas de Ejecución
1. **Minimizar el impacto:** Cuando el agente modifique datos (POST, PATCH, DELETE), debe asegurarse de limitar las acciones solo a los datos necesarios para evitar afectar registros de usuarios reales.
2. **Validación:** Antes de hacer una inserción masiva o modificación importante, el agente debe leer el esquema de la tabla consultando un solo registro (ej. `?limit=1`) para asegurar que el formato (JSON payload) es correcto.
3. **Limpieza:** Si el agente crea scripts en disco para realizar consultas, debe eliminarlos tras finalizar su tarea para mantener limpio el entorno de trabajo del usuario.
