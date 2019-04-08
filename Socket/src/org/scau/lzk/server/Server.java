package org.scau.lzk.server;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
     public static void main(String[] argv) throws IOException{
    	 ServerSocket server=new ServerSocket(5656);
    	 System.out.println("准备接收:");
    	 Socket socket=server.accept();
    	// MainThread thread=new MainThread(socket);
    	// thread.start();
    	 UserThreadForBinary thread=new UserThreadForBinary(socket);
    	 thread.start();
     }
}
