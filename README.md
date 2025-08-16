# Sprint 1 - Configurando VPC e Instância AWS  
**Compass UOL**

> **Nota:**
> Esta documentação faz parte do programa da Compass UOL e não é considerada um tutorial. Siga cada etapa cuidadosamente e, em caso de dúvidas, consulte a documentação oficial da AWS. 

## Índice



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

[Código AWS ClowdFormation](/compassWordpressSprint-v2.yaml)

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

## 7. EC2 - Modelo de Execução

O ideal é sempre começar com uma EC2, porém já temos o [UserData](/UserDataEC2Model.sh) pronto, na qual eu já fiz toda esta parte de testar e validar os passos. Por isto, tomo a liberdade de ir direto ao Modelo de Execução, na qual iremos colar o [UserData](/UserDataEC2Model.sh) e já dar início ao nosso Modelo e poder incrementar no AutoScalling da AWS

### 7.1. EC2 Modelo de Execução e depois em "Criar modelo de execução"

![EC2 MODEL](/imgs/AWS-MODEL-EC2-INICIAL.png)

### 7.2. Adicionar o nome da Template, TAGS (se houverem) e Descrição

![EC2 Criar](/imgs/AWS-MODEL-EC2CRIAR.png)

### 7.3. Nesta parte, seleciona o tipo de instância, a sua chave PEM (PRIMORDIAL) e as configurações de Rede

![EC2 Model VPC](/imgs/AWS-MODEL-EC2REDE.png)

>**Nota:** Se atente em usar as subnets privadas e o Grupo de Segurança [2.6.4. Grupo de Segurança EC2](https://github.com/josewolffsantiago/CompassUOL-Docker-Sprint-PBJUN2025-DevSecOPs-?tab=readme-ov-file#264-grupo-de-seguran%C3%A7a-ec2)

### 7.4. Sabe a função de Identidade que Fizemos no passo [5. IAM - O Básico para rodar a EC2](https://github.com/josewolffsantiago/CompassUOL-Docker-Sprint-PBJUN2025-DevSecOPs-?tab=readme-ov-file#5-iam---o-b%C3%A1sico-para-rodar-a-ec2)

![EC2 Model IAM](/imgs/AWS-MODEL-EC2-IAM.png)

Procure o nome da função que você criou neste quadro acima para ativar o funcionamento do código do UserData

### 7.5. Após selecionar o Perfil do IAM, ao descer, encontraremos um campo para colocar [UserData](/UserDataEC2Model.sh)

![EC2 Model IAM](/imgs/AWS-MODEL-EC2-USERDATA.png)

### 7.6. Pode clicar em Criar Modelo de Execução








## 8. Referências

Abaixo irei colocar todos os sites na qual retirei recursos e aprendizados para fazer possível este projeto:

[Easy Local WordPress](https://www.youtube.com/watch?v=gEceSAJI_3s)

https://hub.docker.com/_/mariadb

https://hub.docker.com/_/mariadb

https://rancher.com/docs/os/v1.x/en/installation/cloud/aws/

https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-ec2-instance.html

https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-autoscaling-launchconfiguration.html

https://docs.aws.amazon.com/pt_br/AWSCloudFormation/latest/UserGuide/quickref-efs.html

https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-autoscaling-launchconfiguration.html


