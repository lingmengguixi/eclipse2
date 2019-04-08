%% @author Administrator
%% @doc @todo Add description to fun_text.


-module(fun_test).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).



%% ====================================================================
%% Internal functions
%% ====================================================================

fun1([],T)->
   T;
fun1([X1|L],T)->
   fun1(L,[X1*2|T]).

fun2([])->
	[];
fun2([X1|L])->
	[X1*2|fun2(L)].

t(N)->
   L=lists:seq(1, N),
   F1=fun(_X)->fun1(L,[]) end,
   F2=fun(_X)->fun2(L) end,
   ptester:run(1, [
           {"fun1:",F1}
		  ,{"fun2:",F2}
        ]
    ).

addList([],T)->
    T;
addList([X1|X],T)->
    addList(X,[X1|T]).
%% 
%% addList(A,B,S)->
%%   lists:reverse(A),
%%   lists:reverse(B);
%%   lists:foreach(fun lists:reverse/1, A),
%%   lists:foreach(fun lists:reverse/1, B),
%%   addList(A,B,S);
%% addList([],[],_)->
%%    [];
%% addList([X1|A],B,0)->
%%    addList(X1,addList(A,B,1));
%% addList(A,[B1|B],1)->
%%    addList(B1,addList(A,B,0)).


re([],T)->
  T;
re([X1|X2],T)->
   re(X2,[X1|T]).
 
