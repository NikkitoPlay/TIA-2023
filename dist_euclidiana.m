1;
global M = input("Digite o expoente de ponderação: ");

function dist = distanciaEuclidiana(objeto, prototipo)
  mem = sqrt(sum((objeto - prototipo).^2));
endfunction
function soma = squareError (mPertinencia, dataBase, pPrototipos)
  mem = 0;
  for i=1:columns(mPertinencia)
    for j=1:rows(mPertinencia)
      #mem += mPertinencia(j,i)^M * [dataBase(j,:)-pPrototipos(i,:)]^2
    endfor
  endfor
  soma = mem;
endfunction

function matrix = atualizaPertinencia(mPertinencia, bataBase)
  den = 0;
  for j=1:columns(mPertinencia)
    for i=1:rows(mPertinencia)
      for p=1:colunms(mPertinencia)
        #den += [(dataBase(i,:)-pPrototipos(j,:))/(dataBase(i,:)-pPrototipos(p,:))]^(2/(M-1));
      endfor
      u(i,j) = 1/den;
      den=0;
    endfor
  endfor
endfunction
dataBase = load('C:/Users/06377250185/ruspini.m', 'r');
dataBase
