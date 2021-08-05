function [G_J, c_J] = Jacobi_factorization(A, b)
  D = diag(diag(A));  # matricea diagonala
  N = D;      
  U = triu(A) - D;    # matricea superior triunghiulata
  L = tril(A) - D;    # matricea inferior triunghiulata
  P = -L - U;
  inv_N = inv(N);     # inversa matricei diagonale
  G_J = inv_N * P;    # matricea de iteratie
  c_J = inv_N * b;    # vector de iteratie
endfunction
