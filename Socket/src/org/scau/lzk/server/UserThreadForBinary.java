package org.scau.lzk.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.Socket;

public class UserThreadForBinary extends Thread{
	Socket socket;

	public UserThreadForBinary (Socket socket) {
		this.socket = socket;
	}
	@Override
	public void run() {
		System.out.println("ÓÃ»§µÇÂ½");
		try {
			InputStream ins = socket.getInputStream();
			int count=0;
			while(true){
				int c=ins.read();
				if(c==-1){
					socket.close();
					break;
				}
				if(count%16==0&&count!=0){
					System.out.println();
				}else if(count!=0){
					System.out.print(" ");
				}
				if(count%8==0&&count%16!=0){
					System.out.print(" ");
				}
				
				count++;
				System.out.printf("%02x",c);
			}
			
		} catch (IOException e) {
             try {
				socket.close();
			} catch (IOException e1) {
   
			}
		}
        System.out.println("user logout!");
	}
}
