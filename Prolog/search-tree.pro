/* -*- Mode:Prolog; coding:utf8; -*- */

/**************************************************************
 * Name: LVNCNT
 * Created: 18 Nov 2015 
 *
 * - Start sicstus in terminal 
 * - Load and Compile: ['feng.pro']. 
 * - Run Example 1: mytreeunique([[a,[b,c]],[a,[b,[c,d]]]], X).
 * - Output: X = [a,b,c,d]
 * - Run Example 2: mydepth([a,[b,[a,[c,d]]]],X). 
 * - Output: X = 8 
 *
 * 1) Given a Binary tree represented as a list, 
 * provide a UNIQUE list of leaves of the tree. 
 * mytreeunique([a,a], X). => X = [a]
 * mytreeunique([a,[b,[a,[c,d]]]],X). => X = [b,a,c,d]
 * mytreeunique([[a,[b,c]],[a,[b,[c,d]]]], X). => X = [a,b,c,d]
 **/ 
        
% is_list(L) 
% Given list L, return if it is a list 
% Rule #1: L is empty return true
% Rule #2: L is an atomic element return false
% Rule #3: list can be expressed as [|]
is_list([]). 
is_list(X) :- 
        var(X), !, 
        fail. 
is_list([_|T]) :- 
        is_list(T).

% remove_dups(L, X)
% remove duplicates from a list L, return result in X 
% Rule #4: L is empty, return empty list. 
% Rule #5: L's first element is contained in the rest of L, 
%          process the rest of L
% Rule #6: L's first element is not contained in the rest of L, 
%          kept L's first element in the result X 
remove_dups([], []).
remove_dups([L | R], X) :-
        member(L, R),
        remove_dups(R, X).
remove_dups([L | R], [L | X]) :-
        \+(member(L, R)),
        remove_dups(R, X).

% mytreeunique(L, X)
% Given a list L, which contains list, first flatten L,
% then remove duplicates in the flattened list 
% Rule #7: L is empty, return empty list
% Rule #8: comes down to single atomic element, return it as a list
% Rule #9: process the head and rest of L, 
%          combine the result together, then remove duplicates 

mytreeunique([], []). 
mytreeunique(X, [X]) :- \+ is_list(X). 
mytreeunique([L|R], X) :- 
        mytreeunique(L, LX), mytreeunique(R, RX), append(LX, RX, Y), remove_dups(Y, X). 

/**************************************************************
 * 2) Given a Binary tree, 
 * report the longest path from the root to a leaf.
 * mydepth([a,[b,[a,[c,d]]]],X) => X=8
 * mydepth([a,[b,c]], X) => X=4
 * mydepth([a,b], X) => 2
 **/ 

% my_max(X, Y, Z)
% Given two numbers X, Y, return the max one in Z 
% Rule #10: X > Y, max is X   
% Rule #11: otherwise, max is Y 
my_max(X, Y, Z) :- X > Y, Z = X. 
my_max(X, Y, Z) :- \+(X > Y), Z = Y.

% mydepth(L, X) 
% Given list L which contains lists, return the max depth in X  
% Rule #12: L is empty, return 0 
% Rule #13: L is an atomic element, return 0 
% Rule #14: process head and the rest of L separately, 
%           get the max of them.  
mydepth([],0).
mydepth(L, 0):-
        atomic(L).
mydepth([H|T],R):-mydepth(H,R1), mydepth(T,R2), my_max(R1,R2,R3), R is R3+1. 
