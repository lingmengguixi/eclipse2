%% @author Administrator
%% @doc @todo Add description to innodb_memory.


-module(innodb_memory).

%% ====================================================================
%% API functions
%% ====================================================================
-export([init/0]).

-define(DB_HOST, "localhost").
-define(DB_PORT, 3306).
-define(DB_USER, "root").
-define(DB_PASS, "1254677754").
-define(DB_NAME, "mydb").

%% ====================================================================
%% Internal functions
%% ====================================================================

%% 记录row
-record(row, {id,row1, row2, row3, row4, row5, row6, row7, row8, row9}).


%% 初始化表
init()->
   mysql:start_link(p1, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, fun(_, _, _, _) -> ok end),
   mysql:connect(p1, ?DB_HOST, undefined, ?DB_USER, ?DB_PASS, ?DB_NAME, true),
   mysql:fetch(p1, <<"drop table if exists test">>),
   mysql:fetch(p1, <<"create table test (id int not null auto_increment,row1 int not null, row2 int not null,row3 int not null,row4 int not null,row5 int not null,row6 int not null,row7 int not null,row8 int not null,row9 int not null, primary key (id)) engine = InnoDB">>),
   ok.

