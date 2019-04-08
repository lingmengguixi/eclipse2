package org.scau.lzk.scene;

import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;

import javafx.application.Platform;

public class ReceiveThread extends Thread{
	Socket socket;
	MainScene scene;
	public int count=20;
    public ReceiveThread(Socket socket,MainScene scene) {
		 this.socket=socket;
		 this.scene=scene;
	}
   @Override
   public void run(){
	    InputStream ins;
		try {
			ins = socket.getInputStream();
		     while(true){
		    	 int c=ins.read();
		    	 if(c==-1) break;
		    	 System.out.printf("%02x ",c);
		          if(c>=101&&c<=100+count){
		        	  Double X=readDouble(ins);
		        	  Double Y=readDouble(ins);
		        	  Platform.runLater(()->{
		        		  scene.setRectangleLayout(c-101,X,Y);
		        	  });
		          }else if(c==202){
		        	  Double X=readDouble(ins);
		        	  Double Y=readDouble(ins);
		        	  Platform.runLater(()->{
		        		  scene.setCircle2Layout(X, Y);
		        	  });
		          }else if(c==201){
		        	  Double X=readDouble(ins);
		        	  Double Y=readDouble(ins);
		        	  Platform.runLater(()->{
		        		  scene.setCircle1Layout(X, Y);
		        	  });
		          }else if(c==210){
		        	  Platform.runLater(()->{
		        		  scene.startGame();
		        	  });
		          }
		     }
		     
		} catch (IOException e) {
            
		}

   }
	public int readInt(InputStream ins) throws IOException{
		int v=0;
		for(int i=0;i<4;i++){
			int c=ins.read();
			v*=256;
			v+=c;
		}
		return v;
	}
	public double readDouble(InputStream ins) throws IOException{
		return readInt(ins)/1000.0;
	}
}
