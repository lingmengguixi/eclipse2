







%% @author Administrator
%% @doc @todo Add description to nameServer.


-module(nameServer).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0,store/2,lookup/1,stop/0,init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2,code_change/3,store_noreply/2]).
-define(SERVER,myserver).
-define(SERVERG,'myserver@PC-20190227BMSJ').
-behaviour(gen_server).


%% ====================================================================
%% Internal functions
%% ====================================================================


start()->
   process_flag(trap_exit, true),
   {ok,Pid}=gen_server:start_link({global,?SERVERG}, ?MODULE, [],[]),
   io:format("the main process pid:~p~n",[self()]),
   io:format("the gen_server pid:~p~n",[Pid]),
   register(?MODULE, Pid).

stop()->gen_server:call(?SERVERG, stop).

store(Key,Value)->gen_server:call(?SERVERG, {store,Key,Value}).

store_noreply(Key,Value)->gen_server:cast(?SERVERG, {store,Key,Value}).

lookup(Key)->gen_server:call(?SERVERG, {lookup,Key}).

count()->gen_server:call(?SERVERG, count).
	
init([])->put(store,0),put(lookup,0),{ok,#{}}.

handle_call(count,_From,Tab)->Reply={{set_count,get(store)},{get_count,get(lookup)}},{reply,Reply,Tab};
handle_call(stop,_From,Tab)->{stop,normal,{ok,stopped},Tab};
handle_call({store,Key,Value},_From,Tab)->
	case Tab of
		#{Key:=P}->
			Reply={ok,P},
			Tab1=Tab#{Key:=Value};
		_->Reply={ok,undefined},
		   Tab1=Tab#{Key=>Value}
	end,
	{reply,Reply,Tab1};
handle_call({lookup,Key},{Server,Ref}=_From,Tab)->
	case Tab of
		#{Key:=P}->
			Reply={ok,P};
		_->Reply={ok,undefined}
	end,
	C=get(lookup),
	put(lookup,C+1),
	{reply,Reply,Tab}.

handle_cast({store,Key,Value},Tab)->
	case Tab of
		#{Key:=P}->
			Reply={ok,P},
			Tab1=Tab#{Key:=Value};
		_->Reply={ok,undefined},
		   Tab1=Tab#{Key=>Value}
	end,
	C=get(store),
	put(store,C+1),
	{noreply,Tab1}.


handle_info({From,store,Ref,Key,Value},Tab)->
	case Tab of
		#{Key:=P}->
			Reply={ok,P},
			Tab1=Tab#{Key:=Value};
		_->Reply={ok,undefined},
		   Tab1=Tab#{Key=>Value}
	end,
	C=get(store),
	put(store,C+1),
	From!{Ref,Reply},
	{noreply,Tab1};
handle_info({From,lookup,Ref,Key},Tab)->
	case Tab of
		#{Key:=P}->
			Reply={ok,P};
		_->Reply={ok,undefined}
	end,
	C=get(lookup),
	put(lookup,C+1),
	From!{Ref,Reply},
	{noreply,Tab};
handle_info({From,count,Ref},Tab)->
	From!{Ref,{{set_count,get(store)},{get_count,get(lookup)}}},
	{noreply,Tab};
handle_info(_Info,Tab)->
	io:format("info:~p~n",[_Info]),
	{noreply,Tab}.

terminate(_Reason,Tab)->
	io:format("the server closed!~n"),
	io:format("resean:~p~n",[_Reason]),
	ok.

code_change(_OldVsn,Tab,Extra)->
	io:format("the code change!~n"),
	{ok,Tab}.

