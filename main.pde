
/* @pjs preload="images/16x16/sea.png,images/16x16/land.png,images/16x16/city0.png,images/16x16/city1.png,images/16x16/city2.png,images/16x16/tank1.png,images/16x16/tank2.png,images/16x16/fighter1.png,images/16x16/fighter2.png,images/16x16/battleship1.png,images/16x16/battleship2.png,images/16x16/bomber1.png,images/16x16/bomber2.png,images/16x16/carrier1.png,images/16x16/carrier2.png,images/16x16/destroyer1.png,images/16x16/destroyer2.png,images/16x16/transport1.png,images/16x16/transport2.png,images/16x16/submarine1.png,images/16x16/submarine2.png"; */

PImage imgSea, imgLand, imgCity0, imgCity1, imgCity2, imgTank1, imgTank2, imgFighter1, imgFighter2, imgBattleship1, imgBattleship2, imgBomber1, imgBomber2, imgCarrier1, imgCarrier2, imgDestroyer1, imgDestroyer2, imgTransport1, imgTransport2, imgSubmarine1, imgSubmarine2;  

PFont FontA;

string GAMETITLE="StratConClone";
string GAMEVERSION="version 0.48";


cWorld oWorld;
cUnitRef[] oUnitRef = new cUnitRef[9];  
cGridCell oGridCell;
cPlayer oPlayer1;
cPlayer oPlayer2;

cViewport oViewport;
cViewport oViewportPlayer2;
cVScrollBar oVScrollBar;
cHScrollBar oHScrollBar;


cAnimate oAnimate;  
cAnimateAttack oAnimateAttack;

cGeometry oGeometry;
cGrid oGrid;
cIslandList oIslandList;
cCityList oCityList;
cUnitList oUnitList; 
cIslandPolyList oIslandPolyList;  

cPanel1 oPanel1;
cPanel2 oPanel2;
cPanelGameMessageLine oPanelGameMessageLine;
cPanelSelectedCity oPanelSelectedCity;
cPanelMap oPanelMap;
cPanelMapPlayer2 oPanelMapPlayer2;
cPanelMapMatrixValidMovesPlayer1 oPanelMapMatrixValidMovesPlayer1;
cPanelMapMatrixValidMovesPlayer2 oPanelMapMatrixValidMovesPlayer2;
cPanelCityList oPanelCityList;
cPanelIslandList oPanelIslandList;
cPanelPlayerUnitCounts oPanelPlayer1UnitCounts;
cPanelPlayerUnitCounts oPanelPlayer2UnitCounts;
cDialogueStartup oDialogueStartup;
cDialogueCityProduction oDialogueCityProduction;
cGameEngine oGameEngine; 

cDoNothing oDoNothing;


int cellWidth=16;
int cellHeight=16;
//int cellWidth=32;
//int cellHeight=32;

int iNumberIndent=1;
int GameState=0; // 0=init, 1=startup diag, 2=startup diag closed, 3= initial city production, 4=play, 5=pause, 6=surrender?, 99=end
int iPlayer1Mode=1; // 1=human, 2=computer.
//int iMapSize=2; // 1=Small (45x25), 2=large (90x50)
int iNumberTextSize=6;
int iStringTextSize=10;
//int iNumberTextSize=6;
//int iStringTextSize=11;
int iNumberOfUnitTypes=9;

int  GridDrawMode					= 1;     // 1=normal images, 2=ScreenBuffer1
bool showViewportScrollBars			= false;
bool ShowFogOfWar					= true;
bool debugShowPlayer2Viewport		= true;
bool debugShowIslandIslandListId	= false;
bool debugShowCityIslandListId		= false;
bool debugShowUnitIslandListId		= false;
bool debugShowUnitMoveTo			= false;
bool debugShowUnitTaskStatus		= false;
bool debugShowCellGridLocation		= false;

bool debugTransport					= false;
bool debugCityAdd					= false;
bool debugCityProduction			= false;
bool debugSleep						= false;
bool debugMouseClick				= false;
bool debugAnimate					= false;
bool debugAnimateAttack				= false;
bool debugMove						= false;
bool debugDrawGrid					= false;
bool debugDrawViewport				= false;
bool debugDoNothing					= false;
bool debugGameState					= false;


PGraphics ScreenBuffer1;
//PImage ScreenBuffer1 = createImage(900, 900, RGB);

void setup() {
	
	//size( oViewport.getWidth()+oPanel1.getWidth(), oViewport.getHeight() );

	if ( debugShowCityIslandListId && debugShowUnitIslandListId ) {
		size( 1100, 1650 ); // width, height
	} else {
		size( 1000, 645 ); // width, height
	}
	//size( 1710, 2300 ); // width, height

	frameRate(7);
	background(0);
	
	//FontA = loadFont("Arial");
	FontA = loadFont("Courier New");
	textFont(FontA);

	
	setTextSizeString();
	noStroke();
	//redraw();

	//oWorld = new cWorld(0);
	oWorld = new cWorld();

	oAnimate = new cAnimate();  
	oAnimateAttack = new cAnimateAttack();

	oPlayer1 = new cPlayer(1, false);
	oPlayer2 = new cPlayer(2, true);

	oGeometry = new cGeometry();
	//oGrid = new cGrid();
	oDoNothing = new cDoNothing();
	oIslandPolyList = new cIslandPolyList();  


	// http://processingjs.org/reference/createGraphics_/

	//ScreenBuffer1 = createGraphics(1700, 1700, JAVA2D);

	//if ( GridDrawMode==2 ) ScreenBuffer1 = createGraphics(900, 900, JAVA2D);
	//if ( GridDrawMode==2 ) ScreenBuffer1 = createGraphics(1700, 1700, JAVA2D);
	if ( GridDrawMode==2 ) ScreenBuffer1 = createGraphics(1700, 1700, P2D);

}


void draw() { 
	
	if(GameState!=99) {

		if ( GameState==4) {
			
			oPanel1.update();
			oAnimate.do();
			oAnimateAttack.do();
			oDoNothing.do();
			//oPanelCityList.show();

			//oViewport.printWidth();

			//oViewport.draw();
		
			//if ( oDialogueCityProduction.isActive()==false && oDialogueSurrender.isActive()==false && oGameEngine.isIdle() ) {

			if ( oDialogueCityProduction.isActive()==false && 
				oDialogueSurrender.isActive()==false && 
				oAnimate.getAnimationInProgress()==false &&
				oAnimateAttack.getAttackAnimationInProgress()==false &&
				oDoNothing.getDoNothingInProgress()==false ) {

				//iCityListId = oCityList.getPlayerFirstCityListId(1);
				//println("debug: player 1 first iCityListId="+iCityListId);

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

			if (debugGameState) println("debug: GameState="+GameState);

			GameState=1;
		
			oWorld.loadImages();

			oWorld.setupUnitRefs();

			oWorld.showKeyboardShortcuts();
			
			oIslandList = new cIslandList();	
			oCityList = new cCityList();
			oUnitList = new cUnitList(); 

			oGrid = new cGrid(99, 99, 1, 1); 

			oViewport = new cViewport(1, 99, 99, 26, 18); // 16x16 (width, height)
			//oViewport = new cViewport(99, 99, 21, 18); // 32x32
			////oViewport = new cViewport(120, 64, 15, 8); // 48x48


			if (debugShowPlayer2Viewport) oViewportPlayer2 = new cViewport(2, 99, 99, 26, 18); // (width, height)


			oPanel1 = new cPanel1(0,50);
			//oPanel2 = new cPanel2(height-30,20);
			oPanel2 = new cPanel2(310,20);


			oPanelSelectedCity = new cPanelSelectedCity(160,100);
			
			oPanelGameMessageLine = new cPanelGameMessageLine(310,20);

			
			oPanelMap = new cPanelMap(10 ,80, oViewport.getWidth()+225, 1);
			oPanelMapPlayer2 = new cPanelMapPlayer2(360, 80, oViewport.getWidth()+225, 2);
			
			oPanelMapMatrixValidMovesPlayer1 = new cPanelMapMatrixValidMovesPlayer1(170, 160, oViewport.getWidth()+225);
			oPanelMapMatrixValidMovesPlayer2 = new cPanelMapMatrixValidMovesPlayer2(370, 160, oViewport.getWidth()+225);

			int listPanelStartY = 350;
			if (debugShowPlayer2Viewport) listPanelStartY = 700;
			oPanelIslandList = new cPanelIslandList(5, listPanelStartY, 400, 900);
			oPanelCityList = new cPanelCityList(500, listPanelStartY, 500, 900);

			oPanelPlayer1UnitCounts = new cPanelPlayerUnitCounts(656+130, 8, 180, 1);
			oPanelPlayer2UnitCounts = new cPanelPlayerUnitCounts(656+130, 358, 180, 2);

			oGameEngine = new cGameEngine(); 
			
			oDialogueStartup = new cDialogueStartup(90,170);
			oDialogueCityProduction = new cDialogueCityProduction(90,170);
			oDialogueSurrender = new cDialogueSurrender(90,170);
			
			//oViewport.draw();
			//if (debugShowPlayer2Viewport) oViewportPlayer2.draw();

			oDialogueStartup.show();
			
		}
		
		
		
		if ( GameState==2 ) { // startup dialogue closed

			if (debugGameState) println("debug: GameState="+GameState);

			GameState=3;

			background(0);

			fill(255);
			textSize(26);
			text("generating map...",(width/2)-90,height/2);

			oGrid.generate();
			
			//oViewport.draw();
			//if (debugShowPlayer2Viewport) oViewportPlayer2.draw();
			
			int iCityListId;
			iCityListId = oCityList.getPlayerFirstCityListId(1);
			println("debug: player 1 first iCityListId="+iCityListId);
			oCityList.clearFogOfWarByPlayerId(1);
			//oCityList.clearFogOfWar(iCityListId);

			background(0);
			oViewport.draw();
			
			if (debugShowPlayer2Viewport) {
				iCityListId = oCityList.getPlayerFirstCityListId(2);
				println("debug: player 2 first iCityListId="+iCityListId);
				oCityList.clearFogOfWarByPlayerId(2);
				//oCityList.clearFogOfWar(iCityListId);
				oViewportPlayer2.draw();
			}
			
			if ( GridDrawMode==2 ) oIslandPolyList.Draw4ScreenBuffer1(); 

				//copy(ScreenBuffer1,
				//	0,0,
				//	1700,1700,
				//	0,600,
				//	1700,1700);

			if ( oPlayer1.getIsAI() ) {

				//iCityListId = oCityList.getPlayerFirstCityListId(1);
				//oCityList.clearFogOfWar(iCityListId);
				//oCityList.setCityProductionUnitTypeId(iCityListId, 0);
				//oViewport.draw();
			
				GameState=4;
				
			} else {

				iCityListId = oCityList.getPlayerFirstCityListId(1);
				//oCityList.clearFogOfWar(iCityListId);

				//oIslandPolyList.Draw(); 
				//oIslandPolyList.Draw4Viewport();

				// show the city production panel for the human player 1 first city
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

		//println("debug: in setupunitrefs ");
		
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

	void showKeyboardShortcuts() {

		println("");
		println("KeyboardShortcuts:");
		println("N: Skip");
		println("S: Sleep");
		println("R: Random");
		println("W: Wake");
		println("M: Stack Move");
		println("");
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

		int ShowFromCellX, ShowFromCellY;

		if ( oGameEngine.getCurrentPlayerId()==1 ) { 
			ShowFromCellX = oPlayer1.getShowFromCellX();
			ShowFromCellY = oPlayer1.getShowFromCellY();
		} else {
			ShowFromCellX = oPlayer2.getShowFromCellX();
			ShowFromCellY = oPlayer2.getShowFromCellY();
		}
	
		sX=translateCoordToCell(ShowFromCellX, sX_);
		sY=translateCoordToCell(ShowFromCellY, sY_);
		
		eX=translateCoordToCell(ShowFromCellX, eX_);
		eY=translateCoordToCell(ShowFromCellY, eY_);
		
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
	Island Poly
************************************************************************/


class cIslandPolyList {

	ArrayList listIslandPoly;

	cIslandPolyList() {
		listIslandPoly = new ArrayList();  // Create an empty ArrayList
	}

	void Add(int[] pX_, int[] pY_, int count_) {
		
		//println("add island poly");		
		listIslandPoly.add( new cIslandPoly(pX_, pY_, count_) );  
	}

	void Draw() {

		for (int i = 0; i < listIslandPoly.size(); i++) { 
			cIslandPoly IslandPoly = (cIslandPoly) listIslandPoly.get( i );
			IslandPoly.Draw();
		}
	}

	void Draw4ScreenBuffer1() {

		for (int i = 0; i < listIslandPoly.size(); i++) { 
			cIslandPoly IslandPoly = (cIslandPoly) listIslandPoly.get( i );
			IslandPoly.Draw4ScreenBuffer1();
		}
	}

	void Draw4Viewport(int playerId_) {

		for (int i = 0; i < listIslandPoly.size(); i++) { 
			cIslandPoly IslandPoly = (cIslandPoly) listIslandPoly.get( i );
			IslandPoly.Draw4Viewport(playerId_);
		}
	}

	void Draw4Map(int sx_, int sy_) {

		for (int i = 0; i < listIslandPoly.size(); i++) { 
			cIslandPoly IslandPoly = (cIslandPoly) listIslandPoly.get( i );
			IslandPoly.Draw4Map(sx_, sy_);
		}

		
		int showFromX, showFromY;
		
		if ( oGameEngine.getCurrentPlayerId()==1 ) { 
			showFromX = oPlayer1.getShowFromCellX();
			showFromY = oPlayer1.getShowFromCellY();
		} else {
			showFromX = oPlayer2.getShowFromCellX();
			showFromY = oPlayer2.getShowFromCellY();
		}

		/*
		
		// draw a rectangle around area viewable within viewport
		noFill();
		stroke(250);
		if ( oGameEngine.getCurrentPlayerId()==1 ) {
			rect( 	sx_+round(showFromX/cellWidth), 
				sy_+(showFromY/cellHeight), 
				round( (oViewport.getViewportCellCountX()-1) /cellWidth), 
				round( (oViewport.getViewportCellCountY()-1) /cellHeight) 
				);
		else if (debugShowPlayer2Viewport) 
			rect(	sx_+round(showFromX/cellWidth), 
				sy_+(showFromY/cellHeight), 
				round( (oViewportPlayer2.getViewportCellCountX()-1) /cellWidth), 
				round( (oViewportPlayer2.getViewportCellCountY()-1) /cellHeight) 
				);
		*/
	}

}

class cIslandPoly {


	int[] pX = new int[50];
	int[] pY = new int[50];
	int count;

	cIslandPoly(int[] pX_, int[] pY_, int count_) {

		pX=pX_;
		pY=pY_;
		count=count_;
	}

	void Draw() {

		//println("in cIslandPoly.Draw()");
		int x,y;
		fill(#45B22D);
		beginShape();

		for (int i = 0; i < count; i++) { 

			x=pX[i];
			y=pY[i];
			//println(pX[i]+","+pY[i]+"... "+x+","+y);
			vertex( x, y );
		}
		endShape();
		//println("leaving cIslandPoly.Draw()");
	}



	void Draw4ScreenBuffer1() {

		
		// ScreenBuffer1.background(102);
		// ScreenBuffer1.stroke(255);
		// ScreenBuffer1.line(40, 40, mouseX, mouseY);
		
		// image(ScreenBuffer1, 10, 10); 
		

		
		ScreenBuffer1.beginDraw();

		// set background colour to sea blue - not working for some reason
		//ScreenBuffer1.background(#51ADD9); // sea is blue
		//ScreenBuffer1.background(81,173,217); // sea is blue
		//ScreenBuffer1.fill(#51ADD9); // sea is blue
		//ScreenBuffer1.rect(0,0,900,900); // sea is blue
		//ScreenBuffer1.tint(#51ADD9); // sea is blue
		ScreenBuffer1.fill(#45B22D); // land is green
		ScreenBuffer1.stroke(0);
		
		ScreenBuffer1.beginShape();

		for (int i = 0; i < count; i++) { 
			//ScreenBuffer1.vertex( round((pX[i])/2), round((pY[i])/2) );
			ScreenBuffer1.vertex( round((pX[i])), round((pY[i])) );
		}
		//ScreenBuffer1.vertex( round((pX[0])/2), round((pY[0])/2) );
		ScreenBuffer1.vertex( round((pX[0])), round((pY[0])) );

		ScreenBuffer1.endShape();
		ScreenBuffer1.endDraw();

		
	}




	void Draw4Viewport(int playerId_) {


		//println("in cIslandPoly.Draw4Viewport()");
		int x,y;
		int cellX,cellY;
		int showFromX, showFromY;
		
		if ( oGameEngine.getCurrentPlayerId()==1 ) { 
			showFromX = oPlayer1.getShowFromCellX();
			showFromY = oPlayer1.getShowFromCellY();
		} else {
			showFromX = oPlayer2.getShowFromCellX();
			showFromY = oPlayer2.getShowFromCellY();
		}

		
		fill(#45B22D);

		beginShape();

		for (int i = 0; i < count; i++) { 

			if ( playerId_==1 ) {
				x=round(pX[i]/2);
				y=round(pY[i]/2);
			} else if (debugShowPlayer2Viewport) {
				x=round(pX[i]/2);
				y=round(pY[i]/2);
			}


			cellX=oGeometry.translateCoordToCell(showFromX, x*2); // return showCellFrom_-1+int(floor((coord_+(cellWidth-1))/cellWidth));
			cellY=oGeometry.translateCoordToCell(showFromY, y*2); 

			if ( playerId_==1 ) {
				x=x+220;
				y=y+20;
			} else if (debugShowPlayer2Viewport) {
				x=x+220;
				y=y+350;
			}


			x=x-((showFromX*cellWidth)/2);
			y=y-((showFromY*cellHeight)/2);


			vertex( x, y );

			
			//if ( 	cellX >= (showFromX-5) && 
			//	cellX <= ( (showFromX+5) + oViewport.getViewportCellCountX()-1)   
			//	&&   
			//	cellY >=(showFromY-5) && 
			//	cellY <= ( (showFromY+5) + oViewport.getViewportCellCountX()-1) )  {
			//	
			//	if ( playerId_==2 ) vertex( x, y );
			//} 
			
			
		}
		endShape();

	}



	void Draw4Map(int sx_, int sy_) {

		int x,y;
		noStroke();
		fill(#45B22D);
		beginShape();

		for (int i = 0; i < count; i++) { 

			x=sx_ + round(pX[i]/cellWidth);
			y=sy_ + round(pY[i]/cellHeight)+150;
			vertex( x, y );
		}
		endShape();

	}

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

void setTextSizeNumber() { textSize(6); }
void setTextSizeString() { textSize(10); }



/************************************************************************
	Do Nothing / Sleep
	used to pause game events for a second so that player1 can take in outcome of attack
************************************************************************/

class cDoNothing {
	
	int counter;
	bool DoNothingInProgress;
	int iLastTime, iCurrentTime;

	cDoNothing() {
		counter=0;
		iLastTime=0;
		setDoNothingInProgress(false);
	}

	void set() {
		if (debugDoNothing) println("debug: in DoNothing.set()");
		setDoNothingInProgress(true);
		counter=0;
		iLastTime=0;
		if (debugDoNothing) println("debug: leaving DoNothing.set()");
	}
	
	void clear() {
		if (debugDoNothing) println("debug: in DoNothing.clear()");
		counter=0;
		setDoNothingInProgress(false);
	}

	void setDoNothingInProgress(bool value_) { DoNothingInProgress=value_; }
	bool getDoNothingInProgress() { return DoNothingInProgress; }

	void do() {

		iCurrentTime = millis();

		if ( getDoNothingInProgress() && oDialogueCityProduction.isActive()==false && iCurrentTime > iLastTime+100) {
		
			counter=counter+1;
			iLastTime = iCurrentTime;
		}

		if ( oDialogueCityProduction.isActive()==false && counter==15 ) {
			if (debugDoNothing) println("debug: calling clear()");
			clear();
		}
	}
	
  
}



