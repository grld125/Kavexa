-- ======================================
-- RLS (Row-Level Security) para Kavexa
-- ======================================
-- Este script habilita seguridad por filas para asegurar que:
-- 1. Cada usuario sólo acceda a sus propios registros.
-- 2. Si el rol es 'admin', accede a toda su organización.
-- Requiere que el backend configure:
-- SET app.user_id = 'uuid_usuario';
-- SET app.user_rol = 'admin' | 'analista' | 'operador';

-- ======================================
-- Función auxiliar para acceso por organización (solo para admins)
-- ======================================
CREATE OR REPLACE FUNCTION misma_organizacion(usuario UUID)
RETURNS BOOLEAN AS $$
BEGIN
RETURN EXISTS (
    SELECT 1 FROM usuarios u1
    JOIN usuarios u2 ON u1.organizacion_id = u2.organizacion_id
    WHERE u2.usuario_id = current_setting('app.user_id')::UUID
    AND u1.usuario_id = usuario
);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ======================================
-- Tablas clave: productos, movimientos_financieros, movimientos_stock, predicciones_flujo, categorias_financieras, alertas, configuracion_alertas
-- ======================================

-- Activa RLS y define política por tabla:

-- Tabla: productos
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
CREATE POLICY rls_productos
ON productos
USING (
    current_setting('app.user_rol') != 'admin' AND usuario_id = current_setting('app.user_id')::UUID
    OR current_setting('app.user_rol') = 'admin' AND misma_organizacion(usuario_id)
);

-- Tabla: movimientos_financieros
ALTER TABLE movimientos_financieros ENABLE ROW LEVEL SECURITY;
CREATE POLICY rls_movimientos_financieros
ON movimientos_financieros
USING (
    current_setting('app.user_rol') != 'admin' AND usuario_id = current_setting('app.user_id')::UUID
    OR current_setting('app.user_rol') = 'admin' AND misma_organizacion(usuario_id)
);

-- Tabla: movimientos_stock
ALTER TABLE movimientos_stock ENABLE ROW LEVEL SECURITY;
CREATE POLICY rls_movimientos_stock
ON movimientos_stock
USING (
    current_setting('app.user_rol') != 'admin' AND usuario_id = current_setting('app.user_id')::UUID
    OR current_setting('app.user_rol') = 'admin' AND misma_organizacion(usuario_id)
);

-- Tabla: predicciones_flujo
ALTER TABLE predicciones_flujo ENABLE ROW LEVEL SECURITY;
CREATE POLICY rls_predicciones_flujo
ON predicciones_flujo
USING (
    current_setting('app.user_rol') != 'admin' AND usuario_id = current_setting('app.user_id')::UUID
    OR current_setting('app.user_rol') = 'admin' AND misma_organizacion(usuario_id)
);

-- Tabla: categorias_financieras
ALTER TABLE categorias_financieras ENABLE ROW LEVEL SECURITY;
CREATE POLICY rls_categorias_financieras
ON categorias_financieras
USING (
    current_setting('app.user_rol') != 'admin' AND usuario_id = current_setting('app.user_id')::UUID
    OR current_setting('app.user_rol') = 'admin' AND misma_organizacion(usuario_id)
);

-- Tabla: alertas
ALTER TABLE alertas ENABLE ROW LEVEL SECURITY;
CREATE POLICY rls_alertas
ON alertas
USING (
    current_setting('app.user_rol') != 'admin' AND usuario_id = current_setting('app.user_id')::UUID
    OR current_setting('app.user_rol') = 'admin' AND misma_organizacion(usuario_id)
);

-- Tabla: configuracion_alertas
ALTER TABLE configuracion_alertas ENABLE ROW LEVEL SECURITY;
CREATE POLICY rls_configuracion_alertas
ON configuracion_alertas
USING (
    current_setting('app.user_rol') != 'admin' AND usuario_id = current_setting('app.user_id')::UUID
    OR current_setting('app.user_rol') = 'admin' AND misma_organizacion(usuario_id)
);


