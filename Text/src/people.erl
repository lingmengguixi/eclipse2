%% @author Administrator
%% @doc @todo Add description to people.


-module(people).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================


do()->
	R=receive
		{add,X,Y}->X + Y;
		{mul,X,Y}->X * Y;
		{more,N,Elemt}->lists:duplicate(N, Elemt);
		live->yes;
	    _-> ok
    end,
	io:format("~p~n",[R]),
    do().

start()->
   spawn(fun()-> do() end).