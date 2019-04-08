%% @author Administrator
%% @doc @todo Add description to gen_event_deal1.


-module(gen_event_deal1).
-behaviour(gen_event).
%% ====================================================================
%% API functions
%% ====================================================================
-export([init/1,terminate/2,handle_event/2,handle_info/2,handle_call/2,code_change/3]).



%% ====================================================================
%% Internal functions
%% ====================================================================

%% 事件处理器添加时候调用的函数
init(InitArgs)->
	io:format("add event deal[~p]! InitArgs:~p~n",[?MODULE,InitArgs]),
	{ok,{status,InitArgs}}.

%% 事件处理器移除的时候调用的函数
terminate(Args,Status)->
    io:format("remove event deal[~p]! status:~p~ncause:~p~n",[?MODULE,Status,Args]),
    Status.

%% 事件处理器的主体,与gen_event的notify有关
handle_event(Event,Status)->
   io:format("event[~p]:do....~n",[?MODULE]),
   io:format("event:~p Status:~p~n",[Event,Status]),
   io:format("result:~p~n",[Event(10)]),
   {ok,Status}.

handle_info(Info, Status)->
   io:format("Info:~p  Status:~p~n",[Info,Status]),
   {ok,Status}.

%% handle_call/2
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_event.html#Module:handle_call-2">gen_event:handle_call/2</a>
-spec handle_call(Request :: term(), State :: term()) -> Result when
	Result :: {ok, Reply, NewState}
			| {ok, Reply, NewState, hibernate}
			| {swap_handler, Reply, Args1, NewState, Handler2, Args2}
			| {remove_handler, Reply},
	Reply :: term(),
	NewState :: term(), Args1 :: term(), Args2 :: term(),
	Handler2 :: Module2 | {Module2, Id :: term()},
	Module2 :: atom().
%% ====================================================================
handle_call(Request, State) ->
    Reply = ok,
    {ok, Reply, State}.


%% code_change/3
%% ====================================================================
%% @doc <a href="http://www.erlang.org/doc/man/gen_event.html#Module:code_change-3">gen_event:code_change/3</a>
-spec code_change(OldVsn, State :: term(), Extra :: term()) -> {ok, NewState :: term()} when
	OldVsn :: Vsn | {down, Vsn},
	Vsn :: term().
%% ====================================================================
code_change(OldVsn, State, Extra) ->
    {ok, State}.

