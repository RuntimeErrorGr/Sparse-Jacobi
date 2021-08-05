function [A, b] = generate_probabilities_system(rows)
  nodes = (rows * (rows + 1)) / 2;                # nr. total noduri
  A = eye(nodes);
  for i = 1:(nodes - rows)                        # prima parte a lui b
    b(i) = 0;
  endfor
  for i = (nodes - rows + 1) : nodes              # a doua parte a lui b
    b(i) = 1;
  endfor
  b = b';
  A(1, 1) = 4;                                    # col. nodurilor din varfuri                        
  A(1, 2:3) = -1;   
  A(2:3, 1) = -1;
  A(nodes, nodes) = 4;                            # nodul nodes
  A(nodes - (rows - 1), nodes - (rows - 1)) = 4;  # nodul nodes - (rows - 1)
  A(nodes - (rows - 1) + 1, nodes - (rows - 1)) = -1;
  A(nodes - (rows -1), nodes - (rows - 1) + 1) = -1;
  k = 2;                                          # col. nodurilor din contur
  i = 2;                                           
  lines = 1;
  while k <= nodes - rows - (rows - 3)            # conturul stanga
   A(k, k) = 5;
   A(k, k+1) = -1;
   A(k+1, k) = -1;
   if k >= 4
    q = 1;
    while(q < lines)                              # nodurile interioare
     A(k + q, k + q) = 6;
     A(k + q + 1, k + q) = -1;
     A(k + q, k + q + 1) = -1;
     A(k + q + lines + 1 : k + q + lines + 2, k + q) = -1;
     A(k + q, k + q + lines + 1 : k + q + lines + 2) = -1;
     q++;
    endwhile
   endif
   A(k, k + i : k + i + 1) = -1; 
   A(k + i : k + i + 1, k) = -1;   
   k += i;
   i++;
   lines++;
  endwhile
  k = 3;
  i = 3;
  while k <= nodes - rows                         # conturul dreapta
   A(k, k) = 5;
   A(k, k + i - 1 : k + i) = -1;
   A(k + i - 1 : k + i, k) = -1;
   k += i;
   i++;
  endwhile
  k = nodes - rows + 2;
  while k <= nodes - 1                            # conturul jos
   A(k, k) = 5;
   A(k+1, k) = -1;
   A(k, k+1) = -1;
   k++;
  endwhile
endfunction