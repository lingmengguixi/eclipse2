%% @author Administrator
%% @doc @todo Add description to server1.


-module(server1).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================

start()->
   {ok,Listen}=gen_tcp:listen(6000, [binary,{packet,4},{reuseaddr,true},{active,true}]),
   io:format("the server start...~n"),
   ParentPid=self(),
   spawn(fun()->loop_listen(Listen,1,ParentPid) end),
   loop_main(#{count=>0}).

loop_main(Status)->
	receive
		{closed,T}->
			Status1=Status#{count:=maps:get(count,Status)-1},
			io:format("the client[~p] logout and now had ~p clients~n",[T,maps:get(count,Status1)]);
		{create,T}->
			Status1=Status#{count:=maps:get(count,Status)+1},
			io:format("new client[~p] login and now had ~p clients~n",[T,maps:get(count,Status1)])
	end,
	loop_main(Status1).

loop_listen(Listen,C,ParentPid)->
	{ok,Socket}=gen_tcp:accept(Listen),
	Pid=spawn(fun()->loop_talk(Socket,ParentPid) end),
	ParentPid!{create,Pid},
	gen_tcp:controlling_process(Socket, Pid),
    loop_listen(Listen,C+1,ParentPid).

loop_talk(Socket,ParentPid)->
	receive
		{tcp,Socket,Bin}->
            Str=erlang:binary_to_term(Bin),
			io:format("[~p]:get the message:[~w]~n",[self(),Str]),
			loop_talk(Socket,ParentPid);
		{tcp_closed,Socket}->
			io:format("Server socket closed~n"),
			gen_tcp:close(Socket),
			ParentPid!{closed,self()};
		P->io:format("what happen?~p~n",[P])
	end.