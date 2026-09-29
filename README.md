# Projeto de Banco de Dados PostgreSQL - Sprint 4

Este repositório contém a implementação do modelo físico do banco de dados relacional para o sistema e-commerce, desenvolvido como entregável da **Sprint 4**.

## 1. Justificativa das Escolhas de Tipos de Dados

* **`SERIAL`**: Utilizado para as Chaves Primárias (`cliente_id`, `pedido_id`, etc.), garantindo autoincremento eficiente sem necessidade de gerenciar sequências manualmente.
* **`VARCHAR(n)` e `TEXT`**: `VARCHAR` foi aplicado em campos com limites bem definidos, como `cpf` (11 caracteres) e `email` (150 caracteres).
* **`NUMERIC(10,2)`**: Utilizado para valores monetários (`preco`, `valor_total`, `preco_unitario`) devido à precisão exata exigida em cálculos financeiros, evitando erros de arredondamento de ponto flutuante.
* **`TIMESTAMPTZ`**: Adotado para registro de datas (`data_cadastro`, `data_pedido`) com fuso horário, garantindo consistência temporal global.
* **`BOOLEAN`**: Utilizado no controle de status ativo/inativo de clientes para otimizar armazenamento (1 byte).

---

## 2. Estratégia de Indexação

A estratégia de indexação seguiu as boas práticas de otimização relacional:

* **Chaves Estrangeiras (`FKs`)**: Foram criados índices B-Tree (`idx_pedidos_cliente_id`, `idx_itens_pedido_pedido_id`, `idx_itens_pedido_produto_id`) em todas as FKs para evitar varreduras completas (`Seq Scan`) durante operações de `JOIN`.
* **Indexação para Filtros e Ordenação**:
  * `idx_pedidos_data_pedido`: Otimiza consultas com ordenação cronológica (`ORDER BY data_pedido DESC`).
  * `idx_pedidos_status_data`: Índice composto criado para acelerar relatórios operacionais por status de pedido filtrados por período.

---

## 3. Garantia de Integridade e Transações (ACID)

As transações foram configuradas para assegurar a consistência transacional:

* **Uso de `RETURNING`**: Permite capturar o `pedido_id` gerado no `INSERT` da tabela pai (`pedidos`) e utilizá-lo imediatamente nos inserções dos filhos (`itens_pedido`), garantindo operabilidade atômica em uma única execução.
* **`SAVEPOINT` e `ROLLBACK TO`**: Utilizados na segunda transação para demonstrar recuperação parcial de erros dentro do mesmo bloco transacional sem comprometer os comandos anteriores.

---

## 4. Controle de Acesso (RBAC)

Aplicou-se o Princípio do Menor Privilégio (*Principle of Least Privilege*):

| Role / Usuário | Nível de Acesso | Comandos Permitidos |
| :--- | :--- | :--- |
| **`role_leitura`** (`usuario_analista`) | Somente Leitura | `SELECT` |
| **`role_operadores`** (`usuario_app`) | Operacional | `SELECT`, `INSERT`, `UPDATE` (Sem permissão de `DELETE`) |

---

## 5. Análise de Performance com `EXPLAIN ANALYZE`

A análise do plano de execução do PostgreSQL confirmou o uso eficiente dos índices:

* **Consulta 1 (Filtro por `cliente_id`)**: O planner utilizou `Index Scan` através de `idx_pedidos_cliente_id`, eliminando o custo de `Seq Scan`.
* **Consulta 2 (Status e Ordenação por Data)**: O planner aplicou o índice composto `idx_pedidos_status_data`, realizando a ordenação de forma imediata na estrutura do índice.