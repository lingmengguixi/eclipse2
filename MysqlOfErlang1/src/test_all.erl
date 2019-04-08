%% @author Administrator
%% @doc @todo Add description to test_all.


-module(test_all).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).



%% ====================================================================
%% Internal functions
%% ====================================================================

t()->
  N=1000000,
  io:format("test ets between insert and all find of read:~n"),
  ets_test:init(),
  ets_test:t(N),
  io:format("test process dict between put and get:~n"),
  dict_pro_test:t(N),
  io:format("test dict between store and find:~n"),
  dict_test:t(N),
  io:format("test mysql between innodb and memory:~n"),
  mysql_test:init(),
  mysql_test:t(N/10).

t1()->
  mysql_test:init(),
  digit_test:init(10).
  
