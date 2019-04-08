%% @author Administrator
%% @doc @todo Add description to main.


-module(my).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

-record(row, {id,row1, row2, row3, row4, row5, row6, row7, row8, row9}).

%% ====================================================================
%% Internal functions
%% ====================================================================
 
 
t(N)->
  F1 = fun(Dict,_I)->
            D = mylib:rand(1, 100000) + _I,
            R = #row{row1=D, row2=D, row3=D, row4=D, row5=D, row6=D, row7=D, row8=D, row9=D},
            dict:store(_I, R, Dict)
    end,
  F2 = fun(Dict,_I)->
            Id = mylib:rand(1, N),
			dict:find(Id,Dict),
            Dict
	end,
   {result,R}=testtool:run(N, [
			{"run1",F1,[]}
		    ,{"run2",F2,[]}	   
	], 
    dict:new()),
    [dict:size(X)||X<-R].

