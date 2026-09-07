# Filament Assistant — AI agent v Langflow

**Domácí úkol č. 2 · Kurz AI Agenti · Lukáš Kellerstein**

No-code AI agent postavený v Langflow, který spravuje inventář filamentů pro 3D tisk. Používá PostgreSQL jako databázi, tři nástroje (SQL Query, Calculator, Web Search) a odpovídá na dotazy přes Claude Haiku 4.5.

## Motivace

Ve své hobby praxi (návrh a tisk vlastních CAD dílů — enclosury pro Raspberry Pi kamery, přípravky pro Festool Domino, custom brackety pro automotive projekty ....) točím desítky cívek filamentu různých značek. Ruční hledání „kolik mi zbývá PETG černý" nebo „který filament snese 100 °C" je otravné. Tenhle agent to řeší přirozeným jazykem.

## Architektura

```
[Chat Input]
    ↓
[Agent (Anthropic Claude Haiku 4.5)]
    │  ├─ Tool 1: query_postgres    → PostgreSQL (tabulka filaments, print_jobs)
    │  ├─ Tool 2: Calculator        → matematické výpočty (gramy, hodiny)
    │  └─ Tool 3: Web Search        → DuckDuckGo (fallback pro obecné dotazy)
    ↓
[Chat Output]
```

**6 nodů, 5 propojení, žádný custom Python** — postaveno výhradně z nativních Langflow komponent, takže je to portabilní na jakoukoliv instanci Langflow 1.12+.

## Struktura projektu

```
filament-agent/
├── docker-compose.yml           # Postgres 16 + Langflow 1.12
├── .env.example                 # Šablona pro LANGFLOW_SECRET_KEY (skutečné .env je gitignored)
├── db-init/
│   ├── 00-langflow-db.sql       # Vytvoří sam. databazi 'langflow_db' pro internal storage Langflow
│   ├── 01-schema.sql            # Tabulky filaments a print_jobs v 'filament_db'
│   └── 02-seed.sql              # 15 reálných cívek + historie tisků
├── flows/
│   └── 3D-filament-asistent.json  # Exportovaný Langflow workflow (ODEVZDÁVANÝ SOUBOR)
├── docs/
│   ├── *.png       # několik screenshots komunikace s asistentem
├── .gitignore
└── README.md
```

## Jak to spustit

Předpoklady: Docker Desktop + Docker Compose v2+.

```bash
cd filament-agent

# 1. Vygeneruj vlastní .env s LANGFLOW_SECRET_KEY
cp .env.example .env
# a v .env nahraď 'your-random-32-byte-base64-key-here' následujícím:
openssl rand -base64 32

# 2. Nastartuj Postgres + Langflow
docker compose up -d

# 3. Ověř že Postgres má seed data
docker exec filament-postgres psql -U filament -d filament_db -c "SELECT count(*) FROM filaments;"
# Očekávaný výstup: 15

# 4. Otevři Langflow v prohlížeči
open http://localhost:7860
```

V Langflow UI:

1. **My Projects** (vlevo nahoře) → tlačítko **Upload** nebo **Import**.
2. Vyber soubor `flows/3D-filament-asistent.json`.
3. Otevři importovaný flow.
4. V Agent nodu vlož svůj **Anthropic API key** (Langflow automaticky sanituje credentials při exportu, takže pole je prázdné):
   - Klikni na Agent node → pole `Anthropic API Key` → vlož `sk-ant-api03-...`
   - Klic si vygeneruješ na [console.anthropic.com/settings/keys](https://console.anthropic.com/settings/keys)
5. Klikni **Playground** (vpravo nahoře) a začni chatovat.

## Ukázkové dotazy

**Přes SQL tool:**
- „Kolik mi zbývá černého PETG?"
- „Které cívky vydrží teplotu nad 100 stupňů?"
- „Kdy jsem naposledy tiskl z Prusamentu?"
- „Přidej mi novou cívku: Prusament PETG Galaxy Silver, průměr 1.75, šedá, tryska 240, podložka 85, 1000 g."

**Přes Calculator:**
- „Pokud každý tisk sežral průměrně 62 g PLA, kolik cívek 1 kg vydrží na 25 tisků?"

**Přes Web Search (fallback):**
- „Co je za firmu Fillamentum a odkud pochází?"
- „Vyplatí se koupit Prusament Galaxy Silver nebo je lepší Fiberlogy Silk Silver?"

## Databázové schéma (výtah)

**filaments** — inventář cívek
- `id`, `brand`, `name`, `material`, `diameter_mm`, `color`, `color_hex`
- `nozzle_temp_c`, `bed_temp_c` — doporučené teploty
- `remaining_g`, `spool_weight_g` — kolik zbývá / celková hmotnost
- `heat_resist_c` — teplotní odolnost hotového výtisku
- `is_flexible`, `is_food_safe` — flagy
- `notes`, `last_used_at`

**print_jobs** — historie tiskových jobů
- `filament_id` (FK), `part_name`, `printed_at`, `duration_min`, `material_used_g`, `outcome`, `notes`

Seed obsahuje 15 reálných cívek od výrobců Prusament, Fiberlogy, Devil Design, Polymaker, Fillamentum a Sunlu, plus 5 ukázkových tiskových jobů.

## Klíčové designové volby

- **Model Anthropic Claude Haiku 4.5** — dobrý poměr cena/kvalita, výborný tool calling, česky odpovídá přirozeně.
- **Systémový prompt agenta v češtině** — používá české technické názvosloví (tryska, podložka, cívka, výtisk), ne anglické překlady.
- **Tři různé druhy nástrojů** — DB dotaz (strukturovaná data), matematický kalkulátor (kvantitativní úvahy), web search (fallback na externí znalost). Ukazuje, že agent umí zvolit správný nástroj podle typu dotazu.
- **SSRF whitelisting** — Langflow 1.12 by default blokuje připojení na interní hostnames (obrana proti SSRF útokům). V compose je nastaveno `LANGFLOW_SSRF_ALLOWED_HOSTS=postgres,host.docker.internal`, aby SQL tool směl kontaktovat interní Postgres.
- **Perzistentní metadata Langflow v Postgresu** — flow definice, users, credentials a message history žijí v sam. databázi `langflow_db` v Postgres kontejneru. `LANGFLOW_SECRET_KEY` z `.env` zajišťuje, že šifrované credentials přežijí restart.

## Známé limity

- SQL Query tool posílá modelu raw SQL, které si sám vygeneruje. Pro produkci by chtělo whitelist tabulek / read-only DB user.
- Chat memory je součástí Playgroundu Langflow, po restartu kontejneru zmizí (Simple Memory v RAM).

## Odevzdávaný soubor

**`flows/3D-filament-asistent.json`** — kompletní definice Langflow workflow (179 kB). Stačí importovat do Langflow 1.12+, doplnit Anthropic API klíč a spustit.

---

*Autor: David Libiger, GlobeDay s.r.o. · Září 2026*
