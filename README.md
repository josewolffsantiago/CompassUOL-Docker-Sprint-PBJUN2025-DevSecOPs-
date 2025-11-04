# Sprint 1 - Configurando VPC e Instância AWS  
**Compass UOL**

> **Nota:**
> Esta documentação faz parte do programa da Compass UOL e não é considerada um tutorial. Siga cada etapa cuidadosamente e, em caso de dúvidas, consulte a documentação oficial da AWS. 

## Índice


[Pré-requisitos](#0-pré-requisitos)

[Introdução](#1-introdução)

[Configurando VPC](#2-configurando-vpc)   

[Criando Banco de Dados na AWS](#3-criando-banco-de-dados-na-aws)

[EFS - Elastic File System](#4-efs---elastic-file-system)

[Identity and Access Management - IAM](#5-identity-and-access-management---iam---o-b%C3%A1sico-para-rodar-a-ec2)

[S3 Bucket](#6-s3-bucket)

[EC2 - Modelo de Execução](#7-ec2---modelo-de-execução)

[Montar o grupo de Auto Scalling](#8-autoscallinggroup)

[CloudFormation](#9-cloudformation)

[Como Configurar o Load Balancer](#10-load-balancer)

[Configurando o Wordpress no Load Balancer AWS](#11-configurando-corretamente-o-seu-sistema-ir%C3%A1-entrar-na-tela-de-login-ap%C3%B3s-a-instala%C3%A7%C3%A3o-do-wordpress)

[Referências](#12-refer%C3%AAncias)

---

## 0. Pré-requisitos

- **Computador com Linux** (qualquer distribuição)  
  Ou **Windows com Windows Subsystem for Linux (WSL)** instalado.

    - Como instalar o WSL no Windows:

        [Acompanhe este tutorial da Alura](https://www.alura.com.br/artigos/wsl-executar-programas-comandos-linux-no-windows?utm_term=&utm_campaign=topo-aon-search-gg-dsa-artigos_conteudos&utm_source=google&utm_medium=cpc&campaign_id=11384329873_164240702375_703853654617&utm_id=11384329873_164240702375_703853654617&hsa_acc=7964138385&hsa_cam=topo-aon-search-gg-dsa-artigos_conteudos&hsa_grp=164240702375&hsa_ad=703853654617&hsa_src=g&hsa_tgt=aud-396128415587:dsa-2276348409543&hsa_kw=&hsa_mt=&hsa_net=google&hsa_ver=3&gad_source=1&gad_campaignid=11384329873&gclid=CjwKCAjwsZPDBhBWEiwADuO6yyGQfTJnF0nhUWCey5rg91xU9ah7KDSnoU6afozjdcvlRnw_r7VJfRoCB4IQAvD_BwE)
    - Recomendação:

        [Instale o Ubuntu pela Microsoft Store (recomendado)](https://apps.microsoft.com/detail/9pdxgncfsczv?ocid=webpdpshare)

    - Guia de instalação Linux em Dual Boot com o Windows(opcional)

        [Guia completo para Fedora em Dual Boot (opcional)](https://discussion.fedoraproject.org/t/guide-fedora-42-workstation-manual-partition-with-without-luks2-encryption-with-windows-11-dual-boot-setup/149123)
    
         [Site oficial do Fedora](https://fedoraproject.org/)

- **Conhecimento básico do console AWS**
    - [Crie uma conta gratuitamente](https://aws.amazon.com/pt/training/digital/?p=train&c=tc&z=1)
    >**Nota:** Mesmo selecionando a conta gratuita, o sistema irá pedir um cartão de crédito para finalizar o cadastro. CUIDADO com os recursos que você irá explorar na AWS.

    - [Faça o AWS Cloud Quest](cloudquest.skillbuilder.aws) Faça os cursos dentro da própria AWS para se ambientar com o console. Primordial para quem quer estudar e aprender mais sobre a AWS.

- **Conhecimento sobre Docker**
    - [Curso Docker para Iniciantes](https://kodekloud.com/courses/docker-for-the-absolute-beginner/) Não é um curso, mas é um ótimo treinamento se você tem pelo menos o básico de conteinerização. 

### 0.1. Materiais para Download:

[UserData](/UserDataEC2Model.sh) 

[Código AWS CloudFormation](/compassWordpressSprint-v3.yaml)

[Código AWS CloudFormation PESSOAL](/compassWordpressSprint-v4-pessoal.yaml) - Este é exclusivo para quem não quer que puxa uma TAG. Para uso em uma conta AWS Free Tier.

[Docker Compose - Wordpress](/docker-compose.yml)

[Arquivo com as váriaveis de ambiente do Docker](/env) Mudar para .env e deixar na mesma pasta do Docker Compose.


---

## 1. Introdução

Este documento é uma continuação da Sprint anterior, na qual fizemos uma EC2 do zero e configuramos para o funcionamento de uma página WEB. Neste desafio, foi **introduzido** como aprendizado para entender a utilização do Docker na AWS para subir uma aplicação ou um servidor WEB. Docker é uma plataforma de código aberto usada para automatizar a implantação, o escalonamento e o gerenciamento de aplicativos em contêineres

O ideal antes de fazer o docker funcionar diretamente na AWS é entender como o conceito de conteinerização funciona. Testar localmente na sua máquina é recomendado para escolher a melhor versão dos programas, Sistema Operacional dentro do conteiner e principalmente o funcionamento dos códigos que integram o docker compose.

Abaixo está uma figura que irá representar o desafio apresentado aqui. 

>**Nota:** Esta imagem foi retirada diretamente do documento do desafio e não possuo certeza se ela pode estar aqui, mas é primordial para o entendimento deste documento.

---

## 2. Configurando VPC 

Tudo na AWS começa com uma VPC bem configurada. Para este projeto, iremos ter uma VPC mais "Robusta", contendo:

#### w. 2 sub-redes públicas
#### x. 4 sub-redes privadas   
#### y. Uma Internet Gateway conectada às sub-redes públicas.        
#### z. Um Gateway NAT conectada em todas às sub-redes privadas.

### 2.1. Na aba escrito Search no canto superior esquerto digite "VPC" 

![VPC Aba Search](/imgs/AWS-VPC-Aba-search.png)

### 2.2. Clica em "Your VPCs"

### 2.3. Ao abrir a página, procure por "Criar VPC"    

### 2.4. A AWS dá duas opções de VPC: "Somente VPC" ou "VPC e muito mais". Iremos na segunda opção, como a imagem abaixo.
    
![VPC Novo VPC](/imgs/AWS-EC2-VPC-CREATE-NEW.png)

#### 2.4.1. Em Bloco CIDR coloque o IP na qual os componentes da AWS irão ser endereçadas. 

#### 2.4.2. Selecionar a quantidade de 2 em "Número de zonas de disponibilidade (AZs)"

![VPC Novo VPC2](/imgs/AWS-VPC-SUBREDE.png) 

#### 2.4.3. Selecionar a quantidade de 2 sub-redes Públicas e 4 sub-redes Privadas:

#### 2.4.4. Selecionar a criação do Gateway NAT

- Cuidado para não incindir cobranças na criação desde Gateway.

![VPC Novo VPC3](/imgs/AWS-VPC-NUM-SUBREDE.png)

### 2.5. Após todos estes passos, a sua pré-visualização deverá ficar próximo a este:

![VPC Pre Visualizacao](/imgs/AWS-VPC-DIAGRAMA-FINAL.png)

### 2.6. Grupo de Segurança:

As rotas da VPC são criadas automaticamente. O que devemos estar atentos são os Grupos de Segurança. Irei pincelar levemente sobre as portas e os caminhos de terão que ser abertos para que os dados consigam trafegar tranquilamente.

Para criar os Grupos de Segurança, faça a busca no campo Search da AWS por "Security Groups". Há um link de acesso direto pela EC2, caso já esteja nesta página.

![VPC EC2 SG](/imgs/AWS-Secutiry-Search.png)

Na página seguinte, clique em "Criar Grupo de Segurança" 

![VPC EC2 SG CREATE](/imgs/AWS-Security-Create.png)

Não existe uma ordem específica para criar os Grupos de Segurança. Pode ser criada uma liberando as portas e depois voltar ao primeiro Grupo para redirecionar corretamente.

#### 2.6.1. Grupo de Segurança RDS (Banco de Dados)

Grupo de segurança do RDS irá comunicar apenas com a EC2 e qualquer modificação ou consulta em nosso banco de dados deve ocorrer dentro destas mesmas instâncias, 
com o acesso pelo Bastion.

```
  WordpressDBSecurityGroup:
      SecurityGroupIngress:
        - IpProtocol: tcp
          Port: 3306
          Redireciona para o Grupo de Segurança da EC2
      SecurityGroupEgress:
        - IpProtocol: tcp
          Port: 3306
          Redireciona para o Grupo de Segurança da EC2
```

#### 2.6.2. Grupo de Segurança AWS EFS

Grupo de segurança da EFS. Objetivo também é só a comunicação com a EC2 que irão hospedar o WordPress

```
      MountTargetEFSSG:
      SecurityGroupIngress:
        - IpProtocol: tcp
          Port: 2049
          Redireciona para o Grupo de Segurança da EC2
      SecurityGroupEgress:
        - IpProtocol: tcp
          Port: 2049
          Redireciona para o Grupo de Segurança da EC2
```

#### 2.6.3. Grupo de Segurança BastionEC2 

Bastion é uma instância especifica que está em comunicação segura com a internet e o objetivo é fazer a interligação com as máquinas que estão hospedando o 
WordPress e estão em subnet Privada, sem comunicação direta via SSH pela internet ou outras comunicações de controle conhecida. Como essas instâncias estão em 
subnets privadas, o Bastion serve como intermediário para comunicações de controle, garantindo que não haja exposição direta das EC2 críticas.

```
      BastionSGroup:
      SecurityGroupIngress:
        - IpProtocol: tcp
          Port: 22
          Liberado TODO o tráfego SSH
      SecurityGroupEgress:
        - IpProtocol: tcp
          Port: 8080
          Liberado TODO o tráfego
        - IpProtocol: tcp
          Port: 22
          Liberado TODO o tráfego
        - IpProtocol: '-1'
          CidrIp: 0.0.0.0/0
          Liberado TODO o tráfego da internet
```

#### 2.6.4. Grupo de Segurança EC2

Este grupo de segurança ele vai ser especialmente para as EC2 que estarão hospedando o serviço Wordpress. As portas liberadas serão as portas para fazer a 
comunicação entre o EFS, Banco de Dados e a instância Bastion.


```
      WordpressEC2SGroup:
      SecurityGroupIngress:
        - IpProtocol: tcp
          Port: 8080
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          Port: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          Port: 3306
          Redirecionado para Security Group responsável pela RDS (Banco de Dados)
        - IpProtocol: tcp
          Port: 2049
          Redirecionado para o Security Group responsável pela EFS
        - IpProtocol: tcp
          Port: 22
          Redirecionado para o Security Group da Bastion EC2
      SecurityGroupEgress:
        - IpProtocol: tcp
          Port: 3306
          Redirecionado para Security Group responsável pela RDS (Banco de Dados)
        - IpProtocol: tcp
          Port: 8080
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          Port: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          Port: 22
          Redirecionado para o Security Group da Bastion EC2
        - IpProtocol: '-1'
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          Port: 2049
          Redirecionado para o Security Group responsável pela EFS
```

Pode ver que este é o maior grupo de segurança que nós iremos criar, pois as instâncias EC2 que estarão com o WordPress precisam se comunicar com o RDS, EFS e a instância Bastion.

---

## 3. Criando Banco de Dados na AWS

O banco de dados é primordial para o funcionamento do WordPress. É no banco de dados onde ficarão armazenados os dados que serão gerados quando o cliente ou usuário for utilizando o site. Configure com atenção, pois alguns dados que serão inseridos aqui estarão nos nossos arquivos de configuração.

### 3.1. Na aba Search na AWS, procure por RDS e clica na primeira opção

![RDS Search](/imgs/AWS-RDS-SEARCH.png)

### 3.2. Logo ao abrir a página, clica em "Criar um banco de dados" logo no meio.

### 3.3. Na página de criação, clica na opção "Criação Padrão" e escolha o MYSQL como opção de mecanismo

![RDS Mecanismo](/imgs/AWS-RDS-Escolha-Mecanismo.png)

### 3.4. CUIDADO: Nesta parte, escolha o Nível gratuito (free tier)

![RDS Mecanismo](/imgs/AWS-RDS-Modelo-Gratuito.png)

### 3.5. Na tela configurações, crie o identificador do seu Banco de Dados, um username e adicione senha.

![RDS Senha](/imgs/AWS-RDS-Config.png)

>**Nota:** ANOTE estes dados, pois eles serão usados em outro momento para que o Wordpress funcione.

### 3.6. Escolha a opção da instância db.t3.micro e o armazenamento o gp2, com 20Gb de espaço.

![RDS Armazanamento](/imgs/AWS-RDS-Armazenamento.png)

>**Nota:** Coloque um limite máximo de armazenamento. Como é apenas para teste, não será necessário escalonar acima de 50Gb.

### 3.7. Em Conectividade, selecione a VPC já criada e coloque o Banco de Dados RDS em um grupo de segurança já criado anteriormente.

![RDS Conectividade](/imgs/AWS-RDS-Conectividade.png)

Fique atento para selecionar uma SubNet Privada, a mesma VPC que nós criamos acima e também selecionar o Grupo de Segurança espeífico do Banco de Dados.

### 3.8. Autenticação e Nome adicional do banco de dados

Passo muito importante também para não errarmos no futuro, quando configurarmos o nosso BD diretamente no Wordpress

![RDS Autenticação](/imgs/AWS-RDS-Autenticacao-Nome.png)

>**Nota:** Isto quer dizer que a autenticação do Banco de Dados será diretamente pelo Username e pela Senha. O MySQL irá interligar ao RDS usando estas autenticações. Colocar o nome adicional como:

'''
wordpress
'''

### 3.9. Criar Banco de Dados

Desta forma, podemos rolar até o final da página e clicar em "Criar Banco de Dados". O processo para a criaçao é bem lenta.

---

## 4. EFS - Elastic File System

A Amazon EFS é o serviço mais simples que iremos utilizar nesta documentação. Ao abrir a página, clique em "Criar Sistema de Arquivo" e logo após, selecione a VPC que criamo e clique novamente em "Criar Sistema de Arquivo".

![EFS Search](/imgs/AWS-EFS-Seach.png)

### 4.1. Após a criação do Sistema de Arquivo, clica sobre ele para abrir a aba "Redes". Clique em "Criar ponto de montagem" para fazermos o link à subnet privada única dos EFS em ambas as zonas (us-east2a e us-east2b para este tutorial) e também redirecionar ao Grupo de Segurança específico deste Sistema de Arquivo.

![EFS Montagem](/imgs/AWS-EFS-Montagem.png)

### 4.2. Selecionar ambas as Zonas que estamos trabalhando e em ambos selecionar o Grupo de Segurança do Elastic File System

![EFS Rede Zona](/imgs/AWS-EFS-Rede-Acesso.png)

Pode Clicar em Salvar para ir para o próximo passo.

## 4.3. Voltando para a página inicial do Elastic File System, procure o botão Anexar, igual a imagem abaixo

![EFS Anexar](/imgs/AWS-EFS-Anexar.png)

## 4.4. Ao abrir a próxima janela, copia o endereço DNS do cliente de NFS para montagem do sistema. Vamos usar mais tarde no [UserData](/UserDataEC2Model.sh)  d EC2 que iremos montar.

![EFS Mount](/imgs/AWS-EFS-Mount.png)

---

## 5. Identity and Access Management - IAM - O Básico para rodar a EC2

Infelizmente o meu conhecimento é muito básico em relação ao IAM, mas irei dar uma dica para conseguirmos fazer algumas automações no nosso [UserData](/UserDataEC2Model.sh) . Vamos criar uma nova Função do IAM para que consigamos utilizar o Bucket S3 e fazer o sistema gerar algumas Variaveis sensíveis e que não será necessário expo-los no nosso código.

![IAM Search](/imgs/AWS-IAM-Search.png)

### 5.2. Vamos acessar a página do IAM na AWS. Nesta página, clique em "Funções" no lado esquerdo e na próxima página, clica em "Criar Perfil"

![IAM Perfil](/imgs/AWS-IAM-Funcoes-Perfil.png)

### 5.3. Selecionar "Serviço da AWS" e logo abaixo selecionar o padrão "EC2"

![IAM EC2](/imgs/AWS-IAM-EC2.png)

Clicar em próximo

### 5.4. Seleciona estas 5 regras abaixo:



    AmazonEC2ContainerServiceforEC2Role
	
    AmazonEFSCSIDriverPolicy
	
    AmazonElasticFileSystemFullAccess

    AmazonS3FullAccess	

    AWSQuickSightDescribeRDS



### 5.5. Resumo

![IAM Resumo](/imgs/AWS-IAM-Resumo.png)

---

## 6. S3 Bucket

Esta função do Amazon AWS é bem interessante. Temos uma forma de colocar os arquivos diretamente para a Instância de forma segura, rápida e direto na própria AWS, sem correr o risco de termos links quebrados, código de download que gera erros ou baixar algum arquivo errado.


![S3 Search](/imgs/AWS-S3-Search.png)

### 6.1. Clique em "Criar bucket"

![S3 Bucket](/imgs/AWS-S3-Bucket.png)

### 6.2. Coloque um nome para o seu S3 Bucket, selecione para bloquiear todo acesso público e lembre de ativar o "Versionamento de bucket"

![S3 Versionamento](/imgs/AWS-S3-Nome-Propriedades.png)

### 6.3. Nesta outra página podemos clicar em "Carregar" para enviar arquivos para o nosso Bucket e o mais importante é o *"COPIAR URL DO S3"*.

 Será esta URL que iremos utilizar para enviar as nossas variaveis e o código do container da WORDPRESS.

![S3 Carregar](/imgs/AWS-S3-Carregar.png)

---

## 7. EC2 - Modelo de Execução

O ideal é sempre começar com uma EC2, porém já temos o [UserData](/UserDataEC2Model.sh) pronto, na qual eu já fiz toda esta parte de testar e validar os passos. Por isto, tomo a liberdade de ir direto ao Modelo de Execução, na qual iremos colar o [UserData](/UserDataEC2Model.sh) e já dar início ao nosso Modelo e poder incrementar no AutoScalling da AWS

>**Nota:** PERCEBA que este UserData ainda é o meu e você terá que estilizar ele, ou seja, trocar os links da S3 pelos seus links, por exemplo. Usando o meu UserData diretamente a sua Instancia EC2 naõ irá funcionar

### 7.1. EC2 Modelo de Execução e depois em "Criar modelo de execução"

![EC2 MODEL](/imgs/AWS-MODEL-EC2-INICIAL.png)

### 7.2. Adicionar o nome da Template, TAGS (se houverem) e Descrição

![EC2 Criar](/imgs/AWS-MODEL-EC2CRIAR.png)

### 7.3. Nesta parte, seleciona o tipo de instância, a sua chave PEM (PRIMORDIAL) e as configurações de Rede

![EC2 Model VPC](/imgs/AWS-MODEL-EC2REDE.png)

>**Nota:** Se atente em usar as subnets privadas e o Grupo de Segurança [2.6.4. Grupo de Segurança EC2](https://github.com/josewolffsantiago/CompassUOL-Docker-Sprint-PBJUN2025-DevSecOPs-?tab=readme-ov-file#264-grupo-de-seguran%C3%A7a-ec2)

### 7.4. Em "Detalhes Avançados", selecione a "IAM ROLE" que criamos posteriormente na seção [5. IAM - O Básico para rodar a EC2](#5-identity-and-access-management---iam---o-b%C3%A1sico-para-rodar-a-ec2)

![EC2 Model IAM](/imgs/AWS-MODEL-EC2-IAM.png)

### 7.5. Descendo mais um pouco, podemos colocar o nosso [UserData](/UserDataEC2Model.sh) 

![EC2 UserData](/imgs/AWS-MODEL-EC2-USERDATA.png)

 e clicar em "Criar Modelo de execução"

---

## 8. AutoScallingGroup

Ainda na aba da EC2, lado esquerdo, última opção nós temos o Grupo Auto Scalling, que, resumindo, consta na criação automática de Instâncias EC2 a partir do momento de Alta Escalabilidade. Ou seja, se houver muitas solicitações no seu site, este grupo pode incrementar mais máquinas para suprir as necessidades. O mesmo pode ocorrer ao contrário, quando ouver menos solicitações ao seu serviço, a própria AWS irá desligar algumas máquinas para desta forma economizar.

![AS EC2](/imgs/AWS-AutoScalling-EC2.png)

### 8.1. Selecionar as Subredes que as Instâncias EC2 que irão trabalhar, sendo a prioridade as Subrede Privadas e o Grupo de Segurança específico para EC2.

![AS Fotto](/imgs/AWS-AutoScalling-Rede.png)

---

## 9. Cloudformation

Neste documento temos disponibilizado um código CloudFormation, que foi um desafio proposto para implementar de forma mais rápida e concisa o sistema.

### 9.1. Dentro da página CloudFormation, clique em "Criar Pilha"

![AWS CloudFormation Search](/imgs/AWS-Clouformation-Search.png)

### 9.2. Selecione o "Escolher modelo existente" e logo abaixo "Fazer upload de um arquivo modelo" para conseguir colocar o arquivo [YAML do código do CloudFormation](/compassWordpressSprint-v3.yaml)

![AWS Cloudformation](/imgs/AWS-Cloudformation-Create%20STACK.png)

### 9.3. Antes de clicar em próximo, clique no icone que irá ser habilidado após o arquivo carregar "Visualizar no Infrastructure Composer", visualize os componentes que serão criados e verifique se há algo de errado no código (Botão Validar.)

![AWS Cloudformation Model](/imgs/AWS-Cloudformation-Model.png)

### 9.4. Na próxima página vai ter vários espaços para colocar Parametros.

Foi criado esta seção para as senhas e variaveis que são sensiveis, que não pode ser guardado diretamente no código e que está disponíbilizado para você fazer este modelo. Adicione o Nome da Pilha (Stack), o CostCenter, selecione a sua chave de acesso SSH e a senha do seu banco de dados

>**Nota:** Se você participa de outra turma deste projeto, é só adicionar o número do CostCenter. Caso você esteja usando a AWS com sua conta pessoal, deixe este campo vazio

![AWS Cloudformation Stack name](/imgs/AWS-Cloudformation-Parametro.png)

### 9.5. Após adicionar os Parametros, na proxima página selecione a opção "Preservar recursos disponibilizados com êxito"

Neste caso, há uma função IAM Role na linha 563 dentro do arquivo do CloudFormation que só irá funcionar na minha STACK. Se você estiver lendo isto e puder alterar pelo nome da função IAM criada por você não haverá este erro.

![AWS CF Stack Error](/imgs/AWS-Cloudformation-Falha.png)

### 9.6. Outra dica:
Há um UserData dentro do código deste arquivo CloudFormation e há uma referencia ao meu Bucket S3, com meus arquivos do [docker-compose.yml](/docker-compose.yml) e do [.env](/env). Eles se encontram na linha 551 e 553, caso queira trocar pelo seu link destes mesmo arquivos no Bucket S3.

---

## 10. LOAD-BALANCER

Após carregado todo a Stack na nuvem e iniciado os recursos na CLOUD da AWS, vamos de imediato iniciar o nosso LOAD BALANCER. Ele que irá fazer a conexão das nossas máquinas que estão protegidas em SUBNET Privada no mundo globalizado da internet. Este recurso é novo, por isto não está automatizado no CloudFormation, possivelmente ele estará incluso com os estudos do Terraform.

![AWS LB](/imgs/AWS-LoadBalancer-Search.png)

### 10.1. Clique em "Criar LOAD BALANCER" e na página seguinte, clique em "Application Load Balancer"

Este é o tipo de Load Balancer que iremos utilizar no nosso Wordpress

![AWS LB APP](/imgs/AWS-LoadBalancer-ApplicationLB.png)

### 10.2. Na página que irá carregar, podemos selecionar a VPC que foi criada e selecionar as duas subrede PÚBLICAS, cada uma em uma zona.

![AWS LB REDE](/imgs/AWS-LoadBalancer-AplicationLB2-Rede.png)

### 10.3. Abaixo, vamos configurar o "Listener" do nosso LoadBalancer. Colocar a porta para 8080 e clique em "Criar grupo de destino"

![AWS LB TARGET](/imgs/AWS-LoadBalancer-Listener3.png)

### 10.4. Nesta próxima tela, selecione "Instância", coloque um nome no grupo de destino e na porta, deixe certo a porta 8080

![AWS LB TARGET2](/imgs/AWS-LoadBalancer-Target1.png)

### 10.5. Coloca em "Listener e roteamento" as opções abaixo, para verificação de integridade. Em código de sucesso, deixe o intervalo de 200 até 300.

![AWS TARGETG](/imgs/AWS-LoadBalancer-Target2.png)

### 10.6. Clicando em "Avançar", terá uma caixa para selecionar as instâncias que estão rodando. Confira novamente as portas 8080

![AWS LB TARGET3](/imgs/AWS-LoadBalancer-Target3-Destinos.png)

### 10.7. Voltando para a tela do Load Balancer, clica no REFRESH ao lado da caixa de seleção do Grupo de destino para aparecer o Grupo de Destino 

Não dê refresh no seu navegador, entenda que é apenas o botão de atualizar da própria AWS para carregar o grupo de destino.

![AWS LB VOLTA](/imgs/AWS-LoadBalancer-ListenerTG2-Selecionar.png)

### 10.8. Pode clicar em "Criar Load Balancer" e ná pagina principal do Load Balancer, copia a DNS e coloque em outra aba do seu navegador com a porta :8080

![AWS LB DNS](/imgs/AWS-LoadBalancer-CopiaDNS.png)

Se você fez tudo conforme este tutorial e utilizou o CLOUDFORMATION ao invés do console, este erro vai ocorrer no seu nagegador.

![AWS LB erro DB](/imgs/AWS-Wordpress-SemBD.png)

O que ocorre no Cloudformation é que o Banco de Dados RDS demora muito para ser inicializado e as máquinas EC2 não conseguem encontrar ele por não ter sido construido. O que vamos fazer é derrubar as duas máquinas criadas e iniciar elas novamente.

#### 10.8.1. Ir na aba "Intância" para ver as instâncias EC2 criadas. Selecionar ambas e clicar em "Interromper Instância" conforme a imagem

![AWS EC2 delete](/imgs/AWS-EC2-Reiniciar.png)

#### 10.8.2. Clica em "Encerrar" na próxima aba que for abrir

![AWS EC2 interromper](/imgs/AWS-EC2-Encerrar2.png)

#### 10.8.3. Espere alguns minutos e o AutoScalling irá iniciar outras duas máquinas

![AWS EC2 iniciando](/imgs/AWS-EC2-Encerrar-iniciando.png)

#### 10.8.4. Volte para a aba "Grupo de destino", que fica logo abaixo do "Load Balancer", clique no Target criado, depois em destino e em "Registrar Destinos"

![AWS LB Target Volta](/imgs/AWS-LoadBalancer-TARGET-DESTINO-VOLTA.png)

#### 10.8.5. Selecione novamente as duas Instâncias EC2 que foram iniciadas pelo AutoScalling

![AWS LB Instancia](/imgs/AWS-LoadBalancer-TARGET-VOLTA2.png)

#### 10.8.6. Coloque o DNS novamente no navegador e coloque a porta :8080 no final do link, irá carregar a página de instalação do WordPress.

![AWS Wordpress funcionando](/imgs/AWS-WORDPRESS2.png)

#### 10.9. Voltando ao Load Balancer, vamos fazer mais uma alteração para funcionar a tela de login

A tela de login dá algum conflito que não entendo como ocorre, mas procurando por documentos, verifiquei que é algo relacionado aos cookies.

#### 10.9.1. Volte para a aba "Grupo de destino"

![AWS TARGETGROUP](/imgs/AWS-LoadBalancer-GrupoDestino1.png)

#### 10.9.2. Clique no Target criado e vá em "Atributos e clique em "Editar"

![AWS TARGETGROUP2](/imgs/AWS-LoadBalancer-Grupodestino2.png)

#### 10.9.3. Nesta página, mude para 60s a opção "Duração de iniciação lenta" e logo abaixo, na "Configuração[...]" seleciona a caixa de seleção da "Ativar a Viscosidade" e altere a perdurilidade para "2 minutos". 


![AWS TARGETGROUP3](/imgs/AWS-LoadBalancer-Grupodestino3.png)

#### 10.9.4. Siga atentamente as opções descritas nesta imagem acima.

### 10.10. Está é a imagem das duas instâncias que estão Saúdaveis e ambas fornecendo o site do Wordpress em pleno funcionamento

![AWS health](/imgs/AWS-RESULTADO-LOADBALANCER.png)

---

## 11. Configurando corretamente, o seu sistema irá entrar na tela de login após a instalação do WordPress

Um teste muito legal é adicionar um arquivo dentro do "Media" no WORDPRESS para ver o Banco de Dados Funcionando

### 11.1. Adicione um arquivo pequeno, de no máximo 2MB no Wordpress Media, nas opções de admin

![Wordpress arquivo](/imgs/AWS-WORDPRESS-ARQUIVO2M.png)

### 11.2. Resultado dele aparecendo no RDS da AWS

![Wordpress RDS](/imgs/AWS-WORPRESS-RDS.png)

### 11.3. O disco EFS conectado em ambas as máquinas e funcionando

![AWS funcionando](/imgs/AWS-EFS-LEITURA.png)

Note que ambas as máquinas estão conectadas e há relatos de leitura e gravação.

---

## 12. Referências

Abaixo irei colocar todos os sites na qual retirei recursos e aprendizados para fazer possível este projeto:

[Easy Local WordPress](https://www.youtube.com/watch?v=gEceSAJI_3s)

https://hub.docker.com/_/mariadb

https://rancher.com/docs/os/v1.x/en/installation/cloud/aws/

https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-ec2-instance.html

https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-autoscaling-launchconfiguration.html

https://docs.aws.amazon.com/pt_br/AWSCloudFormation/latest/UserGuide/quickref-efs.html




