%% @author Administrator
%% @doc @todo Add description to msg_ets.


-module(msg_ets).

%% ====================================================================
%% API functions
%% ====================================================================
-export([ets_init/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================

%% 该模块用于管理信息的存储，实现离线发送消息

-include("head.hrl").
ets_init()->
	?CORE!{add,self(),"msg ets process"},
	put(freeId,1),
	ets:new(?MSGTABLE, [named_table, protected, set]),
    command().

command()->
   receive
	   {emailPull,Pid,Id}->
           emailPull(Pid,Id);
	   {emailPush,Pid,Ref,DstId,Email}->
		   ?ETS!{checkId,self(),Ref,DstId},
		   receive
			   {Ref,false}->Pid!{false,"no exist the id."};
			   {Ref,{ok,_}}->Pid!emailPush(DstId,Email);
			   A->Pid!{false,"ssa"},
				  io:format("I:asas:~p~n",[A])
		   after 3000->
			   Pid!{false,"the busy ~p server.",[whereis(?ETS)]}
		   end;
	   {emailDelete,Pid,Ref,MsgId}->
		   emailDelete(MsgId);
       _->
          false
   end,
   command().

emailPull(Pid,Id)->
   Fun1=fun({MsgId,{FromId,ToId,ChatType,ChatMsg}}) when ToId=:=2->
			{msg,FromId,ToId,ChatType,ChatMsg}
	    end,
%%    io:format("~p~n",[PP]),
   Emails=ets:select(?MSGTABLE, [{{'$1',{msg,'$2','$3','$4','$5'}},[{'=:=','$3',Id}],[['$1',{{msg,'$2','$3','$4','$5'}}]]}]),
   sendEmails(Pid,Emails).

sendEmails(_,[])->
	ok;
sendEmails(Pid,[[MsgId,X]|T])->
    Pid!{from,X},
	ets:delete(?MSGTABLE, MsgId),
	sendEmails(Pid,T).
     

emailPush(DstId,Email)->
	io:format("I:hehe1~n"),
	Ref=make_ref(),
	?CORE!{lookupUser,self(),Ref,DstId},
	?ETS!{chatNumAdd,Email#msg.fromId},
	receive
		{lookupUser,Ref,undefined}->
			ets:insert(?MSGTABLE, {freeId(),Email}),
			{ok,save};
		{lookupUser,Ref,Pid}->
			io:format("I:send to process:~p~n",[Pid]),
			Pid!{from,Email},
			{ok,sendTo}
	after 6000->
		{false,"the busy server."}
	end.

emailDelete(MsgId)->
	ets:delete(?MSGTABLE, MsgId).

freeId()->
  Id=get(freeId),
  Id1=Id+1,
  put(freeId,Id1),
  Id.
