%% @author Administrator
%% @doc @todo Add description to demo4.


-module(demo4).

%% ====================================================================
%% API functions
%% ====================================================================
-export([main/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================

f1(Pid,{Key,Value}=X)->
	Pid!X.
f2(_Key,Value,Count)->
	Count=Count+Value.

main()->
   Count=phofs:mapreduce(f1,f2,0,[{a,1},{b,2},{3,4},{w,3}]),
   Count.