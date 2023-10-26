*** Settings ***
Library    Browser
Library    FakerLibrary
Library    DateTime

*** Variables ***

${BROWSER}             chromium
${HEADLESS}            ${true}
${SITE_SERVE_REST}     https://front.serverest.dev/

*** Keywords ***

Abrir O Navegador
    New Browser        browser=${BROWSER}
    ...                headless=${HEADLESS}
    
    ${TRACE_NAME}      FakerLibrary.Uuid 4
    ${NOW}             Get Current Date    result_format=%d-%m-%Y_%H%M%S
    &{recordVideo}     Create Dictionary   dir=${OUTPUT_DIR}/evidencies/videos/${NOW}
    New Context        viewport={'width': 1200, 'height': 800}
    ...                tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    ...                recordVideo=${recordVideo}

Ir Para O Site Serve Rest
    New Page       url=${SITE_SERVE_REST}
    ${title}       Get Title  ==  Front - ServeRest
    Log            ${title}


Preencher Os Dados Do Novo Usuario E Cadastrar
    
    ${EMAIL}          FakerLibrary.Email
    ${NOME}           FakerLibrary.Name

    Click             css=[data-testid='cadastrar']
    Fill Text         css=[data-testid='nome']         ${NOME}
    Fill Text         css=[data-testid='email']        ${EMAIL}
    Fill Text         css=[data-testid='password']     123456
    Check Checkbox    css=[data-testid='checkbox']
    Click             css=[data-testid='cadastrar']

    ${INFO_USUARIO}    Create Dictionary    username=${NOME}    email=${EMAIL}
    RETURN    ${INFO_USUARIO}

Conferir Usuario Cadastrado Com Sucesso
    [Arguments]    ${NOME}
    Get Text    h1  ==  Bem Vindo ${NOME}
    Get Element States    css=[data-testid='logout']  validate  value & visible

Clicar Listar Usuarios
    Click             css=[data-testid='listarUsuarios']

Clicar Cadastrar Produtos
    Click             css=[data-testid='cadastrar-produtos']

Cadastrar Novo Produto
    
    ${NOME}           FakerLibrary.Word
    ${PRECO}          FakerLibrary.Random Int    10    100
    ${DESCRICAO}      FakerLibrary.Text    30
    ${QUANTIDADE}     FakerLibrary.Random Int    1    100

    Fill Text                     css=[data-testid='nome']         ${NOME}
    Fill Text                     css=[data-testid='preco']        ${PRECO}
    Fill Text                     css=[data-testid='descricao']    ${DESCRICAO}
    Fill Text                     css=[data-testid='quantity']     ${QUANTIDADE}
    Upload File By Selector       css=[data-testid='imagem']       ${CURDIR}/../files/product_image.jpg

    Click             css=[data-testid='cadastarProdutos']

    ${PRECO}         Convert To String    ${PRECO}
    ${QUANTIDADE}    Convert To String    ${QUANTIDADE}
    
    ${INFO_PRODUTO}    Create Dictionary    nome=${NOME}    preco=${PRECO}    descricao=${DESCRICAO}    quantidade=${QUANTIDADE}
    RETURN    ${INFO_PRODUTO}

Usuario Deve Estar Presente Na Lista De Usuários Cadastrados
    [Arguments]    ${USER_NOME}    ${USER_EMAIL}
    Tabela Deve Conter Dados Corretos    Email    ${USER_NOME}    ${USER_EMAIL}
    

Produto Deve Estar Presente Na Lista De Produtos Cadastrados
    [Arguments]    &{PRODUTO_INFO}
    Tabela Deve Conter Dados Corretos    Preço         ${PRODUTO_INFO.nome}    ${PRODUTO_INFO.preco}
    Tabela Deve Conter Dados Corretos    Descrição     ${PRODUTO_INFO.nome}    ${PRODUTO_INFO.descricao}
    Tabela Deve Conter Dados Corretos    Quantidade    ${PRODUTO_INFO.nome}    ${PRODUTO_INFO.quantidade}

Tabela Deve Conter Dados Corretos
    [Arguments]    ${coluna}    ${linha}    ${informacao}
    ${elemento}    Get Table Cell Element    css=.table-striped    "${coluna}"    "${linha}"
    Get Text    ${elemento}    ==    ${informacao}

Criar Usuario Via API
    ${EMAIL}          FakerLibrary.Email
    ${NOME}           FakerLibrary.Name

    Set Suite Variable    ${EMAIL}
    Set Suite Variable    ${NOME}

    ${resposta}    Http    url=https://serverest.dev/usuarios
    ...                    method=POST
    ...                    body={"nome": "${NOME}", "email": "${EMAIL}", "password": "123456", "administrador": "true"}

    Should Be Equal As Integers    ${resposta["status"]}    201

Logar Usuario Cadastrado Via API
    
    ${resposta}    Http    url=https://serverest.dev/login
    ...                    method=POST
    ...                    body={"email": "${EMAIL}", "password": "123456"}
    
    Should Be Equal As Integers    ${resposta["status"]}    200

    LocalStorage Set Item    serverest/userEmail    ${EMAIL}
    LocalStorage Set Item    serverest/userToken    ${resposta["body"]["authorization"]}
    LocalStorage Set Item    serverest/userNome     ${NOME}

    Go To    https://front.serverest.dev/admin/home


Cadastrar Usuario E Logar
    New Browser        browser=${BROWSER}
    ...                headless=${HEADLESS}

    New Page    url=${SITE_SERVE_REST}
    Criar Usuario Via API
    Logar Usuario Cadastrado Via API
    ${STORAGE_FILE}    Save Storage State
    Set Suite Variable    ${STORAGE_FILE}

Abrir O Site Serve Rest Logado

    New Browser        browser=${BROWSER}
    ...                headless=${HEADLESS}

    New Context    viewport={'width': 1200, 'height': 800}
    ...            storageState=${STORAGE_FILE}
    New Page    url=https://front.serverest.dev/admin/home
    Get Text    h1  ==  Bem Vindo ${NOME}
