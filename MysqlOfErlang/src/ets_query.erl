%%----------------------------------------------------
%% ETS两种查询方式的比较
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(ets_query).
-compile(export_all).

-record(struct, {row1, row2, row3, row4, row5, row6, row7, row8, row9}).

%% 新建一个ETS表
init(N)->
    ets:new(ets_test, [named_table, protected, set]),
    F = fun(I)->
            D = ptester:rand(1, 100000) + I,
            R = #struct{row1=D, row2=D, row3=D, row4=D, row5=D, row6=D, row7=D, row8=D, row9=D},
            ets:insert(ets_test, {I, R})
    end,
    ptester:for(1, N, F).

%% 比较ETS的lookup和match查询效率
t(N)->
    F1 = fun(_I)->
            Id = ptester:rand(1, N),
            ets:lookup(ets_test, Id)
    end,
    F2 = fun(_I)->
            Id = ptester:rand(1, N),
            ets:match(ets_test, {Id, '$1'})
    end,
    ptester:run(N, [
            {"lookup", F1}
            ,{"match", F2}
        ]
    ).

%% 结果:
%% 1> ets_query:init(10000000).
%% true
%% 2> ets_query:t(10000000).
%% "lookup" [total: 26800(26910)ms avg: 2.680(2.691)us]
%% "match" [total: 47612(47846)ms avg: 4.761(4.785)us]
%% ========================================================================
%%               lookup =  26800.00ms [  100.00%]  26910.00ms [  100.00%]
%%                match =  47612.00ms [  177.66%]  47846.00ms [  177.80%]
%% ========================================================================
