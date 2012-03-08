
class cPanel {

	int panelStartX, panelStartY, panelWidth, panelHeight;
	bool bActive;
	int iLineNumber;
	int iSpaceHeight;
	int iLeftTextIndent;
		
	cPanel(int panelStartY_, int panelHeight_) {
	
		panelStartX = oViewport.getWidth()+5;
		panelStartY = panelStartY_;
		panelWidth = 210;
		panelHeight = panelHeight_;
		
		bActive=false; // when active, system checks for mouse clicks. use if panel contains clickable items.
		
		iSpaceHeight=16;
		iLeftTextIndent=8;
	}

	int getWidth() { return panelWidth; }
	
	bool isActive() { return bActive; } 
	
	void clear(int fillValue_) {
		noStroke();
		fill(fillValue_);
		rect(panelStartX, panelStartY, panelWidth, panelHeight );	
	}

	
	void hide() {
		fill(255);
		rect(panelStartX, panelStartY, panelWidth, panelHeight );	
		redraw();
	}
	
	
}




/* ====================================================================================
   this panel displays mouse/cursor grid location and screen coordinates.
*/
class cPanel1 extends cPanel {

	cPanel1(int panelStartY_, int panelHeight_) {
		super(panelStartY_, panelHeight_);
	}
	
	void update() {
		
		clear(255);
		
		fill(0); //fill(255,0,0);
		int cellY=oGrid.getShowFromCellY()-1+int(floor((mouseY+16)/16));
		int cellX=oGrid.getShowFromCellX()-1+int(floor((mouseX+16)/16));

		iSpaceHeight=10;
		iLineNumber=1;
		textSize(11);

		text("     day: "+ oGameEngine.getDayNumber(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		
		
		// only display when mouse/cursor is within the viewport
		if ( mouseX > 0 && mouseY > 0 && mouseX < oViewport.getWidth() && mouseY < oViewport.getHeight() ) {
			
			iLineNumber++;
			text("    grid: "+ nf(cellX,3) + ","+nf(cellY,3), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
			
			iLineNumber++;
			text("   coord: "+nf(mouseX,3) + "," + nf(mouseY,3), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
			
			int iDistanceInCells=oGeometry.getDistanceInCells();
			if (iDistanceInCells!=-1) {
				iLineNumber++;
				text("distance: "+iDistanceInCells, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
			}
			
		}
		
		textSize(12);
		
		//color c1 = color(255, 120, 0);
		//set(10, 10, c1);		
	}
}



/* ====================================================================================
   this panel displays current player.
*/
class cPanel2 extends cPanel {

	cPanel2(int panelStartY_, int panelHeight_) {
		super(panelStartY_, panelHeight_);
		panelStartX = 5;
		panelWidth=95;
		//println("leaving cPanel2 constructor");
	}
	
	void show() {
		
		if ( GameState==4 ) {
			//println("in cPanel2.show()");
			clear(255);
			fill(50);
			textSize(12);
			text("Player "+oGameEngine.getCurrentPlayerId()+" turn", panelStartX+2, panelStartY+10);
		}
	}
}



/* ====================================================================================
   this panel displays information about the currently selected unit
*/
class cPanelSelectedUnit extends cPanel {

	cPanelSelectedUnit(int panelStartY_, int panelHeight_) {
	
		super(panelStartY_, panelHeight_);
		
		panelStartX=120;
		panelWidth=450;
	}
	
	void show(string unitName_, int location_, int strength_, int fuel_, int movesLeftToday_) {
		
		clear(255);
		
		fill(0); //fill(255,0,0);
		
		textSize(12);

		string strMsg = "";
		
		if ( fuel_==-1 ) strMsg = unitName_ +", strength "+ strength_ +", "+ movesLeftToday_ +" moves left, at "+location_
		else strMsg = unitName_ +", strength "+ strength_ +", fuel: "+ fuel_ +", "+ movesLeftToday_ +" moves left, at "+location_
		
		
		text(strMsg, panelStartX+2, panelStartY+10);

		
		/*
		iLineNumber=1;
				
		text("      unit: "+unitName_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		
		text("  location: "+location_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		
		text("  strength: "+strength_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		
		if ( fuel_!=-1 ) {
			text("      fuel: "+fuel_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
			iLineNumber++;
		}
		
		text("moves left: "+movesLeftToday_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		*/
		
	}
}



/* ====================================================================================
   this panel displays information about the currently selected city
*/
class cPanelSelectedCity extends cPanel {

	int iSpaceHeight;
	cButton oButtonProduction;

	cPanelSelectedCity(int panelStartY_, int panelHeight_) {
		super(panelStartY_, panelHeight_);
		
		iSpaceHeight=14;
		
		oButtonProduction = new cButton(999, "Change Production", panelStartX+iLeftTextIndent, panelStartY+(iSpaceHeight*6)); 
	}
	
	void show(int location_, string productionUnitTypeName_, int productionDaysLeft_, int unitCount_) {
		
		clear(255);
		
		fill(0); //fill(255,0,0);
		int iLineNumber=1;
		textSize(12);
		
		text("          city", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		
		text("      location: "+location_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;

		text("    unit count: "+unitCount_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		
		text("prod days left: "+productionDaysLeft_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		
		text("     prod unit: "+productionUnitTypeName_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));

		oButtonProduction.display();
		
		bActive=true;
		
		//redraw();
	}

	
	void handleEvent(int x_, int y_) {
	
		if ( oButtonProduction.isClicked(x_, y_) ) {
		
			int selectedCityListId = oGameEngine.getSelectedCityListId();
			if (selectedCityListId!=-1)
				oDialogueCityProduction.show( selectedCityListId );
			//bActive=false;
			//hide();
		}
		
	}
	
	
}





/* ====================================================================================
   this panel displays a small map of the generated world
*/
class cPanelMap extends cPanel {

	cPanelMap(int panelStartY_, int panelHeight_) {
		super(panelStartY_, panelHeight_);
		
		panelStartX = oViewport.getWidth()+25;
	}
	
	void show() {
		
		//clear();
		oGrid.drawMap(panelStartX, panelStartY);
	}
}



