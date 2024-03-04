# Use a imagem base Ubuntu 20.04
FROM ubuntu:20.04

# Defina o fuso horário para São Paulo
ENV TZ=America/Sao_Paulo

# Defina a variável de ambiente DEBIAN_FRONTEND como noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Atualize os repositórios e instale as dependências
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    sudo


# Crie um usuário não-root (opcional)
RUN useradd -m -s /bin/bash umbrelos
RUN echo "umbrelos ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Troque para o usuário não-root
USER umbrelos

# Baixe e instale o umbrelOS
RUN curl -L https://umbrel.sh | bash

# Execute o umbrelOS
CMD ["umbrel"]

# Defina o diretório de trabalho
WORKDIR /app

# Exponha a porta 80 (se necessário)
EXPOSE 80

