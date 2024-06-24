# Aplicativo Tirol Office

Aplicativo multiplataforma desenvolvido em Flutter para gestão e manutenção de espaços de coworking. Ele permite que os usuários registrem e acompanhem manutenções, além de fornecer funcionalidades de autenticação e integração com Firebase.

## Funcionalidades

- Registro e acompanhamento de salas, equipamento e manutenções
- Leitura de códigos de barras para identificação de salas
- Autenticação de usuários usando Firebase
- Integração com Cloud Firestore para armazenamento de dados
- Validação de email e strings

## Autenticação (Firebase)

- Usuário e senha
- Provedor de autenticação via conta gmail

## Banco de Dados

- Cloud Firestore (NoSQL)

## Gerenciamento de estado

- Provider
- Mobx

## Instalação

Para configurar o projeto localmente, siga estas etapas:

1. **Clone o repositório:**

   ```bash
   git clone [https://github.com/matheusmota3242/tirol_office_app]

2. **Instale as dependências**

   ```bash
   flutter pub get

3. **Execute o aplicativo**
   ```bash
   flutter run

## Dependências
   ```bash
   dependencies:
     flutter:
       sdk: flutter
     cupertino_icons: ^1.0.0
     flutter_svg:
     flutter_barcode_scanner:
     firebase_core: ^0.7.0
     firebase_auth: ^0.20.0+1
     cloud_firestore: ^0.16.0
     mobx: ^1.2.1+4
     flutter_mobx: ^1.1.0+2
     provider: ^4.3.3
     fluttertoast: ^7.1.6
     email_validator: '^1.0.5'
     string_validator: ^0.1.4

   dev_dependencies:
     mobx_codegen:
     build_runner:
     flutter_test:
    sdk: flutter
```

## Estrutura

   ```bash  
   lib
     auth
     db
     helpers
     models
     service
     views
