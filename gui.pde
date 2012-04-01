
class cViewport {

	int viewportWidth;
	int viewportHeight;

	int viewportCellCountX;
	int viewportCellCountY;
	
	int iStartX;
	int iStartY;
	
	int ScrollBarWidth;

	cViewport(int gridCellCountX, int gridCellCountY, int viewportCellCountX_, int viewportCellCountY_) {
	
		iStartX=1;
		iStartY=1;
	
		viewportCellCountX = viewportCellCountX_;
		viewportCellCountY = viewportCellCountY_;
	
		viewportWidth = (viewportCellCountX*cellWidth)+cellWidth; 
		viewportHeight = (viewportCellCountY*cellHeight)+cellHeight;

		oVScrollBar = new cVScrollBar(viewportWidth, viewportHeight, viewportCellCountX, viewportCellCountY, gridCellCountX, gridCellCountY); 
		oHScrollBar = new cHScrollBar(viewportWidth, viewportHeight, viewportCellCountX, viewportCellCountY, gridCellCountX, gridCellCountY); 

		//println("create grid...gridCellCountX="+ gridCellCountX  +", gridCellCountY="+gridCellCountY);

		oGrid = new cGrid(gridCellCountX, gridCellCountY, iStartX, iStartY); 
		
		ScrollBarWidth = cellWidth;

	}

	void resize(int gridCellCountX, int gridCellCountY, int viewportCellCountX_, int viewportCellCountY_) {
	
		iStartX=1;
		iStartY=1;
	
		//println("in viewport.resize...viewportCellCountX="+ viewportCellCountX  +", viewportCellCountY="+viewportCellCountY);
		
		viewportCellCountX = viewportCellCountX_;
		viewportCellCountY = viewportCellCountY_;
		
		//println("in viewport.resize...viewportCellCountX="+ viewportCellCountX  +", viewportCellCountY="+viewportCellCountY);
	
		viewportWidth = (viewportCellCountX*cellWidth)+cellWidth; 
		viewportHeight = (viewportCellCountY*cellHeight)+cellHeight;

		oVScrollBar = new cVScrollBar(viewportWidth, viewportHeight, viewportCellCountX, viewportCellCountY, gridCellCountX, gridCellCountY); 
		oHScrollBar = new cHScrollBar(viewportWidth, viewportHeight, viewportCellCountX, viewportCellCountY, gridCellCountX, gridCellCountY); 

		//oGrid = new cGrid(gridCellCountX, gridCellCountY, iStartX, iStartY);
		oGrid.resize(gridCellCountX, gridCellCountY, iStartX, iStartY);  
		//oGrid.resize(viewportCellCountX_, viewportCellCountY_, iStartX, iStartY);  
		
		ScrollBarWidth = 15;

	}

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
	
		//println("debug: in viewport.draw()");
		
		background(#FFFFFF);
		fill(0);
		rect(0,0,viewportWidth-ScrollBarWidth,viewportHeight-ScrollBarWidth);
		noStroke();
		
		oVScrollBar.draw();
		oHScrollBar.draw();

		oGrid.draw();
		//oCityList.Draw();
		oUnitList.Draw();
		oPanelCityList.show();
		oPanelIslandList.show();
		
		if ( GameState==4 ) {

			switch( iMapSize ) {
				case 1:
					oPanelMap.show();
					break;
				case 2:
					oPanelMap.show();
					break;
				case 100:
					// do nothing
					break;

			}


		}
		
		//oPanel2.show();

		//redraw();
	}
	
	bool isCellWithinViewport(int x_, int y_) {
	
		if ( 	x_ >= oGrid.getShowFromCellX() && 
			x_ <= (oGrid.getShowFromCellX()+getViewportCellCountX()-1)   
			&&   
			y_ >= oGrid.getShowFromCellY() && 
			y_ <= (oGrid.getShowFromCellY()+getViewportCellCountY()-1) )  {
			
			return true;
		} else 
			return false;	
	}

	void scrollIfAppropriate(int x_, int y_) {

		int iMargin=1;
		bool bRedraw=false;

		if( getViewportCellCountX() - oGrid.getCellCountX()!=0 ) { 

			//switch( oWorld.getScenario() ) {
			switch( iMapSize ) {
				case 1:
					iMargin=2;
					break;
				case 2:
					iMargin=2;
					break;
			}

			//println("debug#1 iMargin="+iMargin);

			//println("debug halfX="+ (round(getViewportCellCountX()/2)) );
			//println("debug halfY="+ (round(getViewportCellCountY()/2)) );
		
			//int iHalfWidthX = round( ( getViewportCellCountX()-getStartX() ) /2 );
		
		
			//println("in adjustIfAppropriate("+x_+","+y_+") iHalfWidthX="+iHalfWidthX);
		
			int temp = x_-(iMargin);
			if ( temp < 1 ) temp=1;
			else if ( temp > (oGrid.getCellCountX()-getViewportCellCountX()-2) ) temp=(oGrid.getCellCountX()-getViewportCellCountX()-2);
			
			

			if ( (x_-iMargin)<1 ) { 
				oGrid.setShowFromCellX(1); bRedraw=true;
				//println("debug1: oGrid.setShowFromCellX=1");
				//println("debug gui/viewport... show from cell x 1");
			} else if ( x_ > (oGrid.getCellCountX()-iMargin) ) { 
				oGrid.setShowFromCellX( (oGrid.getCellCountX()-getViewportCellCountX()-1) ); bRedraw=true;
				//println("temp="+temp+" x_="+x_);
				//println("debug gui/viewport... x is greater than");
				//println("debug2: oGrid.setShowFromCellX="+ (oGrid.getCellCountX()-getViewportCellCountX()-1) );
			} else if ( x_ < (oGrid.getShowFromCellX()+iMargin) ) { 
				oGrid.setShowFromCellX( temp ); bRedraw=true;
				//println("temp="+temp+" x_="+x_);
				//println("debug gui/viewport... x is less than");
				//println("debug3: x_"+x_+", (oGrid.getShowFromCellX()+iMargin)="+(oGrid.getShowFromCellX()+iMargin)  );
			} else if ( x_ > (oGrid.getShowFromCellX()+getViewportCellCountX()-iMargin) ) { 
				oGrid.setShowFromCellX( temp ); bRedraw=true;
				//println("temp="+temp+" x_="+x_);
				//println("debug gui/viewport... x is greater than 2nd  "+ (oGrid.getShowFromCellX()+getViewportCellCountX()-iMargin) );
				//println("debug4: x_"+x_+", (getViewportCellCountX()-iMargin)="+(getViewportCellCountX()-iMargin)  );
				//println("");
			}


			//println("debug#2");

			temp = y_-iMargin;
			if ( temp < 1 ) temp=1;
			else if ( temp > (oGrid.getCellCountY()-getViewportCellCountY()-2) ) temp=(oGrid.getCellCountY()-getViewportCellCountY()-2);
			
			

			if ( (y_-iMargin)<1 ) { 
				oGrid.setShowFromCellY(1); bRedraw=true;
				//println("debug gui/viewport... show from cell y 1");
			} else if ( y_ > (oGrid.getCellCountY()-iMargin) ) { 
				oGrid.setShowFromCellY( (oGrid.getCellCountY()-getViewportCellCountY()-1) ); bRedraw=true;
				//println("temp="+temp+" y_="+y_);
				//println("debug gui/viewport... y is greater than");
			} else if ( y_ < (oGrid.getShowFromCellY()+iMargin) ) { 
				oGrid.setShowFromCellY( temp ); bRedraw=true;
				//println("temp="+temp+" y_="+y_);
				//println("debug gui/viewport... y is less than");
				//println("debug3: y_"+y_+", (oGrid.getShowFromCellY()+iMargin)="+(oGrid.getShowFromCellY()+iMargin)  );
			} else if ( y_ > (oGrid.getShowFromCellY()+getViewportCellCountY()-iMargin) ) { 
				oGrid.setShowFromCellY( temp ); bRedraw=true;
				//println("temp="+temp+" y_="+y_);
				//println("debug gui/viewport... y is greater than 2nd  "+ (oGrid.getShowFromCellY()+getViewportCellCountY()-iMargin) );
				//println("debug4: y_"+y_+", (getViewportCellCountY()-iMargin)="+(getViewportCellCountY()-iMargin)  );
				//println("");
			}

			oHScrollBar.setBlockStartX( (oGrid.getShowFromCellX()*8) );
			oVScrollBar.setBlockStartY( (oGrid.getShowFromCellY()*8) );

			if ( bRedraw ) oViewport.draw();

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
		
		objWidth = 210;
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

			/* The noStroke() function disables drawing the stroke (outline). If both <b>noStroke()</b> and
	      	   <b>noFill()</b> are called, no shapes will be drawn to the screen.
			*/
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

