package javatool;

import java.util.Date;
import java.util.Scanner;

public class Main {
     public static void main(String[] args){
    	 long time=0;
    	 if(args.length==0){
    		 System.out.println("now:"+System.currentTimeMillis());
    		 System.out.print("����ʱ���:");
    		 Scanner input=new Scanner(System.in);
    		 time=input.nextLong();
    	 }else if(args.length==1){
    		 System.out.println("now:"+System.currentTimeMillis());
    		 time=Long.parseLong(args[0]);
    	 }else {
    		 System.out.println("�﷨:timetool [ʱ���]");
    		 System.out.println("E:args len is "+args.length);
    		 return ;
    	 }
    	 
    	 Date date=new Date(time);
    	 System.out.print("����ʱ���ʱ��Ϊ:");
    	 System.out.println(date.toLocaleString());
    	 
     }
}