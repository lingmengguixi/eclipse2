-module(main).

-export([start/0]).

start()->
   Dict=dict:new(),
   spawn(fun()-> loop(Dict) end).
   
f(N)->
   io:format("the time:~p~n",[N]).
   
loop(Dict)->
   receive 
   after 1000->
      V=Dict:lookup(v),
      f(V),
	  Dict:store(v,V+1)
    end,
	loop(Dict). 