%% @author Administrator
%% @doc @todo Add description to ets.


-module(ets_test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================


start()->
	lists:foreach(fun test_ets/1, [set,ordered_set,bag,duplicate_bag]).

test_ets(Mode)->
	TableId=ets:new(test,[Mode]),
	ets:insert(TableId,{a,1}),
	ets:insert(TableId,{b,2}),
	ets:insert(TableId,{[a],1}),
	ets:insert(TableId,{a,3}),
	List=ets:tab2list(TableId),
	io:format("~-13w  =>  ~p~n",[Mode,List]),
    X=ets:lookup(TableId,b),
    io:format("~p~n",[X]),
    ets:delete(TableId).



