FROM alpine:latest

# Instalação de dependências
RUN apk add --no-cache \
    bash \
    curl \
    ttyd

# Copia um script para iniciar o ttyd
COPY start.sh /start.sh

# Permissão de execução para o script
RUN chmod +x /start.sh

# Porta que o ttyd irá ouvir
EXPOSE 7681

# Comando para iniciar o ttyd
CMD ["/start.sh"]
