%% @author Administrator
%% @doc @todo Add description to chatClient.


-module(chatClient).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).
-include("head.hrl").
%% ====================================================================
%% Internal functions
%% ====================================================================
-define(RECEIVEPROCESS,receiveProcess).
-define(CONSOLEPROCESS,consoleProcess).


start()->
   connectNet().

connectNet()->
   case gen_tcp:connect(?HOST, ?PORT, [binary,{packet,4}]) of
	    {ok,Socket}->
			io:format("find the server ok!~n"),
			Pid=self(),
			UserReceive=spawn_link(fun()->startRecive(Socket) end),
			put(receiveProcess,UserReceive),
			register(?RECEIVEPROCESS,UserReceive),
			register(?CONSOLEPROCESS,self()),
			gen_tcp:controlling_process(Socket, UserReceive), 
			command(Socket);
	    Args->io:format("cannot connect the network!~ncause:~p~n",[Args])
   end.

%% 指令进程
command(Socket)->
	Command=io:get_line('>'),
	RePid=get(receiveProcess),
	receive
		{'EXIT',RePid,Why}->
			io:format("exit:~p~n",[Why]);
        {email,Message}->
			showMessage(Message)
	after 0->
		case Command of
			 "login\n" ->
				    Id=readIntegreLineWithoutLineFlag('user id:'),
					Password=readLineWithoutLineFlag('user password:'),
					gen_tcp:send(Socket, term_to_binary({login,Id,Password})),
					receive 
						{login_result,{ok,[Name,Login_times,Chat_times,Last_login]}}->
							io:format("\rI:login success!hi,~p   the last login time:~p~n",[Name,time2Lists(calendar:now_to_local_time(Last_login))]),
							io:format("login times:~p~n",[Login_times]),
							io:format("chat times:~p~n",[Chat_times]);
						{login_result,{false,Why}}->
							io:format("login false:~p~n",[Why])
					after 6000->
						    io:format("E:time out!the server not response~n")
					end,command(Socket);
			 "logout\n" ->
				    gen_tcp:send(Socket, term_to_binary({logout})),
					receive
						{logout_result,Msg}->
							io:format("I:~p~n",[Msg])
					after 6000->
						  io:format("E:time out!the server not response~n")
					end,
					command(Socket);
			 "who\n"->who,command(Socket);
			 "to\n"->
				    ?RECEIVEPROCESS!{writing},
					case getSendToWho(Socket) of
						 false->io:format("false to check the id!~n");
						 [Id|Name]->io:format("check ok:~p~n",[Name]),
							  Message=getWriteMessage([]),
				              gen_tcp:send(Socket, term_to_binary({to,Id,Message}));
                          In->io:format("error to input:~p~n",[In])
					end,
					receive 
						{toResult,ok,Why}->
							io:format("sucess:~p~n",[Why]);
						{toResult,false,Why}->
							io:format("  fail:~p~n",[Why])
					after 6000->
						io:format("  fail:~p~n",["time out"])
					end,
					?RECEIVEPROCESS!{writed},
			        command(Socket);
			 "exit\n"->
				    exit;
			  "\n"->
				  command(Socket);
			  "help\n"-> io:format("the command list:~n"),
				  io:format("command:login~n"),
				  io:format("        use the id and password to login~n"),
				  io:format("command:logout~n"),
				  io:format("        if you had login,it will logout!~n"),
				  io:format("command:exit~n"),
				  io:format("        exit the client!~n"),
				  io:format("command:to~n"),
				  io:format("        write a message and send it to who you want chat with~n"),
				  io:format("command:look~n"),
				  io:format("        to see the mail if anyone send to you!if had any one,you can open and read it!~n"),
				  command(Socket);
			  _->io:format("please use the command [help] to get the help~n"),
				  command(Socket)
		end
	end.
	
showMessage({msg,FromId,_ToId,text,Message})->
     io:format("\~n~p from id:~p~n",[time2Lists(calendar:local_time()),FromId]),
     io:format("~p~n",[Message]);
showMessage(Message)->
	 io:format("E:Invalid Message to receive!~n"),
	 io:format("Message:~p~n",[Message]).

time2Lists({{Year,Month,Day},{H,M,S}})->
	 combineOfLists([integer_to_list(Year),"-",integer_to_list(Month),"-",integer_to_list(Day),"  ",integer_to_list(H),":",integer_to_list(M),":",integer_to_list(S)]).

combineOfLists([])->
	[];
combineOfLists([[]|T])->
	combineOfLists(T);
combineOfLists([[X1|X2]|T])->
	[X1|combineOfLists([X2|T])].

getWriteMessage(Temp)->
	S=io:get_line(':'),
	case S of
		".\n"->combineOfLists(lists:reverse(Temp));
		_->getWriteMessage([S|Temp])
	end.

getSendToWho(Socket)->
	Id=readIntegreLineWithoutLineFlag('to Id:'),
	Ref=erlang:make_ref(),
	gen_tcp:send(Socket, term_to_binary({who,Ref,Id})),
	receive
		{who,Ref,ok,Name}->
           [Id|Name];
		{who,Ref,false}->
		   false
	after 6000->
		false
	end.

%% 接收服务端消息的进程
startRecive(Socket)->
	receive
		{tcp,Socket,List}->
			Msg=erlang:binary_to_term(List),
			case Msg of
				{login_result,_}->
					?CONSOLEPROCESS!Msg;
				{logout_result,_}->
					?CONSOLEPROCESS!Msg;
				{email,Message}->
					case get(writeStatus) of
						true->
							?CONSOLEPROCESS!{email,Message};
						false->
							showMessage(Message);
						undefined->
							put(writeStatus,false),
							showMessage(Message)
					 end;
				{who,Ref,false}->
					?CONSOLEPROCESS!Msg;
				{who,Ref,ok,_}->
					?CONSOLEPROCESS!Msg;
				{toResult,_,Why}->
					?CONSOLEPROCESS!Msg;
				{repeat_closed}->
			         io:format("I:You login on other client!you can try to relogin again~n");
				Msg->io:format("from server:~p~n",[Msg])
			end,
			startRecive(Socket);
		{tcp_closed,Socket}->
			io:format("I:the connect closed!~n"),
			exit("connect close");		
		{writing}->
			put(writeStatus,true),
			startRecive(Socket);
		{writed}->
			put(writeStatus,false),
			startRecive(Socket)
	end.

%% 从控制台获取字符串，该字符串没有换行标志符
readLineWithoutLineFlag(Tip)->
   S=io:get_line(Tip),
   [$\n|S1]=lists:reverse(S),
   lists:reverse(S1).   

%% 从控制台获取一行数字
readIntegreLineWithoutLineFlag(Tip)->
	String=readLineWithoutLineFlag(Tip),
    try erlang:list_to_integer(String) of
        Int ->Int
    catch
        A:B->
        error
    end.
    