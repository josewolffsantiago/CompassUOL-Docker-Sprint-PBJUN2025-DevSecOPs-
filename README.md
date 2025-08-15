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










AmazonEC2ContainerServiceforEC2Role
	
AmazonEFSCSIDriverPolicy
	
AmazonElasticFileSystemFullAccess

AmazonS3FullAccess
	

AWSQuickSightDescribeRDS


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


