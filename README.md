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

graph TD
    classDef vpc fill:#f9f9f9,stroke:#333,stroke-width:2px;
    classDef public fill:#e1f5fe,stroke:#0288d1;
    classDef private fill:#e8f5e9,stroke:#388e3c;
    classDef component fill:#fff,stroke:#000,color:#000;  /* Texto preto */

    VPC:::vpc

    %% Gateways
    IGW(("Internet Gateway")):::component
    NAT(("NAT Gateway")):::component

    %% Conexões entre gateways
    NAT --> IGW

    %% Zona A
    subgraph "Zona de Disponibilidade A"
        PublicA[Subnet Pública]:::public
            BastionA[Bastion Host]:::component
        PrivateA1[Subnet Privada 1]:::private
            WP1[EC2 WordPress]:::component
        PrivateA2[Subnet Privada 2]:::private
            RDS1[Amazon RDS]:::component
    end

    %% Zona B
    subgraph "Zona de Disponibilidade B"
        PublicB[Subnet Pública]:::public
        PrivateB1[Subnet Privada 3]:::private
            WP2[EC2 WordPress]:::component
        PrivateB2[Subnet Privada 4]:::private
            RDS2[Amazon RDS]:::component
    end

    %% Conexões
    PublicA --> IGW
    PublicB --> IGW
    
    PrivateA1 --> NAT
    PrivateA2 --> NAT
    PrivateB1 --> NAT
    PrivateB2 --> NAT

    VPC --> PublicA
    VPC --> PublicB
    VPC --> PrivateA1
    VPC --> PrivateA2
    VPC --> PrivateB1
    VPC --> PrivateB2




## 8. Referências

Abaixo irei colocar todos os sites na qual retirei recursos e aprendizados para fazer possível este projeto:

[Easy Local WordPress](https://www.youtube.com/watch?v=gEceSAJI_3s)

https://hub.docker.com/_/mariadb

https://hub.docker.com/_/mariadb

https://rancher.com/docs/os/v1.x/en/installation/cloud/aws/


