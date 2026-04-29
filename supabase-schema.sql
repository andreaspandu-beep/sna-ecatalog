-- ============================================================
-- SUPABASE SQL SCHEMA
-- PT. Saka NiagaSukses Abadi — eCatalog
-- Jalankan di Supabase > SQL Editor
-- ============================================================

-- 1. TABEL KATEGORI
CREATE TABLE categories (
  id         BIGSERIAL PRIMARY KEY,
  name       TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABEL PRODUK
CREATE TABLE products (
  id           BIGSERIAL PRIMARY KEY,
  name         TEXT NOT NULL,
  category_id  BIGINT REFERENCES categories(id) ON DELETE SET NULL,
  description  TEXT,
  image_url    TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  is_active    BOOLEAN DEFAULT TRUE,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  updated_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABEL SPESIFIKASI PRODUK
CREATE TABLE product_specs (
  id         BIGSERIAL PRIMARY KEY,
  product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  label      TEXT NOT NULL,
  value      TEXT NOT NULL,
  sort_order INTEGER DEFAULT 0
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Aktifkan RLS
ALTER TABLE categories    ENABLE ROW LEVEL SECURITY;
ALTER TABLE products      ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_specs ENABLE ROW LEVEL SECURITY;

-- PUBLIC: boleh baca semua (untuk eCatalog user)
CREATE POLICY "public_read_categories"    ON categories    FOR SELECT USING (TRUE);
CREATE POLICY "public_read_products"      ON products      FOR SELECT USING (is_active = TRUE);
CREATE POLICY "public_read_product_specs" ON product_specs FOR SELECT USING (TRUE);

-- ADMIN: pengguna login bisa baca/tulis semua
CREATE POLICY "admin_all_categories"    ON categories    FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_products"      ON products      FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "admin_all_product_specs" ON product_specs FOR ALL USING (auth.role() = 'authenticated');

-- ============================================================
-- DATA AWAL (SAMPLE DATA)
-- ============================================================

-- Kategori
INSERT INTO categories (name) VALUES
  ('Kayu & Panel'),
  ('Atap & Dinding'),
  ('Perpipaan'),
  ('Baja & Besi'),
  ('Cat & Finishing'),
  ('Alat & Aksesoris');

-- Produk (sesuaikan category_id setelah insert kategori)
INSERT INTO products (name, category_id, description, image_url, is_available, is_active) VALUES
  ('Triplek / Plywood', 1, 'Triplek berkualitas tinggi untuk konstruksi, furniture, dan dekorasi interior. Tersedia berbagai ketebalan sesuai kebutuhan.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/xTripleks.jpg.pagespeed.ic_.NkFhRfsgbX-300x300.jpg', TRUE, TRUE),

  ('Spandek & Trimdek', 2, 'Atap spandek dan trimdek baja ringan anti karat, ideal untuk bangunan industri, pergudangan, dan perumahan.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/spandek-300x225.jpg', TRUE, TRUE),

  ('Seng', 2, 'Seng gelombang dan datar untuk berbagai kebutuhan atap dan dinding. Tahan cuaca dan mudah dipasang.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/seng-300x150.jpg', TRUE, TRUE),

  ('Pipa PVC & Besi', 3, 'Pipa PVC dan pipa besi untuk instalasi air bersih, air limbah, dan kebutuhan konstruksi bangunan.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/pipa-pvc-300x183.jpg', TRUE, TRUE),

  ('Paku', 6, 'Paku bangunan berbagai ukuran untuk kebutuhan konstruksi kayu, beton, dan rangka atap.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/124325_paku-300x198.jpg', TRUE, TRUE),

  ('Kawat', 6, 'Kawat baja dan kawat bendrat untuk tulangan beton, pengikatan, dan kebutuhan konstruksi lainnya.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/Kawat-300x180.jpg', TRUE, TRUE),

  ('Hollow / Besi Kotak', 4, 'Besi hollow (pipa kotak) untuk rangka partisi, pagar, canopy, dan berbagai kebutuhan konstruksi metal.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/holow-300x191.jpg', TRUE, TRUE),

  ('GRC Board', 1, 'GRC Board (Glass Fibre Reinforced Cement) untuk plafon, partisi, dan dinding eksterior. Tahan air dan api.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/GRC-Board-300x212.jpg', TRUE, TRUE),

  ('Floordeck / Bondek', 4, 'Floordeck/bondek baja sebagai bekisting permanen pengganti triplek untuk lantai beton komposit.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/floordeck-bondek-300x142.jpg', TRUE, TRUE),

  ('Ember Plastik', 6, 'Ember plastik berkualitas untuk kebutuhan konstruksi, pengecatan, dan material handling di lapangan.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/ember-300x225.jpg', TRUE, TRUE),

  ('Cat', 5, 'Cat tembok dan cat besi untuk interior maupun eksterior. Warna lengkap, daya tutup tinggi, tahan cuaca.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/cat-300x196.jpg', TRUE, TRUE),

  ('Besi Beton', 4, 'Besi beton polos dan ulir (deformed bar) sebagai tulangan struktur bangunan, jembatan, dan infrastruktur.',
   'https://www.sakaniagasuksesabadi.com/wp-content/uploads/2017/08/besi-beton-4-300x225.jpg', TRUE, TRUE);

-- Spesifikasi Produk (contoh untuk Triplek)
INSERT INTO product_specs (product_id, label, value, sort_order) VALUES
  (1, 'Material',        'Kayu Lapis Berlapis',   0),
  (1, 'Ukuran Standar',  '122 x 244 cm',          1),
  (1, 'Ketebalan',       '3mm – 18mm',            2),
  (1, 'Standar',         'SNI',                   3);

-- Spesifikasi Besi Beton
INSERT INTO product_specs (product_id, label, value, sort_order) VALUES
  (12, 'Jenis',    'Polos (BjTP) / Ulir (BjTS)', 0),
  (12, 'Diameter', '6mm – 32mm',                 1),
  (12, 'Panjang',  '12m per batang',              2),
  (12, 'Standar',  'SNI 2052:2017',               3);
