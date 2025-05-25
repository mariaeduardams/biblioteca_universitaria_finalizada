---TRIGGER---
---Auditoria---
---Função---
CREATE OR REPLACE FUNCTION log_auditoria_func()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Log_Auditoria (tabela_afetada, acao, registro_id, data_hora, usuario_responsavel)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        COALESCE(NEW.id, OLD.id),
        CURRENT_TIMESTAMP,
        current_user
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----Exemplo de Aplicação na Tabela Usuarios---
CREATE TRIGGER trigger_log_usuarios
AFTER INSERT OR UPDATE OR DELETE ON Usuarios
FOR EACH ROW
EXECUTE FUNCTION log_auditoria_func();


---Envolvendo Duas Tabelas---
---FUNÇÃO---
---DIMINUIR---
CREATE OR REPLACE FUNCTION diminuir_disponibilidade()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Livros
    SET quantidade_disponivel = quantidade_disponivel - 1
    WHERE id = NEW.livro_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_diminuir_disponibilidade
AFTER INSERT ON Emprestimos
FOR EACH ROW
EXECUTE FUNCTION diminuir_disponibilidade();

---AUMENTAR---
CREATE OR REPLACE FUNCTION aumentar_disponibilidade()
RETURNS TRIGGER AS $$
BEGIN
   
    IF NEW.data_devolucao_real IS NOT NULL AND OLD.data_devolucao_real IS NULL THEN
        UPDATE Livros
        SET quantidade_disponivel = quantidade_disponivel + 1
        WHERE id = NEW.livro_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_aumentar_disponibilidade
AFTER UPDATE ON Emprestimos
FOR EACH ROW
EXECUTE FUNCTION aumentar_disponibilidade();

---Alterar Comportamento---
---FUNÇÃO---
CREATE OR REPLACE FUNCTION bloquear_exclusao_usuario()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Emprestimos
        WHERE usuario_id = OLD.id AND status = 'ativo'
    ) THEN
        RAISE EXCEPTION 'Usuário possui empréstimos ativos e não pode ser excluído.';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_bloquear_exclusao
BEFORE DELETE ON Usuarios
FOR EACH ROW
EXECUTE FUNCTION bloquear_exclusao_usuario();

---TESTES DOS TRIGGER---
---AUDITORIA---
---Inserir novo usuário---
INSERT INTO Usuarios (nome, email, tipo)
VALUES ('Teste Auditoria', 'auditoria@teste.com', 'aluno');

---Atualizar usuário---
UPDATE Usuarios
SET nome = 'Teste Alterado'
WHERE email = 'auditoria@teste.com';

---Deletar usuário---
DELETE FROM Usuarios
WHERE email = 'auditoria@teste.com';

---Verificação da Tabela Log---
SELECT * FROM Log_Auditoria ORDER BY id DESC;


---DIMINUIR---
SELECT id, titulo, quantidade_disponivel FROM Livros WHERE id = 1;
---fazendo um empréstimo---
INSERT INTO Emprestimos (usuario_id, livro_id, data_emprestimo, data_devolucao_prevista, status)
VALUES (1, 1, CURRENT_DATE, CURRENT_DATE + INTERVAL '7 days', 'ativo');
---teste para ver se realmente diminuiu---
SELECT id, titulo, quantidade_disponivel FROM Livros WHERE id = 1;

---AUMENTAR---
SELECT quantidade_disponivel FROM Livros WHERE id = 1;
---atualizando---
UPDATE Emprestimos
SET data_devolucao_real = CURRENT_DATE
WHERE id = 1;
---teste para ver se realmente aumentou---
SELECT quantidade_disponivel FROM Livros WHERE id = 1;

---BLOQUEAR EXCLUSÃO---
SELECT * FROM Emprestimos WHERE usuario_id = 1 AND status = 'ativo';
---tentativa de delete(tem que dar erro)---
DELETE FROM Usuarios WHERE id = 1;

