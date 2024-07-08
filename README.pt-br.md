# AUR Builder

Instalar pacotes do AUR quando se está logado como root no arch linux às vezes é uma merda, principalmente se estiver tentando fazer isso na hora da instalação do sistema, seja manualmente ou com algum script. Fiz o AUR Builder com a motivação de resolver esse problema, já que pra todas as instalações que eu faço do arch, eu crio um script pra elas, e ter que adicionar alguns pacotes manualmente depois da instalação é realmente chato, a opção além dessa instalação manual pós-instalação do sistema seria adicionar aos meus scripts de instalação o código desse repositório, então achei mais prático criar um pacote separado pra isso.

Apesar do foco ser o uso durante a instalação do Arch, o AUR Builder funciona muito bem para o uso comum.

- [Instalação](#instalação)
  - [Instalação automática](#instalação-automática)
  - [Construindo a partir da fonte](#construindo-a-partir-da-fonte)
- [Como usar](#como-usar)
- [Contribuindo](#contribuindo)

## Instalação

### Instalação automática

```bash
curl -L https://sirius-red.github.io/aurbuilder/install | sh

# Alterando o diretório root, altere `/mnt` pelo diretório que deseja usar como root
curl -L https://sirius-red.github.io/aurbuilder/install | sh -s -- --chroot /mnt
```

### Construindo a partir da fonte

```bash
git clone https://github.com/sirius-red/aurbuilder.git --depth 1
cd aurbuilder
scripts/builder --production --install
```

## Como usar

Ao tentar instalar um pacote, o aurbuilder vai usar o `yay` se estiver instalado, caso contrário a instalação vai ser feita clonando o repositório do AUR e instalando com o `makepkg`.

Basta usar o comando abaixo:

```bash
aurbuilder <nome_do_pacote>

# Instalação de vários pacotes
aurbuilder pacote1 pacote2 pacote3
```

Caso esteja usando o aurbuilder para instalar pacotes na hora da instalação do Arch:

```bash
# Substitua `/mnt` para o diretório onde você montou a partição root
aurbuilder --chroot /mnt <nome_do_pacote>
```

**Todas** as informações necessárias estão no comando de ajuda:

```bash
aurbuilder --help
```

Mas caso queira, segue o link da [documentação oficial](https://sirius-red.github.io/aurbuilder/docs)

## Contribuindo

Instale as dependências necessárias:

- **zip** (instale com seu gerenciador de pacotes)
- **ruby** (instale com seu gerenciador de pacotes)
- **bashly** (informações da instalação na [documentação oficial](https://bashly.dannyb.co/installation/))

**Leia a documentação do bashly antes de qualquer coisa, não vai conseguir fazer nada sem saber como ele funciona.**

Use o watch mode do bashly para gerar o binário conforme você salva as alterações:

```bash
bashly generate --watch
```

Na pasta `scripts` tem um script auxiliar para buildar o projeto (execute-o da raíz do projeto como mostra abaixo):

```bash
scripts/builder --help
```
