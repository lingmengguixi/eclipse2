%%----------------------------------------------------
%% Mnesia和Mysql的内存表性能比较
%% 
%% @author yeahoo2000@gmail.com
%%----------------------------------------------------
-module(mnesia_mysql).
-compile(export_all).

-define(DB_HOST, "localhost").
-define(DB_PORT, 3306).
-define(DB_USER, "root").
-define(DB_PASS, "1254677754").
-define(DB_NAME, "mydb").

-record(tab_test, {id, row1=123456789, row2=123456789}).
 
%% 初始化
init() ->
    mysql:start_link(p1, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, fun(_, _, _, _) -> ok end),
%%    mysql:connect(p1, ?DB_HOST, undefined, ?DB_USER, ?DB_PASS, ?DB_NAME, true),
    mysql:connect(p1, ?DB_HOST, undefined, ?DB_USER, ?DB_PASS, ?DB_NAME, true),
    mysql:fetch(p1, <<"drop table if exists mnesia_mysql">>),
    mysql:fetch(p1, <<"create table mnesia_mysql (id int not null auto_increment,row1 int not null, row2 int not null, primary key (id)) engine = memory">>),

    mnesia:start(),
    mnesia:create_table(tab_test, [{attributes, record_info(fields, tab_test)}]),
    ok.

%% 测试
t(N) ->
    F1 = fun(I) ->
            mnesia:dirty_write(#tab_test{id=I})
    end,
    F2 = fun(_I) ->
            mysql:fetch(p1, <<"insert into mnesia_mysql(row1, row2) values(123456789, 123456789)">>)
    end,
    ptester:run(N, [
            {"mnesia(memory) write", F1}
            ,{"mysql(memory) write", F2}
        ]
    ).
