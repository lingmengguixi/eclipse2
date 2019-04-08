%% @author Administrator
%% @doc @todo Add description to demo2.


-module(demo2).

%% ====================================================================
%% API functions
%% ====================================================================
-export([main/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================

run(X)->
	receive
	after 2000 ->
       io:format("wait:~ps~n",[(X+2000)/1000])
    end,
	run(X+2000).
main1()->
   spawn(fun()->run(0) end),
   io:read("to end:").

reverse1(L)->
	reverse1(L,[]).

reverse1([X|L],T)->
	reverse1(L,[X|T]);
reverse1([],T)->
	T.

forMore(M,M)->
	[M];
forMore(I,M)->
	[I|forMore(I+1,M)].

for([L1|L2])->
	2*L1,for(L2);
for([])->
	[].
main()->
   L=forMore(0,100000000),
   {T2,_}=timer:tc(fun for/1, [L]),
   T2/1000000.
