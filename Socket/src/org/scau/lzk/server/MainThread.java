package org.scau.lzk.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.Socket;

public class MainThread extends Thread {
	Socket socket;

	public MainThread(Socket socket) {
		this.socket = socket;
	}

	@Override
	public void run() {
		System.out.println("ÓÃ»§µÇÂ½");
		try {
			InputStream ins = socket.getInputStream();
			BufferedReader reader=new BufferedReader(new InputStreamReader(ins, "utf-8"));
			while(true){
				String s=reader.readLine();
				if(s==null){
					socket.close();
					break;
				}
				System.out.println("client:"+s);
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
