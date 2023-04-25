# terraform-atlantis

Atlantis é um aplicativo para automatizar o deploy de infraestrutura como código, tem como objetivo simplificar o gerenciamento de projetos de infraestrutura baseados em Terraform. O Atlantis funciona em conjunto com plataformas de gerenciamento de código como o GitHub, GitLab ou Bitbucket, e ouve solicitações de `pull request` do Terraform por meio de webhooks.

Quando uma solicitação de pull request é recebida, o Atlantis executa o comando `terraform plan` e gera um comentário no PR com a saída do plano, permitindo que os membros da equipe revisem as alterações propostas.

Quando a equipe estiver pronta para aplicar as alterações, ela pode simplesmente escrever um comentário no PR com o comando atlantis apply, e o Atlantis executará o terraform apply. Isso ajuda a simplificar o fluxo de trabalho do Terraform e reduzir o tempo gasto na execução de tarefas manuais repetitivas.

## Testando Atlantis Localmente

Essas instruções explicam como executar o Atlantis em seu próprio computador para que você possa testá-lo em seus próprios repositórios antes de decidir instalá-lo permanentemente.

Pré-requisito
- Docker

### Instalar Terraform

Siga os passos descristo na documentação do Terraform. 
[Install terraform](https://www.terraform.io/downloads.html)

### Baixar Atlantis

Faça o download do binário Atlantis.
[Download Atlantis](https://github.com/runatlantis/atlantis/releases)

### Baixar Ngrok

Ngrok é uma ferramenta que encaminha sua porta local para um nome de host público aleatório. O Atlantis será executado através do envio de webhook do Github. 

```shell
docker run -it -p 4141:4141 -p 4040:4040 ngrok/ngrok:alpine http 80
```

Copie a url do campo `Forwarding`:

![URL Ngrok](./img/ngrok-forwarding.png)

```shell
export URL="https://{MUDE-PARA-URL-FORWARDING}"
```

### Criar um token para webhook

O GitHub e o GitLab usam segredos de webhook para que os clientes possam verificar se os webhooks vieram deles.
Crie uma string aleatória de qualquer tamanho (você pode usar https://www.random.org/strings/ ) e defina uma variável de ambiente:

```shell
export SECRET="{MUDE=PARA-SECRET-STRING}"
```

### Adicionar webhook no repositório GitHub

- Vá para as configurações do seu repositório github.
- Selecione Webhooks ou Hooks na barra lateral.
- Clique em Adicionar webhook.
- Defina Payload URL para o seu ngrok url com `/events` no final. Ex.`http://c5004d84.ngrok.io/events`.
- Verifique novamente se você adicionou `/events` ao final do seu URL.
- Defina o tipo de conteúdo application/json.
- Defina o segredo para sua string aleatória.
- Selecione a opção, Deixe-me selecionar eventos individuais.
- Verifique as caixas:
    - Pull request reviews
    - Pushes
    - Issue comments
    - Pull requests
- Deixar Ativo, marcado.
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
docker run -d --name atlantis -e URL=$$URL -e SECRET=$$SECRET -e TOKEN=$$TOKEN -e USERNAME=$$USERNAME -e REPO_ALLOWLIST=$$REPO_ALLOWLIST -e AWS_ACCESS_KEY_ID=$$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$$AWS_SECRET_ACCESS_KEY runatlantis/atlantis:latest server --atlantis-url="$URL" --gh-user="$USERNAME" --gh-token="$TOKEN" --gh-webhook-secret="$SECRET" --repo-allowlist="$REPO_ALLOWLIST"
```

### Criar uma solicitação pull

Crie um pull request para testar o Atlantis e no comentário do PR digite os comandos:

```shell
atlantis plan -d .
atlantis apply
```
