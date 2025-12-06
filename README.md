# TTPS Opción Ruby - Trabajo Práctico Integrador

## Requerimientos
* rails 8.1.1
* ruby  3.4.5
* wkhtmltopdf


## Para correr localmente el proyecto
1. bundle install
2. rails db:reset
3. ./bin/dev
 

## Usuarios de prueba
### Rol Admin
  ```
    email: admin@example.com
    password: password123
  ```
### Rol Manager
  ```
    email: manager@example.com
    password: password123
  ```
### Rol Empleado
  ```
    email: employee@example.com
    password: password123
  ```

## Algunas de las GEMAS UTILIZADAS

- **Devise**: autenticación
- **Pundit**: manejo de permisos de usuarios
- **Byebug**: para debuguear.
- **Tailwind**: para los estilos en las vistas.
- **Paranoia**: borrado lógico.
- **Wicked_pdf** y wkhtmltopdf-binary: generación de pdfs.
- **Chartkick** y **groupdate**: gráficos de torta, tablas, etc.  (reporte de ventas)
- **Kaminari**: paginación.
- **Bullet**: detectar queries n+1.