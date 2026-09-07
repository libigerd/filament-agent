-- Filament inventory schema for the Filament Assistant agent
-- Author: Dave (GlobeDay s.r.o.)

CREATE TABLE IF NOT EXISTS filaments (
    id              SERIAL PRIMARY KEY,
    brand           VARCHAR(60)  NOT NULL,
    name            VARCHAR(120) NOT NULL,
    material        VARCHAR(20)  NOT NULL,   -- PLA, PETG, ABS, ASA, TPU, PA (nylon), PC-blend...
    diameter_mm     NUMERIC(3,2) NOT NULL DEFAULT 1.75,
    color           VARCHAR(60)  NOT NULL,
    color_hex       CHAR(7),                  -- '#RRGGBB'
    nozzle_temp_c   INT          NOT NULL,   -- doporucena tryska
    bed_temp_c      INT          NOT NULL,   -- doporucena podlozka
    remaining_g     INT          NOT NULL,   -- zbyva gramu
    spool_weight_g  INT          NOT NULL DEFAULT 1000,
    heat_resist_c   INT,                      -- do jake teploty vydrzi hotovy vytisk
    is_flexible     BOOLEAN      NOT NULL DEFAULT FALSE,
    is_food_safe    BOOLEAN      NOT NULL DEFAULT FALSE,
    notes           TEXT,
    last_used_at    DATE,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_filaments_material ON filaments(material);
CREATE INDEX IF NOT EXISTS idx_filaments_brand    ON filaments(brand);

-- Historie tisku pro rozsirene otazky ("na cem jsem naposledy tiskl...")
CREATE TABLE IF NOT EXISTS print_jobs (
    id              SERIAL PRIMARY KEY,
    filament_id     INT REFERENCES filaments(id) ON DELETE SET NULL,
    part_name       VARCHAR(120) NOT NULL,
    printed_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    duration_min    INT,
    material_used_g INT,
    outcome         VARCHAR(20)  NOT NULL,   -- OK, FAIL, PARTIAL
    notes           TEXT
);

CREATE INDEX IF NOT EXISTS idx_print_jobs_filament ON print_jobs(filament_id);
