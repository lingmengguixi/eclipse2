%% @author Administrator
%% @doc @todo Add description to demo13.

%% 分裂一个进程，该进程主动与主进程连接，设置定时报错，主进程会收到一条错误消息。
-module(demo13).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0,erun/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================


%% 处理错误进程
on_exit(Pid,Fun)->
  spawn(fun()->
				Ref=link(Pid),
				receive
				  erun->io:format("aaaa"),
						1/0;
		          X->Fun(X)
				after 3000->
				  io:format("run the error~n"),
						1/0
                end
		end).

%% 处理错误函数
deal_error(X)->
   io:format("error:~p~n",[X]).

loop()->
	receive
	after 3000->
		io:format("time~n")
	end,
	loop().


erun()->
   1/0.

start()->
	process_flag(trap_exit,true),
	Pid1=self(),
	io:format("the main process pid:~p~n",[Pid1]),
    io:format("the spawn process pid:~p~n",[Pid2=on_exit(Pid1, fun deal_error/1)]),
	receive
		X->io:format("sss:~p~n",[X])
	end,
	{Pid1,Pid2}.
