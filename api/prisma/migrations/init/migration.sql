-- P6 · Nivel digital de obra

CREATE TABLE visita (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tecnico TEXT NOT NULL,
  mastil TEXT NOT NULL,
  azimut_objetivo REAL NOT NULL,
  iniciada_en TIMESTAMPTZ NOT NULL DEFAULT now(),
  cerrada_en TIMESTAMPTZ
);

CREATE TABLE medicion (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  visita_id UUID NOT NULL REFERENCES visita(id),
  inclinacion_x REAL NOT NULL,
  inclinacion_y REAL NOT NULL,
  azimut REAL NOT NULL,
  azimut_objetivo REAL NOT NULL,
  latitud DOUBLE PRECISION NOT NULL,
  longitud DOUBLE PRECISION NOT NULL,
  foto_ruta TEXT NOT NULL,
  cumple BOOLEAN NOT NULL,
  creada_en TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_medicion_visita ON medicion (visita_id);
