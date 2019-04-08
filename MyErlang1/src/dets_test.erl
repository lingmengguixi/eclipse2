%% @author Administrator
%% @doc @todo Add description to dets_test.


-module(dets_test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([open/1,close/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================


open(File)->
   io:format("dets opened:~p~n",[File]),
   Bool=filelib:is_file(File),
   case dets:open_file(?MODULE,[{file,File}]) of
	   {ok,?MODULE}->
		   case Bool of
			   true->void;
			   false->ok=dets:insert(?MODULE, {free,1})
		   end;
	   {error,Reason}->
		   io:format("cannot open dets tables~N"),
		   exit({eDetsOpen,File,Reason})
   end.
close()->dets:close(?MODULE).

