-- =============================================================
-- Bondly Seed Data — Tenant: Fluss  |  account: 10000001
-- Tema: Héroes Nacionales Mexicanos
-- Contraseña universal: Bondly2024!
-- =============================================================
-- El trigger handle_new_user() crea automáticamente al insertar
-- en auth.users:  public.users, user_profiles, user_points, carts
-- =============================================================

-- =============================================================
-- 1. AUTH USERS
-- =============================================================
INSERT INTO auth.users (
    instance_id, id, aud, role, email, encrypted_password,
    email_confirmed_at, raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at, confirmation_token, email_change,
    email_change_token_new, recovery_token
) VALUES

-- ── Equipo Fluss (admin / creator) ──────────────────────────
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'authenticated', 'authenticated',
  'saul@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '6 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Saul Ramirez","company_name":"Fluss","account_number":10000001,"role":"admin","account_type":"creator","monthly_points":500}',
  NOW() - INTERVAL '6 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'authenticated', 'authenticated',
  'juan@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '6 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Juan Mora","company_name":"Fluss","account_number":10000001,"role":"admin","account_type":"creator","monthly_points":500}',
  NOW() - INTERVAL '6 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'authenticated', 'authenticated',
  'mariana@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '6 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Mariana Islas","company_name":"Fluss","account_number":10000001,"role":"admin","account_type":"creator","monthly_points":500}',
  NOW() - INTERVAL '6 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'authenticated', 'authenticated',
  'fernando@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '6 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Fernando Piedra","company_name":"Fluss","account_number":10000001,"role":"admin","account_type":"creator","monthly_points":500}',
  NOW() - INTERVAL '6 months', NOW(), '', '', '', ''
),

-- ── Héroes Nacionales (client / invitee) ────────────────────
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000005', 'authenticated', 'authenticated',
  'miguel.hidalgo@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '5 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Miguel Hidalgo y Costilla","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '5 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000006', 'authenticated', 'authenticated',
  'jose.morelos@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '5 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"José María Morelos","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '5 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000007', 'authenticated', 'authenticated',
  'vicente.guerrero@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '5 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Vicente Guerrero","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '5 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000008', 'authenticated', 'authenticated',
  'ignacio.allende@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '5 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Ignacio Allende","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '5 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000009', 'authenticated', 'authenticated',
  'josefa.ortiz@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '4 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Josefa Ortiz de Domínguez","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '4 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000010', 'authenticated', 'authenticated',
  'leona.vicario@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '4 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Leona Vicario","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '4 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000011', 'authenticated', 'authenticated',
  'benito.juarez@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '4 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Benito Juárez","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '4 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000012', 'authenticated', 'authenticated',
  'francisco.madero@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '4 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Francisco I. Madero","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '4 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000013', 'authenticated', 'authenticated',
  'emiliano.zapata@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '3 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Emiliano Zapata","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '3 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000014', 'authenticated', 'authenticated',
  'francisco.villa@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '3 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Francisco Villa","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '3 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000015', 'authenticated', 'authenticated',
  'lazaro.cardenas@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '3 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Lázaro Cárdenas","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '3 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000016', 'authenticated', 'authenticated',
  'venustiano.carranza@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '3 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Venustiano Carranza","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '3 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000017', 'authenticated', 'authenticated',
  'alvaro.obregon@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '2 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Álvaro Obregón","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '2 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000018', 'authenticated', 'authenticated',
  'ricardo.flores@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '2 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Ricardo Flores Magón","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '2 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000019', 'authenticated', 'authenticated',
  'carmen.serdan@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '2 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Carmen Serdán","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '2 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000020', 'authenticated', 'authenticated',
  'andres.quintana@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '2 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Andrés Quintana Roo","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '2 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000021', 'authenticated', 'authenticated',
  'ignacio.zaragoza@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '2 months',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Ignacio Zaragoza","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '2 months', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000022', 'authenticated', 'authenticated',
  'juan.barrera@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '6 weeks',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Juan de la Barrera","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '6 weeks', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000023', 'authenticated', 'authenticated',
  'nicolas.bravo@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '6 weeks',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Nicolás Bravo","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '6 weeks', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000024', 'authenticated', 'authenticated',
  'guadalupe.victoria@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '6 weeks',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Guadalupe Victoria","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '6 weeks', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000025', 'authenticated', 'authenticated',
  'juan.aldama@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '5 weeks',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Juan Aldama","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '5 weeks', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000026', 'authenticated', 'authenticated',
  'mariano.matamoros@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '5 weeks',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Mariano Matamoros","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '5 weeks', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000027', 'authenticated', 'authenticated',
  'hermenegildo.galeana@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '4 weeks',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Hermenegildo Galeana","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '4 weeks', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000028', 'authenticated', 'authenticated',
  'agustin.iturbide@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '3 weeks',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Agustín de Iturbide","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '3 weeks', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000029', 'authenticated', 'authenticated',
  'cuitlahuac@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '2 weeks',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Cuitláhuac","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '2 weeks', NOW(), '', '', '', ''
),
(
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-aaaa-aaaa-aaaa-000000000030', 'authenticated', 'authenticated',
  'cuauhtemoc@fluss.mx', crypt('Bondly2024!', gen_salt('bf')),
  NOW() - INTERVAL '1 week',
  '{"provider":"email","providers":["email"]}',
  '{"complete_name":"Cuauhtémoc","company_name":"Fluss","account_number":10000001,"role":"client","account_type":"invitee","monthly_points":200}',
  NOW() - INTERVAL '1 week', NOW(), '', '', '', ''
);

-- =============================================================
-- 2. UPDATE users — employee numbers y puntos post-reconocimientos
-- (el trigger ya creó los registros con valores iniciales)
-- =============================================================
UPDATE users SET employee_number = 1001, points_received = 325, gifted_points = 350, seats = 30, plan_type = 'enterprise' WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001';
UPDATE users SET employee_number = 1002, points_received = 125, gifted_points = 250, seats = 30, plan_type = 'enterprise' WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002';
UPDATE users SET employee_number = 1003, points_received = 50,  gifted_points = 325, seats = 30, plan_type = 'enterprise' WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003';
UPDATE users SET employee_number = 1004, points_received = 75,  gifted_points = 175, seats = 30, plan_type = 'enterprise' WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004';
-- Héroes
UPDATE users SET employee_number = 2001, points_received = 50,  gifted_points = 75  WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005';
UPDATE users SET employee_number = 2002, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000006';
UPDATE users SET employee_number = 2003, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000007';
UPDATE users SET employee_number = 2004, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000008';
UPDATE users SET employee_number = 2005, points_received = 150, gifted_points = 150 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000009';
UPDATE users SET employee_number = 2006, points_received = 75,  gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000010';
UPDATE users SET employee_number = 2007, points_received = 300, gifted_points = 0   WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011';
UPDATE users SET employee_number = 2008, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000012';
UPDATE users SET employee_number = 2009, points_received = 100, gifted_points = 125 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000013';
UPDATE users SET employee_number = 2010, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000014';
UPDATE users SET employee_number = 2011, points_received = 100, gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000015';
UPDATE users SET employee_number = 2012, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000016';
UPDATE users SET employee_number = 2013, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000017';
UPDATE users SET employee_number = 2014, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000018';
UPDATE users SET employee_number = 2015, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000019';
UPDATE users SET employee_number = 2016, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000020';
UPDATE users SET employee_number = 2017, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000021';
UPDATE users SET employee_number = 2018, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000022';
UPDATE users SET employee_number = 2019, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000023';
UPDATE users SET employee_number = 2020, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000024';
UPDATE users SET employee_number = 2021, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000025';
UPDATE users SET employee_number = 2022, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000026';
UPDATE users SET employee_number = 2023, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000027';
UPDATE users SET employee_number = 2024, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000028';
UPDATE users SET employee_number = 2025, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000029';
UPDATE users SET employee_number = 2026, points_received = 0,   gifted_points = 200 WHERE id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000030';

-- =============================================================
-- 3. UPDATE user_profiles — info profesional y personal
-- =============================================================
UPDATE user_profiles SET job_position = 'Chief Technology Officer',   job_area = 'Tecnología',     location = 'Ciudad de México', b_day = '1990-03-15' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001';
UPDATE user_profiles SET job_position = 'Chief Executive Officer',    job_area = 'Dirección',      location = 'Ciudad de México', b_day = '1988-07-22' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002';
UPDATE user_profiles SET job_position = 'Head of Product',            job_area = 'Producto',       location = 'Guadalajara',      b_day = '1993-11-05' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003';
UPDATE user_profiles SET job_position = 'Head of Design',             job_area = 'Diseño',         location = 'Monterrey',        b_day = '1991-04-18' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004';
UPDATE user_profiles SET job_position = 'Ingeniero de Software Sr.',  job_area = 'Tecnología',     location = 'Ciudad de México', b_day = '1753-05-08' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005';
UPDATE user_profiles SET job_position = 'Líder de Proyectos',         job_area = 'Operaciones',    location = 'Valladolid',       b_day = '1765-09-30' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000006';
UPDATE user_profiles SET job_position = 'Gerente de Operaciones',     job_area = 'Operaciones',    location = 'Tixtla',           b_day = '1782-08-10' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000007';
UPDATE user_profiles SET job_position = 'Director Comercial',         job_area = 'Ventas',         location = 'Guanajuato',       b_day = '1769-01-21' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000008';
UPDATE user_profiles SET job_position = 'Coordinadora de RH',         job_area = 'Recursos Humanos', location = 'Querétaro',      b_day = '1768-04-08' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000009';
UPDATE user_profiles SET job_position = 'Comunicación Corporativa',   job_area = 'Comunicación',   location = 'Ciudad de México', b_day = '1789-04-10' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000010';
UPDATE user_profiles SET job_position = 'Asesor Jurídico',            job_area = 'Legal',          location = 'Oaxaca',           b_day = '1806-03-21' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011';
UPDATE user_profiles SET job_position = 'Analista de Estrategia',     job_area = 'Estrategia',     location = 'San Pedro',        b_day = '1873-10-30' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000012';
UPDATE user_profiles SET job_position = 'Especialista en Innovación', job_area = 'Innovación',     location = 'Morelos',          b_day = '1879-08-08' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000013';
UPDATE user_profiles SET job_position = 'Responsable de Logística',   job_area = 'Logística',      location = 'Durango',          b_day = '1878-06-05' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000014';
UPDATE user_profiles SET job_position = 'Gerente de Relaciones Ext.', job_area = 'Relaciones',     location = 'Jiquilpan',        b_day = '1895-05-21' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000015';
UPDATE user_profiles SET job_position = 'Coordinador de Cumplimiento',job_area = 'Legal',          location = 'Cuatro Ciénegas',  b_day = '1859-12-29' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000016';
UPDATE user_profiles SET job_position = 'VP de Operaciones',          job_area = 'Operaciones',    location = 'Sonora',           b_day = '1880-02-19' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000017';
UPDATE user_profiles SET job_position = 'Analista de Contenidos',     job_area = 'Marketing',      location = 'San Luis Potosí',  b_day = '1873-09-16' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000018';
UPDATE user_profiles SET job_position = 'Coordinadora de Bienestar',  job_area = 'Recursos Humanos', location = 'Puebla',         b_day = '1875-10-16' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000019';
UPDATE user_profiles SET job_position = 'Analista Político',          job_area = 'Estrategia',     location = 'Yucatán',          b_day = '1787-11-30' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000020';
UPDATE user_profiles SET job_position = 'Gerente de Seguridad',       job_area = 'Operaciones',    location = 'Bahía de Banderas',b_day = '1829-03-24' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000021';
UPDATE user_profiles SET job_position = 'Ingeniero de Infraestructura',job_area = 'Tecnología',    location = 'Ciudad de México', b_day = '1828-06-21' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000022';
UPDATE user_profiles SET job_position = 'Oficial de Proyectos',       job_area = 'Operaciones',    location = 'Chilpancingo',     b_day = '1786-09-10' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000023';
UPDATE user_profiles SET job_position = 'Director de Finanzas',       job_area = 'Finanzas',       location = 'Comanjilla',       b_day = '1786-09-29' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000024';
UPDATE user_profiles SET job_position = 'Auditor Interno',            job_area = 'Finanzas',       location = 'Guanajuato',       b_day = '1774-01-05' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000025';
UPDATE user_profiles SET job_position = 'Capellán Corporativo',       job_area = 'Cultura',        location = 'Jantetelco',       b_day = '1770-08-14' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000026';
UPDATE user_profiles SET job_position = 'Especialista en Campo',      job_area = 'Operaciones',    location = 'Tecpan',           b_day = '1762-04-12' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000027';
UPDATE user_profiles SET job_position = 'Director de Expansión',      job_area = 'Estrategia',     location = 'Valle de México',  b_day = '1783-09-27' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000028';
UPDATE user_profiles SET job_position = 'Gestor de Alianzas',         job_area = 'Relaciones',     location = 'Iztapalapa',       b_day = '1476-04-18' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000029';
UPDATE user_profiles SET job_position = 'Director Ejecutivo',         job_area = 'Dirección',      location = 'Tenochtitlán',     b_day = '1497-02-26' WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000030';

-- =============================================================
-- 4. BADGE CATEGORIES
-- =============================================================
INSERT INTO badge_categories (id, name, account, type, description, visible) VALUES
  ('ca000000-0000-0000-0000-000000000001', 'Colaboración',  10000001, 'core',    'Trabajo en equipo e integración',              true),
  ('ca000000-0000-0000-0000-000000000002', 'Innovación',    10000001, 'core',    'Ideas creativas y soluciones disruptivas',      true),
  ('ca000000-0000-0000-0000-000000000003', 'Liderazgo',     10000001, 'core',    'Inspirar, guiar y desarrollar a otros',         true),
  ('ca000000-0000-0000-0000-000000000004', 'Desempeño',     10000001, 'core',    'Excelencia y resultados sobresalientes',         true),
  ('ca000000-0000-0000-0000-000000000005', 'Bienestar',     10000001, 'special', 'Cultura positiva y equilibrio en el equipo',    true)
ON CONFLICT DO NOTHING;

-- =============================================================
-- 5. BADGES (3 por categoría = 15 badges)
-- =============================================================
INSERT INTO badges (id, category_id, name, image, value, is_active, visible) VALUES
  -- Colaboración
  ('ba000000-0000-0000-0000-000000000001', 'ca000000-0000-0000-0000-000000000001', 'Trabajo en Equipo',      'badges/teamwork.png',    50,  true, true),
  ('ba000000-0000-0000-0000-000000000002', 'ca000000-0000-0000-0000-000000000001', 'Colaborador Estrella',   'badges/star.png',        100, true, true),
  ('ba000000-0000-0000-0000-000000000003', 'ca000000-0000-0000-0000-000000000001', 'Puente de Ideas',        'badges/bridge.png',       75, true, true),
  -- Innovación
  ('ba000000-0000-0000-0000-000000000004', 'ca000000-0000-0000-0000-000000000002', 'Idea Brillante',         'badges/idea.png',         75, true, true),
  ('ba000000-0000-0000-0000-000000000005', 'ca000000-0000-0000-0000-000000000002', 'Disruptivo',             'badges/disruptive.png',  125, true, true),
  ('ba000000-0000-0000-0000-000000000006', 'ca000000-0000-0000-0000-000000000002', 'Mente Creativa',         'badges/creative.png',    100, true, true),
  -- Liderazgo
  ('ba000000-0000-0000-0000-000000000007', 'ca000000-0000-0000-0000-000000000003', 'Líder Nato',             'badges/leader.png',      150, true, true),
  ('ba000000-0000-0000-0000-000000000008', 'ca000000-0000-0000-0000-000000000003', 'Mentor Inspirador',      'badges/mentor.png',      125, true, true),
  ('ba000000-0000-0000-0000-000000000009', 'ca000000-0000-0000-0000-000000000003', 'Voz del Equipo',         'badges/voice.png',       100, true, true),
  -- Desempeño
  ('ba000000-0000-0000-0000-000000000010', 'ca000000-0000-0000-0000-000000000004', 'Excelencia Total',       'badges/excellence.png',  200, true, true),
  ('ba000000-0000-0000-0000-000000000011', 'ca000000-0000-0000-0000-000000000004', 'Más Allá del Deber',     'badges/beyond.png',      150, true, true),
  ('ba000000-0000-0000-0000-000000000012', 'ca000000-0000-0000-0000-000000000004', 'Entrega a Tiempo',       'badges/ontime.png',       75, true, true),
  -- Bienestar
  ('ba000000-0000-0000-0000-000000000013', 'ca000000-0000-0000-0000-000000000005', 'Energía Positiva',       'badges/energy.png',       50, true, true),
  ('ba000000-0000-0000-0000-000000000014', 'ca000000-0000-0000-0000-000000000005', 'Equilibrio Ejemplar',    'badges/balance.png',      75, true, true),
  ('ba000000-0000-0000-0000-000000000015', 'ca000000-0000-0000-0000-000000000005', 'Embajador de Cultura',   'badges/culture.png',     100, true, true)
ON CONFLICT DO NOTHING;

-- =============================================================
-- 6. REWARDS
-- =============================================================
INSERT INTO rewards (id, name, description, category, points, company_name, account, enable, visible) VALUES
  ('e0000000-0000-0000-0000-000000000001', 'Día Libre Adicional',          'Un día de descanso extra a tu elección',                  'Tiempo libre',  500, 'Fluss', 10000001, true, true),
  ('e0000000-0000-0000-0000-000000000002', 'Tarjeta de regalo $500 MXN',   'Canjeable en tiendas participantes',                      'Tarjetas',      300, 'Fluss', 10000001, true, true),
  ('e0000000-0000-0000-0000-000000000003', 'Curso Online a Elegir',        'Acceso a plataforma de e-learning por 3 meses',           'Educación',     200, 'Fluss', 10000001, true, true),
  ('e0000000-0000-0000-0000-000000000004', 'Viernes Corto',                'Salida a las 2pm el viernes de tu elección',              'Tiempo libre',  400, 'Fluss', 10000001, true, true),
  ('e0000000-0000-0000-0000-000000000005', 'Lunch con el CEO',             'Comida privada con el CEO para conocer tu visión',        'Experiencias',  600, 'Fluss', 10000001, true, true),
  ('e0000000-0000-0000-0000-000000000006', 'Suscripción Streaming 1 Mes',  'Netflix, Spotify o Amazon Prime (a elegir)',              'Entretenimiento',250,'Fluss', 10000001, true, true),
  ('e0000000-0000-0000-0000-000000000007', 'Kit Wellness',                 'Set de bienestar: aromaterápia, diario y snacks saludables','Bienestar',    350, 'Fluss', 10000001, true, true),
  ('e0000000-0000-0000-0000-000000000008', 'Equipo Home Office $1,000 MXN','Voucher para comprar lo que necesites en tu home office',  'Productividad', 800, 'Fluss', 10000001, true, true)
ON CONFLICT DO NOTHING;

-- =============================================================
-- 7. BANNERS
-- =============================================================
INSERT INTO banners (id, name, slug, description, is_active, company_name, visible) VALUES
  ('b0000000-0000-0000-0000-000000000001', 'Bienvenida Q1 2026',        'bienvenida-q1-2026',     '¡Arrancamos el año con todo! Conoce las metas del trimestre y los nuevos reconocimientos disponibles.', true, 'Fluss', true),
  ('b0000000-0000-0000-0000-000000000002', 'Convocatoria Innovación',   'convocatoria-innovacion','Tienes hasta el 31 de marzo para enviar tu propuesta al Hackathon Interno Fluss 2026. ¡Grandes premios!',true,  'Fluss', true),
  ('b0000000-0000-0000-0000-000000000003', 'Semana de Bienestar',       'semana-bienestar',       'Del 10 al 14 de marzo: yoga en línea, talleres de mindfulness y actividades de integración para todo el equipo.', true, 'Fluss', true)
ON CONFLICT DO NOTHING;

-- =============================================================
-- 8. ACKNOWLEDGMENTS (el trigger crea actividades para el sender)
-- Distribución:
--  01: Saul      → Miguel Hidalgo   | Trabajo en Equipo   (50)
--  02: Juan      → Josefa Ortiz     | Líder Nato          (150)
--  03: Mariana   → Leona Vicario    | Idea Brillante      (75)
--  04: Fernando  → Benito Juárez    | Excelencia Total    (200)
--  05: Miguel H. → Saul             | Mentor Inspirador   (125)
--  06: Josefa O. → Mariana          | Energía Positiva    (50)
--  07: Emiliano  → Fernando         | Entrega a Tiempo    (75)
--  08: Saul      → Emiliano Zapata  | Colaborador Estrella(100)
--  09: Juan      → Benito Juárez    | Voz del Equipo      (100)
--  10: Mariana   → Lázaro Cárdenas  | Embajador de Cultura(100)
--  11: Fernando  → Juan             | Disruptivo          (125)
--  12: Benito J. → Saul             | Excelencia Total    (200)
-- =============================================================
INSERT INTO acknowledgments (id, badge_id, sender_id, message, account, visible, created_at) VALUES
  ('ac000000-0000-0000-0000-000000000001', 'ba000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Miguel, tu manera de integrar al equipo en cada proyecto es ejemplar. ¡Gracias por siempre tender puentes!', 10000001, true, NOW() - INTERVAL '10 weeks'),
  ('ac000000-0000-0000-0000-000000000002', 'ba000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'Josefa, tu liderazgo natural inspira a todo el equipo. Es un honor trabajar contigo.', 10000001, true, NOW() - INTERVAL '9 weeks'),
  ('ac000000-0000-0000-0000-000000000003', 'ba000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'Leona, tu propuesta para rediseñar el onboarding fue brillante. Cambió la experiencia de todos los nuevos ingresos.', 10000001, true, NOW() - INTERVAL '8 weeks'),
  ('ac000000-0000-0000-0000-000000000004', 'ba000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Benito, tu dedicación al proyecto legal fue total. El resultado habla por sí solo. ¡Excelencia pura!', 10000001, true, NOW() - INTERVAL '7 weeks'),
  ('ac000000-0000-0000-0000-000000000005', 'ba000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005', 'Saul siempre está disponible para orientarnos. Su mentoría ha hecho que todo el equipo de tech crezca. ¡Gracias!', 10000001, true, NOW() - INTERVAL '6 weeks'),
  ('ac000000-0000-0000-0000-000000000006', 'ba000000-0000-0000-0000-000000000013', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000009', 'Mariana irradia positividad. Cada reunión mejora con su actitud. ¡El equipo te lo agradece mucho!', 10000001, true, NOW() - INTERVAL '5 weeks'),
  ('ac000000-0000-0000-0000-000000000007', 'ba000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000013', 'Fernando siempre entrega en tiempo y forma, sin importar la complejidad. ¡Eso hace toda la diferencia!', 10000001, true, NOW() - INTERVAL '4 weeks'),
  ('ac000000-0000-0000-0000-000000000008', 'ba000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Emiliano, tu colaboración durante el sprint fue clave para que llegáramos al goal. ¡Eres una estrella!', 10000001, true, NOW() - INTERVAL '3 weeks'),
  ('ac000000-0000-0000-0000-000000000009', 'ba000000-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'Benito, siempre alzas la mano cuando el equipo necesita una voz clara. Gracias por hablar por todos.', 10000001, true, NOW() - INTERVAL '2 weeks'),
  ('ac000000-0000-0000-0000-000000000010', 'ba000000-0000-0000-0000-000000000015', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'Lázaro, eres la persona que más vive y transmite nuestra cultura. ¡Fluss te necesita como embajador!', 10000001, true, NOW() - INTERVAL '10 days'),
  ('ac000000-0000-0000-0000-000000000011', 'ba000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Juan, tu propuesta de reestructurar el roadmap fue completamente disruptiva. Gracias por pensar diferente.', 10000001, true, NOW() - INTERVAL '6 days'),
  ('ac000000-0000-0000-0000-000000000012', 'ba000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011', 'Saul, la arquitectura que diseñaste para el nuevo módulo es perfecta. Excelencia técnica al 100%.', 10000001, true, NOW() - INTERVAL '2 days')
ON CONFLICT DO NOTHING;

-- =============================================================
-- 9. ACKNOWLEDGMENT RECIPIENTS
-- (el trigger create_activity_for_recipient() crea actividades)
-- =============================================================
INSERT INTO acknowledgment_recipients (acknowledgment_id, user_id) VALUES
  ('ac000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005'),  -- Miguel Hidalgo
  ('ac000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000009'),  -- Josefa Ortiz
  ('ac000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000010'),  -- Leona Vicario
  ('ac000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011'),  -- Benito Juárez
  ('ac000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001'),  -- Saul
  ('ac000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003'),  -- Mariana
  ('ac000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004'),  -- Fernando
  ('ac000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000013'),  -- Emiliano Zapata
  ('ac000000-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011'),  -- Benito Juárez
  ('ac000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000015'),  -- Lázaro Cárdenas
  ('ac000000-0000-0000-0000-000000000011', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002'),  -- Juan
  ('ac000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001')   -- Saul
ON CONFLICT DO NOTHING;

-- =============================================================
-- 10. ACCOUNT FEEDS
-- 12 reconocimientos + 3 anuncios del equipo
-- =============================================================
INSERT INTO account_feeds (id, account, header, body, footer, sender_id, type, badge_id, is_highlighted, visible, created_at) VALUES
  -- Reconocimientos
  ('fe000000-0000-0000-0000-000000000001', 10000001,
   'Saul Ramirez reconoció a Miguel Hidalgo y Costilla',
   'Miguel, tu manera de integrar al equipo en cada proyecto es ejemplar. ¡Gracias por siempre tender puentes!',
   'Trabajo en Equipo · 50 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'reconocimiento', 'ba000000-0000-0000-0000-000000000001', false, true, NOW() - INTERVAL '10 weeks'),

  ('fe000000-0000-0000-0000-000000000002', 10000001,
   'Juan Mora reconoció a Josefa Ortiz de Domínguez',
   'Josefa, tu liderazgo natural inspira a todo el equipo. Es un honor trabajar contigo.',
   'Líder Nato · 150 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'reconocimiento', 'ba000000-0000-0000-0000-000000000007', false, true, NOW() - INTERVAL '9 weeks'),

  ('fe000000-0000-0000-0000-000000000003', 10000001,
   'Mariana Islas reconoció a Leona Vicario',
   'Leona, tu propuesta para rediseñar el onboarding fue brillante. Cambió la experiencia de todos los nuevos ingresos.',
   'Idea Brillante · 75 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'reconocimiento', 'ba000000-0000-0000-0000-000000000004', false, true, NOW() - INTERVAL '8 weeks'),

  ('fe000000-0000-0000-0000-000000000004', 10000001,
   'Fernando Piedra reconoció a Benito Juárez',
   'Benito, tu dedicación al proyecto legal fue total. El resultado habla por sí solo. ¡Excelencia pura!',
   'Excelencia Total · 200 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'reconocimiento', 'ba000000-0000-0000-0000-000000000010', true, true, NOW() - INTERVAL '7 weeks'),

  ('fe000000-0000-0000-0000-000000000005', 10000001,
   'Miguel Hidalgo y Costilla reconoció a Saul Ramirez',
   'Saul siempre está disponible para orientarnos. Su mentoría ha hecho que todo el equipo de tech crezca. ¡Gracias!',
   'Mentor Inspirador · 125 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000005', 'reconocimiento', 'ba000000-0000-0000-0000-000000000008', false, true, NOW() - INTERVAL '6 weeks'),

  ('fe000000-0000-0000-0000-000000000006', 10000001,
   'Josefa Ortiz de Domínguez reconoció a Mariana Islas',
   'Mariana irradia positividad. Cada reunión mejora con su actitud. ¡El equipo te lo agradece mucho!',
   'Energía Positiva · 50 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000009', 'reconocimiento', 'ba000000-0000-0000-0000-000000000013', false, true, NOW() - INTERVAL '5 weeks'),

  ('fe000000-0000-0000-0000-000000000007', 10000001,
   'Emiliano Zapata reconoció a Fernando Piedra',
   'Fernando siempre entrega en tiempo y forma, sin importar la complejidad. ¡Eso hace toda la diferencia!',
   'Entrega a Tiempo · 75 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000013', 'reconocimiento', 'ba000000-0000-0000-0000-000000000012', false, true, NOW() - INTERVAL '4 weeks'),

  ('fe000000-0000-0000-0000-000000000008', 10000001,
   'Saul Ramirez reconoció a Emiliano Zapata',
   'Emiliano, tu colaboración durante el sprint fue clave para que llegáramos al goal. ¡Eres una estrella!',
   'Colaborador Estrella · 100 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'reconocimiento', 'ba000000-0000-0000-0000-000000000002', false, true, NOW() - INTERVAL '3 weeks'),

  ('fe000000-0000-0000-0000-000000000009', 10000001,
   'Juan Mora reconoció a Benito Juárez',
   'Benito, siempre alzas la mano cuando el equipo necesita una voz clara. Gracias por hablar por todos.',
   'Voz del Equipo · 100 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'reconocimiento', 'ba000000-0000-0000-0000-000000000009', false, true, NOW() - INTERVAL '2 weeks'),

  ('fe000000-0000-0000-0000-000000000010', 10000001,
   'Mariana Islas reconoció a Lázaro Cárdenas',
   'Lázaro, eres la persona que más vive y transmite nuestra cultura. ¡Fluss te necesita como embajador!',
   'Embajador de Cultura · 100 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'reconocimiento', 'ba000000-0000-0000-0000-000000000015', true, true, NOW() - INTERVAL '10 days'),

  ('fe000000-0000-0000-0000-000000000011', 10000001,
   'Fernando Piedra reconoció a Juan Mora',
   'Juan, tu propuesta de reestructurar el roadmap fue completamente disruptiva. Gracias por pensar diferente.',
   'Disruptivo · 125 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'reconocimiento', 'ba000000-0000-0000-0000-000000000005', false, true, NOW() - INTERVAL '6 days'),

  ('fe000000-0000-0000-0000-000000000012', 10000001,
   'Benito Juárez reconoció a Saul Ramirez',
   'Saul, la arquitectura que diseñaste para el nuevo módulo es perfecta. Excelencia técnica al 100%.',
   'Excelencia Total · 200 pts',
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000011', 'reconocimiento', 'ba000000-0000-0000-0000-000000000010', true, true, NOW() - INTERVAL '2 days'),

  -- Anuncios del equipo Fluss
  ('fe000000-0000-0000-0000-000000000013', 10000001,
   '¡Bienvenidos al Q1 2026!',
   'Arrancamos el año con energía renovada. Este trimestre tenemos como meta llegar a 50 reconocimientos entre el equipo. ¡Vamos juntos! 🚀',
   NULL,
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'reconocimiento', NULL, true, true, NOW() - INTERVAL '11 weeks'),

  ('fe000000-0000-0000-0000-000000000014', 10000001,
   'Hackathon Interno Fluss 2026 — ¡Inscríbete!',
   'Tienes hasta el 31 de marzo para enviar tu propuesta. Los tres proyectos ganadores recibirán puntos extra y mentoring con el equipo directivo. ¡No te quedes fuera!',
   NULL,
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'reconocimiento', NULL, false, true, NOW() - INTERVAL '3 weeks'),

  ('fe000000-0000-0000-0000-000000000015', 10000001,
   'Semana de Bienestar Fluss — Del 10 al 14 de marzo',
   'Yoga en línea a las 8am, taller de respiración a las 2pm y el viernes cerramos con una actividad sorpresa para todo el equipo. ¡Agendenlo!',
   NULL,
   'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'reconocimiento', NULL, true, true, NOW() - INTERVAL '1 week')
ON CONFLICT DO NOTHING;

-- =============================================================
-- 11. FEED COMMENTS
-- =============================================================
INSERT INTO feed_comments (feed_id, user_id, message, created_at) VALUES
  ('fe000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '¡Muy bien merecido Miguel! 👏', NOW() - INTERVAL '10 weeks' + INTERVAL '2 hours'),
  ('fe000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000006', 'Totalmente de acuerdo, siempre disponible para colaborar.', NOW() - INTERVAL '10 weeks' + INTERVAL '4 hours'),
  ('fe000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Josefa es un ejemplo de liderazgo para todos. ¡Felicidades!', NOW() - INTERVAL '9 weeks' + INTERVAL '1 hour'),
  ('fe000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'Excelente trabajo Benito. El equipo legal lo hizo increíble.', NOW() - INTERVAL '7 weeks' + INTERVAL '3 hours'),
  ('fe000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', 'Ese proyecto fue un reto enorme. ¡Bien merecido!', NOW() - INTERVAL '7 weeks' + INTERVAL '5 hours'),
  ('fe000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'Saul, gracias por siempre tener tiempo para el equipo. 🙏', NOW() - INTERVAL '6 weeks' + INTERVAL '2 hours'),
  ('fe000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Emiliano entró al sprint tarde y aún así lo sacó. ¡Crack!', NOW() - INTERVAL '3 weeks' + INTERVAL '1 hour'),
  ('fe000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', '¡Lázaro siempre el alma del equipo! Muy merecido esto. 🌟', NOW() - INTERVAL '10 days' + INTERVAL '2 hours'),
  ('fe000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', 'Ese módulo quedó impecable. 10/10 Saul.', NOW() - INTERVAL '2 days' + INTERVAL '3 hours'),
  ('fe000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '¡Qué orgullo ver a nuestro equipo brillar así! 💪', NOW() - INTERVAL '2 days' + INTERVAL '5 hours'),
  ('fe000000-0000-0000-0000-000000000013', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005', '¡Vamos con todo este Q1! Meta de 50 reconocimientos 💯', NOW() - INTERVAL '11 weeks' + INTERVAL '2 hours'),
  ('fe000000-0000-0000-0000-000000000015', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000013', 'La actividad sorpresa del viernes suena increíble. ¿Cuándo revelan de qué es?', NOW() - INTERVAL '6 days');

-- =============================================================
-- 12. FEED LIKES
-- =============================================================
INSERT INTO feed_likes (feed_id, user_id, created_at) VALUES
  ('fe000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '10 weeks'),
  ('fe000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', NOW() - INTERVAL '10 weeks'),
  ('fe000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000009', NOW() - INTERVAL '10 weeks'),
  ('fe000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '9 weeks'),
  ('fe000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '9 weeks'),
  ('fe000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000007', NOW() - INTERVAL '9 weeks'),
  ('fe000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '8 weeks'),
  ('fe000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '8 weeks'),
  ('fe000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '7 weeks'),
  ('fe000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '7 weeks'),
  ('fe000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', NOW() - INTERVAL '7 weeks'),
  ('fe000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000007', NOW() - INTERVAL '7 weeks'),
  ('fe000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000013', NOW() - INTERVAL '7 weeks'),
  ('fe000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '6 weeks'),
  ('fe000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', NOW() - INTERVAL '6 weeks'),
  ('fe000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '6 weeks'),
  ('fe000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '3 weeks'),
  ('fe000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '3 weeks'),
  ('fe000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '10 days'),
  ('fe000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '10 days'),
  ('fe000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '10 days'),
  ('fe000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000009', NOW() - INTERVAL '10 days'),
  ('fe000000-0000-0000-0000-000000000011', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '6 days'),
  ('fe000000-0000-0000-0000-000000000011', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', NOW() - INTERVAL '6 days'),
  ('fe000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '2 days'),
  ('fe000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '2 days'),
  ('fe000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005', NOW() - INTERVAL '2 days'),
  ('fe000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000009', NOW() - INTERVAL '2 days'),
  ('fe000000-0000-0000-0000-000000000013', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '11 weeks'),
  ('fe000000-0000-0000-0000-000000000013', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '11 weeks'),
  ('fe000000-0000-0000-0000-000000000013', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005', NOW() - INTERVAL '11 weeks'),
  ('fe000000-0000-0000-0000-000000000013', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000007', NOW() - INTERVAL '11 weeks'),
  ('fe000000-0000-0000-0000-000000000015', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '1 week'),
  ('fe000000-0000-0000-0000-000000000015', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '1 week'),
  ('fe000000-0000-0000-0000-000000000015', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000005', NOW() - INTERVAL '1 week'),
  ('fe000000-0000-0000-0000-000000000015', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011', NOW() - INTERVAL '1 week'),
  ('fe000000-0000-0000-0000-000000000015', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000013', NOW() - INTERVAL '1 week')
ON CONFLICT DO NOTHING;

-- =============================================================
-- 13. ACCOUNT STATEMENTS (estado de cuenta de los 4 de Fluss)
-- =============================================================
INSERT INTO account_statements (id, user_id, date, balance, description) VALUES
  -- Saul
  ('5a000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '3 months', 500,  'Recarga mensual — Octubre'),
  ('5a000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '2 months', 575,  'Recarga mensual — Noviembre + Reconocimiento recibido (Mentor Inspirador 125 pts, −50 gastados)'),
  ('5a000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', NOW() - INTERVAL '1 month',  325,  'Recarga mensual — Diciembre + Reconocimiento recibido (Excelencia Total 200 pts, −100 gastados)'),
  -- Juan
  ('5a000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '3 months', 500,  'Recarga mensual — Octubre'),
  ('5a000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '2 months', 375,  'Recarga mensual — Noviembre (−150 Líder Nato, −100 Voz del Equipo)'),
  ('5a000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', NOW() - INTERVAL '1 month',  125,  'Reconocimiento recibido — Disruptivo (125 pts)'),
  -- Mariana
  ('5a000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', NOW() - INTERVAL '3 months', 500,  'Recarga mensual — Octubre'),
  ('5a000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', NOW() - INTERVAL '2 months', 425,  'Recarga mensual — Noviembre (−75 Idea Brillante)'),
  ('5a000000-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000003', NOW() - INTERVAL '1 month',  50,   'Reconocimiento recibido — Energía Positiva (50 pts, −100 Embajador de Cultura gastado)'),
  -- Fernando
  ('5a000000-0000-0000-0000-000000000010', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '3 months', 500,  'Recarga mensual — Octubre'),
  ('5a000000-0000-0000-0000-000000000011', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '2 months', 300,  'Recarga mensual — Noviembre (−200 Excelencia Total)'),
  ('5a000000-0000-0000-0000-000000000012', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000004', NOW() - INTERVAL '1 month',  75,   'Reconocimiento recibido — Entrega a Tiempo (75 pts, −125 Disruptivo gastado)')
ON CONFLICT DO NOTHING;

-- =============================================================
-- 14. STATEMENT TRANSACTIONS
-- =============================================================
INSERT INTO statement_transactions (id, statement_id, name, amount, type, date) VALUES
  -- Saul - Oct
  ('7e000000-0000-0000-0000-000000000001', '5a000000-0000-0000-0000-000000000001', 'Saldo Anterior',          0,   'Saldo Anterior',    NOW() - INTERVAL '3 months'),
  ('7e000000-0000-0000-0000-000000000002', '5a000000-0000-0000-0000-000000000001', 'Recarga Mensual',       500,   'Reconocimiento',    NOW() - INTERVAL '3 months'),
  -- Saul - Nov
  ('7e000000-0000-0000-0000-000000000003', '5a000000-0000-0000-0000-000000000002', 'Saldo Anterior',        500,   'Saldo Anterior',    NOW() - INTERVAL '2 months'),
  ('7e000000-0000-0000-0000-000000000004', '5a000000-0000-0000-0000-000000000002', 'Mentor Inspirador',     125,   'Reconocimiento',    NOW() - INTERVAL '6 weeks'),
  ('7e000000-0000-0000-0000-000000000005', '5a000000-0000-0000-0000-000000000002', 'Trabajo en Equipo (enviado)', -50, 'Reconocimiento', NOW() - INTERVAL '10 weeks'),
  -- Saul - Dic
  ('7e000000-0000-0000-0000-000000000006', '5a000000-0000-0000-0000-000000000003', 'Saldo Anterior',        575,   'Saldo Anterior',    NOW() - INTERVAL '1 month'),
  ('7e000000-0000-0000-0000-000000000007', '5a000000-0000-0000-0000-000000000003', 'Excelencia Total',      200,   'Reconocimiento',    NOW() - INTERVAL '2 days'),
  ('7e000000-0000-0000-0000-000000000008', '5a000000-0000-0000-0000-000000000003', 'Colaborador Estrella (enviado)', -100, 'Recompensa',  NOW() - INTERVAL '3 weeks'),
  -- Juan - Nov
  ('7e000000-0000-0000-0000-000000000009', '5a000000-0000-0000-0000-000000000005', 'Saldo Anterior',        500,   'Saldo Anterior',    NOW() - INTERVAL '2 months'),
  ('7e000000-0000-0000-0000-000000000010', '5a000000-0000-0000-0000-000000000005', 'Líder Nato (enviado)',  -150,  'Recompensa',        NOW() - INTERVAL '9 weeks'),
  ('7e000000-0000-0000-0000-000000000011', '5a000000-0000-0000-0000-000000000005', 'Voz del Equipo (enviado)', -100, 'Recompensa',      NOW() - INTERVAL '2 weeks'),
  -- Juan - Dic
  ('7e000000-0000-0000-0000-000000000012', '5a000000-0000-0000-0000-000000000006', 'Saldo Anterior',        375,   'Saldo Anterior',    NOW() - INTERVAL '1 month'),
  ('7e000000-0000-0000-0000-000000000013', '5a000000-0000-0000-0000-000000000006', 'Disruptivo',            125,   'Reconocimiento',    NOW() - INTERVAL '6 days'),
  -- Fernando - Nov
  ('7e000000-0000-0000-0000-000000000014', '5a000000-0000-0000-0000-000000000011', 'Saldo Anterior',        500,   'Saldo Anterior',    NOW() - INTERVAL '2 months'),
  ('7e000000-0000-0000-0000-000000000015', '5a000000-0000-0000-0000-000000000011', 'Excelencia Total (enviado)', -200, 'Recompensa',    NOW() - INTERVAL '7 weeks'),
  -- Fernando - Dic
  ('7e000000-0000-0000-0000-000000000016', '5a000000-0000-0000-0000-000000000012', 'Saldo Anterior',        300,   'Saldo Anterior',    NOW() - INTERVAL '1 month'),
  ('7e000000-0000-0000-0000-000000000017', '5a000000-0000-0000-0000-000000000012', 'Entrega a Tiempo',       75,   'Reconocimiento',    NOW() - INTERVAL '4 weeks'),
  ('7e000000-0000-0000-0000-000000000018', '5a000000-0000-0000-0000-000000000012', 'Disruptivo (enviado)',  -125,  'Recompensa',        NOW() - INTERVAL '6 days')
ON CONFLICT DO NOTHING;

-- =============================================================
-- 15. USER BALANCES (balance mensual)
-- =============================================================
INSERT INTO user_balances (user_id, period, initial_balance, final_balance) VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000001', '2025-10', 0,   500),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000001', '2025-11', 500, 575),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000001', '2025-12', 575, 325),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000002', '2025-10', 0,   500),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000002', '2025-11', 500, 375),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000002', '2025-12', 375, 125),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '2025-10', 0,   500),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '2025-11', 500, 425),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000003', '2025-12', 425, 50),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000004', '2025-10', 0,   500),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000004', '2025-11', 500, 300),
  ('aaaaaaaa-aaaa-aaaa-aaaa-000000000004', '2025-12', 300, 75)
ON CONFLICT DO NOTHING;

-- =============================================================
-- 16. AMBASSADORS
-- El trigger sync_ambassador_status() actualiza user_profiles
-- =============================================================
INSERT INTO ambassadors (id, user_id, badge_id, date, visible) VALUES
  ('a0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000015', 'ba000000-0000-0000-0000-000000000015', NOW() - INTERVAL '10 days', true),
  ('a0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011', 'ba000000-0000-0000-0000-000000000007', NOW() - INTERVAL '5 days',  true)
ON CONFLICT DO NOTHING;

UPDATE user_profiles SET ambassador_title = 'Embajador de Cultura Fluss'        WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000015';
UPDATE user_profiles SET ambassador_title = 'Embajador de Liderazgo Fluss'       WHERE user_id = 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011';

-- =============================================================
-- 17. EXCHANGES (canjes completados)
-- =============================================================
INSERT INTO exchanges (id, user_id, reward_id, code, status, company_name, created_at) VALUES
  ('f0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000001', 'e0000000-0000-0000-0000-000000000003', 'FLSS8A3C', 'Entregado', 'Fluss', NOW() - INTERVAL '5 weeks'),
  ('f0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000002', 'e0000000-0000-0000-0000-000000000004', 'FLSSX9TY', 'Entregado', 'Fluss', NOW() - INTERVAL '3 weeks'),
  ('f0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000011', 'e0000000-0000-0000-0000-000000000006', 'FLSS2BKM', 'En espera', 'Fluss', NOW() - INTERVAL '1 week'),
  ('f0000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-000000000009', 'e0000000-0000-0000-0000-000000000002', 'FLSSQ7PN', 'Recibido',  'Fluss', NOW() - INTERVAL '4 days')
ON CONFLICT DO NOTHING;

-- =============================================================
-- 18. NEWS
-- =============================================================
INSERT INTO news (id, title, content, hidden, visible) VALUES
  ('de000000-0000-0000-0000-000000000001',
   'Bondly lanza reconocimientos en tiempo real',
   'A partir de este mes el equipo puede enviar reconocimientos instantáneos desde la app móvil. Cada badge tiene un valor en puntos que se acumula en el perfil del colaborador.',
   false, true),
  ('de000000-0000-0000-0000-000000000002',
   'Nuevo catálogo de recompensas Q1 2026',
   'Hemos renovado el catálogo con 8 nuevas recompensas: desde días libres hasta equipo para home office. Revisa tu saldo y elige la tuya.',
   false, true)
ON CONFLICT DO NOTHING;
