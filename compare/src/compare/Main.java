package compare;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class Main {
	static void copy(String path1,String path2) {
		File file1=new File(path1);
		File file2=new File(path2);
		if(file1.isFile()) {
			File p=new File(file2.getParent());
			if(!p.exists()) p.mkdirs();
			String command=null;
			try {
				FileOutputStream outs=new FileOutputStream(file2);
				FileInputStream input=new FileInputStream(file1);
				System.out.println("copy:"+file1.getPath()+"\n");
				while(true){
					int v=input.read();
					if(v==-1) break;
					outs.write(v);
				}
				input.close();
				outs.close();
			} catch (IOException e) {
				System.out.println("command:"+command+"\n"+e);
			}
		}else{
			if(!file2.exists()) file2.mkdirs();
			File[] files1=file1.listFiles();
			for(int i=0;i<files1.length;i++){
				copy(files1[i].getPath(),path2+"\\"+files1[i].getName());
			}
		}
	}
	static void compare(File f1,File f2,String save){
		if(!f1.exists()&&!f2.exists()){
			return;
		}else if(f1.exists()!=f2.exists()){
			if(f1.exists()) System.out.println(f2.getPath()+" not exist");
			else System.out.println(f2.getPath()+" more than before");
			return;
		}
		if(f1.isFile()&&!f2.isFile()){
			System.out.println(f2.getParent()+"/"+f2.getName()+" is not a file");
			return ;
		}
		if(!f1.isFile()&&f2.isFile()){
			System.out.println(f2.getPath()+" is a file");
			return ;
		}
		if(f1.isFile()){
			if(f1.length()!=f2.length()){
				System.out.println(f2.getPath()+" not same with the length");
				return;
			}
		}else{
			File[] files1=f1.listFiles();
			File[] files2=f2.listFiles();
			for(int i=0;i<files1.length;i++){
				int j;
				for(j=0;j<files2.length;j++){
					if(files1[i].getName().equals(files2[j].getName())&&files1[i].isFile()==files2[j].isFile()) {
						compare(files1[i],files2[j],save+"\\"+files1[i].getName());
						break;
					}
				}
				if(j>=files2.length) {
					String path=save+"\\"+files1[i].getName();
					System.out.println(files1[i].getPath()+" not find!");
					copy(files1[i].getPath(),path);
					 
				}
			}
			for(int j=0;j<files2.length;j++){
				int i;
				for(i=0;i<files1.length;i++){
					if(files1[i].getName().equals(files2[j].getName())&&files1[i].isFile()==files2[j].isFile()) break;
				}
				if(i>=files1.length){
					System.out.println(files2[j]+" more than");
				}
			}
		}
	}
    public static void main(String[] argv){
    	File f1=new File("D:\\program\\eclipse\\eclipse");//»ù×¼
    	File f2=new File("F:\\ÏÂÔØ\\eclipse-jee-neon-3-win32-x86_64\\eclipse");
    	System.out.println("start");
    	compare(f1,f2,"e:\\compare");
    	System.out.println("end");
    }
}
