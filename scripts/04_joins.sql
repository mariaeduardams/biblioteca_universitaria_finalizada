---JOINS AVANÇADOS---
---INNER JOIN---
SELECT u.nome, l.titulo, e.data_emprestimo
FROM Usuarios u
INNER JOIN Emprestimos e ON u.id = e.usuario_id
INNER JOIN Livros l ON e.livro_id = l.id;

---LEFT JOIN---
SELECT u.nome, e.id AS emprestimo_id
FROM Usuarios u
LEFT JOIN Emprestimos e ON u.id = e.usuario_id;


---RIGHT JOIN---
SELECT e.id AS emprestimo_id, u.nome
FROM Emprestimos e
RIGHT JOIN Usuarios u ON e.usuario_id = u.id;

---FULL OUTER JOIN---
SELECT u.nome, e.id AS emprestimo_id
FROM Usuarios u
FULL OUTER JOIN Emprestimos e ON u.id = e.usuario_id;


---JOIN COM SUBCONSULTA COMO TABELA DERIVADA---
SELECT u.nome, sub.total
FROM Usuarios u
JOIN (
    SELECT usuario_id, COUNT(*) AS total
    FROM Emprestimos
    GROUP BY usuario_id
    HAVING COUNT(*) > 1
) AS sub ON u.id = sub.usuario_id;

