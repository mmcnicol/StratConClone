
/* @pjs preload="images/sea.png,images/land.png,images/city0.png,images/city1.png,images/city2.png,images/tank1.png,images/tank2.png,images/fighter1.png,images/fighter2.png,images/battleship1.png,images/battleship2.png,images/bomber1.png,images/bomber2.png,images/carrier1.png,images/carrier2.png,images/destroyer1.png,images/destroyer2.png,images/transport1.png,images/transport2.png,images/submarine1.png,images/submarine2.png"; */

PImage imgSea, imgLand, imgCity0, imgCity1, imgCity2, imgTank1, imgTank2, imgFighter1, imgFighter2, imgBattleship1, imgBattleship2, imgBomber1, imgBomber2, imgCarrier1, imgCarrier2, imgDestroyer1, imgDestroyer2, imgTransport1, imgTransport2, imgSubmarine1, imgSubmarine2;  

PFont FontA;

string GAMETITLE="StratConClone";
string GAMEVERSION="version 0.41";

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
cDialogueStartup oDialogueStartup;
cDialogueCityProduction oDialogueCityProduction;
cGameEngine oGameEngine; 

int cellWidth=16;
int cellHeight=16;
int GameState=0; // 0=init, 1=startup diag, 2=startup diag closed, 3= initial city production, 4=play, 5=pause, 6=surrender?, 99=end
int iPlayer1Mode=1; // 1=human, 2=computer.
int iMapSize=1; // 1=Small (45x25), 2=large (90x50)

void setup() {
	
	//size( oViewport.getWidth()+oPanel1.getWidth(), oViewport.getHeight() );

	size( 930, 460 );

	frameRate(4);
	background(0);
	
	//FontA = loadFont("Arial");
	FontA = loadFont("Courier New");
	textFont(FontA);
	
	fill(255);
	//textSize(26);
	//text("generating map...",(width/2)-90,height/2);
	
	
	textSize(12);
	noStroke();
	//redraw();
	



	//oWorld = new cWorld(0);
	oWorld = new cWorld();
	oAnimate = new cAnimate();
	oPlayer1 = new cPlayer(1, false);
	oPlayer2 = new cPlayer(2, true);
	oGeometry = new cGeometry();

}


void draw() { 

	//println("debug 1: GameState="+GameState);
	
	if(GameState!=99) {

		if ( GameState==4) {
			
			oPanel1.update();
			oAnimate.do();

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

			//switch( oWorld.getScenario() ) {
			switch( iMapSize ) {
			
				case 1:
					oViewport = new cViewport(45, 25, 45, 25); 
					break;
				case 2:
					oViewport = new cViewport(90, 50, 45, 25); 
					break;
			}

			oPanel1 = new cPanel1(0,45);
			oPanel2 = new cPanel2(height-20,20);
			
			oPanelSelectedCity = new cPanelSelectedCity(160,100);
			
			oPanelSelectedUnit = new cPanelSelectedUnit(260,80);	
			
			oPanelMap = new cPanelMap(50,102);
			
			oGameEngine = new cGameEngine(); 
			
			
			oDialogueStartup = new cDialogueStartup(157,200);
			oDialogueCityProduction = new cDialogueCityProduction(157,200);
			oDialogueSurrender = new cDialogueSurrender(157,200);
			
			oViewport.draw();
			
			oDialogueStartup.show();
			
		}
		
		
		
		if ( GameState==2 ) {
			
			GameState=3;
			//println("debug#2");

			switch( iMapSize ) {
			
				case 1:
					oViewport.resize(45, 25, 45, 25); 
					break;
				case 2:
					oViewport.resize(90, 50, 45, 25); 
					break;
			}

			oGrid.generate();
			
			//println("debug#3");
			// show the city production panel for the human player 1 first city
			int iCityListId = oCityList.getPlayerFirstCityListId(1);
			oCityList.clearFogOfWar(iCityListId);
			
			println("debug#4");
			if ( oPlayer1.getIsAI() ) {
				//println("debug#5");
				oCityList.clearFogOfWar(iCityListId);
				oCityList.setCityProductionUnitTypeId(iCityListId, 0);
				oViewport.draw();
				//println("debug#6");
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
	
		imgSea = loadImage("images/sea.png");
		imgLand = loadImage("images/land.png");
		imgCity0 = loadImage("images/city0.png");
		imgCity1 = loadImage("images/city1.png");
		imgCity2 = loadImage("images/city2.png");
		imgTank1 = loadImage("images/tank1.png");
		imgTank2 = loadImage("images/tank2.png");
		imgFighter1 = loadImage("images/fighter1.png");
		imgFighter2 = loadImage("images/fighter2.png");

		imgBattleship1 = loadImage("images/battleship1.png");
		imgBattleship2 = loadImage("images/battleship2.png");

		imgBomber1 = loadImage("images/bomber1.png");
		imgBomber2 = loadImage("images/bomber2.png");

		imgCarrier1 = loadImage("images/carrier1.png");
		imgCarrier2 = loadImage("images/carrier2.png");

		imgDestroyer1 = loadImage("images/destroyer1.png");
		imgDestroyer2 = loadImage("images/destroyer2.png");

		imgTransport1 = loadImage("images/transport1.png");
		imgTransport2 = loadImage("images/transport2.png");

		imgSubmarine1 = loadImage("images/submarine1.png");
		imgSubmarine2 = loadImage("images/submarine2.png");
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
		return showCellFrom_-1+int(floor((coord_+15)/16));
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






