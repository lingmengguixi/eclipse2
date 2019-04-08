%% @author Administrator
%% @doc @todo Add description to pro.


-module(pro).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).



%% ====================================================================
%% Internal functions
%% ====================================================================

showByte(X)->
	if 
		X<1024->
          {X,byte};
		X<1024*1024->
		  {X/1024,kb};
		X<1024*1024*1024->
		  {X/(1024*1024),mb};
		X->
		   {[X/(1024*1024*1024)],gb};
	    true->
           unknown
	end.
memory()->
  [{Type,showByte(X)}||{Type,X}<-erlang:memory()].

memory(Pid)->
  erlang:process_info(Pid,memory).


