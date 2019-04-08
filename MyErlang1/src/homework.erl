%% @author Administrator
%% @doc @todo Add description to homework.


-module(homework).

%% ====================================================================
%% API functions
%% ====================================================================
-export([main1/0,main2/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================
odd_list1([X|T])->
	if 
		X rem 2=:=1->[X|odd_list1(T)];
		true ->odd_list1(T)
	end;
odd_list1([])->
	[].

odd_list2(L)->
	lists:filter(fun(X)->X rem 2=:=1 end, L).

odd_list3(L)->
	odd_list3(L,[]).
odd_list3([X|L],T) when X rem 2=:=1->
	odd_list3(L,[X|T]);
odd_list3([X|L],T)->
	odd_list3(L,T);
odd_list3([],T)->
	lists:reverse(T).

odd_list4([X|T])->
	case X rem 2 of
		1->[X|odd_list4(T)];
		_->odd_list4(T)
	end;
odd_list4([])->
    [].

odd_list5([X|_]=T)->
	odd_list5(X rem 2,T);
odd_list5(_)->[].
odd_list5(1,[X|T])->
	[X|odd_list5(T)];
odd_list5(_,[_|T])->odd_list5(T).

odd_list6([X|T])->
	try true=(X rem 2=:=1) of
        true->[X|odd_list6(T)]
    catch
		_:_->odd_list6(T)
	end;
odd_list6([])->
    [].

odd_list7(L)->
	[X||X<-L,X rem 2 =:=1].
	

main1()->
   L = [1, 2, 3, 4, 5, 6, 7, 8, 9],
   odd_list7(L).


-record(item, {id, name, owner}).
list_to_record([X1,X2,X3])->
	#item{id=X1,name=X2,owner=X3}.

main2()->
	I=[3123, <<"XXX">>, <<"DDD">>],
    Item=list_to_record(I),
Item#item.name.

%% OTP框架中有几种behaviour?其中有哪一些你觉得比较了解？

%% 有4大behaviour，gen_server,gen_statem(gen_fsm),gen_event,supervisor
%% 课本主要介绍gen_server

%% handle_call/3 远程过程调用
%% handle_cast/2 实现播发,没有返回值的调用
%% handle_info/2处理自发性消息，即未显式调用前两者，但服务却得到的消息

%% 20世纪80年代中期,调查适合下一代电信产品的编程语言,开发一种全新的语言erlang，即为电信级应用开发
%% erlang 是动态类型的语言(不能进行静态分析，所生成的文档也不包含有助于理解的类型信息),但它早已发展出了一套自己的类型标注系统，不仅用来生成文档，更重要的是可以据此对源码进行静态分析，通过程序来排除一些低级的和隐藏的错误。
%% 总得来说:优点为方便阅读，清晰明了，缺点为不方便调试
%% Erlang的拥有GC垃圾回收机制，类似java的回收机制，但缺了mark过程
%% Erlang中有个builtin的高可靠性，如link和monitor机制
%% erlang 使用它存在维护上的风险
%% Erlang的变量不可变
%%　最简洁精练的分布式模型
%% 最优雅的错误处理模型：速错
%% 热部署，代码热切换
%% Erlang的实现基于虚拟机beam
%% 在消息执行方式上的优势在于灵活。属于弱类型语言
%% 注:函数式编程永远只能是小众语言.因为主流的计算机架构都是冯诺依曼体系的，并不是最适合函数式语言的生存土壤。
%% 天生自带RPC通信

%% 用erlang进行多核编程时，如果希望我们的程序运行得更高效，需要遵循哪一些其本准则?
%% 使用大量进程
%% 避免副作用
%% 避免顺序瓶颈
%% 编写"小消息，大计算"的代码



