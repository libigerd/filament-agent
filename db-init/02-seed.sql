-- Seed data pro Filament Assistant
-- 15 realnych civek z reznych vyrobcu, mix materialu

INSERT INTO filaments
    (brand, name, material, diameter_mm, color, color_hex, nozzle_temp_c, bed_temp_c, remaining_g, spool_weight_g, heat_resist_c, is_flexible, is_food_safe, notes, last_used_at)
VALUES
    ('Prusament',    'PLA Galaxy Black',           'PLA',   1.75, 'cerna metalicka',  '#101820', 215, 60,  620, 1000,  55, FALSE, FALSE, 'Prusa doporucuje sunit trysku 0.6 mm pro velke plochy', '2026-08-14'),
    ('Prusament',    'PETG Jet Black',             'PETG',  1.75, 'cerna',            '#000000', 240, 85,  180, 1000,  70, FALSE, TRUE,  'Skoro dochazi - pripravit novou civku',              '2026-08-30'),
    ('Prusament',    'PETG Prusa Orange',          'PETG',  1.75, 'oranzova',         '#FF8C00', 240, 85,  875, 1000,  70, FALSE, TRUE,  'Referencni Prusa oranzova',                          '2026-07-22'),
    ('Prusament',    'ASA Signal White',           'ASA',   1.75, 'bila',             '#F5F5F5', 260, 100, 940, 1000,  95, FALSE, FALSE, 'Pro venkovni pouziti - UV stabilni',                 '2026-06-11'),
    ('Fiberlogy',    'PLA Silk Gold',              'PLA',   1.75, 'zlata silk',       '#D4AF37', 210, 55,  430, 850,   50, FALSE, FALSE, 'Pekny lesk, ale nizsi teplotni odolnost',            '2026-08-02'),
    ('Fiberlogy',    'PCTG Transparent',           'PCTG',  1.75, 'transparent',      NULL,      250, 90,  760, 1000,  80, FALSE, TRUE,  'Prumyslova varianta PETG - odolnejsi chemii',        '2026-07-01'),
    ('Fiberlogy',    'MattFlex 40D Black',         'TPU',   1.75, 'cerna',            '#111111', 225, 45,  510, 850,   60, TRUE,  FALSE, 'Shore 40D - stredne mekky, pomale tisknout',         '2026-08-20'),
    ('Devil Design', 'PLA Galaxy Purple',          'PLA',   1.75, 'fialova metalicka','#4B0082', 215, 60,  920, 1000,  55, FALSE, FALSE, 'Levna alternativa Prusamentu, kvalita OK',           '2026-05-30'),
    ('Devil Design', 'ABS+ White',                 'ABS',   1.75, 'bila',             '#FFFFFF', 250, 100, 340, 1000, 100, FALSE, FALSE, 'Vyzaduje uzavrenou tiskarnu, dratove pripevneni',    '2026-04-18'),
    ('Polymaker',    'PolyMax PC-FR Black',        'PC',    1.75, 'cerna',            '#0A0A0A', 270, 105, 620, 1000, 110, FALSE, FALSE, 'Polykarbonat - vysoka teplotni odolnost, samozhas',  '2026-03-12'),
    ('Polymaker',    'PolyMide CoPA Natural',      'PA',    1.75, 'natur',            '#E8DDC7', 265, 90,  480, 1000, 120, FALSE, FALSE, 'Nylon copolymer - susit pred tiskem (6h/80C)',       '2026-02-25'),
    ('Fillamentum',  'PLA Extrafill Vertigo Grey', 'PLA',   1.75, 'seda metalicka',   '#4A4A4A', 215, 60,  240, 750,   55, FALSE, FALSE, 'Ceska znacka, kvalitni PLA pro dekorativni tisk',    '2026-08-28'),
    ('Fillamentum',  'CPE HG100 Neon Green',       'CPE',   1.75, 'neonove zelena',   '#39FF14', 245, 90,  680, 750,   80, FALSE, FALSE, 'Copolyester - alternativa PETG, mensi civka',        '2026-06-06'),
    ('Sunlu',        'PLA+ Grey',                  'PLA+',  1.75, 'seda',             '#808080', 220, 60, 1000, 1000,  55, FALSE, FALSE, 'Nova civka, jeste nepouzita',                        NULL),
    ('Sunlu',        'PETG Skin',                  'PETG',  1.75, 'telova',           '#F5D5B0', 235, 80,  55,  1000,  70, FALSE, TRUE,  'Skoro prazdne - pouze na zbytkove tisky',            '2026-08-25');

-- Ukazkove tiskove joby
INSERT INTO print_jobs (filament_id, part_name, printed_at, duration_min, material_used_g, outcome, notes)
VALUES
    (1, 'Krabicka na sroubky',        '2026-08-14 18:22:00', 145, 62,  'OK',      NULL),
    (2, 'Drzak GoPro na Raspberry',   '2026-08-30 09:10:00', 220, 88,  'OK',      'Prvni layer bylo potreba pretisknout - zvedla se rohova cast'),
    (7, 'Silentblok pro Domino',      '2026-08-20 21:45:00', 95,  30,  'OK',      'TPU Shore 40D drzi vibrace vyborne'),
    (9, 'Testovaci kostka',           '2026-04-18 11:00:00', 25,  12,  'FAIL',    'Warping - potreba lepsi adheze podlozky'),
    (2, 'Kryt kamery pro ALPR',       '2026-08-25 14:30:00', 310, 145, 'OK',      'PETG - venkovni pouziti, snese slunce');
