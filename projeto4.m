1;
function imagem = calcFit(particula)
  x = particula(1);
  y = particula(2);
  valor = x^2 - 10*cos(2*pi*x) + y^2 - 10*cos(2*pi*y);
  imagem = valor;
endfunction

function matrix = InitMatrix(nVar)
 m = rand(10,nVar);
 matrix = m;
endfunction

function aptidao = avaliarParticulas(posicao)
  v = zeros(1, rows(posicao));
  for i=1:rows(posicao)
    v(i) = calcFit(posicao(i,:));
  endfor
  aptidao = v;
endfunction

function p = atualiza_pBest(pBest, posicao)
  pb = zeros(rows(pBest), columns(pBest));
  for i=1:rows(pBest)
    if (calcFit(pBest(i,:)) > calcFit(posicao(i,:)))
      pb(i,:) = posicao(i,:);
    else
      pb(i,:) = pBest(i,:);
    endif
  endfor
  p = pb;
endfunction

function indice = atualiza_gBest(gBest, aptidao)
  gb = calcFit(gBest);
  [~,i] = min(aptidao);
  if gb > aptidao(i)
    indice = i;
  else
    indice = -1; #gBest ainda é o melhor
  endif
endfunction


###############################  M A I N  ##################################

#init
posicao = InitMatrix(2);
velocidade = InitMatrix(2);
pBest = InitMatrix(2);
gBest = rand(1,2);
melhoresPosicoes = avaliarParticulas(gBest);

for it=1:50
  aptidao = avaliarParticulas(posicao);
  pBest = atualiza_pBest(pBest, posicao);
  indice = atualiza_gBest(gBest, aptidao);
  if indice != -1
    gBest(1,:) = posicao(indice, :);
  endif

  w=0.9;
  for i=1:rows(velocidade) #atualiza velocidade
    velocidade(i,:) = w*velocidade(i,:) + 2*rand()*(pBest(i,:)-posicao(i,:)) + 2*rand()*(gBest-posicao(i,:));
  endfor
  for i=1:rows(posicao) #atualiza posicao
    posicao(i,:) =  posicao(i,:) + velocidade(i,:);
  endfor
  w = w*0.95;
  melhoresPosicoes = [melhoresPosicoes, avaliarParticulas(gBest)];
endfor

columns(melhoresPosicoes)
x=1:51;
plot(x, melhoresPosicoes); title(avaliarParticulas(gBest));
