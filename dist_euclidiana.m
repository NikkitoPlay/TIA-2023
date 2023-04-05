1;
global M = input("Digite o expoente de ponderação: ");

function dist = distanciaEuclidiana(objeto, prototipo)
  mem = sqrt(sum((objeto - prototipo).^2));
  if mem>1 && mem<inf
    dist = mem;
  else
    disp("Error na func euclidiana");
    dist = inf;
  endif
endfunction

function soma = squareError (mPertinencia, dataBase, pPrototipos)
  mem = 0;
  for i=1:columns(mPertinencia)
    for j=1:rows(mPertinencia)
      mem += mPertinencia(j,i)^M * [distanciaEuclidiana(dataBase(j,:), pPrototipos(i,:))^2];
    endfor
  endfor
  soma = mem;
endfunction

function matrix = atualizaPertinencia(mPertinencia, bataBase, pPrototipos)
  den = 0;
  u = zeros(rows(mPertinencia),columns(mPertinencia));
  for j=1:columns(mPertinencia)
    for i=1:rows(mPertinencia)
      for p=1:colunms(mPertinencia)
        den += [distanciaEuclidiana(dataBase(i,:), pPrototipos(j,:))/distanciaEuclidiana(dataBase(i,:), pPrototipos(p,:))]^(2/(M-1));
      endfor
      u(i,j) = 1/den;
      den=0;
    endfor
  endfor
  matriz = u;
endfunction

function prototipos = atualizaPrototipos(dataBase, mPertinencia)
  p = zeros(4,2);
  num = den = 0;
  for k=1:columns(mPertinencia)
    for i=1:rows(dataBase)
      num += dataBase(i,:)*mPertinencia(i,k)^M;
      den += mPertinencia(i,k)^M;
    endfor
    p(k,:) = num/den;
    num = 0;den = 0;
  endfor
  prototipos = p;
endfunction

dataBase = load('C:/Users/06377250185/ruspini.m', 'r');
pPrototipos = rand(4,2);
mPertinencia = zeros(rows(dataBase), rows(pPrototipos));

pPrototipos

