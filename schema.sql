-- Criacao da tabela de Clientes
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_cadastro TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status_ativo BOOLEAN DEFAULT TRUE NOT NULL,
    CONSTRAINT chk_cpf_tamanho CHECK (LENGTH(cpf) = 11)
);

-- Criacao da tabela de Produtos
CREATE TABLE produtos (
    produto_id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    preco NUMERIC(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_preco_positivo CHECK (preco > 0),
    CONSTRAINT chk_estoque_nao_negativo CHECK (estoque >= 0)
);

-- Criacao da tabela de Pedidos
CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_pedido TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDENTE' NOT NULL,
    valor_total NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    CONSTRAINT fk_pedidos_cliente FOREIGN KEY (cliente_id) 
        REFERENCES clientes (cliente_id) ON DELETE RESTRICT,
    CONSTRAINT chk_status_valido CHECK (status IN ('PENDENTE', 'PAGO', 'ENVIADO', 'CANCELADO'))
);

-- Criacao da tabela de Itens do Pedido
CREATE TABLE itens_pedido (
    item_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario NUMERIC(10, 2) NOT NULL,
    CONSTRAINT fk_itens_pedido FOREIGN KEY (pedido_id) 
        REFERENCES pedidos (pedido_id) ON DELETE CASCADE,
    CONSTRAINT fk_itens_produto FOREIGN KEY (produto_id) 
        REFERENCES produtos (produto_id) ON DELETE RESTRICT,
    CONSTRAINT chk_quantidade_positiva CHECK (quantidade > 0),
    CONSTRAINT chk_preco_unitario_positivo CHECK (preco_unitario > 0)
);