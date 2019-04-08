%% @author Administrator
%% @doc @todo Add description to list_test.


-module(list_test).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).



%% ====================================================================
%% Internal functions
%% ====================================================================

%% list的合并
merge(L,Data,1)->
	[[1|Data]|L];
merge(L,Data,N)->
	[[N|Data]|merge(L,Data,N-1)].

%% lists的分裂
separate([K|T])->
	K.

%% 测试大数据性能
%% M:数据值量大小
t(digit_test,N,M) ->
    Data=lists:duplicate(M, 1000),
	%% _N:代表有_N个元素进行合并(写入)
    F = fun(_N)->
			fun (_I)->
                merge([],Data,_N)
			 end
        end,
    io:format("test the list:~n"),
    ptester:run(1, [
             {erlang:integer_to_list(10000)++" to merge", F(10000)}
		    ,{erlang:integer_to_list(100000)++" to merge", F(100000)}

        ]
    ).
