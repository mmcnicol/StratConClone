
class cPanel {

	int panelStartX, panelStartY, panelWidth, panelHeight;
	bool bActive;
	int iLineNumber;
	int iSpaceHeight;
	int iLeftTextIndent;
		
	cPanel(int panelStartY_, int panelHeight_) {
	
		panelStartX = oViewport.getWidth()+5;
		panelStartY = panelStartY_+2;
		panelWidth = 210;
		panelHeight = panelHeight_;
		
		bActive=false; // when active, system checks for mouse clicks. use if panel contains clickable items.
		
		iSpaceHeight=cellHeight+2;
		iLeftTextIndent=(cellWidth/2);
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
		int cellY=oGrid.getShowFromCellY()-1+int(floor((mouseY+cellHeight)/cellHeight));
		int cellX=oGrid.getShowFromCellX()-1+int(floor((mouseX+cellWidth)/cellWidth));

		iSpaceHeight=iNumberTextSize+3;
		iLineNumber=1;
		
		setTextSizeString();
		text("     day: "+ oGameEngine.getDayNumber(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		
		
		// only display when mouse/cursor is within the viewport
		if ( mouseX > 0 && mouseY > 0 && mouseX < oViewport.getWidth() && mouseY < oViewport.getHeight() ) {
			
			iLineNumber++;
			//setTextSizeString();
			text("    grid: "+ nf(cellX,3) + ","+nf(cellY,3), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
			
			iLineNumber++;
			//setTextSizeString();
			text("   coord: "+nf(mouseX,3) + "," + nf(mouseY,3), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
			
			int iDistanceInCells=oGeometry.getDistanceInCells();
			if (iDistanceInCells!=-1) {
				iLineNumber++;
				//setTextSizeString();
				text("distance: "+iDistanceInCells, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
			}
			
		}
		
		//setTextSizeString();
		
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
			setTextSizeString();
			text("Player "+oGameEngine.getCurrentPlayerId()+" turn", panelStartX+2, panelStartY+14);
		}
	}
}



/* ====================================================================================
   this panel displays information about the currently selected unit
*/
class cPanelSelectedUnit extends cPanel {

	cPanelSelectedUnit(int panelStartY_, int panelHeight_) {
	
		super(panelStartY_, panelHeight_);
		
		panelStartX=170;
		panelWidth=450;
	}
	
	void show(string unitName_, int location_, int strength_, int fuel_, int movesLeftToday_) {
		
		clear(255);
		
		fill(0); //fill(255,0,0);
		
		setTextSizeString();

		string strMsg = "";
		
		if ( fuel_==-1 ) strMsg = unitName_ +", strength "+ strength_ +", "+ movesLeftToday_ +" moves left, at "+location_
		else strMsg = unitName_ +", strength "+ strength_ +", fuel: "+ fuel_ +", "+ movesLeftToday_ +" moves left, at "+location_
		
		
		text(strMsg, panelStartX+2, panelStartY+14);

		
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
		
		iSpaceHeight=iNumberTextSize+3;
		
		oButtonProduction = new cButton(999, "Change Production", panelStartX+iLeftTextIndent, panelStartY+(iSpaceHeight*7)); 
	}
	
	void show(int location_, string productionUnitTypeName_, int productionDaysLeft_, int unitCount_) {
		
		clear(255);
		
		fill(0); //fill(255,0,0);
		int iLineNumber=1;
		setTextSizeString();
		
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

	int iMapPlayerId=-1;

	cPanelMap(int panelStartY_, int panelHeight_, int panelStartX_, int iMapPlayerId_) {
		super(panelStartY_, panelHeight_);
		
		iMapPlayerId=iMapPlayerId_;
		//panelStartX = oViewport.getWidth()+25;
		panelStartX = panelStartX_;
		panelWidth = 85;
	}
	
	void show() {
		
		//clear(255);
		oGrid.drawMap(panelStartX, panelStartY, iMapPlayerId);
	}
}




/* ====================================================================================
   this panel displays a small map of the generated world
*/
class cPanelMapPlayer2 extends cPanel {

	int iMapPlayerId=-1;

	cPanelMapPlayer2(int panelStartY_, int panelHeight_, int panelStartX_, int iMapPlayerId_) {
		super(panelStartY_, panelHeight_);
		
		iMapPlayerId=iMapPlayerId_;
		//panelStartX = oViewport.getWidth()+25;
		panelStartX = panelStartX_;
		panelWidth = 85;
	}
	
	void show() {
		
		//clear(255);
		oGrid.drawMap(panelStartX, panelStartY, iMapPlayerId);
	}
}




/* ====================================================================================
   this panel displays a small map of valid player1 moves
*/
class cPanelMapMatrixValidMovesPlayer1 extends cPanel {

	int iMapPlayerId=1;

	cPanelMapMatrixValidMovesPlayer1(int panelStartY_, int panelHeight_, int panelStartX_) {
		super(panelStartY_, panelHeight_);
		
		//iMapPlayerId=iMapPlayerId_;
		panelStartX = panelStartX_;
		panelWidth = 230;
	}
	
	void show() {
		
		clear(255);
		oGrid.drawMapValidMove(panelStartX, panelStartY, iMapPlayerId);
	}
}


/* ====================================================================================
   this panel displays a small map of valid player1 moves
*/
class cPanelMapMatrixValidMovesPlayer2 extends cPanel {

	int iMapPlayerId=2;

	cPanelMapMatrixValidMovesPlayer2(int panelStartY_, int panelHeight_, int panelStartX_) {
		super(panelStartY_, panelHeight_);
		
		//iMapPlayerId=iMapPlayerId_;
		panelStartX = panelStartX_;
		panelWidth = 230;
	}
	
	void show() {
		
		clear(255);
		oGrid.drawMapValidMove(panelStartX, panelStartY, iMapPlayerId);
	}
}



/* ====================================================================================
   this panel displays information based on City List
*/
class cPanelCityList extends cPanel {

	int iSpaceHeight;
	int iLineNumber;
	//cButton oButtonProduction;

	cPanelCityList(int panelStartY_, int panelHeight_) {
		super(panelStartY_, panelHeight_);
		panelStartX = 5;
		panelWidth=500;
		iSpaceHeight=iNumberTextSize+3;
	}
	
	void show() {
		
		//clear(255);
		clear(200);
		
		fill(0); //fill(255,0,0);
		iLineNumber=1;
		setTextSizeString();

		//println("oCityList.getCount()...");
		//println("oCityList.getCount()" + oCityList.getCount() );
		text("City Count: " + oCityList.getCount(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		text("City List:", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		text("CityId | Status     | Location | IslandId | isPort | CurrentProduction", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		text("----------------------------------------------------------------------", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		
		oCityList.printIslandCityLocationsToPanelCityList();
	
	}

	void addLine(string str_) {
		text(str_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
	}
	
}





/* ====================================================================================
   this panel displays information based on Island List
*/
class cPanelIslandList extends cPanel {

	int iSpaceHeight;
	int iLineNumber;
	//cButton oButtonProduction;

	cPanelIslandList(int panelStartY_, int panelHeight_) {
		super(panelStartY_, panelHeight_);
		panelStartX = 5;
		panelWidth=500;
		iSpaceHeight=iNumberTextSize+3;
	}
	
	void show() {
		
		//clear(255);
		clear(230);
		
		fill(0); //fill(255,0,0);
		iLineNumber=1;
		setTextSizeString();
		
		text("Island Count: " + oIslandList.getCount(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		text("Island List:", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		text("IslandId | Status     | P1City | P2City | UnoccupiedCity", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		text("--------------------------------------------------------", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		oIslandList.printIslandListToPanelIslandList();
	
	}

	void addLine(string str_) {
		text(str_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
	}
	
}







/* ====================================================================================
   this panel displays information based on PlayerUnitCounts
*/
class cPanelPlayerUnitCounts extends cPanel {

	int iSpaceHeight;
	int iLineNumber;
	int iPlayerId;
	//cButton oButtonProduction;

	cPanelPlayerUnitCounts(int panelStartX_, int panelStartY_, int panelHeight_, int iPlayerId_) {
		super(panelStartY_, panelHeight_);
		panelStartX = panelStartX_;
		panelWidth=200;
		iSpaceHeight=iNumberTextSize+3;
		iPlayerId=iPlayerId_;
	}
	
	void show() {
		
		//println("in cPanelPlayerUnitCounts.show()...");

		//clear(255);
		clear(230);
		
		fill(0); //fill(255,0,0);
		iLineNumber=1;
		setTextSizeString();
		
		text("Player "+iPlayerId+" Unit Counts: ", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		text("Unit Type     | Count", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
		text("--------------------------", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;

		if (iPlayerId==1) oPlayer1.printUnitTypeCountsToPanel();
		else if (iPlayerId==2) oPlayer2.printUnitTypeCountsToPanel();
	
		//println("leaving cPanelPlayerUnitCounts.show()...");

	}

	void addLine(string str_) {
		text(str_, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));
		iLineNumber++;
	}
	
}




