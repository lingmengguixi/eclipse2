%% @author Administrator
%% @doc @todo Add description to 'Test'.


-module('test').

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).
-include("head.hrl").



%% ====================================================================
%% Internal functions
%% ====================================================================


start()->
   connectNet().

connectNet()->
   case gen_tcp:connect(?HOST, ?PORT, [binary,{packet,4}]) of
	    {ok,Socket}->
			io:format("find the server ok!~n"),
			send(Socket);
	    Args->io:format("cannot connect the network!~ncause:~p~n",[Args])
   end.

send(Socket)->
   gen_tcp:send(Socket, term_to_binary([1,2,3])),
   gen_tcp:close(Socket).
	