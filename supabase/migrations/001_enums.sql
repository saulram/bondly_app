-- =============================================
-- Bondly Backend Migration: ENUM Types
-- =============================================

-- User roles in the system
CREATE TYPE user_role AS ENUM ('superAdmin', 'admin', 'client');

-- Subscription plan types
CREATE TYPE plan_type AS ENUM ('free', 'premium', 'standard', 'enterprise', 'Basic', 'plus');

-- Account types: creator (account holder) or invitee (team member)
CREATE TYPE account_type AS ENUM ('creator', 'invitee');

-- Cart types: shopping cart or wishlist
CREATE TYPE cart_type AS ENUM ('cart', 'wishList');

-- Exchange/redemption status progression
CREATE TYPE exchange_status AS ENUM ('Entregado', 'En espera', 'Recibido', 'Devolución');

-- Activity feed entry types
CREATE TYPE feed_type AS ENUM ('reconocimiento', 'canje', 'comentario', 'recompensa');

-- Transaction types for account statements
CREATE TYPE transaction_type AS ENUM ('Recompensa', 'Reconocimiento', 'Saldo Anterior');
