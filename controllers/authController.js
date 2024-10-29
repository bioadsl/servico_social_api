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
