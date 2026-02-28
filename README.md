# RetailFlow

Aplicativo móvel offline-first desenvolvido em Flutter para gestão financeira e de varejo. O foco do projeto é oferecer uma experiência fluida, rápida e escalável para o gerenciamento de vendas, notas e boletos.

## Visão Geral

O RetailFlow foi projetado para contornar problemas de conectividade, garantindo que o usuário possa realizar operações de caixa e gestão mesmo sem acesso à internet. A aplicação foca em alta performance de leitura e escrita de dados no próprio dispositivo.

## Tecnologias e Arquitetura

O projeto foi estruturado seguindo rigorosas práticas de engenharia de software para garantir escalabilidade e facilidade de manutenção:

* **Framework:** Flutter / Dart
* **Arquitetura:** Clean Architecture
* **Padrão de Projeto:** MVVM (Model-View-ViewModel) para separação clara entre a lógica de negócios e a interface de usuário (UI).
* **Banco de Dados Local:** Isar Database (escolhido por sua extrema velocidade e suporte a queries complexas de forma síncrona/assíncrona).

## Funcionalidades Principais

* Gestão de Vendas (Criação, leitura e histórico).
* Controle de Notas e Boletos.
* Funcionamento 100% offline-first com persistência local de dados.
* Interface responsiva, modular e focada na experiência do usuário (UI/UX).

## Como Executar o Projeto

Pré-requisitos: É necessário ter o Flutter SDK instalado na sua máquina.

1. Clone este repositório:
```bash
git clone [https://github.com/TacioMoreira25/retailflow.git](https://github.com/TacioMoreira25/retailflow.git)

```

2. Acesse a pasta do projeto:

```bash
cd retailflow

```

3. Instale as dependências:

```bash
flutter pub get

```

4. Como o projeto utiliza o Isar Database, é necessário gerar os arquivos de banco de dados (.g.dart) caso haja alguma modificação nos modelos. Para gerar os arquivos, execute:

```bash
flutter pub run build_runner build --delete-conflicting-outputs

```

5. Execute o aplicativo:

```bash
flutter run

```

## Estrutura de Pastas

A estrutura do projeto segue a divisão proposta pela Clean Architecture:

* `/lib/domain`: Regras de negócio, entidades e interfaces (contratos).
* `/lib/data`: Implementação de repositórios, serviços de banco de dados (Isar) e chamadas externas.
* `/lib/ui`: Telas (Views), ViewModels e componentes visuais do aplicativo.
