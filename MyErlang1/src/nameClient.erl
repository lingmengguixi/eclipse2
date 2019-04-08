%% @author Administrator
%% @doc @todo Add description to nameClient.


-module(nameClient).

%% ====================================================================
%% API functions
%% ====================================================================
-export([store/2,lookup/1,link/0,count/0]).
-define(NODE,'server@PC-20190227BMSJ').
-define(ServerG,'server@PC-20190227BMSJ').

%% ====================================================================
%% Internal functions
%% ====================================================================




link()->
	net_kernel:connect_node(?NODE).

store(Key,Value)->
	Ref=make_ref(),
	{nameServer,?NODE}!{self(),store,Ref,Key,Value},
	receive
		{Ref,Result}->
	      io:format("the result:~p~n",[Result])
	after 6000->
	io:format("no any reply!~n")
	end.

lookup(Key)->
	Ref=make_ref(),
	{nameServer,?NODE}!{self(),lookup,Ref,Key},
	receive
		{Ref,Result}->
	      io:format("the result:~p~n",[Result])
	after 6000->
	io:format("no any reply!~n")
	end.

count()->
	Ref=make_ref(),
	{nameServer,?NODE}!{self(),count,Ref},
	receive
		{Ref,Result}->
	      io:format("the result:~p~n",[Result])
	after 6000->
	io:format("no any reply!~n")
	end.