%% @author Administrator
%% @doc @todo Add description to socket_examples.


-module(socket_examples).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_nano_server/0,nano_client_eval/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================


start_nano_server()->
   {ok,Listen}=gen_tcp:listen(6000, [binary,{packet,4},{reuseaddr,true},{active,true}]),
   {ok,Socket}=gen_tcp:accept(Listen),
   gen_tcp:close(Listen),
   loop(Socket).

loop(Socket)->
	receive
		  {tcp,Socket,Bin}->
			  io:format("Server received binary=~p~n",[Bin]),
			  Str=erlang:binary_to_term(Bin),
			  io:format("server (unpacked) ~p~n",[Str]),
			  Reply=lists:reverse(Str),
			  io:format("Server replying = ~p~n",[Reply]),
			  gen_tcp:send(Socket,term_to_binary(Reply));
	      {tcp_closed,Socket}->
              io:format("Server socket closed~n")
    end,
    loop(Socket).

nano_client_eval(Str)->
   {ok,Socket}=gen_tcp:connect("localhost", 6000, [binary,{packet,4}]),
   ok=gen_tcp:send(Socket, erlang:term_to_binary(Str)),
   receive
	   {tcp,Socket,Bin}->
		   io:format("Clinent receive binary = ~p~n",[Bin]),
		   Val=binary_to_term(Bin),
		   io:format("Client result = ~p~n",[Val]),
		   gen_tcp:close(Socket)
   end.


	