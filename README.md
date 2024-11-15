# Batalha Naval Assembly MASM/TASM 
###### Projeto de Organização de Sistemas Computacionais da PUC-C
![MAIN MENU](https://i.ibb.co/sRFZrWH/image.png)
## Introdução
Bem Vindo à documentação do projeto de Organização de Sistemas Computacionais de 2024 da PUC-Campinas. Este projeto consiste em recriar o jogo Batalha-Naval em Assembly x64 Intel Masm/Tasm.

## Recursos

O programa deve ter os seguintes recursos:

- As embarcações devem estar dispostas em uma matriz, e as embarcações não podem estar encostadas (distância de uma casa, na vertical, na horizontal e na diagonal);
- O jogador deve dar seus “tiros” informando as linha e coluna;
- Deve estar visível para o usuário, a matriz onde seus tiros serão marcados, incluindo a informação de acerto em embarcações;
- Deve ter uma opção de finalização automática do jogo.

## Requirements

Requrimentos para o funcionamento do programa:

- [VSCode] - IDE de programação
- [MASM/TASM] - Extenção do VSCode

## Installation

To install the aplication you can download the files by cloning the repo or dowloading the ZIP file from our [GitHub] repository.
```sh
git clone https://github.com/rsushizawa/Batalha-Naval-Assembly.git
```

## Como Jogar

Ao rodar o programa, você irá se deparar com a seguinte interface. Na matriz à esquerda, o seu mapa, está mostrando a posição de cada barco. O outro mapa é da CPU, o seu oponente, e o ponto crucial para a sua vitória é acertar todos os barcos escondidos da matriz à direita digitando a sua coordenada fornecida pelos índices ao lado da tabela.
![player input target](https://i.ibb.co/nrxCkSQ/image.png)

Para fornecer as coordenadas, deve-se primeiro digitar o eixo X da coordenada, indicado pelos números de 0 a 9. Após isso, deverá digitar o eixo Y da coordenada, representado pelo alfabeto de A a F, o programa irá apenas aceitar letras maiúsculas.
![player input target](https://i.ibb.co/J3VtL8R/image.png)

Quando você acertar um navio, a coordenada atingida será substituída por X e você terá outra oportunidade de ataque e com isso, deverá digitar a outra coordenada que deseja acertar.
![player input target](https://i.ibb.co/844D3DF/image.png)

Ao errar a posição de um barco, a mesma irá ser substituída por O e você perderá o seu turno e será o turno da CPU.
![player input target](https://i.ibb.co/3mfnzf7/image.png)

Durante o turno da CPU será indicado as coordenadas do alvo da CPU e uma indicação se o tiro acertou água(O) ou um navio(X).
![player input target](https://i.ibb.co/q9sYkXp/image.png)

Quando um todos as partes de um navio são atingidas é uma menssagem de naufráfio é exibida.
![player input target](https://i.ibb.co/d75mgZ4/image.png)


A tela de vitória/derrota apenas aparece quando todos os navios do oponente/jogador são atingidos e o programa irá finalizar automaticamente ao acontecer esse evento.
![player input target](https://i.ibb.co/N2ssmGg/image.png)
![player input target](https://i.ibb.co/bbfyPsf/image.png)

## Equipe

- Daniel Wu - 24021993
- Luan Costa SIlva - 24787079
- Rodrigo Seiji Yugoshi Ushizawa - 24009811




   [MASM/TASM]: <https://marketplace.visualstudio.com/items?itemName=xsro.masm-tasm>
   [VSCode]: <https://code.visualstudio.com/>
   [GitHub]: <https://github.com/rsushizawa/Batalha-Naval-Assembly.git>