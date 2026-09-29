-- Carga inicial de teste antes das analises
INSERT INTO clientes (nome, email, cpf) VALUES ('Cliente Teste', 'teste@email.com', '12345678901');
INSERT INTO produtos (nome, preco, estoque) VALUES ('Notebook', 3000.00, 10), ('Mouse', 50.00, 100);
INSERT INTO pedidos (cliente_id, status, valor_total) VALUES (1, 'PAGO', 3000.00);
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES (1, 1, 1, 3000.00);

-- Consulta 1: Busca de pedidos por cliente com JOIN
EXPLAIN ANALYZE
SELECT c.nome, p.pedido_id, p.data_pedido, p.valor_total
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.cliente_id = 1;

-- Consulta 2: Busca por pedidos filtrados por status e ordenados por data
EXPLAIN ANALYZE
SELECT pedido_id, data_pedido, valor_total
FROM pedidos
WHERE status = 'PAGO'
ORDER BY data_pedido DESC;