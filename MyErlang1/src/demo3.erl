%% @author Administrator
%% @doc @todo Add description to demo3.
%% P372实验 26.4


-module(demo3).

%% ====================================================================
%% API functions
%% ====================================================================
-export([main/0,ptests/1]).



%% ====================================================================
%% Internal functions
%% ====================================================================

randomList(0)->
	[];
randomList(N)->
  [rand:uniform(100000)|randomList(N-1)].

randomData(0,_)->
	[];
randomData(N,M)->
	[randomList(M)|randomData(N-1,M)].

%% 顺序运算
test1(Data,F)->
	lists:map(F, Data).
%% 并行运算
test2(Data,F)->
	S=self(),
	Ref=erlang:make_ref(),
	lists:foreach(fun(I) -> spawn(fun()->test2_do(I,Ref,S,F) end) end, Data),
	gather(erlang:length(Data),Ref).

test2_do(I,Ref,S,F)->
	S!{Ref,F(I)}.

gather(0,_)->
	[];
gather(N,Ref)->
	receive
		{Ref,Ret}->[Ret|gather(N-1,Ref)]
	end.

%% 斐波拉数列
ptests(0)->
	1;
ptests(1)->
	1;
ptests(N)->
	ptests(N-2)+ptests(N-1).

main()->
  Data1=randomData(100,1000),
  Data2=lists:duplicate(100, 27),
  io:format("start~n"),
  {T1,_}=timer:tc(fun test1/2,[Data1,fun lists:sort/1]),
  {T2,_}=timer:tc(fun test2/2,[Data1,fun lists:sort/1]),
  {T3,_}=timer:tc(fun test1/2,[Data2,fun ptests/1]),
  {T4,_}=timer:tc(fun test2/2,[Data2,fun ptests/1]),
  io:format("test1:~p~ntest2:~p~n", [T1,T2]),
  io:format("test3:~p~ntest4:~p~n", [T3,T4]).

