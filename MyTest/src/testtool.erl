%% @author Administrator
%% @doc @todo Add description to testtool.


-module(testtool).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).



%% ====================================================================
%% Internal functions
%% ====================================================================

result([])->
	[];
result([[Result|_]|T])->
	[Result|result(T)].

%% N次迭代运行不同函数的比较
run(N,List,Status)->
	io:format("test start...~n"),
    X=[[_,L, T1, T2] = H | T] = loop_run_time_test(List,Status,N),
	io:format("========================================================================~n"),
    io:format("~20s = ~9.2fms [~8.2f%] ~9.2fms [~8.2f%]~n", [L, T1 + 0.0, 100.0, T2 + 0.0, 100.0]),
    compare(T, H),
    io:format("========================================================================~n"),
	{result,result(X)}.

loop_run_time_test([],_Status,_)->
	[];
loop_run_time_test([{Label, F,Args}|T],Status,N)->
	X=[StatusNew|_]=time_test(Label, F, N,Args,Status),
	[X|loop_run_time_test(T,StatusNew,N)].


%% N次单独运行不同函数的比较
run(N,List)->
   	io:format("test start...~n"),
    [[L, T1, T2] = H | T] = [time_test(Label, F, N,Args) || {Label, F,Args} <- List],
	io:format("========================================================================~n"),
	io:format("~20s = ~9.2fms [~8.2f%] ~9.2fms [~8.2f%]~n", [L, T1 + 0.0, 100.0, T2 + 0.0, 100.0]),
	compare(T, H),
    io:format("========================================================================~n").

%% 运行单项测试并计时
time_test(Label, F, N,Args) ->
    statistics(runtime),
    statistics(wall_clock),
    for(1, N, F,Args),
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    U1 = Time1 * 1000 / N,
    U2 = Time2 * 1000 / N,
    io:format("~p [total: ~p(~p)ms avg: ~.3f(~.3f)us]~n", [Label, Time1, Time2, U1, U2]),
    [Label, Time1, Time2].

time_test(Label, F, N,Args,Status)->
    statistics(runtime),
    statistics(wall_clock),
    Result=for(1, N, F,Args,Status),
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    U1 = Time1 * 1000 / N,
    U2 = Time2 * 1000 / N,
    io:format("~p [total: ~p(~p)ms avg: ~.3f(~.3f)us]~n", [Label, Time1, Time2, U1, U2]),
    [Result,Label, Time1, Time2].


for(Max,Max,F,Args,Status)->
	apply(F,[Status,Max|Args]);
for(I,Max,F,Args,Status)->
	StatusNew=apply(F,[Status,I|Args]),
	for(I+1,Max,F,Args,StatusNew).
  
for(Max,Max,F,Args)->
   apply(F, Args);
for(I,Max,F,Args)->
   [apply(F, Args)|for(I+1,Max,F,Args)].

%% 比较结果
compare([], _) ->
    ok;
compare([[L, T1, T2] | T], [_, TB1, TB2] = TB) ->
    io:format("~20s = ~9.2fms [~8.2f\%] ~9.2fms [~8.2f\%]~n", [L, T1 + 0.0, T1 / (TB1 + 0.00000001) * 100, T2 + 0.0, T2 / (TB2 + 0.00000001) * 100]),
    compare(T, TB);
compare([[_,L, T1, T2] | T], [_,_, TB1, TB2] = TB) ->
    io:format("~20s = ~9.2fms [~8.2f\%] ~9.2fms [~8.2f\%]~n", [L, T1 + 0.0, T1 / (TB1 + 0.00000001) * 100, T2 + 0.0, T2 / (TB2 + 0.00000001) * 100]),
    compare(T, TB).