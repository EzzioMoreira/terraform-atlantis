# terraform-atlantis

Atlantis é um aplicativo para automatizar o Terraform por meio de pull requests. O Atlantis ouve os webhooks do GitHub, GitLab ou Bitbucket sobre solicitações de pull do Terraform. Em seguida, ele é executado `terraform plan` no comentário do pull request.
Quando precisar, escreva um comentário no PR `atlantis apply` e o Atlantis executará o `terraform apply`.

## Testando Atlantis Localmente

Estas instruções são para executar o Atlantis localmente em seu próprio computador para que você possa testá-lo em seus próprios repositórios antes de decidir se deseja instalá-lo de forma mais permanente.

### Instalar Terraform

Siga os passos descristo na documentação do Terraform. 
[Install terraform](https://www.terraform.io/downloads.html)

### Baixar Atlantis

Faça o download do binário Atlantis.
[Download Atlantis](https://github.com/runatlantis/atlantis/releases)

### Baixar Ngrok

Ngrok é uma ferramenta que encaminha sua porta local para um nome de host público aleatório. O Atlantis será executado através do envio de webhook do Github. 

Vá para https://ngrok.com/download, baixe o ngrok e `unzi` pele.
Comece `ngrok` na porta 4141 e anote o nome do host que ela fornece:

```shell
ngrok http 4141
```

```shell
export URL="https://{YOUR_HOSTNAME}.ngrok.io"
```

### Criar um token para webhook

O GitHub e o GitLab usam segredos de webhook para que os clientes possam verificar se os webhooks vieram deles.
Crie uma string aleatória de qualquer tamanho (você pode usar https://www.random.org/strings/ ) e defina uma variável de ambiente:

```shell
export SECRET="{YOUR_RANDOM_STRING}"
```

### Adicionar webhook no repositório GitHub

- Vá para as configurações do seu repositório
- Selecione Webhooks ou Hooks na barra lateral
- Clique em Adicionar webhook
- Defina Payload URL para o seu ngrok url com `/events` no final. Ex.https://c5004d84.ngrok.io/events
- Verifique novamente se você adicionou `/events` ao final do seu URL.
- Defina o tipo de conteúdo paraapplication/json
- Defina o segredo para sua string aleatória
- Selecione Deixe-me selecionar eventos individuais
- Verifique as caixas
    - Pull request reviews
    - Pushes
    - Issue comments
    - Pull requests
- Deixar Ativo marcado
- Clique em Adicionar webhook

### Token de acesso GitHub

- Siga https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#creating-a-token
- Criar um token com escopo de repositório.
- Defina o token como uma variável de ambiente.

```shell
export TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Iniciar Atlantis
Antes de iniciar o Atlantis precisamos definir duas variáveis de ambiente:

```shell
export USERNAME=SEU_USUÁRIO_GITHUB
export REPO_ALLOWLIST=github.com/SEU_USUÁRIO_GITHUB/SEU_REPOSITÓRIO_GITHUB
```
> Obs. Para provedor cloud AWS adicione as variáveis de ambiente.
```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx
export AWS_DEFAULT_REGION=us-west-1
```

Definindo configurações básicas de repositório no Atlantis. Criar um arquivo `repos.yaml`.

```shell
cat <<EOF > repo.yaml
# repos.yaml
repos:
- id: /.*/
  apply_requirements: [approved, mergeable]
  delete_source_branch_on_merge: true
  allow_custom_workflows: true
  allowed_overrides: [apply_requirements]
EOF
```

Agora podemos iniciar o Atlantis.


```shell
./atlantis server \
--atlantis-url="$URL" \
--gh-user="$USERNAME" \
--gh-token="$TOKEN" \
--gh-webhook-secret="$SECRET" \
--repo-allowlist="$REPO_ALLOWLIST" \
--repo-config=./repos.yaml
```

### Criar uma solicitação pull

Crie um pull request para testar o Atlantis e no comentário do PR digite os comandos:

```shell
atlantis plan -d .
atlantis apply
```
