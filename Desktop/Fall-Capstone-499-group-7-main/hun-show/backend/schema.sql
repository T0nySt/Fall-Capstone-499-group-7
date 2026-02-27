-- ============================================
-- Users & Accounts Schema for Hun Show Backend
-- ============================================

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================
-- This is the USERS TABLE
-- Stores core account information for all users
-- ============================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- This is the unique identifier for each user
    username VARCHAR(50) UNIQUE NOT NULL, -- This would public display name, must be unique.
    email VARCHAR(255) UNIQUE NOT NULL, -- Login email, must be unique
    password_hash VARCHAR(255) NOT NULL, -- Bcrypt hashed password, never store plain text
    first_name VARCHAR(50), -- we would have an optional first name.
    last_name VARCHAR(50), -- and we can also have a last name.
    profile_picture TEXT, -- URL to profile picture
    is_verified BOOLEAN DEFAULT FALSE, -- once it is true, user verifies their email
    is_active BOOLEAN DEFAULT TRUE, -- False if account is banned or deactivated
    role VARCHAR(20) DEFAULT 'user' CHECK (
        role IN ('user', 'admin', 'moderator')
    ), -- Access level
    created_at TIMESTAMP DEFAULT NOW(), -- When the account was created
    updated_at TIMESTAMP DEFAULT NOW() -- Auto-updated whenever the row changes
);

-- ============================================
-- This is the USER SESSIONS TABLE
-- Tracks active login sessions for each user
-- ============================================
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- this would be a unique session identifier
    user_id UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE, -- Links to the user, deletes session if user is deleted
    token TEXT NOT NULL, -- JWT or session token
    ip_address VARCHAR(45), -- IP address at login (supports IPv6)
    user_agent TEXT, -- Browser/device info at login
    expires_at TIMESTAMP NOT NULL, -- When the session expires
    created_at TIMESTAMP DEFAULT NOW() -- When the session was created
);

-- ============================================
-- INDEXES
-- This speeds up common lookups and queries.
-- ============================================

CREATE INDEX idx_users_email ON users (email);
-- This is for fast login lookup by email
CREATE INDEX idx_users_username ON users (username);
-- Fast lookup by username
CREATE INDEX idx_sessions_user_id ON user_sessions (user_id);
-- Find all sessions for a user
CREATE INDEX idx_sessions_token ON user_sessions (token);
-- Validate session tokens quickly

-- ============================================
-- AUTO UPDATE updated_at TRIGGER
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();