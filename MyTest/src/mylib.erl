%% @author Administrator
%% @doc @todo Add description to mylib.


-module(mylib).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).



%% ====================================================================
%% Internal functions
%% ====================================================================


%% 产生随机数
rand(Min, Max)->
    case get("rand_seed") of
        undefined ->
            RandSeed = erlang:now(),
            random:seed(RandSeed),
            put("rand_seed", RandSeed);
        _ ->
            skip
    end,
    M = Min - 1,
	random:uniform(Max - M) + M.