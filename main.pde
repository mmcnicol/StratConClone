
/* @pjs preload="images/16x16/sea.png,images/16x16/land.png,images/16x16/city0.png,images/16x16/city1.png,images/16x16/city2.png,images/16x16/tank1.png,images/16x16/tank2.png,images/16x16/fighter1.png,images/16x16/fighter2.png,images/16x16/battleship1.png,images/16x16/battleship2.png,images/16x16/bomber1.png,images/16x16/bomber2.png,images/16x16/carrier1.png,images/16x16/carrier2.png,images/16x16/destroyer1.png,images/16x16/destroyer2.png,images/16x16/transport1.png,images/16x16/transport2.png,images/16x16/submarine1.png,images/16x16/submarine2.png"; */

PImage imgSea, imgLand, imgCity0, imgCity1, imgCity2, imgTank1, imgTank2, imgFighter1, imgFighter2, imgBattleship1, imgBattleship2, imgBomber1, imgBomber2, imgCarrier1, imgCarrier2, imgDestroyer1, imgDestroyer2, imgTransport1, imgTransport2, imgSubmarine1, imgSubmarine2;  

PFont FontA;

string GAMETITLE="StratConClone";
string GAMEVERSION="version 0.45";

cWorld oWorld;
cAnimate oAnimate;
cPlayer oPlayer1;
cPlayer oPlayer2;
cGeometry oGeometry;
cGridCell oGridCell;
cViewport oViewport;
cVScrollBar oVScrollBar;
cHScrollBar oHScrollBar;
cGrid oGrid;
cUnitRef[] oUnitRef = new cUnitRef[9]; 
cIslandList oIslandList;
cCityList oCityList;
cUnitList oUnitList; 
cPanel1 oPanel1;
cPanel2 oPanel2;
cPanelSelectedUnit oPanelSelectedUnit;
cPanelSelectedCity oPanelSelectedCity;
cPanelMap oPanelMap;
cPanelMapPlayer2 oPanelMapPlayer2;
cPanelCityList oPanelCityList;
cPanelIslandList oPanelIslandList;
cPanelPlayerUnitCounts oPanelPlayer1UnitCounts;
cPanelPlayerUnitCounts oPanelPlayer2UnitCounts;
cDialogueStartup oDialogueStartup;
cDialogueCityProduction oDialogueCityProduction;
cGameEngine oGameEngine; 

int cellWidth=16;
int cellHeight=16;
//int cellWidth=32;
//int cellHeight=32;

int iNumberIndent=1;
int GameState=0; // 0=init, 1=startup diag, 2=startup diag closed, 3= initial city production, 4=play, 5=pause, 6=surrender?, 99=end
int iPlayer1Mode=1; // 1=human, 2=computer.
int iMapSize=2; // 1=Small (45x25), 2=large (90x50)
//int iNumberTextSize=10;
//int iStringTextSize=18;
int iNumberTextSize=6;
int iStringTextSize=11;
bool ShowFogOfWar=true;

int iNumberOfUnitTypes=9;

void setup() {
	
	//size( oViewport.getWidth()+oPanel1.getWidth(), oViewport.getHeight() );

	//size( 1000, 620 );
	size( 1000, 2000 );

	frameRate(10);
	background(0);
	
	//FontA = loadFont("Arial");
	FontA = loadFont("Courier New");
	textFont(FontA);
	
	fill(255);
	//textSize(26);
	//text("generating map...",(width/2)-90,height/2);
	
	
	textSize(iStringTextSize);
	noStroke();
	//redraw();
	



	//oWorld = new cWorld(0);
	oWorld = new cWorld();
	oAnimate = new cAnimate();
	oPlayer1 = new cPlayer(1, false);
	oPlayer2 = new cPlayer(2, true);
	oGeometry = new cGeometry();
	//oGrid = new cGrid();

}


void draw() { 

	//println("debug 1: GameState="+GameState);
	
	if(GameState!=99) {

		if ( GameState==4) {
			
			oPanel1.update();
			oAnimate.do();
			//oPanelCityList.show();

			//oViewport.printWidth();

			//oViewport.draw();
		
			if ( oDialogueCityProduction.isActive()==false && oDialogueSurrender.isActive()==false && oGameEngine.isIdle() ) {
				oGameEngine.doPlayerMove();

			} //else println("oDialogueCityProduction.isActive()==true");

			//stroke(255,255,255,255);
			//stroke(0,0,0);
			//fill(255,0,0);
			//line(30, 20, 85, 20);
			//background(204);
			//fill(255);
		}
		

		
		if ( GameState==0 ) {
			
			GameState=1;
		
			oWorld.loadImages();

			oWorld.setupUnitRefs();
			

			oIslandList = new cIslandList();	
			oCityList = new cCityList();
			oUnitList = new cUnitList(); 

			oGrid = new cGrid(80, 79, 1, 1); 

			//switch( oWorld.getScenario() ) {
			switch( iMapSize ) {
			
				case 1:
					//oViewport = new cViewport(45, 25, 45, 25); // 16x16
					//oViewport = new cViewport(22, 12, 22, 12); // 32x32
					oViewport = new cViewport(15, 8, 15, 8); // 32x32
					break;
				case 2:
					////oViewport = new cViewport(90, 50, 45, 25); // 16x16
					oViewport = new cViewport(80, 79, 40, 35); // 16x16
					//oViewport = new cViewport(90, 80, 20, 17); // 32x32
					////oViewport = new cViewport(120, 64, 15, 8); // 48x48
					break;
			}

			oPanel1 = new cPanel1(0,50);
			//oPanel2 = new cPanel2(height-30,20);
			oPanel2 = new cPanel2(590,20);
			
			oPanelSelectedCity = new cPanelSelectedCity(160,300);
			
			//oPanelSelectedUnit = new cPanelSelectedUnit(height-30,20);
			oPanelSelectedUnit = new cPanelSelectedUnit(590,20);
			
			oPanelMap = new cPanelMap(70 ,102, oViewport.getWidth()+25, 1);
			oPanelMapPlayer2 = new cPanelMapPlayer2(70, 102, oViewport.getWidth()+125, 2);
			
			oPanelIslandList = new cPanelIslandList(650,500);
			oPanelCityList = new cPanelCityList(1200,790);

			oPanelPlayer1UnitCounts = new cPanelPlayerUnitCounts(570, 650,190,1);
			oPanelPlayer2UnitCounts = new cPanelPlayerUnitCounts(790, 650,190,2);

			oGameEngine = new cGameEngine(); 
			
			
			oDialogueStartup = new cDialogueStartup(90,250);
			oDialogueCityProduction = new cDialogueCityProduction(90,250);
			oDialogueSurrender = new cDialogueSurrender(90,250);
			
			oViewport.draw();
			
			oDialogueStartup.show();
			
		}
		
		
		
		if ( GameState==2 ) {
			
			GameState=3;
			//println("debug#2");

			switch( iMapSize ) {
			
				case 1:
					//oViewport = new cViewport(45, 25, 45, 25); // 16x16
					//oViewport = new cViewport(44, 24, 22, 12); // 32x32
					oViewport = new cViewport(15, 8, 15, 8); // 32x32
					break;
				case 2:
					////oViewport = new cViewport(90, 50, 45, 25); // 16x16
					oViewport = new cViewport(80, 79, 40, 35); // 16x16
					//oViewport = new cViewport(90, 80, 20, 17); // 32x32
					////oViewport = new cViewport(120, 64, 15, 8); // 48x48
					break;
			}

			oGrid.generate();
			
			// show the city production panel for the human player 1 first city
			int iCityListId = oCityList.getPlayerFirstCityListId(1);

			oCityList.clearFogOfWarByPlayerId(1);
			
			if ( oPlayer1.getIsAI() ) {
			
				oCityList.clearFogOfWar(iCityListId);
				oCityList.setCityProductionUnitTypeId(iCityListId, 0);
				oViewport.draw();
			
				GameState=4;
				
			} else {
				//println("debug#7");
				oDialogueCityProduction.show(iCityListId);
				println("confirm initial city production to begin...");
			
			}


		}
		
		
		
	}

	
} 



class cWorld {

	//int iScenario;
	
	//cWorld(int iScenario_) {
	cWorld() {  
		//iScenario = iScenario_;
	}
	
	
	//int getScenario() { return iScenario; }
	
	
  	void setpix(int x, int y, int c) {
    		set(x, y, c);
	}
  
  	color getpix(int x, int y) {
  		return get(x, y);
  	}
  
  
  
	void setupUnitRefs() {

		println("debug: in setupunitrefs ");
		
		// UnitTypeId, UnitName, daysToProduce, strength, attackRange, caputuresCity, movesOnLand, movesOnWater, movesPerTurn, maxFuel

		oUnitRef[0] = new cUnitRef(0, "Tank",        4,  2, 1,  true,  true, false,  2, -1);
		oUnitRef[1] = new cUnitRef(1, "Fighter",     6,  1, 1, false,  true,  true, 20, 20);

		oUnitRef[2] = new cUnitRef(2, "Battleship", 20, 18, 4, false, false,  true,  3, -1);
		oUnitRef[3] = new cUnitRef(3, "Bomber",     25,  1, 1, false, true,  true, 10, 30);
		oUnitRef[4] = new cUnitRef(4, "Carrier",    10, 12, 1, false, false,  true,  3, -1);
		oUnitRef[5] = new cUnitRef(5, "Destroyer",   8,  3, 1, false, false,  true,  4, -1);
		oUnitRef[6] = new cUnitRef(6, "Transport",   8,  3, 1, false, false,  true,  3, -1);
		oUnitRef[7] = new cUnitRef(7, "Submarine",   8,  3, 1, false, false,  true,  3, -1);

		oUnitRef[8] = new cUnitRef(8, "Artillery",   4,  1, 4,  true,  true, false,  1, -1);
		oUnitRef[9] = new cUnitRef(9, "Helicopter",  8,  1, 1, false,  true,  true, 10, 10);

		//oUnitRef[0].print();
		//oUnitRef[1].print();
	}


	void loadImages() {
	
		println("debug: in loadimages");
	
		imgSea = loadImage("images/16x16/sea.png");
		imgLand = loadImage("images/16x16/land.png");
		imgCity0 = loadImage("images/16x16/city0.png");
		imgCity1 = loadImage("images/16x16/city1.png");
		imgCity2 = loadImage("images/16x16/city2.png");
		imgTank1 = loadImage("images/16x16/tank1.png");
		imgTank2 = loadImage("images/16x16/tank2.png");
		imgFighter1 = loadImage("images/16x16/fighter1.png");
		imgFighter2 = loadImage("images/16x16/fighter2.png");

		imgBattleship1 = loadImage("images/16x16/battleship1.png");
		imgBattleship2 = loadImage("images/16x16/battleship2.png");

		imgBomber1 = loadImage("images/16x16/bomber1.png");
		imgBomber2 = loadImage("images/16x16/bomber2.png");

		imgCarrier1 = loadImage("images/16x16/carrier1.png");
		imgCarrier2 = loadImage("images/16x16/carrier2.png");

		imgDestroyer1 = loadImage("images/16x16/destroyer1.png");
		imgDestroyer2 = loadImage("images/16x16/destroyer2.png");

		imgTransport1 = loadImage("images/16x16/transport1.png");
		imgTransport2 = loadImage("images/16x16/transport2.png");

		imgSubmarine1 = loadImage("images/16x16/submarine1.png");
		imgSubmarine2 = loadImage("images/16x16/submarine2.png");
	}
  
}




class cGameIsland {

	int iPlayerId;
	int iCellX;
	int iCellY;

	cGameIsland(int iPlayerId_, int iCellX_, int iCellY_) {
		iPlayerId=iPlayerId_;
		iCellX=iCellX_;
		iCellY=iCellY_;
	}

}




class cGeometry {

	int distanceInCells, sX, sY, eX, eY;
	
	cGeometry() { }
	
	// coord = mouse (pixels), a screen coordinate.
	// cell = a viewport grid square.
	
	int translateCoordToCell(int showCellFrom_, int coord_) {
		return showCellFrom_-1+int(floor((coord_+(cellWidth-1))/cellWidth));
	}
	
	void distanceDragBegin(int sX_, int sY_, int eX_, int eY_) { 
	
		sX=translateCoordToCell(oGrid.getShowFromCellX(), sX_);
		sY=translateCoordToCell(oGrid.getShowFromCellY(), sY_);
		
		eX=translateCoordToCell(oGrid.getShowFromCellX(), eX_);
		eY=translateCoordToCell(oGrid.getShowFromCellY(), eY_);
		
		distanceInCells=max( abs(sX-eX), abs(sY-eY) );
	}
	
	void distanceDragEnd() { distanceInCells=-1; }
	
	int getDistanceInCells() { return distanceInCells; }
	
}




class cGridCell {

	int x,y;
	cGridCell(int x_,int y_) {
		x=x_;
		y=y_;
	}

	int getX() { return x; }
	int getY() { return y; }
}



/************************************************************************
	String functions
************************************************************************/
string LPAD(string str_, int length_) {

	while (str_.length() < length_) {
		str_=" "+str_;
	}
	return str_;
}

string RPAD(string str_, int length_) {

	while (str_.length() < length_) {
		str_=str_+" ";
	}
	return str_;
}




