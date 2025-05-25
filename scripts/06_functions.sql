---FUNCTIONS---
---Tipo Escalar(ex:o total de multas de um usuário)---
CREATE OR REPLACE FUNCTION calcular_total_multas(p_usuario_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC := 0;
BEGIN
    SELECT SUM(m.valor)
    INTO total
    FROM Multas m
    JOIN Emprestimos e ON m.emprestimo_id = e.id
    WHERE e.usuario_id = p_usuario_id;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;

SELECT calcular_total_multas(3);

---Retorna a Tabela(ex:lista de livros emprestados por usuário)---
CREATE OR REPLACE FUNCTION listar_livros_usuario(p_usuario_id INT)
RETURNS TABLE(titulo VARCHAR, data_emprestimo DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT l.titulo, e.data_emprestimo
    FROM Emprestimos e
    JOIN Livros l ON e.livro_id = l.id
    WHERE e.usuario_id = p_usuario_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM listar_livros_usuario(1);


---Tratamento de Erro---
CREATE OR REPLACE FUNCTION verificar_disponibilidade(p_livro_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    disponivel INT;
BEGIN
    SELECT quantidade_disponivel INTO disponivel FROM Livros WHERE id = p_livro_id;

    IF disponivel IS NULL THEN
        RAISE EXCEPTION 'Livro com ID % não encontrado.', p_livro_id;
    ELSIF disponivel < 1 THEN
        RAISE EXCEPTION 'Livro com ID % está indisponível para empréstimo.', p_livro_id;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

SELECT verificar_disponibilidade(1);

