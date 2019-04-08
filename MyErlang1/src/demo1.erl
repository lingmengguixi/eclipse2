%% @author Administrator
%% @doc @todo Add description to demo1.


-module(demo1).

%% ====================================================================
%% API functions
%% ====================================================================
-export([main/0,rpc/2]).



%% ====================================================================
%% Internal functions
%% ====================================================================

rpc(Pid,Q)->
	Pid!{self(),Q},
	receive
		{Pid}->Pid
	end.
 
loop()->
	receive
		{From,Q}->
			io:format("the request is ~p~n",[Q]),
			From!{self()+1}
	end,
	loop().

start()->
	spawn(fun()->loop() end).

main()->
   start().