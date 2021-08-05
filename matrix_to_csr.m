function [values, colind, rowptr] = matrix_to_csr(A)
  [n, p] = size(A);                
  nz = rows(find(A));               # nr de valori nenule
  v = find(A');                     # vector indecsi valori nenule
  for i = 1: nz
    values(i) = A'(v(i));           # vector valori nenule
    if mod(v(i), p) != 0             
      colind(i) = mod(v(i),p);      # vector indici coloanelor elementelor nenl.
    else 
      colind(i) = p;
    endif
  endfor
  jumps = 0;                        # sar peste jumps elemente din values
  for i = 1 : n
    ok = 0;                         # verific daca este primul element al liniei
    for j = 1 : p
      if A(i,j) != 0 && ok == 0
        ok = 1;
        for k = 1 + jumps : nz
          if values(k) == A(i,j)
            rowptr(i) = k;
            break;
          endif
        endfor
        endif
       if A(i,j) != 0 && ok == 1    # daca nu este primul element nenul
        jumps ++;                   # incrementez nr. de sarituri
       endif
     endfor
    endfor 
  rowptr(n+1) = nz +1;              # ultimul element al vectorului
endfunction