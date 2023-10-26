*** Settings ***
Resource    ../resources/serve-rest-front.resource

Suite Setup       Cadastrar Usuario E Logar
Suite Teardown    Close Browser    ALL

*** Test Cases ***

Login Com Sucesso Serve Rest Front
    Abrir O Navegador
    Ir Para O Site Serve Rest
    ${INFO_USUARIO}    Preencher Os Dados Do Novo Usuario E Cadastrar
    Conferir Usuario Cadastrado Com Sucesso    ${INFO_USUARIO.username}


Novo Usuário Deve Aparecer Na Lista De Usuário Cadastrados
    Abrir O Site Serve Rest Logado
    Clicar Listar Usuarios
    Usuario Deve Estar Presente Na Lista De Usuários Cadastrados    ${NOME}    ${EMAIL}

Novo Produto Deve Ser Cadastrado Com Sucesso
    Abrir O Site Serve Rest Logado
    Clicar Cadastrar Produtos
    &{INFO_PRODUTO}    Cadastrar Novo Produto
    Produto Deve Estar Presente Na Lista De Produtos Cadastrados    &{INFO_PRODUTO}

Exemplo Usando O Storage Armazenado No Contexto
    Abrir O Site Serve Rest Logado
    Clicar Listar Usuarios
    