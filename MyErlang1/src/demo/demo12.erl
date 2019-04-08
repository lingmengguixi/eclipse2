%% @author Administrator
%% @doc @todo Add description to demo12.

%% 分裂的进程为系统进程，与主进程连接,分裂的进程会收到主进程退出的消息，反之没有
-module(demo12).

%% ====================================================================
%% API functions
%% ====================================================================
-export([main/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================

loop()->
	receive
		re->io:format("receive~n");
		X->io:format("over:~p~n",[X])
	end.

erun()->
	1/0.
	
main()->
  Pid1=spawn_link(fun()-> process_flag(trap_exit,true),loop() end),
  io:format("pid:~p  link pid:~p~n",[self(),Pid1]),
  exit(normal1).