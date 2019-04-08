%% @author Administrator
%% @doc @todo Add description to dict_pro_test.


-module(dict_pro_test).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).
-include("head.hrl").



%% ====================================================================
%% Internal functions
%% ====================================================================

%% 测试进程字典读与写
t(N)->
    F1 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            R = #row{row1=D, row2=D, row3=D, row4=D, row5=D, row6=D, row7=D, row8=D, row9=D},
            put(_I,R)
    end,
    F2 = fun(_I)->
            Id = ptester:rand(1, N),
            get(Id)
    end,
    ptester:run(N, [
			 {"pro dict put", F1}
            ,{"pro dict get", F2}
        ]
    ).

%% 测试进程字典大数据
%% N为数据量
%% M为数据值数量
t(digit_test,N,M)->
  F1 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            put(_I,lists:duplicate(M, D))
  end,
  F2 = fun(_I)->
            Id = ptester:rand(1, N),
            get(Id)  
  end,
  F3 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            put(_I,lists:duplicate(9, D))
  end,
  F4 = fun(_I)->
            Id = ptester:rand(1, N),
            get(Id)  
  end,
  io:format("test the process dict:~n"),
  ptester:run(N, [
             {"big digit to put", F1}
            ,{"big digit to get", F2}
            ,{"no  digit to put", F3}
            ,{"no  digit to get", F4}
        ]
    ).