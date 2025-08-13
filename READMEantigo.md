# Sprint 1 - Configurando VPC e Instância AWS  
**Compass UOL**

> **Nota:**
> Esta documentação faz parte do programa da Compass UOL e não é considerada um tutorial. Siga cada etapa cuidadosamente e, em caso de dúvidas, consulte a documentação oficial da AWS. 

## Índice

- [Pré-requisitos](#0-pré-requisitos)

- [Introdução](#1-introdução)

- [Configurando VPC](#2-configurando-vpc)

- [Criando Instância EC2 na AWS](#3-criando-instância-ec2-na-aws)

- [Acesso usando a chave SSH](#4-acesso-usando-a-chave-ssh)

- [NGINX e o código HTML básico](#5-nginx-e-o-código-html-básico)

- [Configurar o WEBHOOK do Telegram](#6-configurar-o-webhook-do-telegram-para-receber-alertas-quando-o-site-estiver-fora-do-ar)

- [Saídas dos códigos](#7-se-estiver-tudo-funcionando-estas-serão-as-saídas-dos-códigos)

- [Referências](#8-referências)

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
- **Vontade de aprender e dedicação**

---

## 1. Introdução

Nesta primeira Sprint fomos introduzidos ao mundo do **Linux**, primordial para o entendimento da virtualização em nuvem. Antes de entrarmos na AWS ou na virtualização de fato, procure entender e compreender a interface de linha de comando (CLI) no LINUX. Independente da distribuição que esteja usando, deixe de lado a interface gráfica e estude os comandos do terminal. Isso é especialmente relevante porque, em ambientes virtualizados, normalmente não há recursos suficientes para rodar interfaces gráficas completas, tornando o domínio do terminal indispensável

É importante entender que as distribuições LINUX possuem "bases diferentes", das quais elas advêm. Explicando de forma mais simples, cada distribuição possuem todos um kernel linux, mas com diferenças importantes em gerenciamento de pacotes, estrutura de arquivos e comandos específicos. Por exemplo, comandos que funcionam no Ubuntu (base Debian) podem não funcionar no Fedora (base Red Hat).

Esses conhecimentos irão formar a base para avançar em virtualização e administração de sistemas Linux na nuvem.

>**Nota:** Conforme documentado a frente, o Amazon Linux, distribuição padrão da AWS, possui base Red Hat.

---

## 2. Configurando VPC  

VPC é a sigla para Virtual Private Cloud e ela é um ambiente de rede isolado dentro da nuvem AWS. A criação de um VPC garante que possamos executar nossos próprios recursos de forma segura e controlada.

O intuito aqui é criar uma VPC seguindo os passos do desafio. A VPC necessita:

   #### x. 2 sub-redes pública

   #### y. 2 sub-redes privadas
   
   #### z. Uma Internet Gateway conectada às sub-redes públicas.

Ao acessar pela primeira vez após a criação da conta AWS ou após habilitação do Administrador, siga estes passos:

### 2.1. Na aba escrito Search no canto superior esquerto digite "VPC" 

![VPC Aba Search](/imgs/AWS-EC2-Aba-search.png)

### 2.2. Clica em "Your VPCs"

### 2.3. Ao abrir a página, procure por "Criar VPC"

### 2.4. A AWS dá duas opções de VPC: "Somente VPC" ou "VPC e muito mais". Iremos na segunda opção, como a imagem abaixo.
    
![VPC Novo VPC](/imgs/AWS-EC2-VPC-CREATE-NEW.png)
    
#### 2.4.1 Em Bloco CIDR coloque o IP na qual as instâncias irão ser endereçadas. 

#### 2.4.2 Selecionar a quantidade de 2 em "Número de zonas de disponibilidade (AZs)"

![VPC Novo VPC2](/imgs/AWS-EC2-VPC-CREATE-NEW2.png) 

#### 2.4.3 Selecionar a quantidade de 2 sub-redes em ambas as opções abaixo:

- Número de sub-redes públicas

- Número de sub-redes Privadas

#### 2.4.4 Selecionar a criação do Gateway NAT

- Cuidado para não incindir cobranças na criação desde Gateway.

### 2.5. Após todos estes passos, a sua pré-visualização deverá ficar próximo a este:

![VPC Pre Visualizacao](/imgs/AWS-EC2-VPC-CREATE-PRE-VISUALIZACAO.png)

### FINAL. Pode clicar em "Criar VPC"

Pronto, a VPC foi criada conforme o desafio.

---

## 3. Criando Instância EC2 na AWS

Vamos criar uma máquina virtual com o sistema operacional Amazon Linux

### 3.1. Na aba "Search" coloque EC2 e logo após clique em "Dashboard"

![VPC Shearch EC2 - Dashboard](/imgs/AWS-EC2-Aba-Search-EC2.png)

### 3.2. Procure por "Executar Instância" e clique

### 3.3. Na próxima janela que foi carregado, preencha as TAGS

![VPC TAGS](/imgs/AWS-EC2-Instance-TAGS.png)

- As Tags são importantes para a organização das suas instâncias

- Foram censuradas as Tags do programa por motivos de segurança

### 3.4. Em "Ínicio rápido", selecione o sistema operacional "Amazon Linux"

### 3.5. Em "Tipo de instância" deixe o padrão (t2.micro)

### 3.6. Em par de chaves, clique em "Criar novo par de chaves"

![VPC Par de Chaves](/imgs/AWS-EC2-Criar-chave-ssh2.png)

- Coloque um nome para a sua chave

>**Nota** Ao criar as chaves, vai aparecer um arquivo para ser realizado o Download. Salve em um lugar seguro pois ele será usado mais para frente.

## 3.7. Configuração de rede: Clique em editar logo a direita para abrir mais opções

![VPC Configuração de Rede](/imgs/AWS-EC2-Configuracao-rede.png)

- Selecione o VPC criado posteriormente

- Selecione a Sub-rede pública criado posteriormente

- Adicione uma regra do grupo de segurança para o HTTP

>**Nota** Importante ter esta regra HTTP ativa e liberada para o NGINX funcionar corretamente.

## FINAL. Clica em executar instância para criar sua máquina virtual

- Espere a instância carregar para fazer o primeiro acesso

---

## 4. Acesso usando a chave SSH

Aguarde um tempo para que a sua instância possa carregar e logo após inicie os passos a seguir:

### Primeira conexão

- Dentro do site da AWS, colete o IP Público da instância. 

- No terminal do Linux (Em WSL ou no próprio sistema operacional linux) digite conforme abaixo:

            ssh -i /caminho/para/sua/chave.pem ec2-user@ec2-endereco_ip_publico.região.da.instância

- Exemplo

            ssh -i /home/USER_LINUX/Downloads/zezinhachave.pem ec2-user@ec2-12-123-321-333.us-east-2.compute.amazonaws.com

- No passo seguinte o terminal irá aparecer a seguinte mensagem:

            Are you sure you want to continue connecting (yes/no/[fingerprint])?

- Coloque "yes" e dê Enter no teclado

### FINAL. Pronto, você está conectado à sua máquina virtual diretamente no terminal LINUX

---

## 5. NGINX e o código HTML básico

NGINX é um software de servidor web de código aberto conhecido por sua alta performance e baixa utilização de recursos. Iremos utilizar ele na nossa máquina virtual para fazermos os devidos testes proposto no desafio.

### 5.1. Instalando pacote NGINX

- No terminal iremos colocar os seguintes comandos

            sudo dnf update && dnf install nginx

### 5.2. Configuração

#### 5.2.1. Faça o backup do arquivo conf padrão do NGINX

            sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

#### 5.2.2. Crie outro arquivo conf no mesmo local com o comando Vim

           sudo vim /etc/nginx/nginx.conf

#### 5.2.3. Adicione estes comandos no arquivo nginx.conf

            worker_processes  1;
            events {
                worker_connections  1024;
            }           
            http {  
                include       mime.types;

                default_type  application/octet-stream;

                server_names_hash_bucket_size 64;
                
                sendfile        on;
                
                
                keepalive_timeout  65;
                #gzip  on;
                include /etc/nginx/conf.d/*.conf;
            }

- Coloque este comando abaixo para averiguar se não há nenhum erro de sintaxe nos arquivos conf.

            sudo nginx -t

#### 5.2.4. Crie um arquivo conf na pasta conf.d com o nome do seu site

            sudo vim /etc/nginx/conf.d/NOME_DO_SEU_SITE.conf

#### 5.2.5. Adicione estes comando no arquivo que vai ser criado (NOME_DO_SEU_SITE.conf)

            server {

                listen 80 default_server;

                server_name NOME_DO_SEU_SITE.com;

                root /var/www/NOME_DO_SEU_SITE/html;

                index index.html;

                location / {
                    try_files $uri $uri/ =404;
                }
            }
 >**Nota:** Perceba que aqui neste arquivo conf você também irá substituir o NOME_DO_SEU_SITE

#### 5.2.6. Crie a pasta em /var/www/NOME_DO_SEU_SITE/html

            sudo mkdir -p /var/www/NOME_DO_SEU_SITE/html

#### 5.2.7. Adicione um arquivo index.html na pasta NOME_DO_SEU_SITE/html

            sudo vim /var/www/NOME_DO_SEU_SITE/html/index.html

- Exemplo de um html simples para testar o NGINX

                <!DOCTYPE html>
                    <html>
                        <head>
                            <title>Example</title>
                        </head>
                        <body>  
                            <p>This is an example of a simple HTML page with one paragraph.</p>
                        </body>
                    </html>

#### 5.2.8. Ajuste as permissões de arquivos para que o NGINX possa ler

            sudo chown -R ec2-user:nginx /var/www/NOME_DO_SEU_SITE/html
            
            sudo chmod -R 750 /var/www/jNOME_DO_SEU_SITE/html

### 5.3. Habilite para o NGINX possa inicializar junto com o sistema
            
            sudo systemctl enable nginx.service

### 5.4. Inicie o NGINX
            
            sudo systemctl start nginx.service

### 5.5. Coloque este comando no terminal para ver seu ip público

            curl -s ifconfig.me

- Copie e cole este IP no seu navegador, se os passos foram feitos corretamente, o site vai estar em funcionamento.

---

## 6. Configurar o WEBHOOK do Telegram para receber alertas quando o site estiver fora do ar

Neste momento nós iremos criar um arquivo com final sh, na qual teremos um código em bash na qual ele irá analizar se o site está em funcionamento. Caso contrário, ele enviará uma mensagem via bot do Telegram informando sobre a queda do servidor.

>**Nota:** Antes de iniciar, [entre neste site e veja como criar um bot no Telegram](https://tecnoblog.net/responde/como-criar-um-bot-no-telegram/). Não irei documentar este item.

>**Nota2:** Vai ser gerado um TOKEN, guarde ele e não compartilhe com ninguém, é um item de segurança de registro do seu BOT.

### 6.1 Como adquirir seu chat ID

>**Nota:** Este irei fazer o passo a passo para registro e futuras orientações.

- Com o TOKEN em mãos, substitua ele no site abaixo.

        https://api.telegram.org/botCOLE_O_TOKEN_AQUI/getUpdates

- Envie uma mensagem de teste da sua conta do Telegram diretamente para o BOT

- Copie e cole a URL acima com o token colado no seu devido lugar

![Telegram-Chat-IP](/imgs/Telegram-CHAT-IP%20.png)

- O Chat ID está na chave "Chat > id"

### 6.2. Código para funcionar o WEBHOOK

O arquivo shell está disponibilizado [aqui](/bash/jgustavo_WEBHOOK_Telegram.sh), mas também terá o código aqui na documentação e explicado.

#### 6.2.1. Criação do arquivo

        sudo vim /usr/local/bin/htmltest.sh

#### 6.2.2. Código para ser colocado no arquivo

        #!/bin/bash
        
        #Variaveis criticas do TELEGRAM - Substitua o termo ESCONDIDO pelo CHAT ID e TOKEN do BOT.

        ID_GROUP=ESCONDIDO
        TOKEN_BOT=ESCONDIDO
        IP_PUBLICO=$(curl -s ifconfig.me)

        #Criar arquivo de log monitoramento.log
        touch /var/log/monitoramento.log
        
        #Codigo para verificar o funcionamento do site, se o mesmo esta no ar corretamente
        
        HTTP_CODE=$(curl -L -s -o /dev/null -w "%{http_code}" $IP_PUBLICO )
        
        if [ "$HTTP_CODE" ==  "200" ]; then
        	MESSAGE_ON="ADMIN: Servidor se encontra ativo"
            echo "$(date +"%F %T") -  $MESSAGE_ON" >> /var/log/monitoramento.log
        
        else
        	MESSAGE_OFF="ADMIN: O site de encontra fora do ar!"
            echo "$(date +"%F %T") -  $MESSAGE_OFF" >> /var/log/monitoramento.log
            curl -s -X POST "https://api.telegram.org/bot$TOKEN_BOT/sendMessage" -d chat_id="$ID_GROUP" -d text="$MESSAGE_OFF"
            
        fi

#### 6.2.3. Permissão para funcionar e rodar no sistema

        chmod +x /usr/local/bin/htmltest.sh

### 6.4 Habilitar o SERVICE do htmltest.sh do servidor EC2

#### 6.4.1. Criar o arquivo html.service no sistema

        sudo vim /etc/systemd/system/htmltest.service

#### 6.4.2. Código para inicializar o bash que esta em /usr/local/bin

        #Começo do Código

        [Unit]
        Description= Servico de teste de ping
        
        [Service]
        ExecStart=/usr/local/bin/htmltest.sh
        
        [Install]
        WantedBy=multi-user.target
        
        EOF

#### 6.4.3. Criar o TIMER do SERVICE do htmltest.service

        sudo vim /etc/systemd/system/htmlteste.timer

#### 6.4.4. Código para inicializar o SERVICE do htmltest.service

        [Unit]
        Description="Iniciar o htmltest.service em quantidade de 30 segundos para cada inicialização do servidor EC2"
        
        [Timer]
        OnBootSec=5
        OnUnitActiveSec=30
        Unit=htmltest.service
        
        [Install]
        WantedBy=multi-user.target

### 6.5. Ativar o serviço para inicializar junto com a máquina

        systemctl enable htmltest.timer

        systemctl start htmltest.timer

---

## 7. Se estiver tudo funcionando, estas serão as saídas dos códigos

### 7.1 Caso o site esteja no ar, haverá apenas o registro no monitoramento.log conforme abaixo

![Sites está no ar](/imgs/Terminal-Log-ON.png)

### 7.2. Caso o site esteja fora do ar, haverá registro no log e também a mensagem de alerta no Telegram

![sites fora do ar](/imgs/Terminal-Log-OFF.png)

![Telegram fora do ar](/imgs/Telegram-site-OFF.png) 

---        

## 8. Referências

Abaixo irei colocar todos os sites na qual retirei recursos e aprendizados para fazer possível este projeto:

[Servidor NGINX básico:](https://www.dio.me/articles/servidor-web-nginx-basico) Menção honrosa. Funciona bem em distribuições com base Debian

[Como instalar NGINX no Fedora:](https://www.atlantic.net/dedicated-server-hosting/how-to-install-nginx-web-server-on-fedora/) Interessante seguir esta opção para distribuições com base RED HAT

[Como criar um Bash Shell simples para enviar mensagens no Telegram: ](https://hackernoon.com/how-to-create-a-simple-bash-shell-script-to-send-messages-on-telegram-lcz31bx) Base para entender a função WEBHOOK do Telegram

[Como criar e executar um Service Timer](https://www.certificacaolinux.com.br/systemd-timer-no-linux-mulplexar-terminal-guia-basico/)

[WIKI systemd.timers](https://wiki.archlinux.org/title/Systemd/Timers)

[Fórum: "Confirmação de status de serviço http"](https://pt.stackoverflow.com/questions/342967/confirma%C3%A7%C3%A3o-de-status-de-servi%C3%A7o-site-ou-host)

[Adicionar saída do bash para texto:](https://pt.stackoverflow.com/questions/374965/adicionar-sa%C3%ADda-do-bash-para-texto) Usado para fazer o script do LOG

[O que o símbolo ">>" faz no echo?:](https://askubuntu.com/questions/471767/what-does-echo-with-symbol-do)
