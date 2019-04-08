%% @author Administrator
%% @doc @todo Add description to 'ChatServer'.


-module('chatServer').

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).
-include("head.hrl").
%% 非使用通用服务器搭建的服务端
%% ====================================================================
%% Internal functions
%% ====================================================================

start()->
    init().

%% 初始化，启动必须的进程
init()->
	Pid=whereis(?CORE),
	case Pid of
		undefined->
			Pid0 = spawn(fun()->core_init() end),
			register(?CORE, Pid0),
			Pid1 = spawn(fun()->listen_process_init() end),
			register(?SERVER,Pid1),
			Pid2 = spawn(fun()->user_ets:ets_init() end),
			register(?ETS,Pid2),
		    Pid3 = spawn(fun()->msg_ets:ets_init() end),
            register(?MSG, Pid3);
	    Pid->
            exit({'the server had run with the pid:',Pid})
    end.
    

%% 管理不同用户的登陆和退出
listen_process_init()->
	?CORE!{add,self(),"listen process"},
    case gen_tcp:listen(?PORT, [binary,{packet,4},{reuseaddr,true},{active,true}]) of
		{ok,Listen}-> io:format("I:start listen...~n"),
					  listen_process(Listen);
		{error,eaddrinuse}->io:format("the illegal port!~n");
        Other->io:format("E:cannot run:~p~n",[Other])
	end.

%% 结束不同的客户端
listen_process(Listen)->
    try gen_tcp:accept(Listen) of
		{ok,Socket}->
			UserServer=spawn(fun()->server_process_init(Socket) end),
			gen_tcp:controlling_process(Socket, UserServer),   %设置为新的进程接管Socket的消息
			listen_process(Listen);
        Other->io:format("E:cannot run:~p~n",[Other])
    catch
        A:B-> io:format("E:fail to accpet new User!~n~p:~p~n",[A,B])
    end.
    
%% 服务单独一个用户进程
server_process_init(Socket)->
	Pid=self(),
	?CORE!{add,Pid,"user process"},
	?CORE!{user_connect,self(),"ee"},
	put(loginStatus,false),
    server_process(Socket).

%% 一个客户的进程		
server_process(Socket)->
   receive
      {tcp,Socket,Bin}->
          Msg=erlang:binary_to_term(Bin),
		  case Msg of
			  %% 客户登陆的处理逻辑
			  {login,Id,Password}->
				  LastStatus=get(loginStatus),
				  case LastStatus of
					  true->
						  Id1=get(id),
						  gen_tcp:send(Socket, erlang:term_to_binary({login_result,{false,"error you had login with id:["++erlang:integer_to_list(Id1)++"]"}}));
					  false->
						  Ref=erlang:make_ref(),
						  ?ETS!{checkPassword,self(),Ref,Id,Password},
						  receive
							  {Ref,{ok,Result}=R}->
								  io:format("I:login message:~p  ok~n",[Msg]),
								  put(loginStatus,true),
								  put(id,Id),
								  ?CORE!{user_login,self(),Id,"ee"},
								  %% io:format("hehe:~p~n",[{login_result,R}]),
                                  ?MSG!{emailPull,self(),Id},
								  gen_tcp:send(Socket, erlang:term_to_binary({login_result,R}));
							  {Ref,{false,Result}=R}->
								  io:format("I:login message:~p  false~n",[Msg]),
								  gen_tcp:send(Socket, erlang:term_to_binary({login_result,{false,"error password"}}))
					      after 6000->
							      io:format("I:login message:~p  false|time out~n",[Msg]),
		                          gen_tcp:send(Socket, erlang:term_to_binary({login_result,{false,"error time out"}}))
		                  end
				  end;
			  %% 客户退出处理的逻辑
			   {logout}->
				   LastStatus=get(loginStatus),
				   Id=get(id),
				   put(loginStatus,false),
				   case LastStatus of
					   false->gen_tcp:send(Socket, erlang:term_to_binary({logout_result,"Fail to logout!Because no login"}));
					   true->gen_tcp:send(Socket, erlang:term_to_binary({logout_result,"success to logout!"})),
							 ?CORE!{user_logout,self(),Id,"ee"}
				   end;
			   {to,DstId,Message}->
				   Ref=erlang:make_ref(),
				   LoginStatus=get(loginStatus),
				   case LoginStatus of
					   false->gen_tcp:send(Socket, erlang:term_to_binary({toResult,false,"no login!"}));
					   true->
							   ?MSG!{emailPush,self(),Ref,DstId,#msg{fromId=get(id),toId=DstId,chatMsg=Message}},
							   io:format("I:chat ~p  ->  ~p  with ~p~n",[get(id),DstId,Message]),
							   receive 
								   {ok,save}->gen_tcp:send(Socket, erlang:term_to_binary({toResult,ok,"success to commit!but who you send seems not to be online,we will send to man when online!~n"}));
								   {ok,sendTo}->gen_tcp:send(Socket, erlang:term_to_binary({toResult,ok,"success to send!~n"}));
								   {false,Why}->gen_tcp:send(Socket, erlang:term_to_binary({toResult,false,Why}))
							   after 6000->
								   gen_tcp:send(Socket, erlang:term_to_binary({toResult,false,"Busy the server!"}))
							   end
				   end;
			   {who,Ref,Id}->
				  ?ETS!{checkId,self(),Ref,Id},
				  receive
					  {Ref,{ok,Name}}->
						  gen_tcp:send(Socket, erlang:term_to_binary({who,Ref,ok,Name}));
					  {Ref,false}->
						  gen_tcp:send(Socket, erlang:term_to_binary({who,Ref,false}))
				  after 6000->
					      gen_tcp:send(Socket, erlang:term_to_binary({who,Ref,false}))
				  end;
			  %% 记录非法请求
		       Msg->
                   io:format("receive the message:~p~n",[Msg])			   
		   end,
		   server_process(Socket);
      {tcp_closed,Socket}->
          userProcessExist(get(loginStatus),self(),get(id));
      {repeat_closed}->
		  gen_tcp:send(Socket, erlang:term_to_binary({repeat_closed})),
		  put(loginStatus,false),
		  server_process(Socket);
	  {from,Email}->
		  gen_tcp:send(Socket, erlang:term_to_binary({email,Email})),
		  server_process(Socket)
   after 300000->
	      gen_tcp:close(Socket),
		  io:format("I:time out~n"),
		  userProcessExist(get(loginStatus),self(),get(id))
   end.

%% 用户进程退出操作
userProcessExist(LastStatus,Pid,Id)->
	?CORE!{user_disconnect,Pid,"the connect close"},
	case LastStatus of
		true->
			userQuit(Pid,Id);
		false->ok
    end.

%% 用户退出操作
userQuit(Pid,Id)->
	put(loginStatus,false),
	?CORE!{user_logout,Pid,Id,"ee"}.

%% core的初始化
core_init()->
	process_flag(trap_exit,true),
	io:format("I:start core[~p] process..~n",[self()]),
	put(connectNum,0),
    put(userNum,0),
	core().

%% 核心进程，负责处理错误的进程
core()->
	receive
		{add,Pid,Msg}->
			monitor(process,Pid),
			io:format("I:process ~p run:~p~n",[Pid,Msg]);
		{'DOWN',_,process,Pid,normal}->
			io:format("I:process[~p] normal exit~n",[Pid]);
	    {'DOWN',_,process,Pid,Why}->
            io:format("E:the process exist:~p~n",[Pid]),
			io:format("E:cause:~p~n",[Why]);
	    {user_disconnect,Pid,_Msg}->
            Num=get(connectNum),
			Num1=Num-1,
            put(connectNum,Num1),
			io:format("I:the user process[~p] disconnect net,online:~p~n",[Pid,Num1]);
		{user_connect,Pid,_Msg}->
            Num=get(connectNum),
			Num1=Num+1,
            put(connectNum,Num1),
			io:format("I:the user process[~p]    connect net,online:~p~n",[Pid,Num1]);
	    {user_login,Pid,Id,_Msg}->
			PreId=get({id,Id}),
			if PreId =/= undefined->PreId!{repeat_closed},
							put({id,Id},Pid),
							Num1=get(userNum),
							io:format("I:the user[~p] of process[~p] login, online:~p~n",[Id,Pid,Num1]);
			   true->Num=get(userNum),
			         Num1=Num+1,
                     put(userNum,Num1),
			         put({id,Id},Pid),
			         io:format("I:the user[~p] of process[~p] login, online:~p~n",[Id,Pid,Num1])
			end;

		{user_logout,Pid,Id,_Msg}->
            Num=get(userNum),
			Num1=Num-1,
            put(userNum,Num1),
			erase({id,Id}),
			io:format("I:the user[~p] of process[~p] logout,online:~p~n",[Id,Pid,Num1]);
		{lookupUser,Pid,Ref,Id}->
			Pid!{lookupUser,Ref,get({id,Id})}
    end,
	core().
