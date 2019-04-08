package org.scau.lzk.scene;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Platform;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.image.Image;
import javafx.scene.input.KeyCode;
import javafx.scene.layout.Background;
import javafx.scene.layout.BackgroundImage;
import javafx.scene.layout.BackgroundPosition;
import javafx.scene.layout.BackgroundRepeat;
import javafx.scene.layout.BackgroundSize;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.shape.Circle;
import javafx.scene.shape.Rectangle;
import javafx.util.Duration;

public class MainScene extends Scene{
	public Pane root;
	public double width;
	public double height;
	public int count=20;
	public double rectangle_width=75;
	public double rectangle_height=20;
	public double rectangle_yv=1.5;
	public double circle_R=10;
	public double qiu_yv=2;
	Timeline timeline=new Timeline();
	public Button start_btn=new Button("start");
	public Button reset_btn=new Button("reset");
	public Button stop_btn=new Button("stop");
	public Rectangle[] rectangle=new Rectangle[20];
	public int level=1;
	public Circle qiu1=new Circle(circle_R,Color.CHARTREUSE);
	public Circle qiu2=new Circle(circle_R,Color.RED);
	public boolean leftMove=false;
	public boolean rightMove=false;
	public boolean lastMoveIsRight=false;
	public Label level_label=new Label("等级:1");
	public Timeline console=new Timeline();
	Socket socket;
	OutputStream outs;
	public MainScene(Pane root, double width, double height) {
		super(root, width, height);
		this.root=root;
		this.width=width;
		this.height=height;
		for(int i=0;i<count;i++){
			rectangle[i]=new Rectangle();
			rectangle[i].setLayoutY(0);
			rectangle[i].setLayoutX(0);
			rectangle[i].setWidth(rectangle_width);
			rectangle[i].setHeight(rectangle_height);
			rectangle[i].setFill(Color.BLUEVIOLET);
			rectangle[i].setTranslateX(-100);
			rectangle[i].setTranslateY(-100);
			root.getChildren().add(rectangle[i]);
		}
		

    	timeline.setCycleCount(Timeline.INDEFINITE);
    	
    	start_btn.setLayoutX(0);
    	start_btn.setLayoutY(0);
    	start_btn.setOnAction(event->{
    		start();
    	});
    	
    	stop_btn.setLayoutX(50);
    	stop_btn.setLayoutY(0);
    	stop_btn.setOnAction(event->{
    		//stop();
    	});
    	stop_btn.setDisable(true);
    	
    	reset_btn.setLayoutX(100);
    	reset_btn.setLayoutY(0);
    	reset_btn.setOnAction(event->{
    		//reset1();
    	});
    	reset_btn.setDisable(true);
    	
    	qiu1.setLayoutX(0);
    	qiu1.setLayoutY(0);
    	qiu2.setLayoutX(0);
    	qiu2.setLayoutY(0);
    	
    	timeline.getKeyFrames().add(new KeyFrame(Duration.millis(20), event->{
    		boolean peng=false;
            for(int i=0;i<count;i++){
            	double py=rectangle[i].getTranslateY();
            	double px1=rectangle[i].getTranslateX();
            	double px2=px1+rectangle_width;
            	boolean isChange=false;
            	double py_new=py-rectangle_yv;
            	rectangle[i].setTranslateY(py_new);     
            	double qx=qiu1.getTranslateX();
            	double qy=qiu1.getTranslateY();
            	if(qx>=px1&&qx<=px2&&qy+circle_R<=py_new+rectangle_yv*2){
                		if(qy+circle_R>py_new){
                			peng=true;
                			qiu1.setTranslateY(py_new-circle_R);
                		}			
            	}
            }
            double qy=qiu1.getTranslateY();
            if(!peng) qiu1.setTranslateY(qy+qiu_yv);
            qy=qiu1.getTranslateY();
            if(qy>=height+circle_R||qy<=circle_R){
            	timeline.stop();
            	console.stop();
            	Platform.runLater(new Runnable() {
					
					@Override
					public void run() {
		            	Alert alert=new Alert(AlertType.CONFIRMATION);
		            	alert.setTitle("游戏结束");
		            	//alert.setContentText("。。。。滚过"+guo+"个木块....");
		            	alert.showAndWait();
		            	leftMove=false;
		            	rightMove=false;
					}
				});
            	
            }
	    }));
    	
    	timeline.setCycleCount(Timeline.INDEFINITE);
    	
    	this.setOnKeyPressed(event->{
    		KeyCode v=event.getCode();
    		if(v==KeyCode.LEFT){
    			leftMove=true;
    			lastMoveIsRight=false;
    		}else if(v==KeyCode.RIGHT){
    			rightMove=true;
    			lastMoveIsRight=true;
    		}
    		
    	});
    	
    	this.setOnKeyReleased(event->{
    		KeyCode v=event.getCode();
    		if(v==KeyCode.LEFT){
    			leftMove=false;
    		}else if(v==KeyCode.RIGHT){
    			rightMove=false;
    		}
    	});
    	
    	console.setCycleCount(Timeline.INDEFINITE);
    	console.getKeyFrames().add(new KeyFrame(Duration.millis(20), event->{
    		  if(!leftMove&&!rightMove) return;
    		  double qx=qiu1.getTranslateX();
    		  if(leftMove&&rightMove){
    			  if(lastMoveIsRight){
    	              	if(qx+5<=width-circle_R) qiu1.setTranslateX(qx+5);
    	              	else qiu1.setTranslateX(width-circle_R); 
    			  }else{
    	              	if(qx-5>=circle_R) qiu1.setTranslateX(qx-5);
    	              	else qiu1.setTranslateX(circle_R); 				  
    			  }
    		  }else if(rightMove){
              	if(qx+5<=width-circle_R) qiu1.setTranslateX(qx+5);
              	else qiu1.setTranslateX(width-circle_R); 
    		  }else if(leftMove){
              	if(qx-5>=circle_R) qiu1.setTranslateX(qx-5);
              	else qiu1.setTranslateX(circle_R); 
    		  }
    	}));
    	
    	level_label.setLayoutX(550);
    	level_label.setLayoutY(10);
    	Image image=new Image("bg01.png");
    	BackgroundSize size=new BackgroundSize(width, height, false, false, false, true);
    	root.setBackground(new Background(new BackgroundImage(image, BackgroundRepeat.NO_REPEAT, BackgroundRepeat.NO_REPEAT, BackgroundPosition.CENTER, size)));
    	root.getChildren().addAll(start_btn,qiu1,qiu2,reset_btn,stop_btn,level_label);
	}
	
	public void start(){
		
		try {
			socket = new Socket("127.0.0.1", 5656);
			outs=socket.getOutputStream();
		} catch (IOException e) {
			System.out.println("连接失败");
			return;
		}
		ReceiveThread thread=new ReceiveThread(socket, this);
		thread.start();
	}
	
	public void startGame(){
   	   timeline.play();
   	   console.play();
//   	   reset_btn.setDisable(false);
//   	   start_btn.setDisable(true);
//   	   stop_btn.setDisable(false);
	}
	
	public void setRectangleLayout(int index,Double X,Double Y){
		rectangle[index].setTranslateX(X);
		rectangle[index].setTranslateY(Y);
	}
	public void setCircle1Layout(Double X,Double Y){
		qiu1.setTranslateX(X);
		qiu1.setTranslateY(Y);
	}
	public void setCircle2Layout(Double X,Double Y){
		qiu2.setTranslateX(X);
		qiu2.setTranslateY(Y);
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
