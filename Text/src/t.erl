%% @author Administrator
%% @doc @todo Add description to t.


-module(t).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).



%% ====================================================================
%% Internal functions
%% ====================================================================

f1([])-> 
	[];
f1([[]|T])->
	f1(T);
f1([[X1|X2]|T])->
	[X1|f1([X2|T])].

f2(T)->
	T1=erlang:list_to_binary(T),
	erlang:binary_to_list(T1).

main(N)->
	L=lists:duplicate(N, "ads"),
	F1=fun(_X)-> f2(L),
				 X1=get(processes),
				 X2=erlang:memory(processes),
				 put(processes,X2),
				 X=X2-X1,
				 io:format("~p~n",[X])
	   end,
   ptester:run(1, [
	  {"run1",F1}
	  ,{"run2",F1}				
   ]).

t1(F,T)->
  F(T).


t()->
	A=get(a),
	put(a,2),
	put(a,undefined),
	B=get(a),
	if
		A=:=undefined->io:format("A:ok");
		true->io:format("A:false[~p]~n",[A])
	end,
	if
		B=:=undefined->io:format("B:ok");
		true->io:format("B:false[~p]~n",[A])
	end.

-record(user, {
        id      	 %% 用户ID
        ,name   	 %% 用户名称
        ,passwd="123456" 	 %% 用户登录密码
        ,login_times=0 %% 登录次数
        ,chat_times=0  %% 聊天次数
        ,last_login=null  %% 最后一次登录时间
    }
).

sendEmails(_,[])->
	ok;
sendEmails(Pid,[X|T])->
    Pid!X,
	sendEmails(Pid,T).

t2()->
	sendEmails(11,[]).

