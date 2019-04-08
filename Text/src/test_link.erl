%% @author Administrator
%% @doc @todo Add description to test_link.


-module(test_link).

%% ====================================================================
%% API functions
%% ====================================================================
-export([t/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================

error_1(Pid)->
	receive
		X->X
	after 3000->
		 exit("close")
	end.

loop()->
	io:get_line('>'),
	receive
		A->io:format("ass~p~n",[A])
    after 100->
		io:format("qw")
	end,loop().

t()->
	process_flag(trap_exit,false),
   Pid=self(),
   spawn_link(fun()->error_1(Pid) end),
   loop().

