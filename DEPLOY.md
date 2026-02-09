# Deploy en Coolify

Este proyecto está listo para desplegarse en [Coolify](https://coolify.io). **Solo se despliega el contenedor de Strapi**; la base de datos MySQL es tu servidor externo (no va en ningún contenedor).

## Opción 1: Docker Compose

1. **Nuevo recurso** → **Application** → Conectar tu repo (GitHub/GitLab, etc.).
2. **Build pack**: **Docker Compose**.
3. **Repository**, **Branch** y **Base directory** (ej. `ctpr`).
4. **Docker Compose file location**: `docker-compose.yml`.
5. **Variables de entorno** en Coolify (todas las de `.env.example`), sobre todo:
   - `DATABASE_HOST`: host de tu servidor MySQL (IP o dominio).
   - `DATABASE_PORT`: `3306` (o el puerto que uses).
   - `DATABASE_NAME`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`: credenciales del MySQL externo.
   - Resto de secrets de Strapi: `APP_KEYS`, `API_TOKEN_SALT`, `ADMIN_JWT_SECRET`, `TRANSFER_TOKEN_SALT`, `JWT_SECRET`, `ENCRYPTION_KEY`.
6. Activar **Preserve code** si quieres persistir `public/uploads` en el servidor.
7. **Deploy**.

---

## Opción 2: Solo Dockerfile

1. **Nuevo recurso** → **Application** → Repo.
2. **Build pack**: **Dockerfile**.
3. **Base directory**: `ctpr`.
4. **Dockerfile location**: `Dockerfile`.
5. **Variables de entorno**: las mismas que arriba; `DATABASE_HOST` debe ser la IP o hostname de tu MySQL externo (accesible desde el servidor donde corre Coolify).
6. **Port**: `1337`.
7. **Deploy**.

---

## Variables de entorno (MySQL externo)

| Variable | Descripción |
|----------|-------------|
| `APP_KEYS` | Claves separadas por coma (ej. `key1,key2`). |
| `API_TOKEN_SALT` | Salt para API tokens. |
| `ADMIN_JWT_SECRET` | Secret JWT del panel admin. |
| `TRANSFER_TOKEN_SALT` | Salt para transfer tokens. |
| `JWT_SECRET` | Secret JWT del plugin Users & Permissions. |
| `ENCRYPTION_KEY` | Clave de cifrado. |
| `DATABASE_CLIENT` | `mysql`. |
| `DATABASE_HOST` | **Host de tu servidor MySQL** (IP o dominio). |
| `DATABASE_PORT` | `3306` (por defecto MySQL). |
| `DATABASE_NAME` | Nombre de la base de datos. |
| `DATABASE_USERNAME` | Usuario MySQL. |
| `DATABASE_PASSWORD` | Contraseña MySQL. |

Generar valores seguros en producción (ej. `openssl rand -base64 32`).

---

## Red y firewall

- El servidor (o contenedor) donde corre Strapi en Coolify debe poder conectar por TCP al puerto **3306** de tu servidor MySQL (firewall y reglas de red permitiendo ese acceso).

---

## Volúmenes

- **Uploads**: en `docker-compose.yml` se monta `./public/uploads` para que los archivos subidos persistan. Con “Preserve code” en Coolify, ese directorio se mantiene.

---

## Comandos útiles

- **Build local**:
  ```bash
  docker build -t ctpr-strapi:latest .
  ```

- **Levantar con compose en local** (con `.env` apuntando a tu MySQL):
  ```bash
  docker compose up -d
  ```

- **Logs en Coolify**: pestaña **Logs** del recurso para depurar arranque o conexión a la DB.
