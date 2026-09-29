BEGIN;

-- 1. Inserir o pedido e capturar o ID gerado
WITH novo_pedido AS (
    INSERT INTO pedidos (cliente_id, status, valor_total)
    VALUES (1, 'PENDENTE', 150.00)
    RETURNING pedido_id
)
-- 2. Inserir itens utilizando o ID capturado
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario)
SELECT pedido_id, 2, 3, 50.00
FROM novo_pedido;

-- 3. Atualizar estoque do produto
UPDATE produtos
SET estoque = estoque - 3
WHERE produto_id = 2;

COMMIT;

BEGIN;

-- Criacao do Savepoint inicial
SAVEPOINT sp_inicio_pedido;

-- Inserir pedido e obter pedido_id
INSERT INTO pedidos (cliente_id, status, valor_total)
VALUES (2, 'PENDENTE', 300.00)
RETURNING pedido_id; -- Suponha que retornou ID 10

-- Tentar adicionar Item 1 (Sucesso)
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario)
VALUES (10, 1, 1, 100.00);

-- Definir Savepoint antes de operacao arriscada
SAVEPOINT sp_item_dois;

-- Tentar adicionar Item 2 (Simulando uma tentativa com regra que falharia se testada via app)
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario)
VALUES (10, 3, 2, 100.00);

-- Caso ocorra algum erro de regra de negócio na integracao, desfaz apenas o item 2:
-- ROLLBACK TO SAVEPOINT sp_item_dois;

COMMIT;