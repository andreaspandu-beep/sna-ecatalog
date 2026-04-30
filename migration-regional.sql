-- ============================================================
-- MIGRATION: Tambah fitur Regional Filter
-- Jalankan di Supabase > SQL Editor
-- ============================================================

-- 1. TABEL REGIONAL
CREATE TABLE regions (
  id         BIGSERIAL PRIMARY KEY,
  name       TEXT NOT NULL UNIQUE,
  is_active  BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABEL ATURAN KATEGORI PER REGIONAL
--    is_blocked = TRUE berarti kategori tsb TIDAK tampil di regional ini
CREATE TABLE region_category_rules (
  id          BIGSERIAL PRIMARY KEY,
  region_id   BIGINT NOT NULL REFERENCES regions(id) ON DELETE CASCADE,
  category_id BIGINT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  is_blocked  BOOLEAN DEFAULT TRUE,
  UNIQUE(region_id, category_id)
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE regions               ENABLE ROW LEVEL SECURITY;
ALTER TABLE region_category_rules ENABLE ROW LEVEL SECURITY;

-- Publik bisa baca
CREATE POLICY "public_read_regions"
  ON regions FOR SELECT USING (TRUE);

CREATE POLICY "public_read_region_rules"
  ON region_category_rules FOR SELECT USING (TRUE);

-- Admin (authenticated) bisa semua
CREATE POLICY "admin_all_regions"
  ON regions FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "admin_all_region_rules"
  ON region_category_rules FOR ALL USING (auth.role() = 'authenticated');

-- ============================================================
-- CONTOH DATA AWAL
-- (Sesuaikan category_id dengan ID di tabel categories Anda)
-- ============================================================

-- Tambah regional
INSERT INTO regions (name, is_active) VALUES
  ('Bali',              TRUE),
  ('Kalimantan Timur',  TRUE),
  ('NTT - NTB',         TRUE);

-- Contoh: di Bali, kategori "Cat" dan "Kayu & Panel" diblok
-- Cek dulu ID kategori Anda: SELECT id, name FROM categories;
-- Lalu sesuaikan angka di bawah ini:
--
-- INSERT INTO region_category_rules (region_id, category_id, is_blocked) VALUES
--   (1, 5, TRUE),   -- Bali blok Cat (id=5)
--   (1, 1, TRUE),   -- Bali blok Kayu & Panel (id=1)
--   (2, 6, TRUE),   -- Kaltim blok Alat & Aksesoris (id=6)
--   (3, 5, TRUE);   -- NTT-NTB blok Cat (id=5)
--
-- Atau langsung atur melalui Admin Panel > Regional > Atur Kategori
