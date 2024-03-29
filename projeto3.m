#este algoritmo descobre uma palavra secreta digitada pelo usuario
1;
function populacao = criaPop(palavra) #cria uma populacao preenchida com todo o alfabeto
  alfabeto = [97:122];
  nLetras = columns(palavra);
  m = zeros(15, nLetras); #cria uma matriz com 15 linhas e numero de coluna igual ao numero de letras na palavra
  r=1; #comeca na linha_1
  for i=1:(15*nLetras)
    c = mod(i,nLetras); #indice ciclico 1-nLetras
    if (c == 0) #significa que o contador chegou na ultima letra 
        c = nLetras;
        if (mod(i,27)!=0)
            m(r, c) = alfabeto(mod(i,27));
        else
            m(r, c) = randperm(26,1)+96;
        endif
        r++;
    else
        if (mod(i,27)!=0)
            m(r, c) = alfabeto(mod(i,27));
        else
            m(r, c) = randperm(26,1)+96;
        endif
    endif
  endfor
  populacao = m;
endfunction

function distancia = calcDistancias(individuo, palavra) #calcula um numero que representa o quão proximo está a palavra
  v = zeros(1,columns(palavra));
  for i=1:columns(palavra)
    v(i) = abs(individuo(i) - palavra(i));
  endfor
  distancia = sum(v);
endfunction

function aptidao = criaApt(populacao, palavra) #cria um vetor que calcula a aptidao de cada individuo
  v = zeros(1,rows(populacao));
  for i=1:rows(populacao)
    v(i) = calcDistancias(populacao(i,:), palavra);
  endfor
  aptidao = v;
endfunction

function vencedores = torneio(vetorPontuacao)
    indices = zeros(1,2);
    for l=1:2
        do
            i = round(rand()*columns(vetorPontuacao));
            j = round(rand()*columns(vetorPontuacao));
        until (i&&j != 0)
        if vetorPontuacao(i)<=vetorPontuacao(j)
            indices(l) = i;
        else indices(l) = j;
        endif
    endfor
    vencedores = indices;
endfunction

function vencedores = roleta(vetorPontuacao)
  do
    i = round(rand()*columns(vetorPontuacao));
    k = round(rand()*columns(vetorPontuacao));
  until(i&&k!=0);
  vencedores = [i,k];
endfunction

function vencedores = elitismo(aptidao)
    indice = zeros(1,2);
    [~,indice(1)] = min(aptidao);
    aptidao(indice(1)) = inf;
    [~,indice(2)] = min(aptidao);
    vencedores = indice;
endfunction

function genitores = selecionaPais(populacao, indices)
    nLetras = columns(populacao(1,:));
    pais = zeros(columns(indices), nLetras);
    for i=1:columns(indices)
        pais(i,:) = populacao(indices(i),:);
    endfor
    genitores = pais;
endfunction

function novosIndividuos = crossover(um, dois) # faz um crossover um-a-um entra os genes selecionados
  nLetras=columns(um);
  filhos = zeros(2,nLetras);
  for i=1:nLetras
    switch (mod(i,2))
      case 0
        filhos(1, i)=um(i);
         filhos(2, i)=dois(i);
      case 1
        filhos(1, i)=dois(i);
        filhos(2, i)=um(i);
       otherwise
         1;
    endswitch
  endfor
  novosIndividuos = filhos;
endfunction

function genesMutados = mutacao(individuo, n) # troca aleatoriamente 'n' letras de um individuo
  ind = zeros(1, n);
  for i=1:n
    ind(i) = randperm(columns(individuo),1);
  endfor
  for k=1:n
    individuo(ind(k)) = randperm(26,1)+96;
  endfor
  genesMutados = individuo;
endfunction

function pior = matar(vetorPontuacao)
  [~,i] = max(vetorPontuacao);
  pior = i;
endfunction

function matrix = removeLinha(m,i) # remove a linha 'i' de uma matriz 'm'
  linhas = rows(m);
  novaMatriz = [];
  for j=1:linhas
    if j!=i
      novaMatriz = [novaMatriz;m(j,:)];
    endif
  endfor
  matrix = novaMatriz;
endfunction

################################### M A I N #########################################


palavra = int8(input("Digite uma palavra entre aspas simples -> "));
populacao = criaPop(palavra);
aptidao = criaApt(populacao, palavra);
melhorIndividuo = min(aptidao);
geracao = 1;

do
  pais = selecionaPais(populacao, elitismo(aptidao));
  filhos = crossover(pais(1,:), pais(2,:));

  if(rand()<0.9)
    indice = round(rand()*1+1);
    filhos(indice,:) = mutacao(filhos(indice,:), 1);
  endif
  populacao = [populacao; filhos];
  filhos = [];
  for i=1:2
    populacao = removeLinha(populacao, matar(aptidao));
  endfor

  aptidao = criaApt(populacao, palavra);
  geracao++;
  melhorIndividuo = [melhorIndividuo, min(aptidao)]; #guarda em um vetor o melhor individuo de cada geracao

  [~,k]=min(aptidao);
  bw = char(populacao(k,:));
  disp(bw);
until(min(aptidao) == 0);

#plotando o grafico
printf("individuo encontrado, geracao %d \n", geracao)
x = 1:geracao;
[~,menor] = min(aptidao);
pEncontrada = char(populacao(menor,:));
plot(x, melhorIndividuo); title(pEncontrada);
