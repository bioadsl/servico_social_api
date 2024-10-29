const db = require('../config/db');

const Usuario = {
    create: (data, callback) => {
        const query = `INSERT INTO usuarios (id, nome_completo, data_nascimento, genero, estado_civil, identificacao, endereco, telefone, email, perfil, senha) VALUES (UUID(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`;
        db.query(query, data, callback);
    },
    findByIdentificacao: (identificacao, callback) => {
        const query = `SELECT * FROM usuarios WHERE identificacao = ?`;
        db.query(query, [identificacao], callback);
    },
};

module.exports = Usuario;
