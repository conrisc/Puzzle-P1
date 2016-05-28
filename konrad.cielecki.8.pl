%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	                                 %%
%%	 Konrad Cielecki(273278)         %%
%%	 Zadanie nr 8 (Lamigowka A,B,C)  %%
%%					 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Predykat rozwiazujacy zagadke
%% solve(+M,+N,+LETTER,+LIST,?RESULT).
solve(M,N,LETTER,LIST,RESULT):-
	apl(ALPHABET,LETTER,['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','W','X','Y','Z']),
	create(M,N,RESULT),
	putt(1,LIST,RESULT),
	fill(RESULT,ALPHABET,SPR),
	check_column(0,N,RESULT,ALPHABET,SPR2),
	one(SPR,SPR2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Tworzy liste(RESULT) liter A-LETTER z listy liter A-Z (ALPHABET)
%% apl(?RESULT,+LETTER,+ALPHABET).
apl([H|RESULT],LETTER,[H|LIST]):-
	H\=LETTER,
	apl(RESULT,LETTER,LIST).
apl([H],H,[H|_]):-
	!.


%% Tworzy pusta tablice M x N
%% create(+M,+N,?RESULT).
create(0,_,[]).
create(M,N,[H|LIST]):-
	M > 0,
	c_row(N,H),
	T is M-1,
	create(T,N,LIST).

%% Tworzy pusty wiersz o dlugosci N
%% c_row(+N,?ROW).
c_row(0,[]).
c_row(N,[_|LIST]):-
	N>0,
	T is N-1,
	c_row(T,LIST).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Wypelnia pusta tablice(TAB) podanymi literami(LIST)
%% putt(+M,+LIST,?TAB).
putt(_,_,[]).
putt(N,LIST,[H|TAB]):-
	p_row(N,1,LIST,H),
	T is N+1,
	putt(T,LIST,TAB).

%% Wypelnia konkretny wiersz(ROW) literami z zadania(LIST)
%% M - wiersz, N - kolumna
%% p_row(+M,+N,+LIST,?ROW).
p_row(_,_,_,[]).
p_row(M,N,LIST,[H|TAB]):-
	letter(M,N,LIST,H),
	T is N+1,
	p_row(M,T,LIST,TAB).

%% Predykat wklada odpowiednia litere z LIST na pozycje (M,N)
%% (o ile zostala podana litera dla tej pozycji)
%% letter(+M,+N,+LIST,?ELEM).
letter(_,_,[],_).
letter(M,N,[(M,N,L)|_],L):-
	!.
letter(M,N,[_|REST],H):-
	letter(M,N,REST,H).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Predykat wypelniajacy tablice wynikowa metoda brute-force
%% RESULT - wynikowa wypelniona tabilca
%% ALPHABET - lista liter, ktorymi zostanie wypelniona tablica
%% SPR - lista list tworzonych przez predykat count(...).
%% fill(?RESULT,+ALPHABET,-SPR).
fill([],_,[]).
fill([R|TAB],ALPHABET,[KEY|SPR]):-
	f_row(R,ALPHABET),             %Wypelnia wiersz
	count(KEY,R,ALPHABET),	       %Zlicza wystapienie liter w utworzonym wierszu
	check_key(KEY),                %Sprawdza czy wszystkie litery wystepuja tyle samo razy
	fill(TAB,ALPHABET,SPR).        %Przechodzi do wypelniania kolejnego wiersza

%% Wypelnia pusty wiersz literami z ALPHABET
%% f_row(+ROW,+ALPHABET).
f_row([],_).
f_row([H|TAIL],ALPHABET):-
	l(H,ALPHABET),
	f_row(TAIL,ALPHABET).

%% Wybiera kolejna litere z listy ALPHABET
%% l(?LETTER,+ALPHABET).
l(H,[H|_]).
l(H,[_|TAIL]):-
	l(H,TAIL).

%% Tworzy liste(KEY) wystapien kolejnych liter(ALPHABET) w wierszu ROW
%% Nie wpisuje do listy wynikowej wystapien = 0
%% count(?KEY,+ROW,+APLHABET).
count([],_,[]).
count([F|KEY],R,[H|TAIL]):-
	number(F,R,H),
	F>0,
	!,
	count(KEY,R,TAIL).
count(KEY,R,[_|TAIL]):-
	count(KEY,R,TAIL).

%% Liczy ilosc wystapien konkretnej litery (LETTER) w liscie ROW
%% number(?ILE,+ROW,+LETTER).
number(0,[],_):-
	!.
number(ILE,[LETTER|TAIL],LETTER):-
	!,
	number(T,TAIL,LETTER),
	ILE is T+1.
number(ILE,[_|TAIL],LETTER):-
	number(ILE,TAIL,LETTER).

%% Predykat wykorzystywany do sprawdzania czy wszystkie
%% litery w danym wierszu wystepuja tyle samo razy.
%% Sam predykat zwraca 'true' jesli wszystkie elementy podanej listy sa
%% takie same.
%% check_key(+TAB).
check_key([_]).
check_key([A,B|LIST]):-
	A==B,
	check_key([B|LIST]).

%% Predykat sprawdzajacy czy litery(ALPHABET) w kolejnych
%% kolumnach (od I do N) tablicy TAB wystepuja tyle samo razy
%% i zwracajacy liste SPR (lista list taka jak w przypadku predykatu
%% fill, lecz dla kolumn)
%% check_column(+I,+N,+TAB,+ALPHABET,-SPR).
check_column(N,N,_,_,[]).
check_column(I,N,TAB,ALPHABET,[KEY|SPR]):-
	I<N,
	column(I,TAB,COLUMN),
	count(KEY,COLUMN,ALPHABET),
	check_key(KEY),
	I2 is I+1,
	check_column(I2,N,TAB,ALPHABET,SPR).

%% Zamienia I-ta kolumne z tablicy TAB w liste RESULT
%% column(+I,+TAB,?RESULT).
column(_,[],[]).
column(N,[H1|TAB],[H2|RESULT]):-
	pull(N,H1,H2),
	column(N,TAB,RESULT).

%% Wyciaga I-ty element z wiersza ROW
%% pull(+I,+ROW,?ELEM).
pull(0,[H|_],H).
pull(N,[_|TAIL],LETTER):-
	N>0,
	T is N-1,
	pull(T,TAIL,LETTER).

%% Sprawdza czy ktoras z list (LIST, LIST2) zawiera singleton
%% Istota dla predykatu Solve(...):
%% sprawdza czy ktoras z list SPR lub SPR2 zawiera singleton,
%% jezeli tak oznacza to, ze ktorys wiersz badz kolumna jest wypelniona
%% jedna litera
%% one(+LIST,+LIST2).
one(LIST,LIST2):-
	singleton(LIST),
	!;
	singleton(LIST2).

%% True - jezeli podana lista zawiera singleton
%% singleton(?LIST).
singleton([[_]|_]):-
	!.
singleton([_|TAIL]):-
	singleton(TAIL).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%								      %%
%%       TESTY%%TESTY%%TESTY%%TESTY%%TESTY%%TESTY%%TESTY%%TESTY       %%
%%	                                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

student_simple_test(6, 6, 'G',[(1,1,'A'),(1,2,'C'),(1,4,'D'),(1,6,'D'),(2,1,'B'),(2,3,'D'),(2,5,'B'),(3,2,'C'),(3,3,'A'),(4,1,'F'),(4,5,'E'),(4,6,'D'),(5,2,'G'),(5,3,'D'),(5,6,'B'),(6,1,'B'),(6,2,'B'),(4,2,'G'),(6,6,'B'),(4,3,'B'),(3,5,'C'),(2,2,'B')],
[['A','C','A','D','C','D'],
['B','B','D','D','B','D'],
['A','C','A','B','C','B'],
['F','G','B','C','E','D'],
['F','G','D','C','E','B'],
['B','B','B','B','B','B']]).

student_simple_test(6, 4, 'C',[(3,1,'B'), (4,1,'A'), (1,2,'B'), (4,2,'C'), (1,3,'C'), (2,4,'A'),(5,3,'B')],
[['C','B','C','B'],
['A','A','A','A'],
['B','A','B','A'],
['A','C','A','C'],
['C','C','B','B'],
['B','B','C','C']]).

student_simple_test(2, 2, 'B',[(1,1,'A'),(2,1,'B')],
[['A', 'B'],
 ['B', 'B']]).


student_count_test(6,6,'G',[(1,1,'A'),(1,2,'C'),(1,4,'D'),(1,6,'D'),(2,1,'B'),(2,3,'D'),(2,5,'B'),(3,2,'C'),(3,3,'A'),(4,1,'F'),(4,5,'E'),(4,6,'D'),(5,2,'G'),(5,3,'D'),(5,6,'B'),(6,1,'B'),(6,2,'B'),(6,3,'B'),(6,4,'B'),(6,5,'B'),(4,2,'G'),(6,6,'B'),(4,3,'B'),(3,5,'C'),(2,2,'B'),(5,5,'E'),(5,1,'F')],2).

student_count_test(6, 4, 'C',[(3,1,'B'), (4,1,'A'), (1,2,'B'), (4,2,'C'), (1,3,'C'), (2,4,'A'),(5,3,'B')],49).

student_count_test(2,2,'B',[(1,1,'A'),(2,1,'B')],3).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       ?- check_solution.        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START TESTING
% simple_test [ok]
% simple_test [ok]
% student_simple_test [ok]
% student_simple_test [ok]
% student_simple_test [ok]
% count_test [ok]
% student_count_test [ok]
% student_count_test [ok]
% student_count_test [ok]
% DONE IN 2.8236180999999974s
% true.
