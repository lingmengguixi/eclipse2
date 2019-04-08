%% @author Administrator
%% @doc @todo Add description to test.


-module(test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([t/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================


t()->
   io:format("shell pid:~p~n",[self()]),
   {ok,Pid}=ch_sup:start_link(),
   io:format("process info~p~n",[erlang:process_info(Pid)]),
   gen_event_test1:add(),
   gen_event_test1:add_sup(),
   io:format("ch sup pid:~p~n",[Pid]),
   io:format("event pid:~p~n",[whereis(eventManageName)]),
   gen_event_test1:lookup(),
   io:format("server pid:~p~n",[whereis(ch3)]),
   
   io:format("start to stop the event and server~n"),
   gen_event_test1:stop(),
   ch3:stop(),
   io:format("shell pid:~p~n",[self()]),
   io:format("event pid:~p~n",[whereis(eventManageName)]),
   gen_event_test1:lookup(),
   io:format("server pid:~p~n",[whereis(ch3)]),
   io:format("process info~p~n",[erlang:process_info(Pid)]).

