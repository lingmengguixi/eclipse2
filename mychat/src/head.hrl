-record(user, {
        id      	 %% 用户ID
        ,name   	 %% 用户名称
        ,passwd="123456" 	 %% 用户登录密码
        ,login_times=0 %% 登录次数
        ,chat_times=0  %% 聊天次数
        ,last_login=now()  %% 最后一次登录时间
        
    }
).

-record(msg, {   
	    fromId,           %% 发送消息的用户id
    	toId,             %% 收到消息的用户的id
	    chatType=text,    %% 聊天方式(文件，语音，纯消息...)
	    chatMsg		      %% 聊天内容
        }
).
 
-define(PORT,6000).
-define(USERTABLE,user_table).
-define(MSGTABLE,msg_table).
-define(CORE,coreProcess).
-define(SERVER,serverProcess).
-define(ETS,userEtsProcess).
-define(MSG,msgEtsProcess).
-define(HOST,"127.0.0.1").

