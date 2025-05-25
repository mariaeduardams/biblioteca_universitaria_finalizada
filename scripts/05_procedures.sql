---STORED PROCEDURES---
---Procedure com cursar---
CREATE OR REPLACE PROCEDURE atualizar_status_emprestimos()
LANGUAGE plpgsql
AS $$
DECLARE
    emp RECORD;
BEGIN
    FOR emp IN SELECT * FROM Emprestimos WHERE data_devolucao_real IS NULL LOOP
        IF emp.data_devolucao_prevista < CURRENT_DATE THEN
            UPDATE Emprestimos
            SET status = 'atrasado'
            WHERE id = emp.id;
        END IF;
    END LOOP;
END;
$$;

CALL atualizar_status_emprestimos();
SELECT * FROM Emprestimos;


---Procedure com Parâmetros Opcionais---
CREATE OR REPLACE PROCEDURE buscar_usuarios(tipo_filtro VARCHAR DEFAULT NULL, nome_filtro VARCHAR DEFAULT NULL)
LANGUAGE plpgsql
AS $$
BEGIN
    IF tipo_filtro IS NOT NULL AND nome_filtro IS NOT NULL THEN
        RAISE NOTICE 'Tipo e nome:';
        PERFORM * FROM Usuarios WHERE tipo = tipo_filtro AND nome ILIKE '%' || nome_filtro || '%';
    ELSIF tipo_filtro IS NOT NULL THEN
        RAISE NOTICE 'Só tipo:';
        PERFORM * FROM Usuarios WHERE tipo = tipo_filtro;
    ELSIF nome_filtro IS NOT NULL THEN
        RAISE NOTICE 'Só nome:';
        PERFORM * FROM Usuarios WHERE nome ILIKE '%' || nome_filtro || '%';
    ELSE
        RAISE NOTICE 'Todos os usuários:';
        PERFORM * FROM Usuarios;
    END IF;
END;
$$;


CALL buscar_usuarios('aluno', 'João');  ---usado para testar---

SELECT * FROM Usuarios ---teste com exibição---
WHERE tipo = 'aluno' AND nome ILIKE '%João%'; 



---Procedure para Registrar Reserva---
CREATE OR REPLACE PROCEDURE registrar_reserva(p_usuario_id INT, p_livro_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Reservas (usuario_id, livro_id, data_reserva, status)
    VALUES (p_usuario_id, p_livro_id, CURRENT_TIMESTAMP, 'ativo');
END;
$$;

CALL registrar_reserva(1, 2);
SELECT * FROM Reservas ORDER BY id DESC;


