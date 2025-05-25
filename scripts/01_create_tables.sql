---database criada manualmente---


---CRIAÇÃO DAS TABELAS---
---Criação da Tabela Usuarios---
CREATE TABLE Usuarios (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  tipo VARCHAR(20) CHECK (tipo IN ( 'aluno', 'professor', 'funcionario')) NOT NULL,
  data_cadastro DATE DEFAULT CURRENT_DATE
);
---Criação da Tabela livros---
CREATE TABLE Livros (
  id SERIAL PRIMARY KEY,
  titulo VARCHAR(200) NOT NULL,
  autor VARCHAR(100) NOT NULL,
  isbn VARCHAR(20) UNIQUE,
  ano_publicacao INT,
  editora VARCHAR(100),
  quantidade_total INT NOT NULL,
  quantidade_disponivel INT NOT NULL,
  CHECK (quantidade_disponivel <= quantidade_total)
);
---Criação da Tabela Emprestimos---
CREATE TABLE Emprestimos (
  id SERIAL PRIMARY KEY,
  usuario_id INT NOT NULL,
  livro_id INT NOT NULL,
  data_emprestimo DATE DEFAULT CURRENT_DATE,
  data_devolucao_prevista DATE NOT NULL,
  data_devolucao_real DATE,
  status VARCHAR(20) DEFAULT 'ativo' CHECK (status IN ('ativo', 'finalizado', 'atrasado')),
  FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
  FOREIGN KEY (livro_id) REFERENCES Livros(id)
);
---Criação da tabela Reservas---
CREATE TABLE Reservas (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    livro_id INT NOT NULL,
    data_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'ativo' CHECK (status IN ('ativo', 'cancelado', 'finalizado')),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY (livro_id) REFERENCES Livros(id)
);

---Criação da tabela Multas--- 
CREATE TABLE Multas (
    id SERIAL PRIMARY KEY,
    emprestimo_id INT NOT NULL,
    valor NUMERIC(10, 2) NOT NULL,
    data_pagamento DATE,
    status VARCHAR(20) DEFAULT 'pendente' CHECK (status IN ('pendente', 'pago')),
    FOREIGN KEY (emprestimo_id) REFERENCES Emprestimos(id)
);

---Criação da tabela Log_Auditoria---
CREATE TABLE Log_Auditoria (
    id SERIAL PRIMARY KEY,
    tabela_afetada VARCHAR(50) NOT NULL,
    acao VARCHAR(10) CHECK (acao IN ('INSERT', 'UPDATE', 'DELETE')) NOT NULL,
    registro_id INT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_responsavel VARCHAR(100)
);


