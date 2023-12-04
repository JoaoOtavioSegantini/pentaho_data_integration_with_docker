# Descrição

Esse projeto é uma implementação da instalação do Pentaho Data Integration (PDI) via Docker

## Instalação

Você pode rodar o projeto executando o seguinte comando:

```zsh
  docker-compose up -d
```

Caso queira subir o pentaho juntamente com o container do pgAdmin, utilize o seguinte comando:

```zsh
  docker-compose --profile pgadmin up -d
```

### Para Windows 

Caso esteja em ambiente windows e utilizando o WSL2, para que o projeto funcione é imprescindível que você instale um 
servidor Windows X. Algumas dicas de como fazer isso estão aqui:  [servidor-windows-x](https://ubunlog.com/pt/vcxsrv-nos-permite-usar-apps-de-linux-con-interfaz-de-usuario-en-windows-10/). 

