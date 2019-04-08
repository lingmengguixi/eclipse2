%% @author Administrator
%% @doc @todo Add description to demo1.


-module(demo11).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0,stop/0,rpc/2]).



%% ====================================================================
%% Internal functions
%% ====================================================================


start()->
   Pid=spawn(fun()->loop() end),
   erlang:register(?MODULE, Pid),
   io:format("server pid:~p~n",[Pid]).

loop()->
  receive
    {data1,Message}->
       io:format("message of data1:~p~n",[Message]);
    {data2,Message}->
       io:format("message of data2:~p~n",[Message]);
    closed->exit(0)
  end,
  loop().

rpc(data1,Msg)->
   ?MODULE!{data1,Msg};
rpc(data2,Msg)->
   ?MODULE!{data2,Msg}.

stop()->
  ?MODULE!closed.


