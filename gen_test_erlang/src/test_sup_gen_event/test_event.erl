%% @author Administrator
%% @doc @todo Add description to test_event.


-module(test_event).

%% ====================================================================
%% API functions
%% ====================================================================
-export([t/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================


t()->
  myevent:start_link(),
  myevent:add_handler(),
  myevent:add_sup_handler(),
  myevent:stop().