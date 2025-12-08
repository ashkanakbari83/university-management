
-- Create the authdb database
CREATE DATABASE authdb;

-- Create the auth_user with password
CREATE USER auth_user WITH PASSWORD 'auth_pass';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE authdb TO auth_user;

-- Connect to authdb and grant schema privileges
\c authdb;
GRANT ALL ON SCHEMA public TO auth_user;
