%% @author Administrator
%% @doc @todo Add description to demo14.


-module(demo14).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================


start()->
	spawn_link(fun()->1/0 end).