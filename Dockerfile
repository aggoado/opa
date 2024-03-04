# Use a imagem base Ubuntu 20.04
FROM ubuntu:20.04

# Atualize os repositórios e instale as dependências
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip

# Baixe e instale o umbrelOS
RUN curl -L https://umbrel.sh | bash

# Execute o umbrelOS
CMD ["umbrel"]

# Defina o diretório de trabalho
WORKDIR /app

# Exponha a porta 80 (se necessário)
EXPOSE 80
