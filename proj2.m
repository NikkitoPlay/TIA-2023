ORIGEM = input('Digite a origem  ');
mapa = [0 1 7 2 6 3 1;
        1 0 1 9 3 10 8;
        7 1 0 1 4 3 7;
        2 9 1 0 1 2 5;
        6 3 4 1 0 1 2;
        1 0 3 2 1 0 1;
        1 8 7 5 2 1 0];
function pop = criaPopulacao(origem, numCidades)
  pop = zeros(10,numCidades+1);
  for i=1:10
    c = randperm(numCidades);
    pop(i, 1:end-1) = c;
    pop(i, 2:end-1) = c(c != origem);
    pop(i, 1) = origem; pop(i, end) = origem;
  endfor
endfunction

function custo = calculaCaminho(caminho, mapa)
  custo = 0;
  for i=1:(columns(caminho)-1)
    custo += mapa(caminho(i), caminho(i+1));
  endfor
endfunction

function vAptidao = criaVetorAptidao(pop, mapa)
  vAptidao = zeros(1, rows(pop));
  for i=1:rows(pop)
    vAptidao(i) = calculaCaminho(pop(i,:), mapa);
  endfor
endfunction

function novosIndividuos = crossover(um, dois)
    filhos = zeros(2,8);
    filhos(1,1) = um(1);
    filhos(1,2:4) = dois(5:7);
    filhos(1,5:7) = um(2:4);
    filhos(1,8) = um(1);

    filhos(2,1) = dois(1);
    filhos(2,2:4) = um(5:7);
    filhos(2,5:7) = dois(2:4);
    filhos(2,8) = dois(1);
    for l=1:3
      cidadesAusentes = zeros(1,2);
      for j=1:2
        aux = inf(1,7);
        for i=1:7
          aux(filhos(j,i)) = 0;
        endfor
        [~,cidadesAusentes(j)] = max(aux);
      endfor
      if(sum(cidadesAusentes != 0))
        for i=1:7
          if filhos(1,i) == cidadesAusentes(2)
            filhos(1,i) = cidadesAusentes(1);
            break;
          endif
        endfor
        for i=1:7
          if filhos(2,i) == cidadesAusentes(1)
            filhos(2,i) = cidadesAusentes(2);
            break;
          endif
        endfor
      else
        continue;
      endif
    endfor
    novosIndividuos = filhos;
endfunction

function genitores = torneio(vetorPontuacao)
    indices = zeros(1,2);
    for l=1:2
        do
            i = round(rand()*columns(vetorPontuacao));
            j = round(rand()*columns(vetorPontuacao));
        until (i&&j != 0)
        if vetorPontuacao(i)>=vetorPontuacao(j)
            indices(l) = i;
        else indices(l) = j;
        endif
    endfor
    genitores = indices;
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
    [~,indice(1)] = max(aptidao);
    aptidao(indice(1)) = 0;
    [~,indice(2)] = max(aptidao);
    genitores = indice;
endfunction

function pior = matar(vetorPontuacao)
  [~,i] = max(vetorPontuacao);
  pior = i;
endfunction


function matrix = removeLinha(m,i)
  linhas = rows(m);
  novaMatriz = [];
  for j=1:linhas
    if j!=i
      novaMatriz = [novaMatriz;m(j,:)];
    endif
  endfor
  matrix = novaMatriz;
endfunction

function genesMutados = mutacao(individuo)
  novoIndividuo = individuo;
  do
    j = round(rand()*5+2);
    k = round(rand()*5+2);
  until j!=k
  novoIndividuo(j) = individuo(k);
  novoIndividuo(k) = individuo(j);
  genesMutados = novoIndividuo;
endfunction

function genitores = selecionaPais(populacao, indices)
    pais = zeros(columns(indices), 8);
    for i=1:columns(indices)
        pais(i,:) = populacao(indices(i),:);
    endfor
    genitores = pais;
endfunction

# main
populacao = criaPopulacao(ORIGEM,7);
aptidao = criaVetorAptidao(populacao, mapa);
geracao = 1;
melhorIndividuo = min(aptidao);
do
    pais = selecionaPais(populacao, elitismo(aptidao));#seleciona genitores elitismo|roleta|torneio
    filho = crossover(pais(1,:), pais(2,:));
    if(rand()>0.1)
      indice = round(rand()*1+1);
      filho(indice,:) = mutacao(filho(indice,:));
    endif
    populacao = [populacao; filho];
    filho = [];
    for i=1:2
       populacao = removeLinha(populacao, matar(aptidao)); 
    endfor
    aptidao = criaVetorAptidao(populacao, mapa);
    geracao++;
    melhorIndividuo = [melhorIndividuo, min(aptidao)]; #guarda em um vetor o melhor individuo de cada geracao
until(min(aptidao)<8)

#plotando o grafico
x = 1:geracao;
[~,menor] = min(aptidao);
caminho = num2str(populacao(menor,:));
plot(x, melhorIndividuo); title(caminho);
