
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

	int intGridCellType[][] = new int[101][101]; // use for land or sea

	int intGridValidMoves[][] = new int[101][101]; // use for next move search algorithm

	int intGridIslands[][] = new int[101][101]; // use for find islands algorithm
	/*
		-4 = nothing
		-3 = island, but we don't know which island number yet
		-2 = Sea next to an Island
		-1 = Sea
		0... = islandListId
	*/

	bool intGridCellFog[][] = new bool[101][101];
	bool intGridCellFogP2[][] = new bool[101][101];

	ArrayList listNeighbour;
	

	cGrid(int countX_, int countY_, int showFromX_, int showFromY_) {
		countX = countX_;
		countY = countY_;

		showFromX = showFromX_;
		showFromY = showFromY_;
		
		listNeighbour = new ArrayList();  // Create an empty ArrayList

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

		// init whole array
		for (y=0; y<100; y=y+1) {
			for (x=0; x<100; x=x+1) {

				intGridCellType[x][y]=-1;
				intGridIslands[x][y]=-4; // Nothing

				intGridCellFog[x][y]=false;
				intGridCellFogP2[x][y]=false;
			}
		}

		// default all GridCellType as Sea (code 0)
		for (y=1; y<=countY; y=y+1) {
			for (x=1; x<=countX; x=x+1) {

				intGridCellType[x][y]=SEA;
				intGridIslands[x][y]=-4; // Nothing

				if (ShowFogOfWar==true) intGridCellFog[x][y]=true;
				else intGridCellFog[x][y]=false;

				intGridCellFogP2[x][y]=true;
			}
		}
		
	}

	void createValidMoveGrid(int intPlayerId_) {

		// init whole array
		for (y=0; y<100; y=y+1) {
			for (x=0; x<100; x=x+1) {

				intGridValidMoves[x][y] = 1; // default to valid move 

				// ignore fog of war at the moment
				// isFogOfWar(int x_, int y_)
				// isFogOfWarP2(int x_, int y_)

				if ( intPlayerId_==1 ) {
					if ( intGridCellType[x][y]==LAND && isFogOfWar(x,y)==false ) 
						intGridValidMoves[x][y] = 2; // valid move on land
					else if ( intGridCellType[x][y]==SEA && isFogOfWar(x,y)==false ) {
						intGridValidMoves[x][y] = 3; // valid move on sea

						if ( oUnitList.isPlayerTransportAtRowCol(intPlayerId_, x, y) == true )
							intGridValidMoves[x][y] = 4; // valid move on transport
					}

				} else {
					if ( intGridCellType[x][y]==LAND && isFogOfWarP2(x,y)==false ) 
						intGridValidMoves[x][y] = 2; // valid move on land
					else if ( intGridCellType[x][y]==SEA && isFogOfWarP2(x,y)==false ) {
						intGridValidMoves[x][y] = 3; // valid move on sea

						if ( oUnitList.isPlayerTransportAtRowCol(intPlayerId_, x, y) == true )
							intGridValidMoves[x][y] = 4; // valid move on transport
					}
				}

			}
		}
	}

	bool getIsValidMove(int x_, int y_, int cell_type_) {

		bool bReturnValue=false;

		// cell_type:
		// 0 = moves on Sea
		// 1 = moves on Land

		// intGridValidMoves[][]:
		// 1 = default to valid move
		// 2 = valid move on land
		// 3 = valid move on sea
		// 4 = valid move on transport
		// 5 = valid move on carrier  

		if ( cell_type_ == 0 && ( intGridValidMoves[x_][y_]==1 || 
					  intGridValidMoves[x_][y_]==3 ) ) {
			bReturnValue=true;

		} else if ( cell_type_ == 1 && ( intGridValidMoves[x_][y_]==1 || 
						 intGridValidMoves[x_][y_]==2 ||
						 intGridValidMoves[x_][y_]==4 ||  
						 intGridValidMoves[x_][y_]==5 ) ) {
			bReturnValue=true;
		}

		//if ( bReturnValue==false) 
			//println("debug: in oGrid.getIsValidMove() x="+x_+",y="+y_+", cell_type_="+cell_type_+", bReturnValue= "+bReturnValue);

		return bReturnValue;
	}

	int getGridCellType(int cellX_, int cellY_) { return intGridCellType[cellX_][cellY_]; }
	
	int getGridIslandId(int cellX_, int cellY_) { return intGridIslands[cellX_][cellY_]; }

	bool isLand(int cellX_, int cellY_) {
		
		if (cellX_>0 && cellY_>0) {
			if( intGridCellType[cellX_][cellY_]==LAND ) {
				//println("isLand("+cellX_+","+cellY_+")=true");
				return true;
			}
		}
		
		return false;
	}


	bool isSea(int cellX_, int cellY_) {
		
		if (cellX_>0 && cellY_>0)
			if( intGridCellType[cellX_][cellY_]==SEA ) return true;
			
		return false;
	}


	bool isSeaNextToIsland(int cellX_, int cellY_) {
		
		if (cellX_>0 && cellY_>0)
			if( intGridIslands[cellX_][cellY_]==-2 ) return true;
			
		return false;
	}

	int getShowFromCellX() { return showFromX; }
	void setShowFromCellX(int value) { 
		if (value<=1) showFromX=1; 
		else if (value>= (99 - oViewport.getViewportCellCountX())-9 ) showFromX=(99 - oViewport.getViewportCellCountX())-9;
		else showFromX=value; 
	}

	int getShowFromCellY() { return showFromY; }	
	void setShowFromCellY(int value) { 
		if (value<=1) showFromY=1;
		else if (value>= (99 - oViewport.getViewportCellCountY())-9 ) showFromY=(99 - oViewport.getViewportCellCountY())-9;
		else showFromY=value; 
	}


	int getCellCountX() { return countX; }
	void setCellCountX(int value) { countX=value; }

	int getCellCountY() { return countY; }	
	void setCellCountY(int value) { countY=value; }
	

	bool isFogOfWar(int x_, int y_) { return intGridCellFog[x_][y_]; }

	bool isFogOfWarP2(int x_, int y_) { return intGridCellFogP2[x_][y_]; }
	

	void clearFogOfWar(int x_, int y_) { intGridCellFog[x_][y_]=false;}
	
	void clearFogOfWarP2(int x_, int y_) { intGridCellFogP2[x_][y_]=false;}


	bool isNextToLand(int x_, int y_) {

		//println("in oGrid.isNextToLand("+x_+","+y_+")");

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


	bool getIslandIdIfIsNextToLand(int x_, int y_) {

		//println("in oGrid.getIslandIdIfIsNextToLand("+x_+","+y_+")");

		bool result=-1;
		
		if (x_-1>=1) 
			if( intGridCellType[x_-1][y_]==LAND ) result=intGridIslands[x_-1][y_];

		if (x_+1<=countX) 
			if( intGridCellType[x_+1][y_]==LAND ) result=intGridIslands[x_+1][y_];		
		

		if (y_-1>=1) 
			if( intGridCellType[x_][y_-1]==LAND ) result=intGridIslands[x_][y_-1];

		if (y_+1<=countY) 
			if( intGridCellType[x_][y_+1]==LAND ) result=intGridIslands[x_][y_+1];



		if (x_-1>=1 && y_-1>=1) 
			if( intGridCellType[x_-1][y_-1]==LAND ) result=intGridIslands[x_-1][y_-1];

		if (x_+1<=countX && y_+1<=countY) 
			if( intGridCellType[x_+1][y_+1]==LAND ) result=intGridIslands[x_+1][y_+1];			
		

		if (x_-1>=1 && y_+1<=countY) 
			if( intGridCellType[x_-1][y_+1]==LAND ) result=intGridIslands[x_-1][y_+1];

		if (x_+1<=countX && y_-1>=1)
			if( intGridCellType[x_+1][y_-1]==LAND ) result=intGridIslands[x_+1][y_-1];	
		
		//println("in grid.getIslandIdIfIsNextToLand("+x_+","+y_+"), result="+result);
		
		//println("leaving oGrid.getIslandIdIfIsNextToLand()");

		return result;
	}



	bool isEnemyOrUnoccupiedIsland(int iPlayerId_, int x_, int y_) {

		if ( intGridCellType[x_][y_]==LAND && intGridIslands[x_][y_]>=0 )
			return oIslandList.isEnemyOrUnoccupiedIsland(iPlayerId_, intGridIslands[x_][y_]);
		else return false;

		//return false;
	}
	



	// ******************************************************
	// GRID ISLANDS
	// ******************************************************

	void UpdateGridIslands() {

		//println("debug: in grid.UpdateGridIslands()");

		// initialise
		for (y=1; y<=countY; y=y+1) {
			for (x=1; x<=countX; x=x+1) {

				if (isSea(x,y)==true) {
					intGridIslands[x][y]=-1; // Sea
					if (isNextToLand(x, y)==true) intGridIslands[x][y]=-2; // Sea next to an Island
				} else intGridIslands[x][y]=-3; // island but we don't know which island number yet
			}
		}

		
		int iIslandListId=0;
		for (y=1; y<=countY; y=y+1) {
			for (x=1; x<=countX; x=x+1) {

				if (intGridIslands[x][y]==-3) {
					intGridIslands[x][y]=iIslandListId;
					UpdateGridIslandsDetail(x,y,iIslandListId);

					while(listNeighbour.size()>0) {

						for (int i = 0; i < listNeighbour.size(); i++) { 
							cGridCell oGridCell = (cGridCell) listNeighbour.get(i);
							UpdateGridIslandsDetail(oGridCell.getX(),oGridCell.getY(),iIslandListId);
							listNeighbour.remove(i);
						}   
						
					}

					oIslandList.AddIsland(-1); // add an island to IslandList which is not assigned to any player

					iIslandListId=iIslandListId+1;
				}
			}
		}
		

		//println("debug: leaving grid.UpdateGridIslands(), iIslandListId="+iIslandListId);
	}


	void UpdateGridIslandsDetail(int x_, int y_, int iIslandListId_) {

		if (x_-1>=1) 
			if( intGridIslands[x_-1][y_]==-3 ) { intGridIslands[x_-1][y_]=iIslandListId_; listNeighbour.add( new cGridCell(x_-1, y_) );  }

		if (x_+1<=countX) 
			if( intGridIslands[x_+1][y_]==-3 ) { intGridIslands[x_+1][y_]=iIslandListId_; listNeighbour.add( new cGridCell(x_+1, y_) );  }
		

		if (y_-1>=1) 
			if( intGridIslands[x_][y_-1]==-3 ) { intGridIslands[x_][y_-1]=iIslandListId_; listNeighbour.add( new cGridCell(x_, y_-1) );  }

		if (y_+1<=countY) 
			if( intGridIslands[x_][y_+1]==-3 ) { intGridIslands[x_][y_+1]=iIslandListId_; listNeighbour.add( new cGridCell(x_, y_+1) );  }



		if (x_-1>=1 && y_-1>=1) 
			if( intGridIslands[x_-1][y_-1]==-3 ) { intGridIslands[x_-1][y_-1]=iIslandListId_; listNeighbour.add( new cGridCell(x_-1, y_-1) );  }

		if (x_+1<=countX && y_+1<=countY) 
			if( intGridIslands[x_+1][y_+1]==-3 ) { intGridIslands[x_+1][y_+1]=iIslandListId_; listNeighbour.add( new cGridCell(x_+1, y_+1) );  }
		

		if (x_-1>=1 && y_+1<=countY) 
			if( intGridIslands[x_-1][y_+1]==-3 ) { intGridIslands[x_-1][y_+1]=iIslandListId_; listNeighbour.add( new cGridCell(x_-1, y_+1) );  }

		if (x_+1<=countX && y_-1>=1)
			if( intGridIslands[x_+1][y_-1]==-3 ) { intGridIslands[x_+1][y_-1]=iIslandListId_; listNeighbour.add( new cGridCell(x_+1, y_-1) );  }

	}



	// ******************************************************
	// ISLAND CITIES
	// ******************************************************

	void AddCitiesToIslands() {

		if (debugCityAdd) println("in cGrid.AddCitiesToIslands() ");

		// for each island
		int i=0;
		for (i=1; i<=oIslandList.getCount(); i=i+1) {

			if (debugCityAdd) println("debug in cGrid.AddCitiesToIslands() CityIslandListId="+i);

			AddCitiesToIslandListId(i);
		}

		if (debugCityAdd) println("leaving cGrid.AddCitiesToIslands() ");		
	}

	
	void AddCitiesToIslandListId(int islandListId_) {

		int x,y;
		int maxCityPerIsland=(int)random(3,8);
		//int intRandomNumber = round(random(1,3));
		int cityCount=0;


		// scan through grid
		for (y=1; y<=countY; y=y+1) {
			for (x=1; x<=countX; x=x+1) {

				if ( intGridIslands[x][y]==islandListId_ ) {

					if ( ((int)random(1,1000)%7==0) && cityCount<maxCityPerIsland ) {

						// game rule: cities should not be immediately next to each other
						if ( oCityList.getCountCityNearby(1, x, y)==0 && oCityList.getCountCityNearby(2, x, y)==0) {

							if (debugCityAdd) println(" debug in cGrid.AddCitiesToIslandListId() islandListId_="+islandListId_);

							oCityList.AddCity(-1, x, y, islandListId_);

							//oIslandList.setPlayerId(islandListId_, intPlayerId);

							cityCount++;					
						}
					}

				}

			}
		}
	}




	// ******************************************************
	// PLAYER ISLAND
	// ******************************************************
	
	void SelectPlayerStartIsland(int PlayerId_) {

		//println("in cGrid.SelectPlayerStartIsland("+PlayerId_+") ");

		int playerListIslandId=0;
		int RandomIslandCityId=-1;
		int counter=0;
		bool done=false;
		
		while ( done==false && counter<=oIslandList.getCount() ) {

			//println("oIslandList.getCount()="+oIslandList.getCount() );
			playerListIslandId=(int)random(0, oIslandList.getCount() );			
			//println("playerListIslandId="+playerListIslandId);
			//println("oIslandList.getPlayerId(playerListIslandId)="+oIslandList.getPlayerId(playerListIslandId) );

			if ( oIslandList.getPlayerId(playerListIslandId)==-1) {
				//println("island is unoccupied");

				// does island have a port city?
				if ( oCityList.IslandHasPortCity(playerListIslandId)==true ) {
					//println("island has a port city");

					// if so, pick a random city on this island
					RandomIslandCityId=oCityList.getRandomIslandCityId(playerListIslandId);
					//println("RandomIslandCityId="+RandomIslandCityId);
					if (RandomIslandCityId!=-1) {
						oCityList.setCityPlayerId(RandomIslandCityId, PlayerId_);
						//oIslandList.setPlayerId(playerListIslandId, PlayerId_);
						done=true;
					}
				} //else println("island does not have a port city");
			} //else println("island is occupied");
			counter=counter+1;
		}

		//println("counter="+counter);

		if ( counter>=oIslandList.getCount() ) {
			//println("algorithm did not work!!");
			println("assigning player a random city");
			RandomIslandCityId=round(random(2, oCityList.getCount() ));
			oCityList.setCityPlayerId(RandomIslandCityId, PlayerId_);
			//oIslandList.setPlayerId(playerListIslandId, PlayerId_);			
		}
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

	}



	// ******************************************************
	// DRAW
	// ******************************************************

	void draw() {

		int DisplayX, DisplayY;

		int showToX = showFromX + oViewport.getViewportCellCountX()-1;
		int showToY = showFromY + oViewport.getViewportCellCountY()-1;

		for (y=showFromY; y<=showToY; y=y+1) {
			for (x=showFromX; x<=showToX; x=x+1) {
			
				DrawCell(x, y, true);
			}
		}

	}



	void drawMap(int sx, int sy, int iMapPlayerId_) {
		
		fill(0);
		rect(sx, sy, countX+1, countY+1);
		
		int DisplayX, DisplayY;

		color colSea = color(0, 0, 200);
		color colLand = color(0, 200, 0);
		
		int x,y;
		for (y=1; y<countY; y=y+1) {

			for (x=1; x<countX; x=x+1) {
				
				DisplayY=sy+y; //(((y-showFromY)+1)*16)-15;
				DisplayX=sx+x; //(((x-showFromX)+1)*16)-(15);
				
				if ( iMapPlayerId_==1 && intGridCellFog[x][y]==false ) {
					
					if ( isSea(x,y) ) stroke(180);	
					else stroke(120);
					
					if( oCityList.isCity(x,y) ) stroke(0);
					
					point(DisplayX, DisplayY);

				} else if ( iMapPlayerId_==2 && intGridCellFogP2[x][y]==false ) {
					
					if ( isSea(x,y) ) stroke(180);	
					else stroke(120);
					
					if( oCityList.isCity(x,y) ) stroke(0);
					
					point(DisplayX, DisplayY);
				}	
			}
		}
		
		// draw a rectangle around area viewable within viewport
		if ( iMapPlayerId_==1 ) { 
			noFill();
			stroke(250);
			rect(sx+showFromX, sy+showFromY, oViewport.getViewportCellCountX()-1, oViewport.getViewportCellCountY()-1);
		}
	}







	void drawMapValidMove(int sx, int sy, int iMapPlayerId_) {
		
		int DisplayX, DisplayY;

		fill(0);
		setTextSizeNumber();
		text( "Viewport Matrix of Valid Moves for Player "+iMapPlayerId_+":" , sx, sy+iNumberTextSize );
		setTextSizeString();
		
		int x,y;
		for (y=getShowFromCellY(); y<=( getShowFromCellY() + oViewport.getViewportCellCountY() ); y=y+1) {

			for (x=getShowFromCellX(); x<=( getShowFromCellX() + oViewport.getViewportCellCountX() ); x=x+1) {
				
				DisplayY=sy+((y-getShowFromCellY())*iNumberTextSize)+iNumberTextSize+iNumberTextSize; //(((y-showFromY)+1)*iNumberTextSize)-iNumberTextSize;
				DisplayX=sx+((x-getShowFromCellX())*iNumberTextSize); //(((x-showFromX)+1)*iNumberTextSize)-(iNumberTextSize);
					
				fill(0);
				setTextSizeNumber();
				text(intGridValidMoves[x][y], DisplayX, DisplayY );
				setTextSizeString();
			}
		}
		
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
						setTextSizeNumber();
						text("S", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
						setTextSizeString();
						*/
					} else {
						//println("drawing land... at ("+x+","+y+") "("+DisplayX+","+DisplayY+")");
						//println("is land... at ("+x+","+y+") ("+DisplayX+","+DisplayY+")");
						image( imgLand, DisplayX, DisplayY ); 

						/*
						// for testing purposes
						fill(0);
						setTextSizeNumber();
						text("L", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
						setTextSizeString();
						*/
					}

					if ( debugShowCellGridLocation ) {

						// clear where we will draw island islandListId
						//fill(255);
						//rect(DisplayX+iNumberIndent, DisplayY+iNumberIndent-1, iNumberTextSize+iNumberTextSize+iNumberTextSize, iNumberTextSize);

						// draw island islandListId
						fill(0);
						setTextSizeNumber();
						//text( x+","+y , DisplayX+cellWidth-iNumberTextSize, DisplayY+cellHeight-1 );
						text( x+","+y , DisplayX+iNumberIndent+1, DisplayY+iNumberTextSize+2 );
						setTextSizeString();

					}


					if ( debugShowIslandIslandListId ) {

						// clear where we will draw island islandListId
						//fill(255);
						//rect(DisplayX+cellWidth-iNumberTextSize, DisplayY+cellHeight-(iNumberTextSize), iNumberTextSize, iNumberTextSize );

						// draw island islandListId
						fill(0);
						setTextSizeNumber();
						text( getGridIslandId(x,y) , DisplayX+cellWidth-iNumberTextSize-iNumberTextSize, DisplayY+cellHeight-1 );
						setTextSizeString();
					}

					if (bDrawAnyUnits)
						oUnitList.Draw(x,y);
				}
				//redraw();
			}
		}


	}



	// ******************************************************
	// GENERATE
	// ******************************************************


	void generate() {

		AddIslands();	

		UpdateGridIslands();

		AddCitiesToIslands();

		SelectPlayerStartIsland(1);
		SelectPlayerStartIsland(2);
	}


	void AddIslands() {

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
						if ((int)random(1,1000)%2==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(4,7), cellHeight*(int)random(5,8) );
						break;
					case 4:
						if ((int)random(1,1000)%2==0) defineIslandAsRandomPoly(-1, cellWidth*(int)random(i-5,i+5), cellHeight*(int)random(j-5,j+5), cellWidth*(int)random(5,8), cellHeight*(int)random(7,9) );
						break;
				} 					
			}
		}
			
	}


	 void defineIslandAsRandomPoly(int intPlayerId, int X, int Y, int w, int h) {

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

		} while (deg <= 6.4 && count < 50);

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

					xxx=ceil((xx)/cellWidth);
					yyy=ceil((yy)/cellHeight);

					if ( xxx>=1 && yyy>=1 && xxx<=countX && yyy<=countY) {
						intGridCellType[xxx][yyy]=1;
					}				
				}
			}
		}
	 }



}
