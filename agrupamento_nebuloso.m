1;
global M = input("Digite o expoente de ponderacao: ");

function dist = distanciaEuclidiana(objeto, prototipo)
  mem = sqrt(sum((objeto - prototipo).^2));
    dist = mem;
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

function matrix = atualizaPertinencia(mPertinencia, dataBase, pPrototipos)
  global M;
  den = 0;
  u = zeros(rows(mPertinencia),columns(mPertinencia));
  for j=1:columns(mPertinencia)
    for i=1:rows(mPertinencia)
      for p=1:columns(mPertinencia)
        den += [distanciaEuclidiana(dataBase(i,:), pPrototipos(j,:))/distanciaEuclidiana(dataBase(i,:), pPrototipos(p,:))]^(2/(M-1));
      endfor
      u(i,j) = 1/den;
      den=0;
    endfor
  endfor
  matrix = u;
endfunction

function prototipos = atualizaPrototipos(dataBase, mPertinencia)
  global M;
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

############################################   M  A  I  N   ############################################

dataBase = load('C:\Users\nikit\Documents\facul-2002\TIA\projeto04\ruspiniNormalizado.m');
pPrototipos = rand(4,2);
mPertinencia = zeros(rows(dataBase), rows(pPrototipos));

for it=1:10
    mPertinencia = atualizaPertinencia(mPertinencia, dataBase, pPrototipos);
    pPrototipos = atualizaPrototipos(dataBase, mPertinencia);
endfor

plot(dataBase(:,1), dataBase(:,2),'o','MarkerFaceColor', 'blue'); hold on;
plot(pPrototipos(:,1), pPrototipos(:,2), 'o', 'MarkerSize', 100, 'MarkerEdgeColor', 'red'); hold off; 
axis("equal");
