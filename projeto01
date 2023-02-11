function matrix = set1(m, i,k)
  matrix = m;
  matrix(i,k) = 1;
endfunction

function valor = avaliarIndividuo(m, i)
  valor = 0;
  for j=5:-1:0
    valor = valor+m(i,columns(m)-j)*(2^j);
  endfor
endfunction

%cria o vetor com a pontuacao dos individuos
function v = criaVetorP(m)
  v=[];
  for i=1:rows(m)
    v = [v,avaliarIndividuo(m,i)];
  endfor
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

function perdedor = torneio(vetorPontuacao)
  do
    i = round(rand()*columns(vetorPontuacao));
    j = round(rand()*columns(vetorPontuacao));
  until (i&&j != 0)
  if vetorPontuacao(i)>=vetorPontuacao(j)
    perdedor = j;
    else perdedor = i;
  endif
endfunction

function populacao = criaPop()
  pop = zeros(100,6);
  for j=1:rows(pop)
    for k=1:6
      if (k<4)&&mod(rand()*100,7)==0
        pop = set1(pop, j, k);
        continue;
      else 
        if rand()*100<20
          pop = set1(pop, j, k);
        endif
      endif
    endfor
  endfor
  populacao = pop;
endfunction


function filhos = crossover(um, dois)
    if rand()<0.7
      filhos(1,1:2) = um(3:4);
      filhos(1,3:4) = dois(1:2);
      filhos(1,5:6) = um(5:6);

      filhos(2,1:2) = dois(5:6);
      filhos(2,3:4) = um(3:4);
      filhos(2,5:6) = dois(1:2);
    else
      filhos(1,1:6) = um;
      filhos(2,1:6) = dois;
    endif
endfunction

populacao = criaPop();
  pontuacao = criaVetorP(populacao);
  melhorIndividuo = zeros(1, 1);
  it= 1;
  melhorIndividuo(it) = max(pontuacao);

  do
    for k=1:30
      populacao = removeLinha(populacao,torneio(pontuacao));
      pontuacao = criaVetorP(populacao);
    endfor
      
    for k=1:15
      filho = crossover(populacao(k,:),populacao(70-k,:));
      populacao = [populacao;filho];
      filho = [];
    endfor
    pontuacao = criaVetorP(populacao);
    it++;
    melhorIndividuo = [melhorIndividuo, max(pontuacao)];
  until (max(pontuacao)==63);

  printf("\n\nIndividuo encontrado! \nGERACAO: %d  \n\n\n", it)
  x = [1:1:columns(melhorIndividuo)];
  y = melhorIndividuo.^2;
  plot(x,y)
  
