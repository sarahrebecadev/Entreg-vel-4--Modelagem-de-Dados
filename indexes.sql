-- Indexacao das Chaves Estrangeiras para acelerar junções (JOINs)
CREATE INDEX idx_pedidos_cliente_id ON pedidos(cliente_id);
CREATE INDEX idx_itens_pedido_pedido_id ON itens_pedido(pedido_id);
CREATE INDEX idx_itens_pedido_produto_id ON itens_pedido(produto_id);

-- Indice B-Tree para buscas e ordenacao por data do pedido
CREATE INDEX idx_pedidos_data_pedido ON pedidos(data_pedido DESC);

-- Indice Composto para filtro por status e data
CREATE INDEX idx_pedidos_status_data ON pedidos(status, data_pedido);