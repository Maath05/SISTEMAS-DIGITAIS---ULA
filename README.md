Este repositório apresenta o projeto e a implementação de uma Unidade Lógica e Arit-
mética (ULA) de 4 bits, componente fundamental de qualquer processador, responsável por
realizar operações matemáticas e lógicas sobre dados binários. O sistema desenvolvido é
capaz de executar oito operações distintas, entre as quais as de soma e subtração são obriga-
tórias e foram implementadas com a representação de números em complemento a 2, o que
permite tratar valores positivos e negativos de forma uniforme e utilizar o mesmo circuito
somador para ambas as operações.
A implementação foi feita em hardware sobre o kit de desenvolvimento Xilinx Spartan-
3, que serve como plataforma de interação com o usuário. Quatro chaves seletoras da placa são
usadas como entrada de dados, sendo reaproveitadas em momentos diferentes para informar,
em sequência, o código da operação desejada e os dois operandos. Para organizar essa
sequência, o projeto emprega botões de confirmação: a cada acionamento, o valor presente
nas chaves é registrado e o sistema avança para a etapa seguinte do processo de inserção.
Concluídas as entradas, a ULA executa a operação selecionada e apresenta o resultado
nos LEDs da placa. Além do resultado, o sistema exibe as flags associadas à operação,
como indicadores de condições especiais, por exemplo, resultado igual a zero, sinal negativo,
overflow e carry, permitindo ao usuário interpretar corretamente o desfecho do cálculo.
