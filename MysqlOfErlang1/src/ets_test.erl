%% @author Administrator
%% @doc @todo Add description to ets_test.


-module(ets_test).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).
-include("head.hrl").


%% ====================================================================
%% Internal functions
%% ====================================================================

init()->
    ets:new(ets_test_table, [named_table, protected, set]),
	ets:new(ets_test_table_digit, [named_table, protected, set]),
	ok.

%% 比较ETS的lookup和match查询效率
t(N)->
	ets:delete_all_objects(ets_test_table),
    F1 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            R = #row{row1=D, row2=D, row3=D, row4=D, row5=D, row6=D, row7=D, row8=D, row9=D},
            ets:insert(ets_test_table, {_I, R})
    end,
    F2 = fun(_I)->
            Id = ptester:rand(1, N),
            ets:lookup(ets_test_table, Id)
    end,
    F3 = fun(_I)->
            Id = ptester:rand(1, N),
            [_]=ets:match(ets_test_table, {Id, '$1'})
    end,
    F4 = fun(_I)->
            Id = ptester:rand(1, N),
            [_]=ets:select(ets_test_table, [{{Id,#row{row1='$1',row2='$2',row3='$3',row4='$4',row5='$5',row6='$6',row7='$7',row8='$8',row9='$9'}}, [], ['$$']}])
    end,
    ptester:run(N, [
			 {"insert", F1}
            ,{"lookup", F2}
            ,{" match", F3}
		    ,{"select", F4}
        ]
    ).

%% 测试索引的搜索的影响
t(index_test,N)->
  ets:delete_all_objects(ets_test_table),
  F1 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            R = #row{row1=D, row2=D, row3=D, row4=D, row5=D, row6=_I, row7=D, row8=D, row9=D},
            ets:insert(ets_test_table, {_I, R})
   end,
  ptester:for(1, N, F1),
  F2 = fun(_I)->
            Id = ptester:rand(1, N),
            [_]=ets:match(ets_test_table, {Id, '$1'})
  end,
  F3 = fun(_I)->
			%% 这里的ID非关键字
            Id = ptester:rand(1, N),
            [_]=ets:match(ets_test_table, {'$1', #row{row1='$2',row2='$3',row3='$4',row4='$5',row5='$6',row6=Id,row7='$7',row8='$8',row9='$9'}})
   end,
  F4 = fun(_I)->
            Id = ptester:rand(1, N),
            [_]=ets:select(ets_test_table, [{{Id,#row{row1='$1',row2='$2',row3='$3',row4='$4',row5='$5',row6='$6',row7='$7',row8='$8',row9='$9'}}, [], ['$$']}])  
  end,
  F5 = fun(_I)->
			%% 这里的ID非关键字
            Id = ptester:rand(1, N),
            [_]=ets:select(ets_test_table, [{{'$1',#row{row1='$2',row2='$3',row3='$4',row4='$5',row5='$6',row6=Id,row7='$7',row8='$8',row9='$9'}}, [], ['$$']}])  
  end,
   ptester:run(N, [
			 {"use id when  match", F2}
            ,{"no  id when  match", F3}
		    ,{"use id when select", F4}
		    ,{"no  id when select", F5}
        ]
    ).


%% 测试ets大数据
%% N为数据量
%% M为数据值数量
t(digit_test,N,M)->
  ets:delete_all_objects(ets_test_table),
  ets:delete_all_objects(ets_test_table_digit),
  F1 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            ets:insert(ets_test_table_digit, erlang:list_to_tuple([_I|lists:duplicate(M, D)]))
  end,
  F2 = fun(_I)->
            Id = ptester:rand(1, N),
            ets:lookup(ets_test_table_digit, Id)
  end,
  F3 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            ets:insert(ets_test_table, erlang:list_to_tuple([_I|lists:duplicate(9, D)]))
  end,
  F4 = fun(_I)->
            Id = ptester:rand(1, N),
            ets:lookup(ets_test_table, Id)
  end,
  io:format("test the ets:~n"),
  ptester:run(N, [
             {"big digit to insert", F1}
            ,{"big digit to lookup", F2}
            ,{"no  digit to insert", F3}
            ,{"no  digit to lookup", F4}
        ]
    ).