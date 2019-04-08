%% @author Administrator
%% @doc @todo Add description to server.


-module(server).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).
-define(PORT,5656).
-define(PEOPLENUM,2).

%% ====================================================================
%% Internal functions
%% ====================================================================


start()->
   	Pid=whereis(?MODULE),
	case Pid of
		undefined->
            register(?MODULE, self());
	    Pid->
            exit({'the server had run with the pid:',Pid})
    end,
	case gen_tcp:listen(?PORT, [binary,{packet,0},{reuseaddr,true},{active,true}]) of
		{ok,Listen}-> io:format("I:start listen game...~n"),
					  listen_process_init(Listen);
		{error,eaddrinuse}->io:format("the illegal port!~n");
        Other->io:format("E:cannot run:~p~n",[Other])
	end.

listen_process_init(Listen)->
	put(num,0),
	listen_process(Listen).

listen_process(Listen)->
    try gen_tcp:accept(Listen) of
		{ok,Socket}->
			Number=get(num),
			NumberNew=(Number+1) rem ?PEOPLENUM,
			put(num,NumberNew),
			put({id,Number+1},Socket),
			io:format("Number is :~p~n",[NumberNew]),
            if
				NumberNew =:= 0->
					Socket1=get({id,1}),
					Socket2=get({id,2}),
					Pid=spawn(fun()->startOne(Socket1,Socket2) end),
					gen_tcp:controlling_process(Socket1, Pid), 
					gen_tcp:controlling_process(Socket2, Pid);
				true->ok
            end,
			listen_process(Listen);
        Other->io:format("E:cannot run:~p~n",[Other])
    catch
        A:B-> io:format("E:fail to accpet new User!~n~p:~p~n",[A,B])
    end.

appendList(Dict,[])->
	Dict;
appendList(Dict, [{Key,Value}|T])->
	Dict1=dict:append(Key,Value,Dict),appendList(Dict1, T).

nextRW()->
	Width=600,
	Rectangle_width=75,
	random:uniform(Width-Rectangle_width+1) - 1.


startOne(Socket1,Socket2)->
	RandSeed = erlang:now(),
    random:seed(RandSeed),
	Width=600,
	Height=500,
	Circle_R=10,
	Rectangle_width=75,
	Rectangle_height=20,
    Dict=appendList(dict:new(),[{{retangle,Index},{nextRW()*1000,(80*Index+200)*1000}}||Index<-lists:seq(1, 20)]),
	Fun1=fun(Index)->
			X=dict:find({retangle,Index}, Dict),
			{ok,[{W,H}]}=X,
			binary_to_list(<<(Index+100):8,W:32,H:32>>) end,
	X=[Fun1(Index)||Index<-lists:seq(1, 20)],
	{ok,[{W1,H1}]}=dict:find({retangle,1}, Dict),
	CW1=W1+Rectangle_width*500,
	CH1=H1-Circle_R*1000,
	io:format("~p ~p~n",[CW1,CH1]),
	X1=[<<201:8,CW1:32,CH1:32>>,<<202:8,CW1:32,CH1:32>>|X],
    gen_tcp:send(Socket1,list_to_binary(X1)),
	gen_tcp:send(Socket2,list_to_binary(X1)),
    gen_tcp:send(Socket1,<<210:8>>),
	gen_tcp:send(Socket2,<<210:8>>).