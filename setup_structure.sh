#!/bin/bash

# Criação da estrutura de pastas
mkdir -p servico_social_api/{config,controllers,middleware,models,routes}

# Criação do arquivo de configuração do banco de dados
cat <<EOL > servico_social_api/config/db.js
const mysql = require('mysql2');
require('dotenv').config();

const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

db.connect((err) => {
    if (err) throw err;
    console.log("Conectado ao banco de dados MySQL!");
});

module.exports = db;
EOL

# Criação do middleware de autenticação
cat <<EOL > servico_social_api/middleware/authMiddleware.js
const jwt = require('jsonwebtoken');
require('dotenv').config();

function authenticateToken(req, res, next) {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) return res.sendStatus(401);

    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
}

module.exports = authenticateToken;
EOL

# Criação do modelo de usuário
cat <<EOL > servico_social_api/models/usuarioModel.js
const db = require('../config/db');

const Usuario = {
    create: (data, callback) => {
        const query = \`INSERT INTO usuarios (id, nome_completo, data_nascimento, genero, estado_civil, identificacao, endereco, telefone, email, perfil, senha) VALUES (UUID(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\`;
        db.query(query, data, callback);
    },
    findByIdentificacao: (identificacao, callback) => {
        const query = \`SELECT * FROM usuarios WHERE identificacao = ?\`;
        db.query(query, [identificacao], callback);
    },
};

module.exports = Usuario;
EOL

# Criação do controlador de autenticação
cat <<EOL > servico_social_api/controllers/authController.js
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const Usuario = require('../models/usuarioModel');
require('dotenv').config();

exports.register = async (req, res) => {
    const { nome_completo, data_nascimento, genero, estado_civil, identificacao, endereco, telefone, email, perfil, senha } = req.body;
    const hashedPassword = await bcrypt.hash(senha, 10);
    Usuario.create([nome_completo, data_nascimento, genero, estado_civil, identificacao, endereco, telefone, email, perfil, hashedPassword], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ message: 'Usuário registrado com sucesso!' });
    });
};

exports.login = (req, res) => {
    const { identificacao, senha } = req.body;
    Usuario.findByIdentificacao(identificacao, async (err, results) => {
        if (err || results.length === 0) return res.status(401).json({ error: 'Identificação ou senha inválidos!' });
        const user = results[0];
        const isMatch = await bcrypt.compare(senha, user.senha);
        if (!isMatch) return res.status(401).json({ error: 'Identificação ou senha inválidos!' });
        const token = jwt.sign({ id: user.id, perfil: user.perfil }, process.env.JWT_SECRET, { expiresIn: '1h' });
        res.json({ token });
    });
};
EOL

# Criação das rotas de autenticação
cat <<EOL > servico_social_api/routes/authRoutes.js
const express = require('express');
const authController = require('../controllers/authController');
const router = express.Router();

router.post('/register', authController.register);
router.post('/login', authController.login);

module.exports = router;
EOL

# Criação do arquivo principal
cat <<EOL > servico_social_api/app.js
const express = require('express');
const db = require('./config/db');
const authRoutes = require('./routes/authRoutes');
require('dotenv').config();

const app = express();
app.use(express.json());

app.use('/auth', authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(\`Servidor rodando na porta \${PORT}\`));
EOL

# Mensagem final
echo "Estrutura de pastas e arquivos criada com sucesso em 'servico_social_api/'!"
echo "Lembre-se de adicionar um arquivo .env com as variáveis de ambiente."
