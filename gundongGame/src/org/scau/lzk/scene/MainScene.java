package org.scau.lzk.scene;


import java.util.Random;

import javafx.animation.KeyFrame;
import javafx.animation.Timeline;
import javafx.application.Platform;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
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
	public Rectangle[] rectangle=new Rectangle[20];
	Timeline timeline=new Timeline();
	public Button start_btn=new Button("start");
	public Button reset_btn=new Button("reset");
	public Button stop_btn=new Button("stop");
	public int count=20;
	public Random random=new Random();
	public double rectangle_width=75;
	public double rectangle_height=20;
	public double rectangle_yv=1.5;
	public double circle_R=10;
	public double qiu_yv=2;
	public boolean leftMove=false;
	public boolean rightMove=false;
	public boolean lastMoveIsRight=false;
	public Pane root;
	public double width;
	public double height;
	public int guo=0;
	public Circle qiu=new Circle(circle_R,Color.CHARTREUSE);
	public Timeline console=new Timeline();
	public int level=1;
	public Label level_label=new Label("等级:1");
	
	public MainScene(Pane root, double width, double height) {
		super(root, width, height);
		this.root=root;
		this.width=width;
		this.height=height;
		for(int i=0;i<count;i++){
			rectangle[i]=new Rectangle();
			rectangle[i].setTranslateX(random.nextInt((int)(width-rectangle_width)));
			rectangle[i].setLayoutY(0);
			rectangle[i].setLayoutX(0);
			rectangle[i].setWidth(rectangle_width);
			rectangle[i].setHeight(rectangle_height);
			rectangle[i].setFill(Color.BLUEVIOLET);
			rectangle[i].setTranslateY(80*i+200);
			root.getChildren().add(rectangle[i]);
		}
		
    	timeline.getKeyFrames().add(new KeyFrame(Duration.millis(20), event->{
    		boolean peng=false;
            for(int i=0;i<count;i++){
            	double py=rectangle[i].getTranslateY();
            	double px1=rectangle[i].getTranslateX();
            	double px2=px1+rectangle_width;
            	boolean isChange=false;
            	if(py<-20) {
            	   py+=count*80;
            	   guo++;
            	   if(guo%count==0) {
            		   level++;
            		   level_label.setText("等级:"+level);
            	   }
            	   isChange=true;
            	   rectangle[i].setTranslateX(random.nextInt(400));
            	}
            	double py_new=py-rectangle_yv;
         	   if(isChange&&guo%(count*1)==0){
        		   rectangle_yv+=0.3;
        	   }
            	rectangle[i].setTranslateY(py_new);     
            	double qx=qiu.getTranslateX();
            	double qy=qiu.getTranslateY();
            	if(qx>=px1&&qx<=px2&&qy+circle_R<=py+rectangle_yv*2){
                		if(qy+circle_R>py_new){
                			peng=true;
                			qiu.setTranslateY(py_new-circle_R);
                		}			
            	}
            }
            double qy=qiu.getTranslateY();
            if(!peng) qiu.setTranslateY(qy+qiu_yv);
            qy=qiu.getTranslateY();
            if(qy>=height+circle_R||qy<=circle_R){
            	timeline.stop();
            	console.stop();
            	Platform.runLater(new Runnable() {
					
					@Override
					public void run() {
		            	Alert alert=new Alert(AlertType.CONFIRMATION);
		            	alert.setTitle("游戏结束");
		            	alert.setContentText("。。。。滚过"+guo+"个木块....");
		            	alert.showAndWait();
		            	leftMove=false;
		            	rightMove=false;
		            	reset1();
					}
				});
            	
            }
	    }));
    	
    	timeline.setCycleCount(Timeline.INDEFINITE);
    	
    	start_btn.setLayoutX(0);
    	start_btn.setLayoutY(0);
    	start_btn.setOnAction(event->{
    		start();
    	});
    	
    	stop_btn.setLayoutX(50);
    	stop_btn.setLayoutY(0);
    	stop_btn.setOnAction(event->{
    		stop();
    	});
    	stop_btn.setDisable(true);
    	
    	reset_btn.setLayoutX(100);
    	reset_btn.setLayoutY(0);
    	reset_btn.setOnAction(event->{
    		reset1();
    	});
    	reset_btn.setDisable(true);
    	
    	qiu.setLayoutX(0);
    	qiu.setLayoutY(0);
    	qiu.setTranslateX(rectangle[0].getTranslateX()+rectangle_width/2);
    	qiu.setTranslateY(rectangle[0].getTranslateY()-circle_R);
    	
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
    		  double qx=qiu.getTranslateX();
    		  if(leftMove&&rightMove){
    			  if(lastMoveIsRight){
    	              	if(qx+5<=width-circle_R) qiu.setTranslateX(qx+5);
    	              	else qiu.setTranslateX(width-circle_R); 
    			  }else{
    	              	if(qx-5>=circle_R) qiu.setTranslateX(qx-5);
    	              	else qiu.setTranslateX(circle_R); 				  
    			  }
    		  }else if(rightMove){
              	if(qx+5<=width-circle_R) qiu.setTranslateX(qx+5);
              	else qiu.setTranslateX(width-circle_R); 
    		  }else if(leftMove){
              	if(qx-5>=circle_R) qiu.setTranslateX(qx-5);
              	else qiu.setTranslateX(circle_R); 
    		  }
    	}));
    	
    	level_label.setLayoutX(550);
    	level_label.setLayoutY(10);
    	Image image=new Image("bg01.png");
    	BackgroundSize size=new BackgroundSize(width, height, false, false, false, true);
    	root.setBackground(new Background(new BackgroundImage(image, BackgroundRepeat.NO_REPEAT, BackgroundRepeat.NO_REPEAT, BackgroundPosition.CENTER, size)));
    	root.getChildren().addAll(start_btn,qiu,reset_btn,stop_btn,level_label);
	}
	
	public void reset1(){
		stop();
		
		for(int i=0;i<count;i++){
			rectangle[i].setTranslateX(random.nextInt((int)(width-rectangle_width)));
			rectangle[i].setTranslateY(80*i+200);
		}
    	qiu.setTranslateX(rectangle[0].getTranslateX()+rectangle_width/2);
    	qiu.setTranslateY(rectangle[0].getTranslateY()-circle_R);
    	
    	
	}
	
    public void start(){
    	 timeline.play();
    	 console.play();
    	 reset_btn.setDisable(false);
    	 start_btn.setDisable(true);
    	 stop_btn.setDisable(false);
    }
    public void stop(){
    	leftMove=false;
    	rightMove=false;
    	timeline.stop();
    	console.stop();
    	level=1;
    	rectangle_yv=1.5;
    	guo=0;
    	level_label.setText("等级:"+level);
    	reset_btn.setDisable(true);
    	start_btn.setDisable(false);
    	stop_btn.setDisable(true);
    }
}
