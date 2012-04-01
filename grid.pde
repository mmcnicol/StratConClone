
class cGrid {

	int countX;
	int countY;
	int x,y;
	int showFromX;
	int showFromY;

	//final int cellWidth=16;
	//final int cellHeight=16;
	
	//constants  
	final static int SEA=0;
	final static int LAND=1;
	//final static int GRIDX=150;
	//final static int GRIDY=100;

	int intGridCellType[][] = new int[121][101];
	bool intGridCellFog[][] = new bool[121][101];


	cGrid(int countX_, int countY_, int showFromX_, int showFromY_) {
		countX = countX_;
		countY = countY_;

		showFromX = showFromX_;
		showFromY = showFromY_;
		
		init();

	}


	void resize(int countX_, int countY_, int showFromX_, int showFromY_) {
		countX = countX_;
		countY = countY_;

		showFromX = showFromX_;
		showFromY = showFromY_;
		
		init();

	}

	void init() {

		//println("debug: in grid.Init()");
		// default all GridCellType as Sea (code 0)
		for (y=1; y<=countY; y=y+1) {
			for (x=1; x<=countX; x=x+1) {

				//int yy=round(intX/cellWidth);
				//int yyy=round(intY/cellHeight);
				//println( "y=" + y + ", x=" + x );
				//image( imgSea, x, y ); 
				
				intGridCellType[x][y]=SEA;

				if (ShowFogOfWar==true) intGridCellFog[x][y]=true;
				else intGridCellFog[x][y]=false;
				
				/*
				//switch( oWorld.getScenario() ) {
					case 0:
						intGridCellType[x][y]=SEA;
						intGridCellFog[x][y]=true;
						break;
					case 1:
						intGridCellType[x][y]=SEA;
						intGridCellFog[x][y]=true; 
						break;

				}
				*/		
		
			}
		}
		
	}


	int getGridCellType(int cellX_, int cellY_) { return intGridCellType[cellX_][cellY_]; }
	
	bool isLand(int cellX_, int cellY_) {
		
		if (cellX_>0 && cellY_>0) {
			if( intGridCellType[cellX_][cellY_]==LAND ) {
				//println("isLand("+cellX_+","+cellY_+")=true");
				return true;
			}
		}
		//println("isLand("+cellX_+","+cellY_+")=false");			
		return false;
	}

	bool isSea(int cellX_, int cellY_) {
		
		if (cellX_>0 && cellY_>0)
			if( intGridCellType[cellX_][cellY_]==SEA ) return true;
			
		return false;
	}

	int getShowFromCellX() { return showFromX; }
	void setShowFromCellX(int value) { showFromX=value; }

	int getShowFromCellY() { return showFromY; }	
	void setShowFromCellY(int value) { showFromY=value; }


	int getCellCountX() { return countX; }
	void setCellCountX(int value) { countX=value; }

	int getCellCountY() { return countY; }	
	void setCellCountY(int value) { countY=value; }
	
	bool isFogOfWar(int x_, int y_) {
		return intGridCellFog[x_][y_];
	}
	
	void clearFogOfWar(int x_, int y_) { intGridCellFog[x_][y_]=false;}


	bool isNextToLand(int x_, int y_) {

		bool result=false;
		
		if (x_-1>=1) 
			if( intGridCellType[x_-1][y_]==LAND ) result=true;

		if (x_+1<=countX) 
			if( intGridCellType[x_+1][y_]==LAND ) result=true;			
		

		if (y_-1>=1) 
			if( intGridCellType[x_][y_-1]==LAND ) result=true;

		if (y_+1<=countY) 
			if( intGridCellType[x_][y_+1]==LAND ) result=true;	



		if (x_-1>=1 && y_-1>=1) 
			if( intGridCellType[x_-1][y_-1]==LAND ) result=true;

		if (x_+1<=countX && y_+1<=countY) 
			if( intGridCellType[x_+1][y_+1]==LAND ) result=true;			
		

		if (x_-1>=1 && y_+1<=countY) 
			if( intGridCellType[x_-1][y_+1]==LAND ) result=true;

		if (x_+1<=countX && y_-1>=1)
			if( intGridCellType[x_+1][y_-1]==LAND ) result=true;	
		
		//println("in grid.isNextToLand("+x_+","+y_+"), result="+result);
		
		return result;
	}


	
	
	// ******************************************************
	// MOVE
	// ******************************************************


	void moveLeft(int moveByCellCount) {
		if ( getShowFromCellX() > oViewport.getViewportCellCountX() ) {
			setShowFromCellX( getShowFromCellX()-(moveByCellCount) );
		} else {
			setShowFromCellX( 1 );
		}
	}

	void moveRight(int moveByCellCount) {
		if ( getShowFromCellX() < oViewport.getViewportCellCountX() ) {
			setShowFromCellX( getShowFromCellX()+(moveByCellCount) );
		} else {
			setShowFromCellX( getCellCountX()-oViewport.getViewportCellCountX() );
		}
		//println( "getShowFromCellX()=" + getShowFromCellX() );
	}

	void moveUp(int moveByCellCount) {
		if ( getShowFromCellY() > oViewport.getViewportCellCountY() ) {
			setShowFromCellY( getShowFromCellY()-(moveByCellCount) );
		} else {
			setShowFromCellY( 1 );
		}
	}

	void moveDown(int moveByCellCount) {
		if ( getShowFromCellY() < oViewport.getViewportCellCountY() ) {
			setShowFromCellY( getShowFromCellY()+(moveByCellCount) );
		} else {
			setShowFromCellY( getCellCountY()-oViewport.getViewportCellCountY() );
		}
		//println( "getShowFromCellY()=" + getShowFromCellY() );
	}



	// ******************************************************
	// DRAW
	// ******************************************************

	void draw() {
		//println("debug: in grid.draw()");
		int DisplayX, DisplayY;
		//println("showFromY="+showFromY+", countY="+countY+  ", showFromX="+showFromX+", countX="+countX);
		//println("oViewport.getViewportCellCountX()="+oViewport.getViewportCellCountX() );
		//println("oViewport.getViewportCellCountY()="+oViewport.getViewportCellCountY() );

		int showToX = showFromX + oViewport.getViewportCellCountX()-1;
		int showToY = showFromY + oViewport.getViewportCellCountY()-1;

		for (y=showFromY; y<=showToY; y=y+1) {
			for (x=showFromX; x<=showToX; x=x+1) {
			
				DrawCell(x, y, true);
							
				/*
				
				//println("x="+x+", y="+y);
				DisplayY=(((y-showFromY)+1)*cellHeight)-(cellHeight-1);
				DisplayX=(((x-showFromX)+1)*cellWidth)-(cellWidth-1);
				
				//if ( intCellX >= oGrid.getShowFromCellY() && intCellX <= (oGrid.getShowFromCellX()+oGrid.getCellCountX())   &&   intCellY >= oGrid.getShowFromCellY() && intCellY <= (oGrid.getShowFromCellY()+oGrid.getCellCountX()) )  {
				
				// for testing purposes
				if (intGridCellFog[x][y]==false) {
					if ( isSea(x,y) ) {
						//println("drawing sea... at ("+DisplayX+","+DisplayY+")");
						image( imgSea, DisplayX, DisplayY ); 
						
						/=*
						// for testing purposes
						fill(0);
						textSize(8);
						text("S", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
						textSize(11);
						*=/
					} else {
						//println("drawing land... at ("+x+","+y+") "("+DisplayX+","+DisplayY+")");
						//println("is land... at ("+x+","+y+") ("+DisplayX+","+DisplayY+")");
						image( imgLand, DisplayX, DisplayY ); 
						
						/=*
						// for testing purposes
						fill(0);
						textSize(8);
						text("L", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
						textSize(11);
						*=/
					}
				}
				
				*/
			
			}
		}

	}



	void drawMap(int sx, int sy) {
		//println("debug: in grid.drawMap()");
		
		fill(0);
		rect(sx, sy, countX+1, countY+1);
		
		int DisplayX, DisplayY;
		//println("showFromY="+showFromY+", countY="+countY+  ", showFromX="+showFromX+", countX="+countX);

		//int showToX = showFromX + oViewport.getViewportCellCountX()-1;
		//int showToY = showFromY + oViewport.getViewportCellCountY()-1;

		color colSea = color(0, 0, 200);
		color colLand = color(0, 200, 0);
		
		//set(10, 10, color(0, 0, 200));
		//set(10, 10, colour(100));
		//set(10, 10, 100);
		//Point(10,10);
		
		int x,y;
		for (y=1; y<countY; y=y+1) {
			//println("y="+y);
			for (x=1; x<countX; x=x+1) {
				//println("x="+x+", y="+y);
				
				
				DisplayY=sy+y; //(((y-showFromY)+1)*16)-15;
				DisplayX=sx+x; //(((x-showFromX)+1)*16)-(15);
				
				// for testing purposes
				if (intGridCellFog[x][y]==false) {
					
					
					if ( isSea(x,y) ) stroke(180);	
					else stroke(120);
					
					if( oCityList.isCity(x,y) ) stroke(0);
					
					point(DisplayX, DisplayY);
					
					
					
					/*
					if ( isSea(x,y) ) {
						//set(DisplayX, DisplayY, color(100));
						oWorld.setpix(DisplayX, DisplayY, colSea );
					} else {
						//set(DisplayX, DisplayY, color(255));
					}
					*/
				}				
			
			}
		}
		
		// draw a rectangle around area viewable within viewport
		noFill();
		stroke(250);
		rect(sx+showFromX, sy+showFromY, oViewport.getViewportCellCountX()-1, oViewport.getViewportCellCountY()-1);
		
	}
	
	
	void DrawCell(int x, int y, bool bDrawAnyUnits) {
		//println("debug: in grid.DrawCell("+x+","+y+") bDrawAnyUnits="+bDrawAnyUnits);
		int DisplayX, DisplayY;
		//println("showFromY="+showFromY+", countY="+countY+  ", showFromX="+showFromX+", countX="+countX);

		int showToX = showFromX + oViewport.getViewportCellCountX()-1;
		int showToY = showFromY + oViewport.getViewportCellCountY()-1;


		//println("x="+x+", y="+y);
		DisplayY=(((y-showFromY)+1)*cellHeight)-(cellHeight-1);
		DisplayX=(((x-showFromX)+1)*cellWidth)-(cellWidth-1);

		//if ( x >= oGrid.getShowFromCellX() && x <= (oGrid.getShowFromCellX()+oGrid.getCellCountX())   &&   y >= oGrid.getShowFromCellY() && y <= (oGrid.getShowFromCellY()+oGrid.getCellCountY()) )  {
		if ( oViewport.isCellWithinViewport(x, y) ) { 
			
			if (intGridCellFog[x][y]==false) {
				if ( oCityList.isCity(x,y) ) {
					oCityList.Draw(x,y);
				//} else if ( oUnitList.isUnit(x,y) && bDrawAnyUnits==true ) {
				//	oUnitList.Draw(x,y);
				} else {
					if ( isSea(x,y) ) {
						//println("drawing sea... at ("+DisplayX+","+DisplayY+")");
						image( imgSea, DisplayX, DisplayY ); 

						/*
						// for testing purposes
						fill(0);
						textSize(8);
						text("S", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
						textSize(11);
						*/
					} else {
						//println("drawing land... at ("+x+","+y+") "("+DisplayX+","+DisplayY+")");
						//println("is land... at ("+x+","+y+") ("+DisplayX+","+DisplayY+")");
						image( imgLand, DisplayX, DisplayY ); 

						/*
						// for testing purposes
						fill(0);
						textSize(8);
						text("L", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
						textSize(11);
						*/
					}
					if (bDrawAnyUnits)
						oUnitList.Draw(x,y);
				}
				//redraw();
			}
		}
		
		/*
		if ( isFogOfWar(x, y)==true ) { // for testing purposes
			fill(0);
			textSize(8);
			text("F", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
			textSize(11);
		}
		*/



	}



	// ******************************************************
	// GENERATE
	// ******************************************************


	void generate() {

		AddIslands();	
	}



	void AddIslands() {

		//switch( oWorld.getScenario() ) {
		switch( iMapSize ) {
			case 1:
				AddIslands();
				break;
			case 2:
				AddIslands();
				break;
			case 100:
				 AddIslands_TestScenario1Transport(); 
				break;

		}

		//oCityList.printIslandCityLocations();
	}



	void AddIslands() {

		int i;


		switch( iMapSize ) {
		
			case 1:
			
				//defineIslandAsRandomPoly(1, 16*(int)random(10,15), 16*(int)random(10,15), 16*(int)random(4,5), 16*(int)random(4,5) );

				//defineIslandAsRandomPoly(2, 16*(int)random(20,25), 16*(int)random(20,25), 16*(int)random(4,6), 16*(int)random(5,7) );

				int i,j;
				for (i=3; i<countX; i=i+8) {
					for (j=3; j<countY; j=j+7) {
						//switch( (int)random(1,3) ) {
						//	case 1:
								if ((int)random(1,1000)%2==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(3,6), cellHeight*(int)random(3,6) );
						/*		break;
							case 2:
								if ((int)random(1,1000)%2==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(4,6), cellHeight*(int)random(4,6) );
								break;
							case 3:
								if ((int)random(1,1000)%2==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(6,10), cellHeight*(int)random(6,10) );
								break;
						} 
						*/					
					}
				}
				break;

			case 2:

				defineIslandAsRandomPoly(1, cellWidth*(int)random(35,45), cellHeight*(int)random(20,25), cellWidth*(int)random(4,5), cellHeight*(int)random(4,5) );

				defineIslandAsRandomPoly(2, cellWidth*(int)random(65,75), cellHeight*(int)random(40,45), cellWidth*(int)random(3,4), cellHeight*(int)random(3,4) );

				int i,j;
				for (i=5; i<countX; i=i+12) {
					for (j=5; j<countY; j=j+14) {
						switch( (int)random(1,4) ) {
							case 1:
								if ((int)random(1,1000)%2==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(2,5), cellHeight*(int)random(2,5) );
								break;
							case 2:
								if ((int)random(1,1000)%3==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(3,6), cellHeight*(int)random(3,6) );
								break;
							case 3:
								if ((int)random(1,1000)%2==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(7,10), cellHeight*(int)random(8,15) );
								break;
							case 4:
								if ((int)random(1,1000)%2==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(10,13), cellHeight*(int)random(14,28) );
								break;
						} 					
					}
				}			
			break;
		}
			
	}




	void AddIslands_TestScenario1Transport() {


		for (y=1; y<=countY; y=y+1) {
			for (x=1; x<=3; x=x+1) {	
				
				intGridCellType[x][y]=LAND;	
			}
		}
		
		oCityList.AddCity(1, 3, 3);
		oUnitList.AddUnit(6, 1, 3, 3);



		for (y=1; y<=countY; y=y+1) {
			for (x=18; x<=countX; x=x+1) {	
				
				intGridCellType[x][y]=LAND;
			}
		}
		
		oCityList.AddCity(2, 18, 3);
		
	}
	


	 void defineIslandAsRandomPoly(int intPlayerId, int X, int Y, int w, int h) {

		int iIslandListId;
		//oHelloWorld.Draw();
		//oCityList.AddCity(intPlayerId, X, Y);
		
		oIslandList.AddIsland(intPlayerId); 
		iIslandListId = oIslandList.getCount()-1;

		// create a poly (island)
		float deg = 0, deg2;
		int x, y, xx, yy, xxx, yyy, rand_number, count=0, prevX, prevY, cityCount=0;

		int[] intX = new int[50];
		int[] intY = new int[50];

		int a=0,b=0;

		do {
			//console.log( "count=" + count );
			x = round(w * cos(deg));
			y = round(h * sin(deg));

			a=X+x;
			b=Y+y;
			intX[count]=X+x;
			intY[count]=Y+y;

			prevX=a;
			prevY=b;

		    rand_number = random(5,8);
		    deg2=(float)rand_number/10;
		    //deg += 0.5; //0.005;
		    deg+=deg2;
		    count=count+1;
		}
		while (deg <= 6.4 && count < 50);


		int maxCityPerIsland=(int)random(2,8);

		// for each cell that is within the rectangle (that contains the poly)
		// credits: amended version of 'point in poly' algorithm by Randolph Franklin
		for (xx=X-w; xx<=(int)X+w; xx=xx+cellWidth) {

			for (yy=Y-h; yy<=(int)Y+h; yy=yy+cellHeight) {


				// next identify if this cell is within the poly (island)
				int npol=count, x=xx+(cellWidth/2), y=yy+(cellHeight/2);

				int i, j, c = 0;

				for (i = 0, j = npol-1; i < npol; j = i++) {

					int intXI=intX[i];
					int intXJ=intX[j];

					int intYI=intY[i];
					int intYJ=intY[j];


					if ((((intYI <= y) && (y < intYJ)) ||
						 ((intYJ <= y) && (y < intYI))) &&
						(x < (intXJ - intXI) * (y - intYI) / (intYJ - intYI) + intXI)) {
					  		c = !c;
						}

				}

				// if point is in poly, mark GridCellType as Land (code 1)
				if ( c==1 ) {  
					//image( imgLand, xx+1, yy+1 ); 
					//intGridCellType[(int)xx/16][(int)yy/16]=1;
					xxx=ceil((xx)/cellWidth);
					yyy=ceil((yy)/cellHeight);

					if ( xxx>=1 && yyy>=1 && xxx<=countX && yyy<=countY) {
						intGridCellType[xxx][yyy]=1;

						//println("debug grid#1");
						int intRandomNumber = round(random(1,6));
						//println("debug grid#2");
					
						
					
						if ( intRandomNumber==2 && cityCount<maxCityPerIsland ) {
							//println("debug grid#3");
							// game rule: cities should not be immediately next to each other
							if ( oCityList.getCountCityNearby(intPlayerId, xxx, yyy)==0) {
							
								// an innovation, each city is assigned a player at the start of the game
								if ( iMapSize==1) { 
									
									switch( (int)random(1,5) ) {
										case 1:
											oCityList.AddCity(1, xxx, yyy, iIslandListId);
											break;	
										case 2:
											oCityList.AddCity(2, xxx, yyy, iIslandListId);
											break;
										case 3:
											oCityList.AddCity(-1, xxx, yyy, iIslandListId); // city with player -1 is empty city
											break;
										case 4:
											oCityList.AddCity(-1, xxx, yyy, iIslandListId); // city with player -1 is empty city
											break;											
									} 
									cityCount++;
									
								// classic game
								} else {
									//println("debug grid#4");
									// game rule: each player should only have one city at the beginning.
									if ( cityCount==0 ) {
										oCityList.AddCity(intPlayerId, xxx, yyy, iIslandListId);
										oIslandList.setPlayerId(iIslandListId, intPlayerId);
									}
									else oCityList.AddCity(-1, xxx, yyy, iIslandListId); // city with player -1 is empty city
									//println("debug grid#5");
									cityCount++;
									//println("debug grid#6");								
								}
							}
						}
					}				

				}

			}

		}
		
		// just testing
		if ( intPlayerId==1) {
			//oUnitList.AddUnit(0, 2, xxx-4, yyy-4);
			//oUnitList.AddUnit(0, 1, xxx-3, yyy-3);
			//oUnitList.AddUnit(0, 1, xxx-3, yyy-3);
		}


	 }




}






