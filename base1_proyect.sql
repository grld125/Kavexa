-- Crear base de datos
CREATE DATABASE dbu1;



-- Tabla de organizaciones
CREATE TABLE organizaciones (
    organizacion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre TEXT NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT now(),
    configuracion JSONB
);

-- Tabla de usuarios
CREATE TABLE usuarios (
    usuario_id UUID PRIMARY KEY REFERENCES auth.users (id),
    organizacion_id UUID NOT NULL REFERENCES organizaciones (organizacion_id),
    nombre TEXT NOT NULL,
    correo TEXT UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT now(),
    ultimo_login TIMESTAMP
);

-- Tabla de roles de usuarios
CREATE TABLE roles_usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios (usuario_id),
    rol TEXT NOT NULL CHECK (rol IN ('admin', 'analista', 'operador')),
    creado TIMESTAMP DEFAULT now()
);

-- Tabla de módulos
CREATE TABLE modulos (
    nombre TEXT PRIMARY KEY,
    descripcion TEXT
);

-- Tabla de módulos activos
CREATE TABLE modulos_activos (
    usuario_id UUID REFERENCES usuarios (usuario_id),
    modulo TEXT REFERENCES modulos (nombre),
    activado BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (usuario_id, modulo)
);

-- Categorías financieras
CREATE TABLE categorias_financieras (
    categoria_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES usuarios (usuario_id),
    nombre TEXT NOT NULL,
    tipo TEXT CHECK (tipo IN ('ingreso', 'egreso', 'ambos')),
    UNIQUE (usuario_id, nombre)
);

-- Movimientos financieros
CREATE TABLE movimientos_financieros (
    movimiento_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios (usuario_id),
    tipo TEXT NOT NULL CHECK (tipo IN ('ingreso', 'egreso')),
    categoria_id UUID REFERENCES categorias_financieras (categoria_id),
    descripcion TEXT,
    monto NUMERIC(12,2) NOT NULL CHECK (monto > 0),
    fecha TIMESTAMP NOT NULL DEFAULT now(),
    documento_ref TEXT,
    monto_estimado NUMERIC(12,2),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Productos
CREATE TABLE productos (
    producto_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES usuarios (usuario_id),
    nombre TEXT NOT NULL,
    descripcion TEXT,
    unidad TEXT NOT NULL,
    precio_actual NUMERIC(12,2) NOT NULL,
    stock_minimo INTEGER DEFAULT 0,
    punto_reorden INTEGER,
    proveedor TEXT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Movimientos de stock
CREATE TABLE movimientos_stock (
    movimiento_stock_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID REFERENCES usuarios (usuario_id),
    producto_id UUID REFERENCES productos (producto_id),
    tipo TEXT NOT NULL CHECK (tipo IN ('entrada', 'salida')),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2),
    motivo TEXT,
    documento_ref TEXT,
    movimiento_financiero_id UUID REFERENCES movimientos_financieros(movimiento_id),
    fecha TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now()
);

-- Predicciones de flujo
CREATE TABLE predicciones_flujo (
    prediccion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios (usuario_id),
    fecha_prediccion TIMESTAMP NOT NULL DEFAULT now(),
    fecha_inicio_periodo DATE NOT NULL,
    fecha_fin_periodo DATE NOT NULL,
    flujo_estimado NUMERIC(12,2) NOT NULL,
    intervalo_confianza NUMERIC(5,2),
    fuente TEXT NOT NULL CHECK (fuente IN ('modelo_lstm', 'modelo_arima', 'manual')),
    parametros_modelo JSONB,
    modelo_usado TEXT,
    comentarios TEXT,
    exactitud_historica NUMERIC(5,2),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    CONSTRAINT valid_period CHECK (fecha_fin_periodo > fecha_inicio_periodo)
);

-- Tabla unificada de alertas
CREATE TABLE alertas (
    alerta_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios (usuario_id),
    tipo_alerta TEXT NOT NULL CHECK (
        tipo_alerta IN ('stock', 'financiera', 'flujo', 'fraude', 'otros')
    ),
    tipo TEXT NOT NULL,
    gravedad TEXT CHECK (gravedad IN ('baja', 'media', 'alta', 'critica')),
    mensaje TEXT NOT NULL,
    cantidad_afectada NUMERIC(10,2),
    nivel_actual NUMERIC(10,2),
    nivel_minimo NUMERIC(10,2),
    fecha_deteccion TIMESTAMP NOT NULL DEFAULT now(),
    fecha_resolucion TIMESTAMP,
    estado TEXT NOT NULL CHECK (estado IN ('pendiente', 'revisada', 'resuelta', 'descartada')) DEFAULT 'pendiente',
    relacionado_a UUID,
    tipo_relacion TEXT,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT now(),
    CONSTRAINT fk_alerta_relacion CHECK (
        (tipo_relacion IS NULL AND relacionado_a IS NULL)
        OR (tipo_relacion IS NOT NULL AND relacionado_a IS NOT NULL)
    )
);

-- Configuración de alertas
CREATE TABLE configuracion_alertas (
    configuracion_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id UUID NOT NULL REFERENCES usuarios (usuario_id),
    tipo_alerta TEXT NOT NULL CHECK (tipo_alerta IN ('financiera', 'inventario')),
    parametros JSONB NOT NULL,
    notificar BOOLEAN DEFAULT TRUE,
    metodo_notificacion TEXT CHECK (metodo_notificacion IN ('email', 'push', 'ambos')),
    umbral_gravedad TEXT CHECK (umbral_gravedad IN ('baja', 'media', 'alta', 'critica')),
    created_at TIMESTAMP DEFAULT now(),
    updated_at TIMESTAMP DEFAULT now(),
    UNIQUE (usuario_id, tipo_alerta)
);
