-- ========================================
-- Configuración de Row-Level Security (RLS) para Kavexa
-- ========================================
-- Paso 1: Activar RLS en tablas sensibles por usuario

ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE roles_usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE modulos_activos ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias_financieras ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimientos_financieros ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimientos_stock ENABLE ROW LEVEL SECURITY;
ALTER TABLE predicciones_flujo ENABLE ROW LEVEL SECURITY;
ALTER TABLE alertas_inventario ENABLE ROW LEVEL SECURITY;
ALTER TABLE alertas_financieras ENABLE ROW LEVEL SECURITY;
ALTER TABLE configuracion_alertas ENABLE ROW LEVEL SECURITY;

-- Paso 2: Crear políticas básicas por usuario en cada tabla

-- usuarios
CREATE POLICY rls_usuarios_por_id
    ON usuarios
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- roles_usuarios
CREATE POLICY rls_roles_usuarios
    ON roles_usuarios
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- modulos_activos
CREATE POLICY rls_modulos_activos
    ON modulos_activos
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- categorias_financieras
CREATE POLICY rls_categorias_financieras
    ON categorias_financieras
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- movimientos_financieros
CREATE POLICY rls_movimientos_financieros
    ON movimientos_financieros
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- productos
CREATE POLICY rls_productos
    ON productos
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- movimientos_stock
CREATE POLICY rls_movimientos_stock
    ON movimientos_stock
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- predicciones_flujo
CREATE POLICY rls_predicciones_flujo
    ON predicciones_flujo
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- alertas_inventario
CREATE POLICY rls_alertas_inventario
    ON alertas_inventario
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- alertas_financieras
CREATE POLICY rls_alertas_financieras
    ON alertas_financieras
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- configuracion_alertas
CREATE POLICY rls_configuracion_alertas
    ON configuracion_alertas
    USING (usuario_id = current_setting('app.user_id')::UUID);

-- Paso 3: (opcional) Políticas ampliadas por organización para administradores

-- Ejemplo para movimientos_financieros
CREATE POLICY rls_admin_organizacion
    ON movimientos_financieros
    USING (
        usuario_id IN (
            SELECT usuario_id
            FROM usuarios
            WHERE organizacion_id = (
                SELECT organizacion_id
                FROM usuarios
                WHERE usuario_id = current_setting('app.user_id')::UUID
            )
        )
    );

-- Paso 4: Asignar variable de sesión desde backend (no desde el cliente)
-- SET app.user_id = 'xxxx-uuid-del-usuario';

-- Paso 5: Verificación
-- SELECT * FROM movimientos_financieros; -- Devolverá solo filas permitidas por RLS
