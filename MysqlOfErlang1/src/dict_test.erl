%% @author Administrator
%% @doc @todo Add description to dict_test.


-module(dict_test).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).
-include("head.hrl").



%% ====================================================================
%% Internal functions
%% ====================================================================

%% 测试字典的读写
t(N)->
  Dict=dict:new(),
  put(dd,Dict),
  F1 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            R = #row{row1=D, row2=D, row3=D, row4=D, row5=D, row6=D, row7=D, row8=D, row9=D},
            Dict1=get(dd),
			Dict2=dict:store(_I, R, Dict1),
			put(dd,Dict2)
			
    end,
  F2 = fun(_I)->
			Dict1=get(dd),
            Id = ptester:rand(1, N),
			{ok,_}=dict:find(Id, Dict1)
	end,
  ptester:run(N, [
			 {"dict store", F1}
            ,{"dict  find", F2}
        ]
    ).

%% 测试字典大数据
%% N为数据量
%% M为数据值数量
t(digit_test,N,M)->
  Dict_digit=dict:new(),
  Dict=dict:new(),
  F1 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
			dict:store(_I, lists:duplicate(M, D), Dict_digit)
  end,
  F2 = fun(_I)->
            Id = ptester:rand(1, N),
			dict:find(Id,Dict_digit)
  end,
  F3 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
			dict:store(_I, lists:duplicate(9, D), Dict)
  end,
  F4 = fun(_I)->
            Id = ptester:rand(1, N),
			dict:find(Id, Dict)
  end,
  io:format("test the process dict:~n"),
  ptester:run(N, [
             {"big digit to store", F1}
            ,{"big digit to find", F2}
            ,{"no  digit to store", F3}
            ,{"no  digit to find", F4}
        ]
    ).