
1) generate_probabilities_system:
	Pentru a obtine sistemul de ecuatii reprezentat de matricea A si vectorul b
am initializat o matrice de dimensiuni corespunzatoare numarului de noduri si am
impartit labirintul in 4 zone de noduri in functie de regula de completare
a coloanelor corespunzatoare fiecarui nod din matricea A: 
- zona nodurilor din varfuri
- zona nodurilor de pe conturul stang + nodurile interioare
- zona nodurilor de pe conturul drept
- zona conturului de jos
	Am observat ca nodurilor din varfuri le sunt corespunzatoare pe diagonala
principala valorile 4, nodurilor din contur stanga si contur dreapta valorile 5
si nodurilor interioare valorile 6.
	Pentru cele 3 noduri din varfuri am facut completarea liniilor respectiv 
coloanelor pentru fiecare nod in parte: nodul 1 de sus, nodul de la baza din 
dreapta si nodul de la baza din stanga.
	Pentru toate celelalte zone am folosit cate o bucla while in care iterez
pana la indicele ultimului nod corespunzator zonei curente si completez 
matricea cu elementul corespunzator diagonalei principale (5 - pt zonele de 
contur sau 6 pentru zona de interior) apoi de la elementul diagonalei principale
completez in jos si in dreapta(in forma de L intors) cu valorile -1 pe pozitiile
corespunzatoare. Pozitiile valorilor -1 urmeaza de asemenea si ele un pattern
asa ca am folosit variabile de tip contor pentru a numara dupa cate pozitii 
de la elementul diagonalei principale vor fi plasate valorile -1.
De asemenea, un labirint contine o zona a nodurilor de interior daca numarul
liniilor din labirint este >= 4 asa ca se intra pe bucla de completare specifica
zonei de interior numai dupa ce s-a ajuns la linia 4 si bineinteles, daca linia
4 nu este ultima (in cazul in care linia 4 este ultima, nodurile intra sub 
incidenta regulilor de completare pentru contur jos).
Regulile de completare pe care le-am considerat pentru fiecare zona sunt:
- zona nodurilor din varfuri:
	- nodul 1: 4 pe diagonala principala, 2 valori -1 la dreapta respectiv in jos;
	- nodul nodes (dreapta jos): 4 pe diagonala principala;
	- nodul nodes - (rows-1) (stanga jos): 4 pe diagonala principala, cate o 
	valoare de -1 la dreapta respectiv in jos;
- zona nodurilor contur stang: 5 pe diagonala principala si intotdeauna 3 valori
de -1. Pozitiile valorilor -1 se modifica odata nu linia pe care se afla nodul,
asa ca dupa completarea cu valori -1 de ordin 1 se lasa i zerouri pana la
urmatoarea grupare de valori -1, unde i = 0 : nr. noduri din zona;
- zona nodurilor interioare: 6 pe diagonala principala si 3 valori -1; 
si in acest caz pozitiile valorilor -1 variaza asemanator celor de la zona contur
stanga;
- zona nodurilor contur dreapta: 5 pe diagonala principala, apoi se lasa cate
i zerouri pana la o grupare de 2 valori -1, unde i = 1 : nr. noduri din zona;
- zona contur jos: 5 pe diagonala principala, apoi cate o valoare -1 imediat
pe pozitiile urmatoare dreapta respectiv jos.
	Vectorul b se completeaza de la nodes - rows cu valori 0 si de la 
nodes - rows + 1 la nodes cu valori 1.

2) matrix_to_csr:
	Pentru a duce o matrice in forma ei CSR am construit pe rand cei 3 vectori 
specificati in enunt: 
	Pentru vectorul de valori nenule am aflat initial indecsii acestor valori din 
matrice cu ajutorul functiei find() apoi am extras elementele de la indecsii
respectivi si i-am plasat in vector.
	Pentru vectorul de indici de coloane m-am folosit de vectorul indecsilor
elementelor din matrice. Pentru a afla un indice de coloana am facut operatia
mod(index_element, nr_coloane). Daca elementul curent nenul se afla pe o pozitie 
multiplu al numarului de coloane, atunci in vectorul colind se introduce o 
valoare egala cu numarul de coloane, altfel se introduce restul impartirii 
indexului de pozitie al elementului in matrice la numarul de coloane.  
	Pentru vectorul rowptr am parcurs intreaga matrice si am folosit o variabila
ok care imi indica daca elementul curent este sau nu primul element nenul de 
pe linia curenta. In cazul in care inca nu a fost gasit primul element nenul de 
pe linia curenta, se parcurge vectorul de valori nenule si in momentul in care
a fost gasit elementul curent, indexul acestuia din vectorul de valori nenule
este trecut in rowptr. De asemenea, odata ce primul element nenul a fost gasit,
chiar daca mai exista elemente nenule pe linia curenta, trebuie sa sarim peste
ele si indecsii acestora nu vor aparea in rowptr. Pentru a numara peste cate 
elemente trebuie sa sar (daca este cazul) am folosit o variabila
jumps. In acest fel cautarea in vectorul values va incepe mereu de la 1 + jumps,
evitand astfel situatia in care daca am elemente duplicat in matrice care pe o
linie sa zicem ca nu respecta conditia de a nu fi primul element nenul, dar 
pe alta linie respecta aceasta conditie, in vectorul rowptr sa fie trecut 
indexul gresit. La finalul lui rowptr se adauga numarul total de elemente 
nenule din patrice + 1.  

3) jacobi_factorization: 
	Pentru a obtine matricea de iteratie si vectorul de iteratie se fac 
operatiile specifice algoritmului Jacobi: se obtine matricea diagonala, matricea
superior triunghiulata, matricea inferior triunghiulata, matricea diferenta, 
inversa matricei diagonale. Matricea de iteratie se obtine ca produs intre
inversa matricei diagonale si matricea diferenta P = -L-U. Vectorul de iteratie
se obtine ca produs intre inversa matricei diagonale si vectorul b.

4) jacobi_sparse: 
	Se intializeaza un vector in care se tin valorile solutie corespunzatoare
interatiei anterioare.
Cat timp eroarea generata de solutiile de la iteratia curenta este mai mare decat
toleranta se initializeaza vectorul solutie cu suma dintre
vectorul de iteratie si vectorul produs intre matricea (trecuta din forma CSR
in forma densa) de iteratie si vectorul de solutii anterioare. Daca eroarea 
devine mai mica decat toleranta se iese din program si se returneaza vectorul
ce reprezinta solutia sistemului.
