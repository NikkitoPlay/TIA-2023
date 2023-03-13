1;
function populacao = criaPop(palavra)
  alfabeto = [97:122];
  nLetras = columns(palavra);
  m = zeros(15, nLetras); #15 individuos
  r=1; #comeca na linha_1
  for i=1:(15*nLetras)
    c = mod(i,nLetras);
    if (c == 0)
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

function distancia = calcDistancias(individuo, palavra)
  v = zeros(1,columns(palavra));
  for i=1:columns(palavra)
    v(i) = abs(individuo(i) - palavra(i));
  endfor
  distancia = sum(v);
endfunction

function aptidao = criaApt(populacao, palavra)
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

function individuo = roleta(vetorPontuacao)
  do
    i = round(rand()*columns(vetorPontuacao));
    k = round(rand()*columns(vetorPontuacao));
  until(i&&k!=0);
  individuo = [i,k];
endfunction

function genitores = elitismo(aptidao)
    indice = zeros(1,2);
    [~,indice(1)] = min(aptidao);
    aptidao(indice(1)) = inf;
    [~,indice(2)] = min(aptidao);
    genitores = indice;
endfunction

function genitores = selecionaPais(populacao, indices)
    pais = zeros(columns(indices), 9);
    for i=1:columns(indices)
        pais(i,:) = populacao(indices(i),:);
    endfor
    genitores = pais;
endfunction

function novosIndividuos = crossover(um, dois)
  filhos = zeros(2,9);
  for i=1:10 
    c = mod(i,10);
    if (c != 0)
      switch (mod(i,2))
        case 0
          filhos(1, c)=um(c);
          filhos(2, c)=dois(c);
        case 1
          filhos(1, c)=dois(c);
          filhos(2, c)=um(c);
        otherwise
          1;
      endswitch
    endif
  endfor
  novosIndividuos = filhos;    
endfunction

function genesMutados = mutacao(individuo, n) # troca aleatoriamente 'n' letras de um individuo
  ind = zeros(1, n);
  for i=1:n
    ind(i) = randperm(9,1);
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


palavra = int8(input("Digite uma palavra de 9 letras entre aspas simples -> "));
populacao = criaPop(palavra);
aptidao = criaApt(populacao, palavra);
melhorIndividuo = min(aptidao);
geracao = 1;

do
  pais = selecionaPais(populacao, elitismo(aptidao));
  filhos = crossover(pais(1,:), pais(2,:));

  if(rand()<0.7)
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
until(min(aptidao) == 0);

#plotando o grafico
x = 1:geracao;
[~,menor] = min(aptidao);
caminho = char(populacao(menor,:));
plot(x, melhorIndividuo); title(caminho);
