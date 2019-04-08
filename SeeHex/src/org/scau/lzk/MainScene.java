package org.scau.lzk;

 

import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.ComboBox;
import javafx.scene.control.TextArea;
import javafx.scene.layout.Pane;
import javafx.scene.shape.Circle;

public class MainScene extends Scene {
    private TextArea input_tx=new TextArea();
    private TextArea output_tx=new TextArea();
    private ComboBox<String> select_cb=new ComboBox<>();
	public MainScene(Pane root, double width, double height) {
		super(root, width, height);
		
		input_tx.minWidthProperty().bind(this.widthProperty().subtract(10));
		input_tx.maxWidthProperty().bind(this.widthProperty().subtract(10));
		input_tx.minHeightProperty().bind(this.heightProperty().divide(2).subtract(32));
		input_tx.maxHeightProperty().bind(this.heightProperty().divide(2).subtract(32));
		input_tx.setLayoutX(5);
		input_tx.setLayoutY(30);
		input_tx.textProperty().addListener(event->{
			solve();
		});
		
		
		output_tx.minWidthProperty().bind(this.widthProperty().subtract(10));
		output_tx.maxWidthProperty().bind(this.widthProperty().subtract(10));
		output_tx.minHeightProperty().bind(this.heightProperty().divide(2).subtract(3));
		output_tx.maxHeightProperty().bind(this.heightProperty().divide(2).subtract(3));
		output_tx.setLayoutX(5);
		output_tx.layoutYProperty().bind(this.heightProperty().divide(2).add(2));
		
		select_cb.setMinWidth(100);
		select_cb.setMaxWidth(100);
		select_cb.setLayoutY(1);
		select_cb.layoutXProperty().bind(this.widthProperty().subtract(100));
		select_cb.getItems().addAll("�ı�","4�ֽ�����-b","8�ֽ�����-b","4�ֽ�����-l","8�ֽ�����-l");
		select_cb.getSelectionModel().select(0);
		select_cb.getSelectionModel().selectedIndexProperty().addListener(event->{
			solve();
		});
		
		root.getChildren().addAll(input_tx,output_tx,select_cb);
	}
	public void solve(){
		int select=select_cb.getSelectionModel().getSelectedIndex();
		if(select==0) solve1(input_tx, output_tx);
		else if(select==1) solve2(input_tx,output_tx,4);
		else if(select==2) solve2(input_tx,output_tx,8);
		else if(select==3) solve3(input_tx, output_tx, 4);
		else if(select==4) solve3(input_tx, output_tx, 8);
	}
	public boolean isLegal(char[] ins,int number){
		  int count=0;
		  for(int i=0;i<ins.length;i++){
			  if(ins[i]>='0'&&ins[i]<='9') count++;
			  else if(ins[i]>='a'&&ins[i]<='z') count++;
			  else if(ins[i]>='A'&&ins[i]<='Z') count++;
			  else if(ins[i]!=' '&&ins[i]!='\t'&&ins[i]!='\r'&&ins[i]!='\n') return false;
		  }
		  if(count%number!=0) return false;
		  return true;
	}
	public int getNumber(char c){
		if(c>='0'&&c<='9') return c-'0';
		else if(c>='a'&&c<='z') return c-'a'+10;
		else if(c>='A'&&c<='Z') return c-'A'+10;
		return -1;
	}
    public void solve1(TextArea input,TextArea output){
    	char[] ins=input.getText().toCharArray();
    	if(!isLegal(ins, 2)){
    		output.setText("");
    		return;
    	}
    	int c1=0;
    	int had=0;
    	StringBuffer s=new StringBuffer();
    	for(int i=0;i<ins.length;i++){
    		int v=getNumber(ins[i]);
    		if(v==-1) continue;
    		if(had==0) {
    			had=1;
    			c1=v;
    		}else if(had==1){
    			had=0;
    			int c0=c1*16+v;
    			if(c0>=32&&c0<127||c0=='\r'||c0=='\n'||c0=='\t'||c0==' ') s.append((char)c0);
    			else s.append(".");
    		}
    	}
    	output.setText(s.toString());
    }
    
    public void solve2(TextArea input,TextArea output,int byteNum){
    	byteNum*=2;
    	char[] ins=input.getText().toCharArray();
    	if(!isLegal(ins, byteNum)){
    		output.setText("");
    		return;
    	}
    	long c1=0;
    	int had=0;
    	StringBuffer s=new StringBuffer();
    	int count=0;
    	for(int i=0;i<ins.length;i++){
    		int v=getNumber(ins[i]);
    		if(v==-1) continue;
    		if(had==byteNum-1) {
    			long c0=c1*16+v;
    			if(count%10==0&&count!=0) s.append("\r\n");
    			else if(count!=0) s.append(",");
    			s.append(c0);
    			count++;
    			had=0;
    			c1=0;
    		}else{
    			had++;
    			c1*=16;
    			c1+=v;
    		}
    	}
    	output.setText(s.toString());
    }
    public void solve3(TextArea input,TextArea output,int byteNum){
    	byteNum*=2;
    	char[] ins=input.getText().toCharArray();
    	if(!isLegal(ins, byteNum)){
    		output.setText("");
    		return;
    	}
    	long c1=0,c0=0;
    	int had=0;
    	long c2=1;
    	StringBuffer s=new StringBuffer();
    	int count=0;
    	for(int i=0;i<ins.length;i++){
    		int v=getNumber(ins[i]);
    		if(v==-1) continue;
    		if(had==byteNum-1) {
    			if(count%10==0&&count!=0) s.append("\r\n");
    			else if(count!=0) s.append(",");
    			c0+=(c1*16+v)*c2;
    			s.append(c0);
    			count++;
    			had=0;
    			c1=0;
    			c0=0;
    			c2=1;
    		}else if(had%2==0){
    			had++;
    			c1=v;
    		}else if(had%2==1){
    			had++;
    			c0+=(c1*16+v)*c2;
    		    c2*=256;
    		}
    	}
    	output.setText(s.toString());
    }
}