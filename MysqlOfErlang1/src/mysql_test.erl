%% @author Administrator
%% @doc @todo Add description to innodb_memory.


-module(mysql_test).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

-define(DB_HOST, "localhost").
-define(DB_PORT, 3306).
-define(DB_USER, "root").
-define(DB_PASS, "1254677754").
-define(DB_NAME, "mydb").

%% ====================================================================
%% Internal functions
%% ====================================================================




%% 初始化表
init()->
   mysql:start_link(p1, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, fun(_, _, _, _) -> ok end,"utf8"),
   mysql:connect(p1, ?DB_HOST, undefined, ?DB_USER, ?DB_PASS, ?DB_NAME, true),
   mysql:fetch(p1, <<"drop table if exists test_InnoDB">>),
   mysql:fetch(p1, <<"create table test_InnoDB (id int not null auto_increment,row1 int not null, row2 int not null,row3 int not null,row4 int not null,row5 int not null,row6 int not null,row7 int not null,row8 int not null,row9 int not null, primary key (id)) engine = InnoDB">>),
   mysql:fetch(p1, <<"drop table if exists test_memory">>),
   mysql:fetch(p1, <<"create table test_memory (id int not null auto_increment,row1 int not null, row2 int not null,row3 int not null,row4 int not null,row5 int not null,row6 int not null,row7 int not null,row8 int not null,row9 int not null, primary key (id)) engine = memory">>),
   ok.

%% 测试innodb和memory引擎的读写
t(N) ->
    mysql:fetch(p1, <<"delete from test_InnoDB">>),
    mysql:fetch(p1, <<"delete from test_memory">>),
    F1 = fun(_I) ->
			D_int = ptester:rand(1, 100000) + _I,
			D=integer_to_list(D_int),
             mysql:fetch(p1, list_to_binary(["insert into test_InnoDB values(",integer_to_list(_I),",",D,",",D,",",D,",",D,",",D,",",D,",",D,",",D,",",D,")"]))
    end,
    F2 = fun(_I) ->
            D_int = ptester:rand(1, 100000) + _I,
			D=integer_to_list(D_int),
            mysql:fetch(p1, list_to_binary(["insert into test_memory values(",integer_to_list(_I),",",D,",",D,",",D,",",D,",",D,",",D,",",D,",",D,",",D,")"]))
    end,
    F3 = fun(_I) ->
            ID_int = ptester:rand(1, N),
			ID=integer_to_list(ID_int),
            {data, _}=mysql:fetch(p1, list_to_binary(["select * from test_InnoDB where id=",ID]))
    end,
    F4 = fun(_I) ->
            ID_int = ptester:rand(1, N),
			ID=integer_to_list(ID_int),
            {data,_}=mysql:fetch(p1, list_to_binary(["select * from test_memory where id=",ID]))
    end,
    F5 = fun(_I) ->
            ID_int = ptester:rand(1, N),
			ID=integer_to_list(ID_int),
			D_int = ptester:rand(1, 100000) + _I,
			D=integer_to_list(D_int),
            mysql:fetch(p1, list_to_binary(["update test_InnoDB set row1=",D," where id=",ID]))
   end,
    F6 = fun(_I) ->
            ID_int = ptester:rand(1, N),
			ID=integer_to_list(ID_int),
			D_int = ptester:rand(1, 100000) + _I,
			D=integer_to_list(D_int),
            mysql:fetch(p1, list_to_binary(["update test_memory set row1=",D," where id=",ID]))
   end,
    ptester:run(N, [
             {"InnoDB write(insert)", F1}
            ,{"memory write(insert)", F2}
		    ,{"InnoDB  read(random)",F3}
		    ,{"memory  read(random)",F4}
		    ,{"InnoDB write(update)",F5}
		    ,{"memory write(update)",F6}
        ]
    ).


%% 测试mysql中包含主键和不包含主键的读取速度对比
t(index_test,N)->
    mysql:fetch(p1, <<"delete from test_memory">>),
    F1 = fun(_I) ->
            D_int = ptester:rand(1, 100000) + _I,
			D=integer_to_list(D_int),
            Id=integer_to_list(_I),
            mysql:fetch(p1, list_to_binary(["insert into test_memory values(",Id,",",D,",",D,",",D,",",D,",",D,",",Id,",",D,",",D,",",D,")"]))
    end,
    ptester:for(1, N, F1),

    F2 = fun(_I) ->
            ID_int = ptester:rand(1, N),
			ID=integer_to_list(ID_int),
            {data,_}=mysql:fetch(p1, list_to_binary(["select * from test_memory where id=",ID]))
    end,
    F3 = fun(_I) ->
            ID_int = ptester:rand(1, N),
			ID=integer_to_list(ID_int),
            {data,_}=mysql:fetch(p1, list_to_binary(["select * from test_memory where row6=",ID]))
    end, 
    ptester:run(N, [
             {"use id when select", F2}
            ,{"no  id when select", F3}
        ]
    ).
%% 测试mysql大数据
%% N为定义的大数据的数据量
t1(N)->
	 mysql:fetch(p1, <<"delete from test_memory">>),
	F = fun(_I)->
            D_int = ptester:rand(1, 100000) + _I,
			D=integer_to_list(D_int),
            Id=integer_to_list(_I),
			X=["insert into test_memory values(",Id,lists_to_one(repeatList([],1,9,fun(_)->lists_to_one([",",D]) end))++");"],
			lists_to_one(X)
		end,
	Command1=repeatList("",1,N,F),
	F1 = fun(_I) ->
				% io:format("~p~n",[Command1])
                  CC=list_to_binary(Command1),
			     X=mysql:fetch(p1,CC),
				 io:format("~p~n~p~n",[CC,X])
		 end,
	ptester:run(1,[{"big digit to insert", F1}]).
%%     ptester:run(N, [
%%              {"big digit to insert", F1}
%%             ,{"big digit to select", F2}
%%             ,{"no  digit to insert", F3}
%%             ,{"no  digit to select", F4}
%%         ]
%%     ).


%% 重复的字符串段，即某一个重复的字符串只有中间的一段不同，其余相同
repeatList(Arg_before,Max,Max,F)->
   lists:reverse([F(Max)|Arg_before]);
repeatList(Arg_before,I,Max,F)->
   repeatList([F(I)|Arg_before],I+1,Max,F).

lists_to_one([])->
	[];
lists_to_one([[]|T])->
	lists_to_one(T);
lists_to_one([[X1|X2]|T])->
	[X1|lists_to_one([X2|T])].

aa()->
  mysql:fetch(p1,<<"insert into test_memory values(2,71923,71923,71923,71923,71923,71923,71923,71923,71923);">>).
