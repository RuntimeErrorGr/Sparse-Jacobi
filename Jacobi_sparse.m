function [x] = Jacobi_sparse(G_values, G_colind, G_rowptr, c, tol)
  prev_x =  rand(1, length(c));
  while 1
    x = csr_multiplication(G_values, G_colind, G_rowptr, prev_x) + c;
    err = norm(x - prev_x);
    if err < tol
      return;
    endif
    prev_x = x;
  endwhile
endfunction