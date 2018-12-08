# OtsFirebase
Componente Delphi de Consumo do Google Firebase

# ONYX Tecnologia em Softwares
http://www.onyxsistemas.com

### Componente sem propriedades? Como assim? "#"
Isso mesmo. Se você já instalou o OtsFirebase no seu Delphi, você deve ter notado que o componente não 
possui propriedades publicadas visiveis ao Object Inspector, foi desenvolvido dessa forma para evitar 
que suas informações fiquem vulneráveis a algum tipo de "pessoa curiosa" e você deve informá-las em tempo de execução.

## Chamada padrão à api rest do Google Firebase: [Get, Post, Put, Patch, Delete]

## Forma de uso :: 
### Partindo da premissa que seu projeto firebase já esta criado no Console Firebase. 

*********************************************************************************************************
   Caso queira controlar usuários que terão acesso ao seu projeto firebase através de usuário e senha, 
   será necessário definir as regras de segurança do banco de dados como no exemplo abaixo;
*********************************************************************************************************
```json
{
  "rules": {
    ".read": "auth !== null",
    ".write": "auth !== null"
  }
}
```
caso contrário basta manté-lo com regras públicas 
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```
*********************************************************************************************************

Acesse as configurações do seu projeto no Console Firebase e obtenha os seguintes dados:
1. Código do Projeto (geralmente é o nome do seu projeto);
2. Chave de API da Web (Ex.: AIzaSyC2ofTLxZoA9HvXPWJV6Oub02LW0mRdTjr)

### Informando os dados do projeto firebase no componente ::
Existem duas formas de informar os dados do projeto ao componente, são elas: 
1. Alimentando a propriedade pública: 
ex.: 
```pascal
    OtsFirebase.API_KEY    := MINHA_API_KEY;
    OtsFirebase.PROJECT_ID := MEU_PROJECT_ID;
```    
2. Diretamente na chamada da consulta desejada: 
ex.: 
```pascal
    OtsFirebase.API(MINHA_API_KEY, MEU_PROJECT_ID)...
```    
Após informar a primeira vez, não será necessário passar novamente durante às chamadas à api.

### Criando um usuário no projeto Firebase através de email e senha ::
É possível criar os usuários que terão acesso ao Firebase, isso evitar perda de tempo por parte 
dos administradores e/ou mantenedores da base de dados, quando esta tarefa é realizada com sucesso, 
a api do Google já retorna seus dados de acesso incluindo o JWT, que é administrado pelo OtsFirebase, 
assim você não precisará se preocupar com o refresh do e/ou informação do Token de acesso temporário,
por exemplo: 
```pascal
    OtsFirebase.API(MINHA_API_KEY, MEU_PROJECT_ID)
        .Auth(meu.email@dominio.com, minha_senha, TRUE)
        .ToJSONObject.ToString;
```
O TRUE no terceiro parâmetro da Autenticação informa ao OtsFirebase para criar o usuário informado;

### Autenticando um usuário para acesso ao consumo do projeto Firebase ::
Para autenticar um usuário previamente cadastrado, basta realizar a mesma chamada de criação de usuários sem 
o terceiro parâmetro TRUE (que é opcional na chamada), ou defina como FALSE, como desejar, assim ele não irá criar, apenas autenticar,
por exemplo:
```pascal
    OtsFirebase.API(MINHA_API_KEY, MEU_PROJECT_ID)
        .Auth(meu.email@dominio.com, minha_senha)
        .ToJSONObject.ToString;
```    
Pronto, assim o OtsFirebase já tem as credenciais necessárias para fazer qualquer chamada à api. 
Além disso você pode autenticar durante qualquer chamada de consumo à api sem a necessidade de fazé-la separadamente, 
por exemplo: 
```pascal
procedure TfrmMain.btnGetDocumentClick(Sender: TObject);
var
  Obj: TJSONObject;
begin
  Obj := OtsFirebase.API(MINHA_API_KEY, MEU_PROJECT_ID)  //Ou apenas OtsFirebase.Auth(meu.email@dominio.com, minha_senha)...
            .Auth(meu.email@dominio.com, minha_senha)
            .Database
            .Resource([node_do_documento]) //Ex.: Vendas/Itens então ficaria assim: .Resource(['Vendas', 'Itens'])
            .Get();    
end;    
```
O OtsFirebase irá autenticar e na mesma chamada vai retornar o JSONObject da sua solicitação, desta forma vc tem 
todo o controle das informações;




    EM BREVE MAIS DETALHES DE USO...
    





