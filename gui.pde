
class cViewport {


	int iPlayerId;

	int viewportWidth;
	int viewportHeight;

	int viewportCellCountX;
	int viewportCellCountY;
	
	int iStartX;
	int iStartY;
	
	int ScrollBarWidth;

	cViewport(int iPlayerId_, int gridCellCountX, int gridCellCountY, int viewportCellCountX_, int viewportCellCountY_) {
	
		iPlayerId = iPlayerId_;

		iStartX=1;
		iStartY=1;
	
		viewportCellCountX = viewportCellCountX_;
		viewportCellCountY = viewportCellCountY_;
	
		//viewportWidth = (viewportCellCountX*cellWidth)+cellWidth; 
		//viewportHeight = (viewportCellCountY*cellHeight)+cellHeight;

		viewportWidth = (viewportCellCountX*cellWidth); 
		viewportHeight = (viewportCellCountY*cellHeight);


		oVScrollBar = new cVScrollBar(viewportWidth, viewportHeight, viewportCellCountX, viewportCellCountY, gridCellCountX, gridCellCountY); 
		oHScrollBar = new cHScrollBar(viewportWidth, viewportHeight, viewportCellCountX, viewportCellCountY, gridCellCountX, gridCellCountY); 

		//println("create grid...gridCellCountX="+ gridCellCountX  +", gridCellCountY="+gridCellCountY);

		//oGrid = new cGrid(gridCellCountX, gridCellCountY, iStartX, iStartY); 
		
		ScrollBarWidth = cellWidth;

	}

	void resize(int gridCellCountX, int gridCellCountY, int viewportCellCountX_, int viewportCellCountY_) {
	
		iStartX=1;
		iStartY=1;
	
		//println("in viewport.resize...viewportCellCountX="+ viewportCellCountX  +", viewportCellCountY="+viewportCellCountY);
		
		viewportCellCountX = viewportCellCountX_;
		viewportCellCountY = viewportCellCountY_;
		
		//println("in viewport.resize...viewportCellCountX="+ viewportCellCountX  +", viewportCellCountY="+viewportCellCountY);
	
		viewportWidth = (viewportCellCountX*cellWidth); 
		viewportHeight = (viewportCellCountY*cellHeight);

		oVScrollBar = new cVScrollBar(viewportWidth, viewportHeight, viewportCellCountX, viewportCellCountY, gridCellCountX, gridCellCountY); 
		oHScrollBar = new cHScrollBar(viewportWidth, viewportHeight, viewportCellCountX, viewportCellCountY, gridCellCountX, gridCellCountY); 

		//oGrid = new cGrid(gridCellCountX, gridCellCountY, iStartX, iStartY);
		oGrid.resize(gridCellCountX, gridCellCountY, iStartX, iStartY);  
		//oGrid.resize(viewportCellCountX_, viewportCellCountY_, iStartX, iStartY);  
		
		ScrollBarWidth = 15;

	}

	int getPlayerId() { return iPlayerId; }

	int getStartX() { return iStartX; } 
	int getStartY() { return iStartY; }  
	
	void setStartX(int x_) { iStartX=x_; } 
	void setStartY(int y_) { iStartY=y_; }  
	
	
	int getWidth() { return viewportWidth; }
	void printWidth() { println("width=" + viewportWidth); }
	
	int getHeight() { return viewportHeight; }
	void printHeight() { println("height=" + viewportHeight); }

	int getViewportCellCountX() { return viewportCellCountX; }
	int getViewportCellCountY() { return viewportCellCountY; }

	
	void draw() {
	
		if (debugDrawViewport) println("debug: in viewport.draw(), oGameEngine.getCurrentPlayerId()="+oGameEngine.getCurrentPlayerId() );

		if ( oAnimateAttack.getAttackAnimationInProgress()==false ) {


			if ( GridDrawMode==1 ) {

				//background(#FFFFFF);

				
				fill(0);

				if ( iPlayerId==-1 ) { 
					rect(220, 0, viewportWidth, viewportHeight);
					rect(220, 350, viewportWidth, viewportHeight);
				} else if ( iPlayerId==1 ) { 
					rect(220, 0, viewportWidth+1, viewportHeight+1);
				} else {
					rect(220, 350, viewportWidth+1, viewportHeight+1);
				}
				

				//background(#FFFFFF);
				//fill(0);
				//rect(0,0,viewportWidth-ScrollBarWidth,viewportHeight-ScrollBarWidth);

			}

			noStroke();
			
			if ( showViewportScrollBars ) {
				oVScrollBar.draw();
				oHScrollBar.draw();
			}




			if ( GridDrawMode ==2 ) {

				int showFromX, showFromY;

				if ( iPlayerId==1 ) { 
					showFromX = oPlayer1.getShowFromCellX()*cellWidth;
					showFromY = oPlayer1.getShowFromCellY()*cellHeight;
				} else {
					showFromX = oPlayer2.getShowFromCellX()*cellWidth;
					showFromY = oPlayer2.getShowFromCellY()*cellHeight;
				}

				// ***********************************************
				// http://processingjs.org/reference/copy_/

				// copy(srcImg,x,y,width,height,dx,dy,dwidth,dheight)

				// Parameters: 	
				// srcImg 	PImage:a image variable referring to the source image.
				// x 		int: X coordinate of the source's upper left corner
				// y 		int: Y coordinate of the source's upper left corner
				// width 	int: source image width
				// height 	int: source image height
				// dx 		int: X coordinate of the destination's upper left corner
				// dy 		int: Y coordinate of the destination's upper left corner
				// dwidth 	int: destination image width
				// dheight 	int: destination image height
				// *****************************************************
				

				noFill();
				int tempScaleFactor=1;
				if ( iPlayerId==1 ) { 
					//println("player 1, copy from ScreenBuffer1, "+showFromX+","+showFromY+"  "+viewportWidth+","+viewportHeight );
					copy(ScreenBuffer1,
						round(showFromX/tempScaleFactor),round(showFromY/tempScaleFactor),
						round(viewportWidth/tempScaleFactor),round(viewportHeight/tempScaleFactor),
						222,2,  viewportWidth-2,viewportHeight-2);

				} else if ( debugShowPlayer2Viewport ) { 
					//println("player 2, copy from ScreenBuffer1, "+showFromX+","+showFromY+"  "+viewportWidth+","+viewportHeight );
					copy(ScreenBuffer1,
						round(showFromX/tempScaleFactor),round(showFromY/tempScaleFactor),
						round(viewportWidth/tempScaleFactor),round(viewportHeight/tempScaleFactor),
						222,352,  viewportWidth-2,viewportHeight-2);
				} 


			}

			//oGrid.draw4Player(iPlayerId); // FISH
			oGrid.draw4Player(1);
			oGrid.draw4Player(2);

			
			//oGrid.draw(); // FISH
			//oCityList.Draw();
			//oIslandPolyList.Draw(); 
			//oIslandPolyList.Draw4Viewport( getPlayerId() ); // FISH
			//oUnitList.Draw();

			
			//oPanel2.show();

			//redraw();
			
		}
	}
	
	bool isCellWithinViewport(int x_, int y_) {

		int showFromX, showFromY;

		if ( iPlayerId==1 ) { 
			showFromX = oPlayer1.getShowFromCellX();
			showFromY = oPlayer1.getShowFromCellY();
		} else {
			showFromX = oPlayer2.getShowFromCellX();
			showFromY = oPlayer2.getShowFromCellY();
		}
	
		if ( 	x_ >= showFromX && 
			x_ <= (showFromX+getViewportCellCountX()-1)   
			&&   
			y_ >=showFromY && 
			y_ <= (showFromY+getViewportCellCountY()-1) )  {
			
			return true;
		} else 
			return false;	
	}

	void scrollIfAppropriate(int x_, int y_) {


	}
	
	




	void scrollIfAppropriate2(int x_, int y_) {

	

		//println("oViewport.scrollIfAppropriate("+x_+","+y_+"), oGameEngine.getCurrentPlayerId()="+oGameEngine.getCurrentPlayerId() );

		if ( oAnimateAttack.getAttackAnimationInProgress()==false ) {

			int iMargin=2;
			bool bRedraw=false;

			int showFromX, showFromY, currentPlayerId;

			//currentPlayerId = oGameEngine.getCurrentPlayerId();

			if ( iPlayerId==1 ) { 
				showFromX = oPlayer1.getShowFromCellX();
				showFromY = oPlayer1.getShowFromCellY();
			} else {
				showFromX = oPlayer2.getShowFromCellX();
				showFromY = oPlayer2.getShowFromCellY();
			}


			int tempX = x_ - showFromX;
			if ( tempX > 20 ) { showFromX = x_ - 10; bRedraw=true; }
			else if ( tempX < -20 ) { showFromX = x_ + 10; bRedraw=true; }

			int tempY = y_ - showFromY;
			if ( tempY > 20 ) { showFromY = y_ - 10; bRedraw=true; }
			else if ( tempY < -20 ) { showFromY = y_ + 10; bRedraw=true; }


			if ( bRedraw==false ) {

				if ( x_ < showFromX+(iMargin*2) && showFromX>1 ) { showFromX = showFromX-iMargin; bRedraw=true; }
				if ( y_ < showFromY+(iMargin*2) && showFromY>1  ) { showFromY = showFromY-iMargin; bRedraw=true; }

				// 32x32
				if ( x_ > showFromX+getViewportCellCountX()-(iMargin*2) && showFromX<(99 - getViewportCellCountX()) ) { showFromX = showFromX+iMargin; bRedraw=true; }
				if ( y_ > showFromY+getViewportCellCountY()-(iMargin*2) && showFromY<(99 - getViewportCellCountY())  ) { showFromY = showFromY+iMargin; bRedraw=true; }
			}

		
			if ( iPlayerId==1 ) { 
				oPlayer1.setShowFromCellX(showFromX);
				oPlayer1.setShowFromCellY(showFromY);
			} else {
				oPlayer2.setShowFromCellX(showFromX);
				oPlayer2.setShowFromCellY(showFromY);
			}
		



			//oHScrollBar.setBlockStartX( (showFromX*8) );
			//oVScrollBar.setBlockStartY( (showFromY*8) );

			//println("bRedraw="+bRedraw);

			if ( bRedraw ) {

				//oViewport.draw();
				draw();
			}
		}
	
	}



	
}


class cLabel {

	string strLabel;
	int startX, startY;
	
	cLabel(string strLabel_, int startX_, int startY_) {
		strLabel = strLabel_;
		//startX = oViewport.getWidth()+8;
		startX = startX_;
		startY = startY_;
	}
	
	void set(string strLabel_) { strLabel=strLabel_; }
	
	void display() {
		
		fill(255); 
		text( strLabel, startX, startY);
		
	}
}


class cClickable {

	string strLabel;
	int startX, startY, objWidth, objHeight;
	int objId;
	bool bEnabled; // if false, prevent user from clicking then item
	
	cClickable(int objId_, string strLabel_, int startX_, int startY_) {
		
		objId = objId_;
		strLabel = strLabel_;
		//startX = oViewport.getWidth()+8;
		startX = startX_;
		startY = startY_;
		
		bEnabled=true;
	}
	
	bool isClicked(int x_, int y_) {
	
		//println("in cClickable.isClicked() ");
		
		if (bEnabled) { 
			//println("checkbox is clicked... x="+x_+", y="+y_);
			if (x_>=(startX) && y_>=(startY) && x_<=(startX+objWidth) && y_<=(startY+objHeight) ) return true;
			else return false;
		} else return false;
	}
}


class cButton extends cClickable {

	cButton(int objId_, string strLabel_, int startX_, int startY_) {
	
		super(objId_, strLabel_, startX_, startY_);
		
		objWidth = 180;
		objHeight = iStringTextSize+2;
	}

	bool isClicked(int x_, int y_) {
		
		//println("in cButton.isClicked() ");
		
		if (bEnabled) { 
			//println("checkbox is clicked... x="+x_+", y="+y_);
			if (x_>=(startX+1) && y_>=(startY-objHeight+4) && x_<=(startX+1+objWidth) && y_<=(startY) ) return true;
			else return false;
		} else return false;
	}
	
	void display() {
		
		//println("in cCheckbox.display() bClicked="+bClicked);
		
		// highight clickable area
		fill(150); 
		rect(startX+1, startY-objHeight+4, objWidth, objHeight );
		
		// show button
		fill(255); 
		text( "[" + strLabel + "]", startX, startY);
		
	}
}


class cCheckbox extends cClickable {

	cCheckbox(int objId_, string strLabel_, int startX_, int startY_) {
	
		super(objId_, strLabel_, startX_, startY_);
		
		objWidth = 18;
		objHeight = iStringTextSize+2;
	}

	bool isClicked(int x_, int y_) {
	
		if (bEnabled) { 
			//println("checkbox is clicked... x="+x_+", y="+y_);
			if (x_>=(startX+1) && y_>=(startY-objHeight+4) && x_<=(startX+1+objWidth) && y_<=(startY) ) return true;
			else return false;
		} else return false;
	}
	
	void display(bool bClicked_, bool bEnabled_) {

		bEnabled = bEnabled_;
		//println("in cCheckbox.display() bClicked_="+bClicked_);
		
		if (bEnabled) { 
			// highight clickable area
			if (bClicked_) fill(255); 
			else  fill(150); 
			rect(startX+1, startY-objHeight+4, objWidth, objHeight );
				
			// show checkbox
			fill(255); 
			text( "[ ] " + strLabel, startX, startY);
		} else {
			text( "    " + strLabel, startX, startY);
		}
	}
}



class cScrollBar {

	int startX;
	int startY;
	int endX;
	int endY;
	int barWidth = cellWidth;
	bool showScrollBar = true;

	int blockStartX;
	int blockStartY;
	int blockEndX;
	int blockEndY;
	int blockLength;
	
	int iScrollByPixelX;
	int iScrollByPixelY;
	
	cScrollBar() {}
	
	void setBlockStartX(int value_) { blockStartX=value_; }
	void setBlockStartY(int value_) { blockStartY=value_; }

	void draw() {

		if ( showScrollBar ) {

			// The noStroke() function disables drawing the stroke (outline). If both <b>noStroke()</b> and
			// <b>noFill()</b> are called, no shapes will be drawn to the screen.
			
			noStroke();

			// draw the scroll bar background
			fill(#d3d3d3); // light gray
			rect(startX, startY, endX, endY);		

			// draw the scroll bar block
			fill(#808080); // gray
			rect(blockStartX, blockStartY, blockEndX, blockEndY);		
		}
	}	

}


class cVScrollBar extends cScrollBar {

	cVScrollBar(int viewportWidth, int viewportHeight, int viewportCellCountX, int viewportCellCountY, int gridCellCountX, int gridCellCountY) {
	
		startX = viewportWidth - barWidth;
		startY = 0;
		endX = barWidth;
		endY = viewportHeight - barWidth;

		if( viewportCellCountY - gridCellCountY==0 ) showScrollBar = false;

		if ( showScrollBar ) {
			blockStartX = startX;
			blockStartY = startY;
			blockEndX = endX;
			blockEndY = round( (viewportCellCountY*cellHeight) / ( (gridCellCountY*cellHeight) / (viewportCellCountY*cellHeight) ) );
			blockLength = blockEndY - blockStartY;
			//println("blockStartY="+blockStartY+", blockEndY="+blockEndY+", blockLength="+blockLength);
			
			iScrollByPixelX = round((viewportCellCountX*cellWidth)/10);
			iScrollByPixelY = round((viewportCellCountY*cellHeight)/10);
		}
	}

	bool isClicked(int mouseX, int mouseY) {
		if ( mouseX>=startX && mouseX<=(startX+endX)  &&  mouseY>=startY && mouseY<=endY) return true;
		else return false;
	}

	void moveUp() {
		int temp = 4;
		oViewport.setStartY( oViewport.getStartY()-temp );
		oGrid.moveUp( temp );
		//blockStartY = blockStartX-round(blockLength/2);
		blockStartY = blockStartY-iScrollByPixelX;
		oViewport.draw();
		
		//oGrid.moveUp(round(oViewport.getViewportCellCountY()/2));
		//blockStartY = blockStartY-round(blockLength/2);

	}

	void moveDown() {
		//oGrid.moveDown(round(oViewport.getViewportCellCountY()/2));
		//blockStartY = blockStartY+round(blockLength/2);
		//oViewport.draw();
		
		int temp = 4;
		oViewport.setStartY( oViewport.getStartY()+temp );
		oGrid.moveDown( temp );
		//blockStartX = blockStartX+round(blockLength/2);
		blockStartY = blockStartY+iScrollByPixelY;
		oViewport.draw();
	}

	void handleClick(int mouseX, int mouseY) {
		if (mouseY < blockStartY) { 
			moveUp();	
		} else if (mouseY > blockEndY) { 
			moveDown();
		}
	}

}



class cHScrollBar extends cScrollBar {

	cHScrollBar(int viewportWidth, int viewportHeight, int viewportCellCountX, int viewportCellCountY, int gridCellCountX, int gridCellCountY) {
	
		startX = 0;
		startY = viewportHeight - barWidth;
		endX = viewportWidth - barWidth;
		endY = barWidth;

		if( viewportCellCountX - gridCellCountX==0 ) showScrollBar = false;

		if ( showScrollBar ) {
			blockStartX = startX;
			blockStartY = startY;
			blockEndX = round( (viewportCellCountX*cellWidth) / ( (gridCellCountX*cellWidth) / (viewportCellCountX*cellWidth) ) );
			blockEndY = endY;
			blockLength = blockEndX - blockStartX;
			
			iScrollByPixelX = round((viewportCellCountX*cellWidth)/10);
			iScrollByPixelY = round((viewportCellCountY*cellHeight)/10);
		}
	}

	bool isClicked(int mouseX, int mouseY) {
		if ( mouseX>=startX && mouseX<=endX  &&  mouseY>=startY && mouseY<=(startY+endY) ) return true;
		else return false;
	}

	void moveLeft() {
		int temp = 8;
		oViewport.setStartX( oViewport.getStartX()-temp );
		oGrid.moveLeft( temp );
		//blockStartX = blockStartX-round(blockLength/2);
		blockStartX = blockStartX-iScrollByPixelX;
		oViewport.draw();
	}

	void moveRight() {
		int temp = 8;
		oViewport.setStartX( oViewport.getStartX()+temp );
		oGrid.moveRight( temp );
		//blockStartX = blockStartX+round(blockLength/2);
		blockStartX = blockStartX+iScrollByPixelX;
		oViewport.draw();
	}

	void handleClick(int mouseX, int mouseY) {
		if (mouseX < blockStartX) { // move left
			moveLeft();
		} else if (mouseX > blockEndX) { // move right
			moveRight();
		}
	}


}

