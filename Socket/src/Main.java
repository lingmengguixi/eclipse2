import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Scanner;

public class Main {
    public static void main(String [] argv){
    	System.out.println(System.currentTimeMillis());
    	if(true) return;
    	Socket s;
		try {
			
			s = new Socket("127.0.0.1", 5656);
	    	OutputStream outs=s.getOutputStream();
	    	BufferedWriter write=new BufferedWriter(new OutputStreamWriter(outs,"utf-8"));
	    	Scanner in=new Scanner(System.in);
	    	char[] len={0,0,0,0};
	    	while(true){
	    		System.out.println("输入文本发送");
	    		String ss=in.nextLine();
	    		len[3]=(char)(ss.length()+2);
	    		write.write(len);
	    		write.write(ss);
	        	write.newLine();
	        	write.flush();
	        	if(s==null) break;
	    	}
	         in.close();
	         s.close();
		} catch (IOException e) {
			System.out.println(e);
		}
    }
}
