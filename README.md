## Informações Importantes

Linguagem: T-SQL
Versão SQL Server: 2017

A única diferença entre os scripts presentes nos branchs *master* e *azure* é o trecho de código a seguir, presente apenas no *master*,
utilizado para hospedar o banco em máquina local, este procedimento já é feito automaticamente em ambientes de nuvem, portanto não é
necessário - nem recomendado - a utilização dele na Azure.

        USE master
        GO

        IF EXISTS(SELECT * FROM sys.databases WHERE NAME = 'StatueStore')
          DROP DATABASE StatueStore
        GO

        CREATE DATABASE StatueStore
        GO

        USE StatueStore
        GO

## DER (Diagrama Entidade Relacionamento)

Diagrama mostrando a relação entre as entidades do banco e suas cardinalidades para facilitar o entendimento:

![Statue Store - DER](https://user-images.githubusercontent.com/59635709/72039482-1ce40980-3284-11ea-8c38-878776e9e737.jpg)

## MER (Modelo Entidade Relacionamento)

Aqui além das tabelas e dos seus relacionamentos, também estão presentes os campos e suas especificações
(clique e amplie):

![Statue Store - MER](https://user-images.githubusercontent.com/59635709/72039721-e78beb80-3284-11ea-8b60-7ab7dcd599b0.png)
