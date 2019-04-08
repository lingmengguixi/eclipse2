%% @author Administrator
%% @doc @todo Add description to server.


-module(server).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).
-include("head.hrl").


%% ====================================================================
%% Internal functions
%% ====================================================================


start()->
   case gen_tcp:listen(?PORT, [binary,{packet,4},{reuseaddr,true},{active,true}]) of
		{ok,Listen}-> io:format("I:start listen...~n"),
					  loop_listen(Listen);
		{error,eaddrinuse}->io:format("the illegal port!~n");
        Other->io:format("E:cannot run:~p~n",[Other])
  end.

loop_listen(Listen)->
   try gen_tcp:accept(Listen) of
		{ok,Socket}->
			UserServer=spawn(fun()->server_process_init(Socket) end),
			gen_tcp:controlling_process(Socket, UserServer),   %设置为新的进程接管Socket的消息
			loop_listen(Listen);
        Other->io:format("E:cannot run:~p~n",[Other])
   catch
        A:B-> io:format("E:fail to accpet new User!~n~p:~p~n",[A,B])
   end.

server_process_init(Socket)->
    server_process(Socket).


server_process(Socket)->
	 receive
         {tcp,Socket,Bin}->
			  io:format("~p~n",[Bin]),
		      server_process(Socket);
	     {tcp_closed,Socket}->
			  ok;
		 X->
			 io:format("X:~p~n",[X]),
			 server_process(Socket)
     end.

