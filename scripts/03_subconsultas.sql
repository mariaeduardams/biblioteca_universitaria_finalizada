---SUBCONSULTAS---
---1: Média de livros emprestados por usuário---
SELECT AVG(total_emprestimos) AS media_emprestimos
FROM (
    SELECT usuario_id, COUNT(*) AS total_emprestimos 
    FROM Emprestimos 
    GROUP BY usuario_id
) AS subquery;

---2: Contar empréstimos por livro---
SELECT 
    titulo, 
    (SELECT COUNT(*) FROM Emprestimos WHERE livro_id = l.id) AS total_emprestimos
FROM Livros l;

---3: Livros nunca emprestados---
SELECT titulo 
FROM Livros l
WHERE NOT EXISTS (
    SELECT 1 
    FROM Emprestimos e 
    WHERE e.livro_id = l.id
);

---4: Usuários com empréstimos ativos---
SELECT nome 
FROM Usuarios
WHERE id IN (
    SELECT usuario_id 
    FROM Emprestimos 
    WHERE status = 'ativo'
);

---5: Livro mais emprestado---
SELECT titulo, autor
FROM Livros
WHERE id = (
    SELECT livro_id 
    FROM Emprestimos 
    GROUP BY livro_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1
);


