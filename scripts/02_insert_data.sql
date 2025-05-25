---INSERÇÃO DE DADOS---
---Inserir usuários---
INSERT INTO Usuarios (nome, email, tipo) VALUES
('João Silva', 'joao@universidade.edu', 'aluno'),
('Maria Souza', 'maria@universidade.edu', 'professor'),
('Carlos Oliveira', 'carlos@universidade.edu', 'funcionario'),
('Ana Pereira', 'ana@universidade.edu', 'aluno');

SELECT * FROM Usuarios;

---Inserir livros---
INSERT INTO Livros (titulo, autor, isbn, ano_publicacao, editora, quantidade_total, quantidade_disponivel) VALUES
('Banco de Dados Avançados', 'Carlos Heuser', '1234567890123', 2020, 'Bookman', 5, 5),
('SQL para Leigos', 'Alan Beaulieu', '9876543210987', 2018, 'Alta Books', 3, 3),
('Introdução à Programação', 'Luis Damas', '4567891230456', 2021, 'FCA', 8, 8),
('Redes de Computadores', 'Andrew Tanenbaum', '7891234560789', 2019, 'Pearson', 4, 4);

SELECT * FROM Livros;

---Inserir empréstimos---
INSERT INTO Emprestimos (usuario_id, livro_id, data_emprestimo, data_devolucao_prevista, status) VALUES
(1, 1, '2025-05-01', '2025-05-15', 'ativo'),
(2, 2, '2025-05-03', '2025-05-17', 'ativo'),
(3, 3, '2025-04-20', '2025-05-04', 'atrasado'),
(4, 4, '2025-05-10', '2025-05-24', 'ativo');

SELECT * FROM Emprestimos;

---Inserir multas---
INSERT INTO Multas (emprestimo_id, valor, status) VALUES
(3, 10.50, 'pendente');

SELECT * FROM Multas;


---Inserir reservas---
INSERT INTO Reservas (usuario_id, livro_id, status) VALUES
(1, 3, 'ativo'),
(2, 1, 'cancelado');

SELECT * FROM Reservas;

