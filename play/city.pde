
class cCity {

	int intCityPlayerId;
	int iCityIslandListId;
	int intCellX, intCellY;
	int productionUnitTypeId;
	string productionUnitTypeName;
	int productionDaysLeft;
	int strength;

	cCity(int intCityPlayerId_, int intCellX_, int intCellY_, int iCityIslandListId_) {

	

		if (debugCityAdd) println("   cCity constructor for intCityPlayerId_=" + intCityPlayerId_+", iCityIslandListId_="+iCityIslandListId_);

		intCityPlayerId=intCityPlayerId_;
		setCityIslandListId(iCityIslandListId_);
		intCellX=intCellX_;
		intCellY=intCellY_;

		strength=1; //int(random(1,3));

		//if( intCityPlayerId_==1 ) {
			//println("cCity constructor for intCityPlayerId_=" + intCityPlayerId_ +" strength="+strength);
		//}

		if( intCityPlayerId_ != -1 ) {
			//println("is human or computer city so build a tank");
			// game rule: default initial production to Tank
			productionUnitTypeId= oUnitRef[0].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[0].getDaysToProduce();
			productionUnitTypeName = oUnitRef[0].getUnitName();
			//println("productionUnitTypeId=" + productionUnitTypeId + ", productionDaysLeft=" + productionDaysLeft);

			oIslandList.updateIslandPlayerCityCount(getCityIslandListId(), -1, intCityPlayerId_);

		} else { 
			//println("city is unoccupied so build nothing");
			// game rule: empty city does not produce anything
			productionUnitTypeId= -1; 
			productionDaysLeft = -1;
			productionUnitTypeName = "N/A";
			//println("productionUnitTypeId=" + productionUnitTypeId + ", productionDaysLeft=" + productionDaysLeft);

			oIslandList.increaseUnoccupiedCityCount( getCityIslandListId() );
		}
	
	}

	string getLocation() { return nf(intCellX,3)+","+nf(intCellY,3); }
	
	int getCellX() { return intCellX; }
	int getCellY() { return intCellY; }
	
	int getCityPlayerId() { return intCityPlayerId; }
	int setCityPlayerId(int intCityPlayerId_) { intCityPlayerId=intCityPlayerId_; }

	int setCityIslandListId(int value_) { iCityIslandListId=value_; }
	int getCityIslandListId() { return iCityIslandListId; }
	
	void printRowCol() {
		println("city at row="+intCellX+", col="+intCellY);
	}

	string getStatus() {

		string strStatus="Unoccupied";

		switch( getCityPlayerId() ) {
			case 1: 
				strStatus="player 1";
				break;
			case 2: 
				strStatus="player 2";
				break;
		}

		return strStatus;
	}

	boolean isNearby(int intCellX_, int intCellY_) {
		if ( abs(intCellX_ - intCellX)<=2 && abs(intCellY_ - intCellY)<=2 ) return true;
		else return false; 
	}

	bool isAt(cellRow_, cellCol_) {
		if( intCellX==cellRow_ && intCellY==cellCol_ ) return true
		else return false;
	}

	bool isOccupied() {
		if( intCityPlayerId==-1 ) return false;
		else return true;
	}


	bool isPort() {
	
		bool result=false;
		
		if (      oGrid.isSea(intCellX-1, intCellY-1) && intCellX-1>=1 && intCellY-1>=1) result=true;
		else if ( oGrid.isSea(intCellX-1, intCellY) && intCellX-1>=1 ) result=true;
		else if ( oGrid.isSea(intCellX-1, intCellY+1) ) result=true;
		
		else if ( oGrid.isSea(intCellX, intCellY-1) && intCellY-1>=1 ) result=true;
		else if ( oGrid.isSea(intCellX, intCellY+1) ) result=true;
		
		else if ( oGrid.isSea(intCellX+1, intCellY-1) && intCellY-1>=1 ) result=true;
		else if ( oGrid.isSea(intCellX+1, intCellY) ) result=true;
		else if ( oGrid.isSea(intCellX+1, intCellY+1) ) result=true;
		
		return result;
	}
	
	bool isWithin(int iWithinNumCells, int cellX_, int cellY_) {
	
		if( ( intCellX >=(cellX_-iWithinNumCells) && intCellX <=(cellX_+iWithinNumCells) )
			&& ( intCellY >=(cellY_-iWithinNumCells) && intCellY <=(cellY_+iWithinNumCells) ) )
			return true;
		else return false;
	}

	// ***********************************************************
	// DRAW
	// ***********************************************************


	void Draw() {
	
		//println("in cCity.Draw(), intCityPlayerId=" + intCityPlayerId+" row="+intCellX+" col="+intCellY);

		int PlayerDrawOffSetX=220;
		int PlayerDrawOffSetY=0;
		bool PlayerCellIsFogOfWar = false;
		bool CellWithinPlayerViewport = false;
		int DisplayY;
		int DisplayX;

		if ( oGameEngine.getCurrentPlayerId()==1 ) {
			PlayerCellIsFogOfWar = oGrid.isFogOfWar(intCellX, intCellY);

			CellWithinPlayerViewport = oViewport.isCellWithinViewport(intCellX, intCellY);

			DisplayY=((intCellY-oPlayer1.getShowFromCellY()+1)*cellWidth)-(cellWidth-1) + PlayerDrawOffSetY;
			DisplayX=((intCellX-oPlayer1.getShowFromCellX()+1)*cellHeight)-(cellHeight-1) + PlayerDrawOffSetX;

		} else if (debugShowPlayer2Viewport) {
			PlayerCellIsFogOfWar = oGrid.isFogOfWarP2(intCellX, intCellY);
			PlayerDrawOffSetY=350;

			CellWithinPlayerViewport = oViewportPlayer2.isCellWithinViewport(intCellX, intCellY);

			DisplayY=((intCellY-oPlayer2.getShowFromCellY()+1)*cellWidth)-(cellWidth-1) + PlayerDrawOffSetY;
			DisplayX=((intCellX-oPlayer2.getShowFromCellX()+1)*cellHeight)-(cellHeight-1) + PlayerDrawOffSetX;
		}

		//println("debug: in cCity.Draw(), intCityPlayerId=" + intCityPlayerId+" row="+intCellX+" col="+intCellY+", CellWithinPlayerViewport="+CellWithinPlayerViewport+", PlayerCellIsFogOfWar="+PlayerCellIsFogOfWar);

		//if ( oViewport.isCellWithinViewport(intCellX, intCellY) ) { 
		if ( CellWithinPlayerViewport ) { 
			
			//int DisplayY=((intCellY-oGrid.getShowFromCellY()+1)*cellWidth)-(cellWidth-1) + PlayerDrawOffSetY;
			//int DisplayX=((intCellX-oGrid.getShowFromCellX()+1)*cellHeight)-(cellHeight-1) + PlayerDrawOffSetX;
			
			//if ( oGrid.isFogOfWar(intCellX, intCellY)==false ) { // for testing purposes
			if (PlayerCellIsFogOfWar==false) {
				switch(intCityPlayerId) {
					case -1:
						image( imgCity0, DisplayX, DisplayY );
						break;
					case 1:
						image( imgCity1, DisplayX, DisplayY );
						
						if( getProductionDaysLeft() > 0 ) {
							// show Production Days Left on city image
							fill(255);
							if ( getProductionDaysLeft() > 9 )
								rect(DisplayX+iNumberIndent, DisplayY+iNumberIndent, iNumberTextSize+iNumberTextSize, iNumberTextSize);
							else
								rect(DisplayX+iNumberIndent, DisplayY+iNumberIndent, iNumberTextSize, iNumberTextSize);

							fill(0);
							setTextSizeNumber();
							//text(getProductionDaysLeft(), DisplayX+iNumberIndent, DisplayY+iNumberTextSize+1 );
							text(getProductionDaysLeft(), DisplayX+iNumberIndent+1, DisplayY+iNumberTextSize );
							setTextSizeString();
						}

						break;				
					case 2:
						image( imgCity2, DisplayX, DisplayY );
						break;
				}


				if ( debugShowCityIslandListId ) {

						// clear where we will draw city islandListId
						fill(255);
						rect(DisplayX+cellWidth-iNumberTextSize-iNumberTextSize, DisplayY+cellHeight-iNumberTextSize, iNumberTextSize, iNumberTextSize );

						// draw city islandListId
						fill(0);
						setTextSizeNumber();
						text( getCityIslandListId() , DisplayX+cellWidth-iNumberTextSize-iNumberTextSize, DisplayY+cellHeight-1 );
						setTextSizeString();				
				}


			}
			
			/*
			if ( oGrid.isFogOfWar(intCellX, intCellY)==true ) { // for testing purposes
				fill(0);
				setTextSizeNumber();
				text("F", DisplayX+iNumberIndent, DisplayY+iNumberTextSize );
				setTextSizeString();
			}
			*/
			
		}	

		//println("leaving cCity.Draw()");
	}


	void clearFogOfWar() {
	
		//println(" in city.clearFogOfWar() ");
		
		int x, y;
		int sx, sy;
		int ex, ey;
		int showFromX, showFromY;

		if ( getCityPlayerId()==1 ) { 
			showFromX = oPlayer1.getShowFromCellX();
			showFromY = oPlayer1.getShowFromCellY();
		} else if ( getCityPlayerId()==2 ) {
			showFromX = oPlayer2.getShowFromCellX();
			showFromY = oPlayer2.getShowFromCellY();
		}

		if( intCellX-1>=showFromX ) sx=intCellX-1;
		else sx=intCellX;
		
		if( intCellX+1<= (showFromX + oViewport.getWidth() ) ) ex=intCellX+1;
		else ex=intCellX;
		
		
		if( intCellY-1>=showFromY ) sy=intCellY-1;
		else sy=intCellY;
				
		if( intCellY+1<= ( showFromY + oViewport.getHeight() ) ) ey=intCellY+1;
		else ey=intCellY;
		
		
		for (y=sy;y<=ey;y++) {
			for (x=sx;x<=ex;x++) {
				if ( getCityPlayerId()==1 ) oGrid.clearFogOfWar(x,y);
				else if ( getCityPlayerId()==2 ) oGrid.clearFogOfWarP2(x,y);
			}
		}
	}
	




	// ***********************************************************
	// PRODUCTION
	// ***********************************************************

	int getProductionUnitTypeId() { return productionUnitTypeId; }
	
	void setProductionUnitTypeId(int productionUnitTypeId_) { 
	
		//println("in city.setProductionUnitTypeId("+productionUnitTypeId_+")");
	
		if ( productionUnitTypeId_ == -1 ) {
			productionUnitTypeId= -1; 
			productionDaysLeft = -1;
			productionUnitTypeName = "N/A";
		} else {
			productionUnitTypeId=productionUnitTypeId_; 
			productionDaysLeft = oUnitRef[productionUnitTypeId_].getDaysToProduce();
			productionUnitTypeName = oUnitRef[productionUnitTypeId_].getUnitName();
		}
	}

	
	string getProductionUnitTypeName() { return productionUnitTypeName; }
	
	int getProductionDaysLeft() { return productionDaysLeft; }

	void manageProduction(int iCityListId_) {
	
		//println("in cCity.manageProduction() at ("+intCellX+","+intCellY+")");

		//if( intCityPlayerId > 0 && intCityPlayerId!=2) { // just testing
		if( intCityPlayerId > 0 ) {
		
			//println("in cCity.manageProduction() cityEmpty=false, productionUnitTypeId=" + productionUnitTypeId + ", productionDaysLeft=" + productionDaysLeft);
			if( productionDaysLeft > 1 ) productionDaysLeft--;
			else {
				
				//println("in city.manageProduction() productionUnitTypeId="+productionUnitTypeId+",  city has finished producing a unit");
				
				// city has finished producing a unit
				
				if ( intCityPlayerId==1 && debugCityProduction ) println( "debug: in manageProduction(), getCityIslandListId() = " + getCityIslandListId() );

				oUnitList.AddUnit(productionUnitTypeId, intCityPlayerId, intCellX, intCellY, getCityIslandListId() );
				
				// start building next unit
				
				//doNextUnitProductionAI(intCityPlayerId); // for testing purposes


				if ( intCityPlayerId==1 ) { 
					oViewport.scrollIfAppropriate2( getCellX(), getCellY() );
					//oPlayer1.setShowFromCellX( getCellX()-10 );
					//oPlayer1.setShowFromCellY( getCellY()-10 );
				} else {
					oViewportPlayer2.scrollIfAppropriate2( getCellX(), getCellY() );
					//oPlayer2.setShowFromCellX( getCellX()-10 );
					//oPlayer2.setShowFromCellY( getCellY()-10 );
				}
				
				if( intCityPlayerId == 2 ) {
				
					if (debugShowPlayer2Viewport) oViewportPlayer2.scrollIfAppropriate(intCellX, intCellY);
					doNextUnitProductionAI(intCityPlayerId);
								
				} else if( intCityPlayerId == 1 && oPlayer1.getIsAI() ) {

					oViewport.scrollIfAppropriate(intCellX, intCellY);
					doNextUnitProductionAI(intCityPlayerId);

								
				} else if( intCityPlayerId == 1 ) {

					oViewport.scrollIfAppropriate(intCellX, intCellY);
				
					if( productionUnitTypeId!=-1) {
		
						productionUnitTypeId= oUnitRef[productionUnitTypeId].getUnitTypeId(); 
						productionDaysLeft = oUnitRef[productionUnitTypeId].getDaysToProduce();
					} else {
					
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); 
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
					}
					
					
					/*
					println("in city.manageProduction() player="+intCityPlayerId+" display city production dialogue...");
					oCityList.updateSelectedCityPanelInformation(iCityListId_);
					oGameEngine.setSelectedCityListId(iCityListId_);
					oDialogueCityProduction.display();
					*/
				}

				clearFogOfWar();
				
			}
		} else {
			//println("in cCity.manageProduction() cityEmpty=true");
		}
	}


	void doNextUnitProductionAI(int iPlayerId_) {

		//println("in city.doNextUnitProductionAI(" + iPlayerId_ + "), getCityIslandListId()=" + getCityIslandListId() );
		//println(">>>>>>>>>>>>>>>>>>="+ oIslandList.getIslandUnitTypeCount( getCityIslandListId(), iPlayerId_, 0 ) );

		int numTanks=0;
		int numDestroyer=0;
		int numTransport=0;

		// ***************************
		// note: temporarily for AI testing purposes, don't build any: fighters, carrier, submarine, battleship, etc.
		// ***************************

		//numTank = oUnitList.getCountOfPlayerUnitsByUnitType(iPlayerId_, 0);
		if (iPlayerId_==1) numTank = oPlayer1.getUnitTypeCount(0);
		else if (iPlayerId_==2) numTank = oPlayer2.getUnitTypeCount(0);

		//numTransport = oUnitList.getCountOfPlayerUnitsByUnitType(iPlayerId_, 6);
		if (iPlayerId_==1) numTransport = oPlayer1.getUnitTypeCount(6);
		else if (iPlayerId_==2) numTransport = oPlayer2.getUnitTypeCount(6);

		//numDestroyer = oUnitList.getCountOfPlayerUnitsByUnitType(iPlayerId_, 5);
		if (iPlayerId_==1) numDestroyer = oPlayer1.getUnitTypeCount(5);
		else if (iPlayerId_==2) numDestroyer = oPlayer2.getUnitTypeCount(5);


		// ******************************************************
		// if player transport is nearby waiting for tanks, build more tanks
		//if ( oUnitList.IsTransportNearbyWaitingForUnits( getCityPlayerId(), -1, getCellX(), getCellY() ) ) {
		if ( oUnitList.IsTransportNearbyWaitingForUnits( getCityPlayerId(), -1, getCityIslandListId() ) ) {

			productionUnitTypeId= oUnitRef[0].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[0].getDaysToProduce();


/* TODO: the following code causes an unexpected error which I have not been able to resolve yet.
		// ******************************************************
		// if is port city and island has too many tanks, build more transports
		if ( isPort() && ( oIslandList.getIslandUnitTypeCount( getCityIslandListId(), iPlayerId_, 0 )>15)  ) {

			productionUnitTypeId= oUnitRef[6].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[6].getDaysToProduce();
*/

		// ******************************************************
		// else, player needs a minimum number of tanks
		//if (numTank<=2 || oCityList.getCountPlayerCityProducingUnit(intCityPlayerId, 0)<=2 ) {
		} else if (numTank<=6 || oGameEngine.getDayNumber()<=15) {

			productionUnitTypeId= oUnitRef[0].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[0].getDaysToProduce();


		// ******************************************************
		// else, player should have a minimum number of transports
		//} else if (isPort() && ( numTransport <= 1 && oCityList.getCountPlayerCityProducingUnit(intCityPlayerId, 6)<=1 ) ) {
		} else if (isPort() && numTransport <= 1 ) {

			productionUnitTypeId= oUnitRef[6].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[6].getDaysToProduce();


		// ******************************************************
		// else, player should have a minimum number of destroyers
		//} else if ( isPort() && ( numDestroyer <= 1  && oCityList.getCountPlayerCityProducingUnit(intCityPlayerId, 5)<=1 ) ) {
		} else if ( isPort() && numDestroyer <= 3 ) {

			productionUnitTypeId= oUnitRef[5].getUnitTypeId(); 
			productionDaysLeft = oUnitRef[5].getDaysToProduce();



		} else if ( oGameEngine.getDayNumber() < 100 )  {

			// ******************************************************
			// if port city, build random unit
			if ( isPort() ) {
				switch( (int)random(1,8) ) {
					case 1:
						//productionUnitTypeId= oUnitRef[4].getUnitTypeId(); // carrier
						//productionDaysLeft = oUnitRef[4].getDaysToProduce();
						productionUnitTypeId= oUnitRef[5].getUnitTypeId(); // destroyer
						productionDaysLeft = oUnitRef[5].getDaysToProduce();
						break;	
					case 2:
						//productionUnitTypeId= oUnitRef[1].getUnitTypeId(); // fighter
						//productionDaysLeft = oUnitRef[1].getDaysToProduce();
						productionUnitTypeId= oUnitRef[5].getUnitTypeId(); // destroyer
						productionDaysLeft = oUnitRef[5].getDaysToProduce();
						break;
					case 3:
						productionUnitTypeId= oUnitRef[6].getUnitTypeId(); // transport
						productionDaysLeft = oUnitRef[6].getDaysToProduce();
						break;
					case 4:
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
						break;	
					case 5:
						productionUnitTypeId= oUnitRef[7].getUnitTypeId(); // submarine
						productionDaysLeft = oUnitRef[7].getDaysToProduce();
						break;
					case 6:
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
						break;	
					case 7:
						//productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
						//productionDaysLeft = oUnitRef[0].getDaysToProduce();
						break;				
					case 8:
						productionUnitTypeId= oUnitRef[5].getUnitTypeId(); // destroyer
						productionDaysLeft = oUnitRef[5].getDaysToProduce();
						break;						
				} 			

			// ******************************************************
			// else not a port city, build random unit			
			} else {

				productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
				productionDaysLeft = oUnitRef[0].getDaysToProduce();	
			}



		} else {


			// ******************************************************
			// if port city, build random unit
			if ( isPort() ) {
				switch( (int)random(1,8) ) {
					case 1:
						//productionUnitTypeId= oUnitRef[4].getUnitTypeId(); // carrier
						//productionDaysLeft = oUnitRef[4].getDaysToProduce();
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
						break;	
					case 2:
						//productionUnitTypeId= oUnitRef[1].getUnitTypeId(); // fighter
						//productionDaysLeft = oUnitRef[1].getDaysToProduce();
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
						break;
					case 3:
						productionUnitTypeId= oUnitRef[3].getUnitTypeId(); // bomber
						productionDaysLeft = oUnitRef[3].getDaysToProduce();
						break;
					case 4:
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
						break;	
					case 5:
						productionUnitTypeId= oUnitRef[7].getUnitTypeId(); // submarine
						productionDaysLeft = oUnitRef[7].getDaysToProduce();
						break;
					case 6:
						productionUnitTypeId= oUnitRef[2].getUnitTypeId(); // battleship
						productionDaysLeft = oUnitRef[2].getDaysToProduce();
						break;	
					case 7:
						productionUnitTypeId= oUnitRef[6].getUnitTypeId(); // transport
						productionDaysLeft = oUnitRef[6].getDaysToProduce();
						break;				
					case 8:
						productionUnitTypeId= oUnitRef[5].getUnitTypeId(); // destroyer
						productionDaysLeft = oUnitRef[5].getDaysToProduce();
						break;						
				} 			

			// ******************************************************
			// else not a port city, build random unit			
			} else {
				switch( (int)random(1,4) ) {
					case 1:
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
						break;
					case 2:
						//productionUnitTypeId= oUnitRef[1].getUnitTypeId(); // fighter
						//productionDaysLeft = oUnitRef[1].getDaysToProduce();
						productionUnitTypeId= oUnitRef[3].getUnitTypeId(); // bomber
						productionDaysLeft = oUnitRef[3].getDaysToProduce();
						break;
					case 3:
						productionUnitTypeId= oUnitRef[0].getUnitTypeId(); // tank
						productionDaysLeft = oUnitRef[0].getDaysToProduce();
						break;						
					case 4:
						productionUnitTypeId= oUnitRef[3].getUnitTypeId(); // bomber
						productionDaysLeft = oUnitRef[3].getDaysToProduce();
						break;
				} 			
			}

		}


		
	}

	
}



