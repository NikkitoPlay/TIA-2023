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

function filhos = crossover(um, dois)
  if(rand()<0.8)
    filhos = [];
    filhos(1,1) = um(1);
    filhos(1,2:3) = dois(6:7);
    filhos(1,4:5) = um(4:5);
    filhos(1,6:7) = dois(2:3);
    filhos(1,8) = um(8);

    filhos(2,1) = dois(1);
    filhos(2,2:3) = um(6:7);
    filhos(2,4:5) = dois(4:5);
    filhos(2,6:7) = um(2:3);
    filhos(2,8) = dois(8);

    cidadesAusentes = zeros(1,2);
    for j=1:2
      aux = inf(1,7);
      for i=1:7
        aux(filhos(j,i)) = 0;
      endfor
      [~,cidadesAusentes(j)] = max(aux);
    endfor
    if min(cidadesAusentes)!=0
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
    endif
  else
    filhos(1,:) = um;
    filhos(2,:) = dois;
  endif
endfunction

function maior = torneio(vetorPontuacao)
  do
    i = round(rand()*columns(vetorPontuacao));
    j = round(rand()*columns(vetorPontuacao));
  until (i&&j != 0)
  if vetorPontuacao(i)>=vetorPontuacao(j)
    maior = i;
    else maior = j;
  endif
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
    j = round(rand()*5+2);
    k = round(rand()*5+2);
  novoIndividuo(j) = individuo(k);
  novoIndividuo(k) = individuo(j);
  genesMutados = novoIndividuo;
endfunction

populacao = criaPopulacao(2,7);
aptidao = criaVetorAptidao(populacao, mapa);
geracao = 1;
do
  for j=1:4
    populacao = removeLinha(populacao, torneio(aptidao));
    aptidao = criaVetorAptidao(populacao, mapa);
  endfor
  for k=1:2
    filho = crossover(populacao(k,:), populacao(end-k,:));
    if(rand()>0.5)
      indice = round(rand()*1+1);
      filho(indice,:) = mutacao(filho(indice,:));
    endif
    populacao = [populacao; filho];
    filho = [];
  endfor

  aptidao = criaVetorAptidao(populacao, mapa);
  geracao++;
until(min(aptidao)<=8)
geracao
