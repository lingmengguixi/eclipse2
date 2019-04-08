%% @author Administrator
%% @doc @todo Add description to client1.


-module(client1).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================


start()->
   {ok,Socket}=gen_tcp:connect("127.0.0.1", 6000, [binary,{packet,4}]),
   loop_talk(Socket).

loop_talk(Socket)->
	io:format("Enter the message to send!~n"),
	{ok,Message}=io:read("message:"),
	io:format("send message:~p~n",[Message]),
	gen_tcp:send(Socket,term_to_binary(Message)),
    loop_talk(Socket).

