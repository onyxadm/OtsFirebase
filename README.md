# OtsFirebase
Componente Delphi de Consumo do Google Firebase

# ONYX Tecnologia em Softwares
http://www.onyxsistemas.com

## Chamada a api rest: [Get, Post, Put, Patch, Delete]

### Componente sem propriedades? Como assim? "#"
Isso mesmo. Se você já instalou o **OtsFirebase** no seu Delphi, você deve ter notado que o componente não 
possui propriedades publicadas visíveis ao Object Inspector, foi desenvolvido dessa forma para evitar 
que suas informações fiquem vulneráveis a algum tipo de "pessoa curiosa" e você deve informá-las em tempo de execução.

### Mais o OtsFirebase serve apenas para consumo do próprio Firebase?
**Não**, o **OtsFirebase** pode consumir qualquer webservices, veja o quanto é fácil: 
```pascal
    OtsFirebase.Request(MINHA_URL).Get();
```
Ainda é possível passar token, parâmetros, header's, etc.
```pascal
    OtsFirebase.Request(MINHA_URL, MEU_TOKEN).Resource([PARAMS]).Header(HEADER_NAME, HERADER_VALUE).Get();
```
*Fácil não?*

### Se não tem propriedades visíveis ao Object Inspector, posso criá-lo em Run-Time?
**Sim**, pode trabalhar normalmente como achar melhor. Para ajudá-lo nisso, foi criado o arquivo 
**OtsFirebase.Integration.pas**, para isso siga os seguintes passos: 
1. Instale o **OtsFirebase** no seu Delphi;
2. Adicione o **OtsFirebase.Integration.pas** ao seu projeto **Vcl/Fmx**; 
3. Pronto! Agora basta você utilizar a chamada da instância **Firebase()...** sem se preocupar com a criação do mesmo; 

Desta forma é mantida apenas uma instância, e caso use para fim de consumo ao Firebase, não fica sendo necessário, 
realizar a autenticação em todas as requisições, pois o token **JWT** do primeiro acesso ainda pode 
ser válido, e por lógica a primeira requisição (*onde acontece a autenticação*) é sempre mais demorada que as outras. 

## Forma de uso :: 
### Partindo da premissa que seu projeto firebase já esta criado no Console Firebase. 
https://console.firebase.google.com/

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
1. **Código do Projeto** (*geralmente é o nome do seu projeto*);
2. **Chave de API da Web** (Ex.: *AIzaSyC2ofTLxZoA9HvXPWJV6Oub02LW0mRdTjr*)

### Informando os dados do projeto firebase no **OtsFirebase** ::
Existem duas formas de informar os dados do projeto ao **OtsFirebase**, são elas: 

1. Alimentando a propriedade pública: 

```pascal
    OtsFirebase.API_KEY    := MINHA_API_KEY;
    OtsFirebase.PROJECT_ID := MEU_PROJECT_ID;
```    

2. Diretamente na chamada da consulta desejada: 

```pascal
    OtsFirebase.API(MINHA_API_KEY, MEU_PROJECT_ID)...
```    
Após informar a primeira vez, não será necessário passar novamente durante às chamadas à api.

### Criando um usuário no projeto Firebase através de email e senha ::
É possível criar os usuários que terão acesso ao Firebase, isso evitar perda de tempo por parte 
dos administradores e/ou mantenedores da base de dados, quando esta tarefa é realizada com sucesso, 
a api do Google já retorna seus dados de acesso incluindo o **JWT**, que é administrado pelo **OtsFirebase**, 
assim você não precisará se preocupar com o refresh do e/ou informação do Token de acesso temporário,
por exemplo: 

```pascal
    OtsFirebase.API(MINHA_API_KEY, MEU_PROJECT_ID)
        .Auth(email@email.com, minha_senha, TRUE)
        .ToJSONObject.ToString;
```
O **TRUE** no terceiro parâmetro da autenticação informa ao **OtsFirebase** para criar o usuário informado;

### Autenticando um usuário para acesso ao consumo do projeto Firebase ::
Para autenticar um usuário previamente cadastrado, basta realizar a mesma chamada de criação de usuários sem 
o terceiro parâmetro **TRUE** (*que é opcional na chamada*), ou defina como **FALSE**, como desejar, assim ele 
não irá criar um usuário, irá apenas autenticar-se,
por exemplo:

```pascal
    OtsFirebase.API(MINHA_API_KEY, MEU_PROJECT_ID)
        .Auth(meu.email@dominio.com, minha_senha)
        .ToJSONObject.ToString;
```    
Pronto, assim o **OtsFirebase** já tem as credenciais necessárias para fazer qualquer chamada à api. 
Além disso você pode autenticar durante chamada qualquer de consumo à api sem a necessidade de fazé-la separadamente, 
por exemplo: 

```pascal
procedure TfrmMain.btnGetDocumentClick(Sender: TObject);
var
  Obj: TJSONObject;
begin
  Obj := OtsFirebase.API(MINHA_API_KEY, MEU_PROJECT_ID)  //Ou apenas OtsFirebase.Auth(email@email.com, minha_senha)
            .Auth(email@email.com, minha_senha)
            .Database
            .Resource([node_do_documento])  //Ex.: 	Vendas/Itens então ficaria assim: 
            .Get();    			    // 		**.Resource(['Vendas', 'Itens'])** ou 
					    // 		**.Resource(['Vendas/Itens'])**
end;    
```
O **OtsFirebase** irá autenticar e na mesma chamada vai retornar o JSONObject da sua solicitação, desta forma você tem 
todo o controle das informações;

### Autenticando como **anonymous** no Firebase sem regras de segurança definidas ::
A fim de facilitar o uso do **OtsFirebase**, é possível trabalhar de forma anônima, necessitando apenas do **Código do Projeto** 
Firebase (*onde geralmente é o nome do seu projeto*), onde se reduz bastante chamadas,
por exemplo:

```pascal
procedure TfrmMain.btnGetDocumentClick(Sender: TObject);
var
  Obj: TJSONObject;
begin
  Obj := OtsFirebase.API(MEU_PROJECT_ID)    //Neste caso, a chamada **OtsFirebase.API(MEU_PROJECT_ID)** se torna obrigatória
            .Database
            .Resource([node_do_documento])  //Ex.: 	Vendas/Itens então ficaria assim: 
            .Get();    			    // 		**.Resource(['Vendas', 'Itens'])** ou 
					    // 		**.Resource(['Vendas/Itens'])**
end;    
```

### Usando o padrão Google de ID nos documentos ::
É possível utilizar o padrão de ID's da própria api (algo como: **-LIpPDOxgUwPVfDwCdRn**) em casos de inserção de documentos,
por exemplo:

```pascal
procedure TfrmMain.btnGetDocumentClick(Sender: TObject);
var
  Obj: TJSONObject;
begin
  Obj := OtsFirebase.API(MEU_PROJECT_ID) 
            .Database 
            .Resource([node_do_documento]) 
	    .AutoIncremento() 
            .Post(JSONValue); 
end;    
```
Desta forma o retorno em JSONObject irá conter o padrão Google de ID's, para utilizar um ID personalizado 
por você mesmo, basta não incluir o **.AutoIncremento()**. 

**OBS: O cuidado deve ser redobrado caso decida não utilizar o AutoIncremento** [*VIDE LICENÇA DO **OtsFirebase***]; 

### Outras chamadas dentro das classes para consumo da api pelo **OtsFirebase** ::
Além do básico já comentado acima, existem alguns recursos do **OtsFirebase** que podem ser executados 
sem sair da linha padrão desejada após o **.Database.Resource([node_do_documento])**, 
por exemplo:
- **ContentType** 
- **AcceptType** 
- **QueryParams**    (*Que são chamadas acrescentadas como parâmetro na url*)
- **Header's** 
- **Token**
- **AutoIncremento** (*Usado para definir se vai usar o padrão do Google nos root's dos documentos*) 
- **OrderByKey**     (*Este é usado por último nas chamadas*) 






*********************************************************************************************************

    EM BREVE MAIS DETALHES DE USO...
    
*********************************************************************************************************




