## 1. Pré-requisitos
Antes de executar o script, verifique se você tem as seguintes ferramentas instaladas:

- **Node.js** (versão 14 ou superior)
- **MySQL** (ou outro banco de dados que você prefira)
- **Git Bash** ou terminal compatível com bash (se estiver usando Windows)

## 2. Executar o Script Bash

1. Criar a Estrutura de Pastas:
- Salve o script que você forneceu em um arquivo chamado setup.sh.
- Abra o terminal (ou Git Bash) e navegue até o diretório onde o setup.sh está salvo.
- Execute o script com o comando:

```
bash setup.sh
```

- Isso criará a estrutura de diretórios e os arquivos necessários.

## 3. Instalar Dependências
Após criar a estrutura de pastas, navegue até a pasta do projeto:


```
cd servico_social_api
```
Em seguida, inicialize um novo projeto Node.js (se ainda não foi feito):

```
npm init -y
```
Agora, instale as dependências necessárias:

```
npm install express mysql2 dotenv bcryptjs jsonwebtoken
```
## 4. Configurar o Banco de Dados
Criar o Banco de Dados e a Tabela:
Acesse o MySQL usando um cliente como o mysql no terminal ou o phpMyAdmin.
Crie um novo banco de dados (por exemplo, servico_social):

```
CREATE DATABASE servico_social;
```
- Use o banco de dados:

```
USE servico_social;
```

- Crie a tabela usuarios:
```
CREATE TABLE usuarios (
    id VARCHAR(36) PRIMARY KEY,
    nome_completo VARCHAR(255),
    data_nascimento DATE,
    genero VARCHAR(50),
    estado_civil VARCHAR(50),
    identificacao VARCHAR(50) UNIQUE,
    endereco TEXT,
    telefone VARCHAR(20),
    email VARCHAR(100),
    perfil VARCHAR(50),
    senha VARCHAR(255)
);
```
## 5. Criar o Arquivo .env
Na raiz do projeto (servico_social_api), crie um arquivo chamado .env e adicione as seguintes variáveis:

```
DB_HOST=localhost
DB_USER=seu_usuario
DB_PASSWORD=sua_senha
DB_NAME=servico_social
JWT_SECRET=seu_segredo
PORT=3000
```
- Certifique-se de substituir seu_usuario, sua_senha e seu_segredo com suas credenciais reais.

## 6. Executar a Aplicação
Agora você pode iniciar a aplicação:

````
node app.js
````
Você deve ver uma mensagem informando que o servidor está rodando:
```
Servidor rodando na porta 3000
```
## 7. Testar as Rotas
Você pode usar uma ferramenta como Postman ou cURL para testar as rotas de autenticação:

- Registrar um Usuário:

- URL: http://localhost:3000/auth/register
- Método: POST
- Corpo (JSON):
```
{
  "nome_completo": "Nome do Usuário",
  "data_nascimento": "2000-01-01",
  "genero": "Masculino",
  "estado_civil": "Solteiro",
  "identificacao": "123456789",
  "endereco": "Rua Exemplo, 123",
  "telefone": "1234567890",
  "email": "usuario@example.com",
  "perfil": "usuario",
  "senha": "senha123"
}
```
-Login do Usuário:

- URL: http://localhost:3000/auth/login
- Método: POST
- Corpo (JSON):

```
{
  "identificacao": "123456789",
  "senha": "senha123"
}

```
## Conclusão
Agora você deve ter sua aplicação backend configurada e em execução. Se você encontrar algum problema ou precisar de mais assistência, sinta-se à vontade para perguntar!
