 -- 1. Criacao de Roles
CREATE ROLE role_leitura;
CREATE ROLE role_operadores;

-- Permissoes da Role de Leitura (Analistas)
GRANT CONNECT ON DATABASE postgres TO role_leitura;
GRANT USAGE ON SCHEMA public TO role_leitura;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO role_leitura;

-- Permissoes da Role de Operacao (Aplicações / Operadores)
GRANT CONNECT ON DATABASE postgres TO role_operadores;
GRANT USAGE ON SCHEMA public TO role_operadores;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO role_operadores;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO role_operadores;

-- 2. Criacao dos Usuarios
CREATE USER usuario_analista WITH PASSWORD 'SenhaSeguraAnalista123!';
CREATE USER usuario_app WITH PASSWORD 'SenhaSeguraApp456!';

-- 3. Atribuicao de Roles aos Usuarios
GRANT role_leitura TO usuario_analista;
GRANT role_operadores TO usuario_app;

-- Restricao explicitada via REVOKE
REVOKE DELETE ON ALL TABLES IN SCHEMA public FROM role_operadores;