%% @author Administrator
%% @doc @todo Add description to user.


-module(user_ets).

%% ====================================================================
%% API functions
%% ====================================================================
-export([ets_init/0]).
-include("head.hrl").


%% ====================================================================
%% Internal functions
%% ====================================================================

ets_init()->
	 ?CORE!{add,self(),"user ets process"},
	ets:new(?USERTABLE, [named_table, protected, set]),
	ets:insert(?USERTABLE, {1001,#user{id=1001,name="haha1"}}),
	ets:insert(?USERTABLE, {1002,#user{id=1002,name="haha2"}}),
    ets:insert(?USERTABLE, {1003,#user{id=1003,name="haha3"}}),
    ets:insert(?USERTABLE, {1004,#user{id=1004,name="haha4"}}),
    ets:insert(?USERTABLE, {1005,#user{id=1005,name="haha5",passwd="123456",login_times=0,chat_times=0,last_login=null}}),
	command().
	
%% 连接ets获得登录信息
checkPassword(Id,Password)->
    A=ets:match(?USERTABLE, {Id, #user{_='_',passwd=Password,name='$1',login_times='$2',chat_times='$3',last_login='$4'}}),
    case A of
        [[Name,Login_times,Chat_times,Last_login]=Msg]->
             ets:update_element(?USERTABLE, Id, {2,#user{id=Id,name=Name,login_times=Login_times+1,chat_times=Chat_times,last_login=os:timestamp()}}),
            {ok,Msg};
        []->{false,"the user no exist"};
        _->{false,A}
    end.

checkId(Id)->
	A=ets:lookup(?USERTABLE, Id),
	case A of
       []->false;
	   [{Id,{user,Id,Name,_,_,_,_}}]->{ok,Name};
	   _->false
   end.

command()->
   receive
	   {checkPassword,Pid,Ref,Id,Password}->
           Pid!{Ref,checkPassword(Id,Password)};
	   {checkId,Pid,Ref,Id}->
		   io:format("check Id[~p]:~p~n",[Id,{Ref,checkId(Id)}]),
		   Pid!{Ref,checkId(Id)};
	   {chatNumAdd,Id}->
		   [{Id,User}]=ets:lookup(?USERTABLE, Id),
		   UserNew=User#user{chat_times=User#user.chat_times+1},
		   ets:update_element(?USERTABLE,Id, {2,UserNew});
       A->
          io:format("E:ets receive the message:~p~n",[A]),false
   end,
   command().