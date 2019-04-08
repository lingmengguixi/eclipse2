%% @author Administrator
%% @doc @todo Add description to dets_test.


-module(dets_test).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).
-include("head.hrl").



%% ====================================================================
%% Internal functions
%% ====================================================================

init()->
    case dets:open_file(?MODULE, [{file,"1.dets"}]) of
		{ok,?MODULE}->io:format("success to open the dets!~n");
		{error,Reason}->io:format("error:~p~n",[Reason])
	end,
	ok.

t(N)->
	init(),
	dets:delete_all_objects(?MODULE),
    F1 = fun(_I)->
            D = ptester:rand(1, 100000) + _I,
            R = #row{row1=D, row2=D, row3=D, row4=D, row5=D, row6=D, row7=D, row8=D, row9=D},
            dets:insert(?MODULE, {_I, R})
    end,
    F2 = fun(_I)->
            Id = ptester:rand(1, N),
            dets:lookup(?MODULE, Id)
    end,
    F3 = fun(_I)->
            Id = ptester:rand(1, N),
            [_]=dets:match(?MODULE, {Id, '$1'})
    end,
    F4 = fun(_I)->
            Id = ptester:rand(1, N),
            [_]=dets:select(?MODULE, [{{Id,#row{row1='$1',row2='$2',row3='$3',row4='$4',row5='$5',row6='$6',row7='$7',row8='$8',row9='$9'}}, [], ['$$']}])
    end,
	  ptester:run(N, [
			 {"insert", F1}
            ,{"lookup", F2}
            ,{" match", F3}
		    ,{"select", F4}
        ]
    ).