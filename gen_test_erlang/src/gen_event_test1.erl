%% @author Administrator
%% @doc @todo Add description to gen_event_test1.


-module(gen_event_test1).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start_link/0,stop/0,lookup/0,add/0,delete/0,do/0,add_sup/0]).

-define(NAME,eventManageName).
-define(DEFALUTDEAL,gen_event_deal1).

%% ====================================================================
%% gen event functions for export
%% ====================================================================
-export([]).

%% ====================================================================
%% Internal functions
%% ====================================================================


start_link()->
	%%  创建一个事件管理器
    io:format("event manage run!~n"),
	gen_event:start_link({local,?NAME}).  

stop()->
	%% 停用一个事件管理器
    gen_event:stop(?NAME).

%% 添加一个事件处理器,默认为gen_event_deal1
add()->
    gen_event:add_handler(?NAME, ?DEFALUTDEAL,1).

%% 添加一个事件处理器
add_sup()->
    gen_event:add_sup_handler(?NAME,?DEFALUTDEAL,2).

%% 添加一个事件处理器
add(EventDeal)->
    gen_event:add_handler(?NAME, EventDeal,1).

%% 添加一个事件处理器
add_sup(EventDeal)->
    gen_event:add_sup_handler(?NAME, EventDeal,2).

%% 删除事件处理器
delete()->
    gen_event:delete_handler(?NAME,?DEFALUTDEAL, 1000).

%% 删除事件处理器
delete(EventDeal)->
    gen_event:delete_handler(?NAME,EventDeal, 1).

%% 查看有事件处理器
lookup()->
    S=gen_event:which_handlers(?NAME),
    io:format("event deal:~p~n",[S]),
	S.

%% 触发事件处理器
do()->
  1/0,
  gen_event:notify(?NAME,fun(X) ->2*X end).

