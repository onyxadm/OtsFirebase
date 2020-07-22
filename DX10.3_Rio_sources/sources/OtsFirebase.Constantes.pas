unit OtsFirebase.Constantes;

{
  Projeto.: Constantes dos Metodos Rest ®
  Data....: 21/12/2018 20:08
  Autor...: Marivaldo Santos
  Empresa.: ONYX Tecnologia em Softwares ®
  Site....: www.onyxsistemas.com
  Licença.: Privada e protegida - © Todos os direitos reservados.
  email...: admin@onyxsistemas.com
}

interface

const
  RECORD_NOT_FOUND       = '{"result": "Nenhum registro encontrado"}';
  RECORD_NOT_PROCESSED   = '{"result": "Nenhum registro processado"}';
  JSON_EMPTY_NOT_ALLOWED = '{"result": "JSON vazio não é permitido"}';
  MSG_SUCESS             = '{"result": "sucesso"}';

  _FIREBASE_DOMAIN_URL             = '.firebaseio.com';
  FIREBASE_DATABASE_URL            = 'https://%s' + _FIREBASE_DOMAIN_URL;
  GOOGLE_REFRESH_AUTH_URL          = 'https://securetoken.googleapis.com/v1/token';
  GOOGLE_CUSTOM_AUTH_URL           = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken';
  GOOGLE_GET_USER_URL              = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo';
  GOOGLE_CURRENT_USER_URL          = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/currentUser';
  GOOGLE_IDENTITY_URL              = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyAssertion';
  GOOGLE_SIGNUP_URL                = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser';
  GOOGLE_PASSWORD_URL              = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword';
  GOOGLE_GET_CONFIRMATION_CODE_URL = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/getOobConfirmationCode';
  GOOGLE_SET_ACCOUNT_URL           = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/setAccountInfo';
  GOOGLE_CREATE_AUTH_URL           = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/createAuthUri';
  TYPE_JSON                        = 'application/json';

  sContentType                = 'Content-Type';
  MediaType_Json              = 'application/json';
  LOCALE_PORTUGUESE_BRAZILIAN = 'pt-BR';

  AUTHORIZATION_STR = 'Authorization';

type
  TArrString = array of string;

implementation

end.
