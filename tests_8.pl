%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tests for task 8, A, B, C
% VERSION: 0.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

taskArity(4). % 4 is the number of input arguments, solve has arity 5

testSimpleSolution(Correct, Result) :-
  Correct == Result.

simple_test(4, 4, 'C', [(3,1,'B'), (4,1,'A'), (1,2,'B'), (4,2,'C'), (1,3,'C'), (2,4,'A')],
[['B','B','C','C'],
['A','C','C','A'],
['B','B','C','C'],
['A','C','C','A']]).

simple_test(2, 6, 'D',
[(1,1,'C'),(1,2,'A'),(1,3,'B'),(1,4,'C'),
(2,1,'B'),(2,2,'B'),(2,3,'A'),(2,6,'D')],
[['C','A','B','C','A','B'],
['B','B','A','D','A','D']]).


count_test(2, 2, 'B', [(1,1,'A'),(2,2,'A')], 3).
