
class cUnit {


	//********* generic to all units
	int intUnitTypeId;
	int intUnitPlayerId;
	int iUnitIslandListId;
	int intCellX, intCellY;
	int iMoveToCellX, iMoveToCellY;

	string strUnitName;
	int strength;
	int attackRange;
	bool caputuresCity;
	bool movesOnLand;
	bool movesOnWater;
	int movesPerTurn;
	int movesLeftToday;
	int attacksLeftToday;
	int fuel; // -1 = N/A

	//********* not really needed?
	int iDayBuilt;

	//********* specific to: BOMBER
	int iBombBlastRadius; // -1 = N/A

	//********* specific to: TRANSPORT and CARRIER
	//ArrayList listCargo;
	//int thisUnitIsCargoOfUnitId; // -1 = N/A
	int[] cargoUnitListId = new int[6];
	int iIsCargoOfUnitListId;

	int transportCargoLoadLocationX;
	int transportCargoLoadLocationY;
	
	int transportCargoDestinationLocationX;
	int transportCargoDestinationLocationY;

	int transportCargoLoadIslandId;

	//********* specific to: TANK
	int iDaysSinceLastClearedFogOfWar; 

	//*********************************
	// TASK STATUS
	//*********************************
	int iTaskStatus; // -1=N/A
	/*
	999=Dead.

	// specific to: TRANSPORT
	0=move to position beside player island (not under attack) where unit can accept cargo
	1=accept cargo
	2=cargo loaded, move to enemy island (or player island which is under attack)
	3=unload cargo
	4=return to cargo load location
	99=sleep
	
	// specific to: TANK
	0=move to using basic algorithm
	1=move to waiting transport
	99=sleep
	*/



	//****************************************************************
	//****************************************************************
	// class constructor
	cUnit(int intUnitTypeId_, int intUnitPlayerId_, int intCellX_, int intCellY_, int iUnitIslandListId_) {

		if( intUnitTypeId_!=-1 ) {
			
			if (intUnitPlayerId_==1 && debugCityProduction) println( "debug: in cUnit initiator, iUnitIslandListId_ = " + iUnitIslandListId_ );

			intUnitTypeId = intUnitTypeId_;
			intUnitPlayerId = intUnitPlayerId_;
			
			setUnitIslandListId(iUnitIslandListId_);

			intCellX=intCellX_;
			intCellY=intCellY_;
					
			strUnitName = oUnitRef[intUnitTypeId_].getUnitName()
			strength = oUnitRef[intUnitTypeId_].getStrength();
			attackRange = oUnitRef[intUnitTypeId_].getAttackRange();
			caputuresCity = oUnitRef[intUnitTypeId_].getCaputuresCity();
			movesOnLand = oUnitRef[intUnitTypeId_].getMovesOnLand();
			movesOnWater = oUnitRef[intUnitTypeId_].getMovesOnWater();
			movesPerTurn = oUnitRef[intUnitTypeId_].getMovesPerTurn();
			movesLeftToday = movesPerTurn;
			attacksLeftToday = 2;
			fuel = oUnitRef[intUnitTypeId_].getMaxFuel();
			
			if (intUnitTypeId_==3) {
				iBombBlastRadius=oUnitRef[3].calculateBombBlastRadius();
			} else iBombBlastRadius=-1;

			
			//listCargo = new ArrayList();  // Create an empty ArrayList
			//thisUnitIsCargoOfUnitId=-1;
			cargoUnitListId[0]=-1;
			cargoUnitListId[1]=-1;
			cargoUnitListId[2]=-1;
			cargoUnitListId[3]=-1;
			cargoUnitListId[4]=-1;
			cargoUnitListId[5]=-1;
			
			iIsCargoOfUnitListId=-1;

			iDayBuilt=oGameEngine.getDayNumber();
			
			iMoveToCellX=-1;
			iMoveToCellY=-1;
			
			if ( isTransport() || isTank() ) {
				iTaskStatus=0;
			} else {
				iTaskStatus=-1;
			}
			
			transportCargoLoadLocationX=-1;
			transportCargoLoadLocationY=-1;
			
			transportCargoDestinationLocationX=-1;
			transportCargoDestinationLocationY=-1;
	
			transportCargoLoadIslandId=getUnitIslandListId();

			if (intUnitPlayerId==1) oPlayer1.increaseUnitTypeCount(intUnitTypeId_, getUnitIslandListId() );
			else if (intUnitPlayerId==2) oPlayer2.increaseUnitTypeCount(intUnitTypeId_, getUnitIslandListId() );

			iDaysSinceLastClearedFogOfWar=0;

		} else {
			println( "error: cannot add unit for unit type " + intUnitTypeId_ );
			//exit();
		}

	}



	//****************************************************************
	//****************************************************************
	
	void printRowCol() {
		println(strUnitName+" at row="+intCellX+", col="+intCellY);
	}


	//int getPlayerId() { return intUnitPlayerId; }
	int getUnitPlayerId() { return intUnitPlayerId; }
	
	int getUnitTypeId() { return intUnitTypeId; }

	void setUnitIslandListId(int value_) { 
		iUnitIslandListId=value_; 
	}
	int getUnitIslandListId() { return iUnitIslandListId; }

	int getAge() { return oGameEngine.getDayNumber()-iDayBuilt; }
	
	
	void setXY(int intCellX_, int intCellY_) {
		
		intCellX=intCellX_;
		intCellY=intCellY_;
		
		// if this unit has cargo, update their XY values also
		if( isTransport() || isCarrier() ) {
		
			moveCargo(intCellX_, intCellY_);
		}
	}

	int getCellRow() { return intCellX; }
	int getCellCol() { return intCellY; }
	
	int getX() { return intCellX; }
	int getY() { return intCellY; }
	
	int setX(int value_) { intCellX=value_; }
	int setY(int value_) { intCellY=value_; }

	bool isAt(int cellX_, int cellY_) {
		if( intCellX==cellX_ && intCellY==cellY_ ) return true
		else return false;
	}

	bool isAtXY(int x_, int y_) {
		int tempX=int(floor((x_+(cellWidth-1))/cellWidth));
		int tempY=int(floor((y_+(cellHeight-1))/cellHeight));

		if( intCellX==tempX && intCellY==tempY ) {
			//println("unit.isAtXY("+x_+", "+y_+"), tempX=" + tempX + ", tempY=" + tempY + ", intUnitPlayerId="+intUnitPlayerId+" match!");
			return true
		} else {
			//println("unit.isAtXY("+x_+", "+y_+"), tempX=" + tempX + ", tempY=" + tempY + ", intUnitPlayerId="+intUnitPlayerId+" no match");
			return false;
		}
	}

	
	void setMoveToX(int value_) { iMoveToCellX=value_; }
	void setMoveToY(int value_) { iMoveToCellY=value_; }
	
	int getMoveToX() { return iMoveToCellX; }
	int getMoveToY() { return iMoveToCellY; }
	

	void setAttacksLeftToday(int value_) { attacksLeftToday=value_; }
	int getAttacksLeftToday() { return attacksLeftToday; }

	void setDaysSinceLastClearedFogOfWar(int value_) { iDaysSinceLastClearedFogOfWar=value_; }
	int getDaysSinceLastClearedFogOfWar() { return iDaysSinceLastClearedFogOfWar; }

	void reduceAttacksLeftToday() {

		if (attacksLeftToday>0) {
			attacksLeftToday=attacksLeftToday-1; 
		} 				
	}
	
	
	int getTaskStatus() { return iTaskStatus; }
	void setTaskStatus(int _value) { 
		iTaskStatus=_value; 
		//if (intUnitPlayerId==1 ) println("in unit.setTaskStatus("+iTaskStatus+") "); 
	}
	
	bool isAsleep() { 
		if (getTaskStatus()==99) return true; 
		else return false; 
	}
	
	bool isAlive() { 
		if (getTaskStatus()!=999) return true; 
		else return false; 
	}	
	

	boolean isNearby(int intCellX_, int intCellY_, int iCellCount) {
		if ( abs(intCellX_ - intCellX)<=iCellCount && abs(intCellY_ - intCellY)<=iCellCount ) return true;
		else return false; 
	}
	
	int getMovesPerDay() { return movesPerTurn; }
	
	int getMovesLeftToday() { return movesLeftToday; }
	void setMovesLeftToday(int value_) { movesLeftToday=value_; }	
	
	void updateMovesLeftToday() { 
		
		//println("debug: in unit.updateMovesLeftToday() ");

		if (movesLeftToday>0) {
			movesLeftToday=movesLeftToday-1; 
			//println("intUnitPlayerId#"+intUnitPlayerId+" movesLeftToday="+movesLeftToday);
			
		} else {
		
			//setAnimation(false);
			
			if ( intUnitPlayerId == 1 ) {
				oAnimate.clear();
			} 
			
		}		
				
	}
	
	bool isSeaVessel() {
	
		//println("debug: in unit.isSeaVessel() ");
	
		bool result = true;
		
		// Tank, Fighter, Bomber, Artillery, Helicopter, are not Sea Vessels
		// (this information should really be a column in unitref)
		if (intUnitTypeId==0 || intUnitTypeId==1 || intUnitTypeId==3 || intUnitTypeId==8 || intUnitTypeId==9 ) 
			result = false;
		
		return result;
	}

	bool isTank() {
		if (intUnitTypeId==0) return true;
		else return false;
	}
	
	bool isFighter() {
		if (intUnitTypeId==1) return true;
		else return false;
	}

	bool isBattleship() {
		if (intUnitTypeId==2) return true;
		else return false;
	}
	
	bool isBomber() {
		if (intUnitTypeId==3) return true;
		else return false;
	}

	bool isCarrier() {
		if (intUnitTypeId==4) return true;
		else return false;
	}

	bool isDestroyer() {
		if (intUnitTypeId==5) return true;
		else return false;
	}

	bool isTransport() {
		if (intUnitTypeId==6) return true;
		else return false;
	}

	bool isSubmarine() {
		if (intUnitTypeId==7) return true;
		else return false;
	}

	bool isBombable	() {

		//println("debug: in unit.isBombable() ");

		// a bomber cannot bomb an enemy fighter or bomber (they could only try to attack them)
		
		if (intUnitTypeId==0 || intUnitTypeId==2 || intUnitTypeId==4 || intUnitTypeId==5 || intUnitTypeId==6 || intUnitTypeId==7 || intUnitTypeId==8 ) return true;
		else return false;	
		
	}
	
	int getStrength() { return strength; }

	void reduceStrength() { 
	
		if (strength>0) {
			strength=strength-1; 
		} else {
			println("warning: in unit.reduceStrength() but unit has no strength left... ");
			//////////////////////////////oUnitList.deleteUnit(int iUnitListId_)
			//kill();
			
			//oUnitList.deleteUnit(iUnitListId_);
			//oGrid.DrawCell(getX(), getY(), false);
		}
	}
	
			
	void updateSelectedUnitPanelInformation() {
		
		string strMsg="";
		string strLocation = nf(intCellX,3)+","+nf(intCellY,3);

		if ( fuel==-1 ) strMsg = strUnitName +", strength "+ strength +", "+ movesLeftToday +" moves left, at "+strLocation;
		else strMsg = strUnitName +", strength "+ strength +", fuel: "+ fuel +", "+ movesLeftToday +" moves left, at "+strLocation;
		
		if (intUnitPlayerId==1) {
			oPanelGameMessageLine.show(strMsg);
		} else if (debugShowPlayer2Viewport) {
			oPanelGameMessageLine.show(strMsg);
		}
	}
	



	//****************************************************************
	//****************************************************************
			

	// specific to: fighters and bombers
	void updateFuelLeft(int iUnitListId_) {
	
		if (fuel>0) {
			fuel=fuel-1; 
			//println("intUnitPlayerId#"+intUnitPlayerId+" fuel="+fuel);
			
		} else {
		
			//setAnimation(false);
			
			if ( intUnitPlayerId == 1 ) {
				oAnimate.clear();
			} 
			
		}	
		
			
		// unit is a fighter or a bomber so can refuel in a city occupied by same player
		if ( oCityList.isCity(intCellX, intCellY)==true ) {
			int tempCityId = oCityList.getCityId(intCellX, intCellY);
			if ( oCityList.getCityPlayerId(tempCityId)==intUnitPlayerId ) {
				fuel = oUnitRef[intUnitTypeId].getMaxFuel();
			}
		}


		// TODO unit is a fighter or a bomber so can refuel on player carrier ship
		// ...


		
		if (fuel==0) {
		
			if(intUnitPlayerId==1) println(strUnitName+" ran out of fuel and crashed!");
			
			oUnitList.deleteUnit(iUnitListId_);
			oGrid.DrawCell(getX(), getY(), false);
			
		}
				
	}
	
	
	void doAttackEnemyCity(int iUnitListId_, int intCellX_, int intCellY_) {
	
		//println("in unit.doAttackEnemyCity() ");

		// try to conquer unoccupied city

		int tempCityId = oCityList.getCityId(intCellX_, intCellY_);
	
		reduceAttacksLeftToday();
	
		// possible outcomes: 
		// - if enemy units units exist in city, they defend the city so attacking unit must attack/destroy enemy units 
		// - if attacking unit can conquer city (tank=yes, fighter=no) and city contains no enemy units:
		//     - 50% probability attack fails, 50% probability unit strength is reduced
		//        - if stregth is 0 unit is destroyed
		//     - 50% probability attack is successful
		//        - set city playerId to that of attacking unit
		//        - delete attacking unit (it is absorbed into the city)


		bool cityAttackSuccessful=false;

		// 50% probability attack successful
		if ( (int)random(1,1000)%2==0 ) 				
			cityAttackSuccessful=true;

		//println("cityAttackSuccessful="+cityAttackSuccessful );

		if ( cityAttackSuccessful ) {

			if (intUnitPlayerId==1) {
				//println("Player "+ getUnitPlayerId() + " attack was successful");
				//println("");	
				oPanelGameMessageLine.show("city attack was successful");
			} else {
				oPanelGameMessageLine.show("city attack was successful");
			}

			oUnitList.deleteUnit(iUnitListId_);
			//oGrid.DrawCell(intCellX, intCellY, false);

			//reDrawNearBy();
			//clearFogOfWarAt(intCellX_, intCellY_);
			
			oCityList.CityConquered(tempCityId, intUnitPlayerId);
		
			
			
			//oViewport.draw();

		} else {


			updateMovesLeftToday();
			if ( oUnitRef[intUnitTypeId].canFly() ) updateFuelLeft(iUnitListId_);
			//if( intUnitPlayerId==1) reDrawNearBy();
			updateSelectedUnitPanelInformation();				


			// if attack was not successful, 
			if (intUnitPlayerId==1) {
				//println("Player "+ getUnitPlayerId() + " attack was not successful");
				//println("");
				oPanelGameMessageLine.show("city attack was not successful");
			} else {
				oPanelGameMessageLine.show("city attack was not successful");
			}
				
			// 50% probability unit strength is to be reduced
			if ( (int)random(1,1000)%2==0 ) {
			
				//if (intUnitPlayerId==1) println("reducing unit strength following unsuccessful attack");
					
				oUnitList.manageUnitStrengthReduction(iUnitListId_);
			}
			//reDrawNearBy();
			//clearFogOfWarAt(intCellX_, intCellY_);
		}
		
		oDoNothing.set();
	}
	
	


	void doAttackEnemyUnit(int iUnitListId_, int intCellX_, int intCellY_) {

		//println("in unit.doAttackEnemyUnit() ");

		bool unitAttackSuccessful=false;
		int factor;
		int iDefendingUnitListId;

		reduceAttacksLeftToday();

		// if enemy transport exists at attack location, attack that instead of any other units at that location
		iDefendingUnitListId = oUnitList.getFirstEnemyTransportUnitIdAt(intUnitPlayerId, intCellX, intCellY);
		if (iDefendingUnitListId==-1)
			iDefendingUnitListId = oUnitList.getFirstEnemyUnitIdAt(intUnitPlayerId, intCellX_, intCellY_);
		else 
			println("found enemy transport to attack");


		// possible outcomes: 
		//     - 50% probability attack fails, 50% probability unit strength is reduced
		//        - if stregth is 0 unit is destroyed
		//     - 50% probability attack is successful
		//        - kill enemy unit
		//        - only move attacking uit to destination location if destination location contains no further enemy units


		// probability attack successful is 50%
		// but is also a function of defending unit strength and attacking unit strength
		

		
		factor = 2 + oUnitList.getUnitStrength(iDefendingUnitListId) - oUnitList.getUnitStrength(iUnitListId_);
		if ( factor<1 ) factor=1;
		if ( (int)random(1,1000)%factor==0 ) 				
			unitAttackSuccessful=true;

		
		
		// exception: submarine should not try to attack bomber or fighter
		//if ( isFighter() && false ) unitAttackSuccessful=false;
		
		// exception: transport should not try to attack bomber or fighter
		//if ( isTransport() && false ) unitAttackSuccessful=false;
		
		
		//println("unitAttackSuccessful="+unitAttackSuccessful );


		updateMovesLeftToday();
		//println("in unit.doAttackEnemyUnit intUnitTypeId="+intUnitTypeId);
		if ( oUnitRef[intUnitTypeId].canFly() ) updateFuelLeft(iUnitListId_);
		//if( intUnitPlayerId==1) reDrawNearBy();
		updateSelectedUnitPanelInformation();				


		if ( unitAttackSuccessful ) {

			if (intUnitPlayerId==1) {
				//println("Player "+ getUnitPlayerId() + " attack was successful");
				//println("");
				oPanelGameMessageLine.show("unit attack was successful");
			} else {
				oPanelGameMessageLine.show("unit attack was successful");
			}
			
			//if (intUnitPlayerId==1) println("reducing defending unit strength following successful attack");

			oUnitList.manageUnitStrengthReduction(iDefendingUnitListId);			

			// only move attacking unit to destination location if destination location contains no further enemy units
			if ( oUnitList.isEnemyUnitAt(intUnitPlayerId, intCellX_, intCellY_)==false 
					&& oCityList.isEnemyCity(intUnitPlayerId, intCellX_, intCellY_)==false 
					&& oUnitList.isEnemyTransportAtRowCol(intUnitPlayerId, intCellX_, intCellY_)==false ) {
					
				//intCellX = intCellX_;
				//intCellY = intCellY_;
				//setXY(intCellX_, intCellY_);
				//Draw();
			}
			
		} else {

			// if attack was not successful, 
			if (intUnitPlayerId==1) {
				//println("Player "+ getUnitPlayerId() + " attack was not successful");
				//println("");
				oPanelGameMessageLine.show("unit attack was not successful");
			} else {
				oPanelGameMessageLine.show("unit attack was not successful");
			}


			// 50% probability unit strength is to be reduced
			if ( (int)random(1,1000)%2==0 ) {

				//if (intUnitPlayerId==1) println("reducing attacking unit strength following unsuccessful attack");

				oUnitList.manageUnitStrengthReduction(iUnitListId_);
			}
		}
		//reDrawNearBy();
		clearFogOfWarAt(intCellX_, intCellY_);

		oDoNothing.set();

	}

	
	void doDropBomb(int iUnitListId_, int intCellX_, int intCellY_) {

		int x, y, factor, counter;

		print("droping bomb");
		//frameRate(0);
		//println("millis()="+millis());
		
		/*
		Initially, the Bombers have a radius of 0, and can thus only destroy one square. However, for Bombers started after day 50, the radius of the Bomber goes up to 1, meaning that the same bomb can now destroy 9 squares and everything in them. After day 100, Bombers will have radius 2, and will destroy a total of 25 squares. 
		*/


		setXY(intCellX_, intCellY_);
		//clearFogOfWarAt(intCellX_, intCellY_);
		reDrawNearBy();
		oGrid.DrawCell(intCellX, intCellY, false);



		int ShowFromCellX, ShowFromCellY;

		if ( oGameEngine.getCurrentPlayerId()==1 ) { 
			ShowFromCellX = oPlayer1.getShowFromCellX();
			ShowFromCellY = oPlayer1.getShowFromCellY();
		} else {
			ShowFromCellX = oPlayer2.getShowFromCellX();
			ShowFromCellY = oPlayer2.getShowFromCellY();
		}



		// draw bomb explosion
		int DisplayX=((intCellX_-ShowFromCellX+1)*cellWidth)-(cellWidth-1);
		int DisplayY=((intCellY_-ShowFromCellY+1)*cellHeight)-(cellHeight-1);
		fill(126);
		
		//println("drawing bomb blast radius "+iBombBlastRadius);
		//println("drawing bomb blast radius "+(iBombBlastRadius+1));
		//println("drawing bomb blast radius "+( (iBombBlastRadius+1) * 16 ));
		//println("drawing bomb blast radius "+round( ( (iBombBlastRadius+1) * 16 ) / 2 ) );
		
		int iDisplayRadius = round( ( (iBombBlastRadius+1) * cellWidth )  );
		int iDisplayRadiusX = round( ( (iBombBlastRadius+1) * cellWidth )  );
		int iDisplayRadiusY = round( ( (iBombBlastRadius+1) * cellHeight )  );
		iDisplayRadius=iDisplayRadius+8;
		iDisplayRadiusX=iDisplayRadiusX+(cellWidth/2);
		iDisplayRadiusY=iDisplayRadiusY+(cellHeight/2);
		
		ellipse(DisplayX+8, DisplayY+8, iDisplayRadiusX, iDisplayRadiusY);
		
		// TODO: NOTE: drawing a large vircle will be a problem if near edge of viewport
		
		redraw();
		
		



		// kill any units in destination location
		switch(iBombBlastRadius) {
		
			case 0: // 1
				//println("debug#1");
				doBombLocation(intCellX_, intCellY_);
				//println("debug#2");
				break;
				
			case 1: // 3x3=9
			
				// XXX
				// XOX
				// XXX
				
				doBombLocation(intCellX_-1, intCellY_-1);
				doBombLocation(intCellX_-1, intCellY_);
				doBombLocation(intCellX_-1, intCellY_+1);

				doBombLocation(intCellX_, intCellY_-1);
				doBombLocation(intCellX_, intCellY_);
				doBombLocation(intCellX_, intCellY_+1);
				
				doBombLocation(intCellX_+1, intCellY_-1);
				doBombLocation(intCellX_+1, intCellY_);
				doBombLocation(intCellX_+1, intCellY_+1);
				break;
				
			case 2: // 5x5
			
				// XXXXX
				// XXXXX
				// XXOXX
				// XXXXX
				// XXXXX
				
				factor=2;
				for (x=intCellX_-factor; x<=intCellX_+factor; x++) {
					for (y=intCellY_-factor; y<=intCellY_+factor; y++) {
						doBombLocation(x, y);

					}
				}
				break;	

			default:
				
				factor=iBombBlastRadius;
				for (x=intCellX_-factor; x<=intCellX_+factor; x++) {
					for (y=intCellY_-factor; y<=intCellY_+factor; y++) {
						doBombLocation(x, y);
					}
				}
				break;					
		}



		
		// kill bomber (the Bomber is a one-shot piece)
		//println("debug#1 kill bomber");
		//oUnitList.deleteUnit(iUnitListId_);
		//println("debug#2 kill bomber");
		

		//if (getUnitPlayerId()==1) clearFogOfWar();
		//clearFogOfWar();
		//reDrawNearBy();
		//oGrid.DrawCell(intCellX, intCellY, false);


	
	
		//println("about to pause game");
		//println("GameState="+GameState);
		//GameState=3;
		//redraw();
		
		//for(counter=0; counter<10000; counter++) { x=counter; }
		
		
		
		//long temp=millis();
		//while(millis()-temp<2000);
		
		
		//println("about to resume game");
		//GameState=2;
		//println("game resumed");
		//frameRate(3);
		
		oDoNothing.set();

	}
	
	void doBombLocation(int x_, int y_) {
	
		oUnitList.killUnitsAt(x_, y_);

		// if City, change to unoccupied
		if ( oCityList.isEnemyCity(intUnitPlayerId, x_, y_) ) {
			//println("debug#1.3");
			oCityList.CityBombed( oCityList.getCityId(x_, y_) );
		}
	}
	
	
	
	
		
	void kill() { 
	
		setTaskStatus(999);
		movesLeftToday=0; 
		thisUnitIsCargoOfUnitId=-1;


		if (intUnitPlayerId==1) oPlayer1.decreaseUnitTypeCount(intUnitTypeId, getUnitIslandListId() );
		else if (intUnitPlayerId==2) oPlayer2.decreaseUnitTypeCount(intUnitTypeId, getUnitIslandListId() );

		// hide unit
		////////oGrid.DrawCell(intCellX, intCellY, false);
	}
	
	
	// ***********************************************************
	// CARGO (a transpot and a carrier can contain units)
	// ***********************************************************

	bool hasCargo() {
	
		//println("in hasCargo()");
	
		for (int i=0; i<6; i++) {
			if ( cargoUnitListId[i] != -1 ) return true;
		}
		//println("no cargo found.");
		return false;		
	}

	int getCargoCount() {
	
		//println("getCargoCount()");
	
		int counter=0;
		for (int i=0; i<6; i++)
			if ( cargoUnitListId[i] != -1 ) counter++;
			
		return counter;
	}

	void printCargo() {

		//println("in printCargo()");
		
		for (int i=0; i<6; i++)
			if ( cargoUnitListId[i] != -1 ) println("cargo["+i+"]="+cargoUnitListId[i]);
		
	}
	
	void wakeCargo() {

		//println("in wakeCargo()");
		
		//oUnitList.commandWakePlayerUnitsAt(intUnitPlayerId, getX(), getY() );
		
		for (int i=0; i<6; i++)
			if ( cargoUnitListId[i] != -1 ) {
				oUnitList.wake( cargoUnitListId[i] );
			}
		
	}

	void moveCargo(int x_, int y_) {

		//println("in moveCargo()");
		
		for (int i=0; i<6; i++)
			if ( cargoUnitListId[i] != -1 ) {
				//oUnitList.move( cargoUnitListId[i], x_, y_ );
				oUnitList.moveCargo( cargoUnitListId[i], x_, y_ );
			}
	}
	
	void addCargo(int iUnitListId_) {
	
		//println("in unit.addCargo("+iUnitListId_+") ");
		
		int i;
		bool done;
		
		// unit should not already exist in cargo
		done=false;
		for (i=0; i<6 && done==false; i++) {
			//println("i="+i+", cargoUnitListId["+i+"]="+cargoUnitListId[i]);
			if ( cargoUnitListId[i] == iUnitListId_ ) {
				println("error: unit should not already exist in cargo");
				done=true;
			}
		}
		
		//done=false;
		for (i=0; i<6 && done==false; i++) {
			//println("i="+i+", cargoUnitListId["+i+"]="+cargoUnitListId[i]);
			if ( cargoUnitListId[i] == -1 ) {
				cargoUnitListId[i]=iUnitListId_;
				done=true;
				//setTaskStatus(99);
				//setMoveToX(-1);
				//setMoveToY(-1);
				//setMovesLeftToday(0);
			}
		}
		
		if (!done) println("error: unable to add cargo!!!!!!!!!!");
	}

	void clearCargoUnit(int iUnitListId_) {
	
		//println("in unit.clearCargoUnit("+iUnitListId_+") ");

		for (int i=0; i<6; i++)
			if ( cargoUnitListId[i] == iUnitListId_ ) {
				cargoUnitListId[i]=-1;
				//println("in unit.deleteCargo("+iUnitListId_+") successful");
			}
			
		//println("in unit.clearCargoUnit("+iUnitListId_+") leaving function");
		//printCargo();
		
	}
	
	
	
	void deleteAllCargo() {
		
		for (int i=0; i<6; i++)
			cargoUnitListId[i]=-1;			
	}
	
	
	void doAddCargo(int iUnitListId_, int intCellX_, int intCellY_) {

		//if (intUnitPlayerId==1) println("in unit.doAddCargo(iUnitListId_="+iUnitListId_+","+intCellX_+","+intCellY_+") ");
		
		int destinationUnitId;
		
		// if unit is tank, get unit list id of destination transport
		if ( isTank() ) destinationUnitId = oUnitList.getFirstPlayerTransportUnitIdAt(intUnitPlayerId, intCellX_, intCellY_);
		
		// if unit is fighter, get unit list id of destination carrier
		if ( isFighter() ) destinationUnitId = oUnitList.getFirstPlayerCarrierUnitIdAt(intUnitPlayerId, intCellX_, intCellY_);
		
		if ( destinationUnitId != -1 ) {
			// add current unit to destination transport or carrier cargo
			//println("adding current unit to destination transport or carrier cargo (unitListId="+destinationUnitId+")");
			//listCargo.add( iUnitListId_ );  
			//cUnit unit = (cUnit) listCargo.get(destinationUnitId);
			//unit.addCargo( destinationUnitId );  
			///////////setTaskStatus(99);
			oUnitList.addUnitCargo( iUnitListId_, destinationUnitId );
			//printCargo();
			
			setXY(intCellX_, intCellY_);
			setIsCargoOf(destinationUnitId);
			setMoveToX(-1);
			setMoveToY(-1);

			if ( oUnitList.isFighter(iUnitListId_) ) {
				//setMovesLeftToday( getMovesPerDay() );
				fuel = oUnitRef[intUnitTypeId].getMaxFuel();
				updateSelectedUnitPanelInformation();
			} else { 
				updateMovesLeftToday();
				setMovesLeftToday(0);
				setTaskStatus(99);
				setUnitIslandListId(-1);
			}
			reDrawNearBy();

			
			if ( oUnitRef[intUnitTypeId].canFly() ) updateFuelLeft(iUnitListId_);
			//if( intUnitPlayerId==1) reDrawNearBy();
			updateSelectedUnitPanelInformation();				
			
		} else println("error: expected to add unit as cargo to destination unit but destinationUnitId="+destinationUnitId);

	}
	
	void setIsCargoOf(int UnitListId_) {
		iIsCargoOfUnitListId=UnitListId_;
	}

	int getIsCargoOf() {
		return iIsCargoOfUnitListId;
	}

	bool isCargoOf() {
		if(iIsCargoOfUnitListId==-1) return false;
		return true;
	}
	


	// ***********************************************************
	// MOVE
	// ***********************************************************

	void resetMovesLeftToday() {
		movesLeftToday = movesPerTurn; 

	}


	void moveToIfSpecified(int iUnitListId_) {

		//println("in unit.moveToIfSpecified current="+intCellX+","+intCellY+" MoveToCell="+iMoveToCellX+","+iMoveToCellY+" getUnitTypeId()="+getUnitTypeId());

		// *********************************************
		// if is transport and status="cargo loaded, move to another island (an unoccupied island, an enemy island (or a player island which is under attack)"
		// *********************************************
		//println("in Unit.moveToIfSpecified(), debug #1 line 960, transportCargoLoadIslandId="+transportCargoLoadIslandId);
		//println("oGrid.isNextToLand("+intCellX+", "+intCellY+")="+ oGrid.isNextToLand(intCellX, intCellY) );
		//println("oGrid.getIslandIdIfIsNextToLand("+intCellX+", "+intCellY+")="+ oGrid.getIslandIdIfIsNextToLand(intCellX, intCellY) );

		if ( isTransport() && getTaskStatus()==2 
				&& intCellX!=transportCargoLoadLocationX
				&& intCellY!=transportCargoLoadLocationY
				&& oGrid.isNextToLand(intCellX, intCellY) 
				&& oGrid.getIslandIdIfIsNextToLand(intCellX, intCellY)!=transportCargoLoadIslandId  
			) {


				//transportCargoDestinationLocationX=intCellX;
				//transportCargoDestinationLocationY=intCellY;
				//println("************************************************");
				//println("transport... is isNextToLand at ("+intCellX+","+intCellY+")");
				//println("************************************************");
				setMoveToX(-1);
				setMoveToY(-1);
				updateMovesLeftToday();
				//println("getCargoCount()="+getCargoCount() );
				if ( getCargoCount()>0 ) wakeCargo();
				setTaskStatus(3);				
			
				//println("in Unit.moveToIfSpecified(), debug #2 line 993");
	
		} else if ( iMoveToCellX!=-1 && iMoveToCellY!=-1 && getMovesLeftToday()>=1 ) 
			moveTo(iUnitListId_, iMoveToCellX, iMoveToCellY);
		else {
			if (intUnitPlayerId==2) {
				if ( oPlayer2.getIsAI() ) moveAI(iUnitListId_);
			} else {
				if ( oPlayer1.getIsAI() ) moveAI(iUnitListId_);
			}
		}
	}

	void moveTo(int iUnitListId_, int intCellX_, int intCellY_) {

		//println("in unit.moveTo current="+intCellX+","+intCellY+" MoveToCell="+intCellX_+","+intCellY_+" getUnitTypeId()="+getUnitTypeId());

		int iNextCellX, iNextCellY;

		//setAnimation(false);
		
		if ( intUnitPlayerId == 1 ) {
			oAnimate.clear();
		} 		

		// store destination
		//if (iMoveToCellX==-1 && iMoveToCellY==-1) {
			iMoveToCellX=intCellX_;
			iMoveToCellY=intCellY_;
		//}


		if ( isAsleep()==true ) { 

			setMovesLeftToday(0);

		} else if ( getMovesLeftToday()>=1 && ( isFighter() || isBomber() ) ) {

			// use simple move logic
			if ( intCellX_ < intCellX ) iNextCellX = intCellX-1;
			else if ( intCellX_ > intCellX ) iNextCellX = intCellX+1;
			else iNextCellX = intCellX;

			if ( intCellY_ < intCellY ) iNextCellY = intCellY-1;
			else if ( intCellY_ > intCellY ) iNextCellY = intCellY+1;
			else iNextCellY = intCellY;

			// if unit has reached destination
			if (iMoveToCellX==iNextCellX && iMoveToCellY==iNextCellY) {
				setMoveToX(-1);
				setMoveToY(-1);
			}

			move(iUnitListId_, iNextCellX, iNextCellY);
			
		} else if ( getMovesLeftToday()>=1 ) {
			int moves_on=0;
			if (movesOnLand) moves_on=1;

			//if (intUnitPlayerId==1) println("calling pathfinding using "+intCellX+","+intCellY+" "+intCellX_+","+intCellY_ );

			oPathfinding = new cPathfinding();
			next_step = oPathfinding.getNextMove(intUnitPlayerId, intCellX, intCellY, intCellX_, intCellY_, moves_on);

			//if ( isTransport() && intUnitPlayerId==1 && debugTransport ) 
			//	println("pathfinding result="+next_step.x+","+next_step.y);


			//pathfinding found next step	
			if (next_step.x!=-3 && next_step.y!=-3) {

				iNextCellX=next_step.x;
				iNextCellY=next_step.y;

			//pathfinding unable to find next step							
			} else {

				// TODO: problem, fix later
				
				//if ( !isFighter() || !isBomber() ) {
					//setMoveToX(-1);
					//setMoveToY(-1);
				//}
				
				////////////////////updateMovesLeftToday();
				if ( isTank() ) {
					//if (intUnitPlayerId==1) println("in unit.moveTo, setting task status=0");
					setTaskStatus(0);
					setMoveToX(-1);
					setMoveToY(-1);
				}

				// so try simple move logic
				if ( intCellX_ < intCellX ) iNextCellX = intCellX-1;
				else if ( intCellX_ > intCellX ) iNextCellX = intCellX+1;
				else iNextCellX = intCellX;

				if ( intCellY_ < intCellY ) iNextCellY = intCellY-1;
				else if ( intCellY_ > intCellY ) iNextCellY = intCellY+1;
				else iNextCellY = intCellY;					
			}


			// if unit has reached destination
			if (iMoveToCellX==iNextCellX && iMoveToCellY==iNextCellY) {
				setMoveToX(-1);
				setMoveToY(-1);
			}

			//if (intUnitPlayerId==1) println(" in unit.moveTO(), calling unit.move("+iNextCellX+","+iNextCellY+")");
			move(iUnitListId_, iNextCellX, iNextCellY);
		}

	}


	void move(int iUnitListId_, int intCellX_, int intCellY_) {

		//println("in unit.move() ");
		//println("in unit.move() getUnitTypeId()="+getUnitTypeId() +" MoveTo="+getMoveToX()+","+getMoveToY()+" step="+intCellX_+","+intCellY_);
		
		updateSelectedUnitPanelInformation();

		if( checkPreMoveValidationRules(iUnitListId_, intCellX_, intCellY_)==false) {
		
			//println("in unit.move() pre move validation failed. getUnitTypeId()="+getUnitTypeId() +" getMoveToX()="+getMoveToX()+", getMoveToY()="+getMoveToY());
			//println("intCellX_="+intCellX_+", intCellY_="+intCellY_);
			setMoveToX(-1);
			setMoveToY(-1);
			updateMovesLeftToday();
			
		} else {

			
			if ( getUnitPlayerId()==1 ) { 
				oViewport.scrollIfAppropriate2( getX(), getY() );
				//oPlayer1.setShowFromCellX( getX()-10 );
				//oPlayer1.setShowFromCellY( getY()-10 );
			} else {
				oViewportPlayer2.scrollIfAppropriate2( getX(), getY() );
				//oPlayer2.setShowFromCellX( getX()-10 );
				//oPlayer2.setShowFromCellY( getY()-10 );
			}
		
		
			//setAnimation(false);

			if ( intUnitPlayerId == 1 ) {
				oAnimate.clear();
			} 
			
			// *********************************************
			// draw cell before moving current unit 
			//       if city, draw city
			//       else if other units exist in cell, draw that unit
			//           (e.g. transport, carrier)
			//       else if land, draw land
			//       else if sea, draw sea

			//if( oCityList.isCity(intCellX, intCellY)==true ) {
			//	oCityList.Draw(intCellX, intCellY);
			//} else if ( oUnitList.isUnit(...)==true ) {
			//} else { 
			
				// draw current location (city or land or sea)
				oGrid.DrawCell(intCellX, intCellY, false);
				
			//}

			

			
			
			//if( intUnitPlayerId==1) println(" in unit.move() debug#1");

			// *********************************************
			// if unit is bomber and destination contains enemy city or enemy unit (not a fighter or bomber), bomb it
			// *********************************************
			
			
			/*
			if( intUnitPlayerId==1) println(" isBomber()="+isBomber() );
			
			if ( isBomber() ) {
				println("oCityList.isEnemyCity()="+ oCityList.isEnemyCity(intUnitPlayerId, intCellX_, intCellY_) );
				println("oUnitList.isBombableEnemy()="+ oUnitList.isBombableEnemy(intUnitPlayerId, intCellX_, intCellY_) );
			}
			*/
			
			if ( isBomber() && ( ( oCityList.isEnemyCity(intUnitPlayerId, intCellX_, intCellY_) 
						&& !oCityList.isUnoccupiedCity(intCellX_, intCellY_) ) 
						|| oUnitList.isBombableEnemy(intUnitPlayerId, intCellX_, intCellY_) ) ) {
			
				//println("isBomber()="+isBomber());
				//println("oCityList.isEnemyCity()="+oCityList.isEnemyCity(intUnitPlayerId, intCellX_, intCellY_));
				//println("oCityList.isUnoccupiedCity()="+oCityList.isUnoccupiedCity(intCellX_, intCellY_));
				//println("oUnitList.isBombableEnemy()="+oUnitList.isBombableEnemy(intUnitPlayerId, intCellX_, intCellY_));
				
				//if (intUnitPlayerId==1) println(" in unit.move() debug#2");
				doDropBomb(iUnitListId_, intCellX_, intCellY_);
				
			// *********************************************
			// if destination contains enemy unit, attack it
			// *********************************************
			} else if ( oUnitList.isEnemyUnitAt(intUnitPlayerId, intCellX_, intCellY_) ) {
			
				//doAttackEnemyUnit(iUnitListId_, intCellX_, intCellY_);

				oAnimateAttack.set(iUnitListId_);
				oAnimateAttack.setAttackType(2);
				oAnimateAttack.setAttackerObjectListId(iUnitListId_);
				oAnimateAttack.setDefenderObjectX(intCellX_);
				oAnimateAttack.setDefenderObjectY(intCellY_);

				
			// *********************************************
			// if unit is tank and destination location is enemy/unoccupied city, attack it
			// *********************************************
			} else if ( isTank() && oCityList.isEnemyOrUnoccupiedCity(intUnitPlayerId, intCellX_, intCellY_) ) {
			
				//doAttackEnemyCity(iUnitListId_, intCellX_, intCellY_);

				oAnimateAttack.set(iUnitListId_);
				oAnimateAttack.setAttackType(1);
				oAnimateAttack.setAttackerObjectListId(iUnitListId_);
				oAnimateAttack.setDefenderObjectX(intCellX_);
				oAnimateAttack.setDefenderObjectY(intCellY_);
				
			
			// *********************************************
			// if unit is tank and destination contains player transport, move into it
			// *********************************************
			} else if ( isTank() && oUnitList.isPlayerTransportAtRowCol(intUnitPlayerId, intCellX_, intCellY_) ) {
			
				doAddCargo(iUnitListId_, intCellX_, intCellY_);
			
			// *********************************************
			// if unit is fighter and destination contains player carrier, move into it
			// *********************************************
			} else if ( isFighter() && oUnitList.isPlayerCarrierAtRowCol(intUnitPlayerId, intCellX_, intCellY_) ) {
			
				fuel = oUnitRef[intUnitTypeId].getMaxFuel();
				doAddCargo(iUnitListId_, intCellX_, intCellY_);
			
			// *********************************************
			// else just do the move
			// *********************************************
			} else {
			
				// if unit just stepped off a transport
				if( isCargoOf() ) {
					//println("in unit.move, tank might just have stepped off a transport, clear unit from transport");
					//println("unit getIsCargoOf()="+getIsCargoOf() );
					//println("unit iUnitListId_="+iUnitListId_ );
					oUnitList.clearUnitFromCargoOf( getIsCargoOf(), iUnitListId_ );
					setIsCargoOf(-1);
				}
				oGrid.DrawCell(intCellX, intCellY, false);
				
				setXY(intCellX_, intCellY_);
				reDrawNearBy();
				updateMovesLeftToday();
				if ( oUnitRef[intUnitTypeId].canFly() ) updateFuelLeft(iUnitListId_);
				//if( intUnitPlayerId==1) reDrawNearBy();
				updateSelectedUnitPanelInformation();				
				
			}
			
		}
		
	}





	// *********************************************
	// PRE-MOVE VALIDATION RULES
	// *********************************************	
	private bool checkPreMoveValidationRules(int iUnitListId_, int intCellX_, int intCellY_) {

		/*
		if ( oGrid.getGridIslandId( getX(),getY() ) != getUnitIslandListId() ) {
			println("debug: in unit.checkPreMoveValidationRules(), unit islandListId ("+getUnitIslandListId()+") is not equal to grid islandListId ("+oGrid.getGridIslandId( getX(),getY() )+")");
			setUnitIslandListId( oGrid.getGridIslandId( getX(),getY() ) );
		}
		*/
		
		bool ValidMove=true;
	
		if( intCellX==intCellX_ && intCellY==intCellY_ ) {
			//if (intUnitPlayerId==1) println("possible invalid move. unit is not moving anywhere.");
			//ValidMove=false;
		}

		if( movesLeftToday<=0 ) {

			println("invalid move. unit has no more moves left today.");
			
			ValidMove=false;

			//setAnimation(false);

			if ( intUnitPlayerId == 1 ) {
				oAnimate.clear();
			} 
			
		}
		
		if ( oUnitRef[intUnitTypeId].canFly() ) {
			if (fuel==0) {
				println("invalid move. unit has no fuel.");
				ValidMove=false;
			}
			
		}
		
		// ***********************************
		// if destination cell is NOT a city
		if( oCityList.isCity(intCellX_, intCellY_)==false ) {
			
			if( movesOnLand==true && movesOnWater==false) {
				
				if( oGrid.isSea(intCellX_, intCellY_)==true ) {
					
					// an exception is a tank can move onto a transport of the same player id
					if( oUnitList.isPlayerTransportAtRowCol(intUnitPlayerId, intCellX_, intCellY_) ) {
						
						if ( isTank() ) {
						
							// an exception is that if the transport is full, unit cannot move into it
							if ( oUnitList.isPlayerTransportFullAtRowCol(intUnitPlayerId, intCellX_, intCellY_)==true ) {
								ValidMove=false;
								setMoveToX(-1);
								setMoveToY(-1);
							}
						}
						
					} else {
					
						//if ( intUnitPlayerId==1 ) println("invalid move. unit cannot move on sea. getUnitTypeId()="+getUnitTypeId()+" isCargoOf()="+isCargoOf() );
						
						ValidMove=false;
						setMoveToX(-1);
						setMoveToY(-1);
					}
				}
			}
			
			if( movesOnLand==false && movesOnWater==true) {
				
				if( oGrid.isLand(intCellX_, intCellY_)==true ) {
				
					// destination cell is Land
					
					//println(" destination cell is Land ");
					
					
					
					//TODO: an exception is a ship can attack enemy units on land (even if they are in an emeny city)
					// ...
				
					//println("invalid move. unit cannot move on land.");
					ValidMove=false;
					setMoveToX(-1);
					setMoveToY(-1);
				} else {
					// destination cell is Sea
					
					// an exception is a ship cannot move into another cell which is already occupied by a ship of the same player id
					if( oUnitList.isPlayerSeaVesselAtRowCol(intUnitPlayerId, intCellX_, intCellY_) ) {
					
						//println("invalid move. two sea vessels of same player cannot occupy the same location.");
						ValidMove=false;
						setMoveToX(-1);
						setMoveToY(-1);
						if ( isTank() ) {
							setMovesLeftToday(0);
							setTaskStatus(99);
						}
					}
				}
			}
			

		// ***********************************	
		// if destination cell is a city
		} else {
		
			// if unit is sea vessel and destination cell is an enemy city
			// which is empty, unit should not be able to move into it
			if ( oCityList.isEnemyCity(intUnitPlayerId, intCellX_, intCellY_) 
				&& isSeaVessel() 
				&& oUnitList.isEnemyUnitAt(intUnitPlayerId, intCellX_, intCellY_)==false ) {
				
				println("invalid move. unit cannot move into empty enemy city.");
				ValidMove=false;
			}

			//note: a sea vessel can move into same player city
			
			//TODO: if destination cell is an enemy city, player unit can only 
			// attack a maximum of 2 times per turn
			//...
			
		}
		
		if ( getAttacksLeftToday()==0 
			&& ( oCityList.isEnemyCity(intUnitPlayerId, intCellX_, intCellY_)  
				|| oUnitList.isEnemyUnitAt(intUnitPlayerId, intCellX_, intCellY_) )
			) {

			//println("invalid move. unit can only attack twice per day.");
			ValidMove=false;
			setMoveToX(-1);
			setMoveToY(-1);
		}
		
		return ValidMove;
	}

	




	// *********************************************
	// MOVE AI
	// *********************************************	

	void moveAI(int iUnitListId_) {

		//if ( intUnitPlayerId==1 && isTank() ) println("in unit.moveAI, isTank()="+isTank() );

		if ( isTank() ) {
			identifyNextMoveTankAI(iUnitListId_);

		} else if ( isAsleep()==false ) {

			if ( isFighter() ) {
				identifyNextMoveFighterAI(iUnitListId_);

			} else if ( isBomber() ) {
				identifyNextMoveBomberAI(iUnitListId_);

			} else if ( isTransport() ) {
				identifyNextMoveTransportAI(iUnitListId_);

			//} else if ( isTank() ) {
			//	identifyNextMoveTankAI(iUnitListId_);

			} else {
				identifyNextMoveAI(iUnitListId_);

			}
		}
		
	}
	
	
	
	void identifyNextMoveTankAI(int iUnitListId_) {

		//if ( intUnitPlayerId==1 ) println("in unit.identifyNextMoveTankAI");

		//if (intUnitPlayerId==1 && isCargoOf() ) println("in unit.identifyNextMoveTankAI, "+intCellX+","+intCellY+" unit status="+getTaskStatus()+", isCargoOf()="+isCargoOf() );
		
		//if ( intUnitPlayerId==1 ) println("in unit.identifyNextMoveTankAI, "+intCellX+","+intCellY+" unit status="+getTaskStatus()+", getDaysSinceLastClearedFogOfWar()="+ getDaysSinceLastClearedFogOfWar()+", IsTransportNearbyWaitingForUnits()="+oUnitList.IsTransportNearbyWaitingForUnits(intUnitPlayerId, iUnitListId_, intCellX, intCellY) );

		//if ( intUnitPlayerId==1 ) println("in unit.identifyNextMoveTankAI, "+intCellX+","+intCellY+" unit status="+getTaskStatus() );

		switch ( getTaskStatus() ) {
			
			case 0: 

		
				// ******************************************************
				// move to X,Y if specified
				if (iMoveToCellX!=-1 && iMoveToCellY!=-1) {

					moveToIfSpecified(iUnitListId_);

				// ******************************************************
				// TODO: else, if it is less than 10 days since last enemy contact
				} else if ( false ) {

					// move to using basic algorithm (see below)
					identifyNextMoveAI(iUnitListId_);

				// ******************************************************
				// else, if no fog cleared recently, go to sleep
				} else if ( getDaysSinceLastClearedFogOfWar() >3 ) {

					//if ( intUnitPlayerId==1 ) println("in unit.identifyNextMoveTankAI, sleep because no fog cleared in last 4 days");
					setTaskStatus(99); // sleep
					oAnimate.clear();
					setMovesLeftToday(0);
					setMoveToX(-1);
					setMoveToY(-1);

				// ******************************************************
				// else, move to using basic algorithm
				} else {
					//if (intUnitPlayerId==1 && isCargoOf() ) println("0=calling identifyNextMoveAI() ");
					identifyNextMoveAI(iUnitListId_);				
				}



				//if ( isCargoOf() ) {
				//	setTaskStatus(99);
				//} else {
					//println("calling identifyNextMoveAI() ");
					//identifyNextMoveAI(iUnitListId_);				
				//}


				break;

			case 1:
				// 1=move to waiting transport
				
				if (intUnitPlayerId==1 && debugTransport ) println("1=move to waiting transport, tank at "+getX()+","+getY()+", moving to transport at ("+getMoveToX()+","+getMoveToY()+") ");
						// && isCargoOf()
				
				/*
				if ( getMoveToX()==-1 && getMoveToY()==-1 ) {
					println("in unit.identifyNextMoveTankAI, unit status=1, assumed to have moved onto transport, so sleep.");
					setTaskStatus(99);
				}
				*/
					

									
				if ( isCargoOf() ) {
					
					if (intUnitPlayerId==1 && debugTransport ) println("debug: tank is cargoOf");
					setTaskStatus(99);
					setMovesLeftToday(0);

				} else {
					
					if ( getMoveToX()==-1 && getMoveToY()==-1 ) {
						setTaskStatus(0); // move to using basic algorithm

					} else if ( oUnitList.getFirstPlayerTransportUnitIdAt(intUnitPlayerId, getMoveToX(), getMoveToY())==-1 ) {

						if (intUnitPlayerId==1 && debugTransport ) println("debug: tank at "+getX()+","+getY()+", moving to transport at ("+getMoveToX()+","+getMoveToY()+") not where expected, set tank to sleep and tank movetoXY=-1");
						setTaskStatus(0); // move to using basic algorithm
						setMoveToX(-1);
						setMoveToY(-1);
						
					} else {
						setDaysSinceLastClearedFogOfWar(0);
						moveToIfSpecified(iUnitListId_);
					}
				}

				break;

			case 99:
				//if (intUnitPlayerId==1 ) println("99=unit sleep ");
						// && isCargoOf()
				//if (intUnitPlayerId==1) println("debug: unit is asleep");
				// 99=sleep
					


				if ( isCargoOf() ) {

					setMovesLeftToday(0);
					// do nothing

				// ******************************************************
				// if transport is nearby which is waiting for units, move towards it
				//if ( oUnitList.IsTransportNearbyWaitingForUnits(intUnitPlayerId, iUnitListId_, intCellX, intCellY)  ) {
				} else if ( oUnitList.IsTransportNearbyWaitingForUnits(intUnitPlayerId, iUnitListId_, getUnitIslandListId() )  ) {

					//if ( intUnitPlayerId==1 ) println("unit has been instructed to move towards waiting transport");

					// unit has been instructed to move towards waiting transport
					//if ( isAsleep() ) {
						//setMoveToX(-1);
						//setMoveToY(-1);	
					//}
					setTaskStatus(1); 
					//setMovesLeftToday( getMovesPerDay() );
					setDaysSinceLastClearedFogOfWar(0);
					//identifyNextMoveAI(iUnitListId_);	

				// ******************************************************
				// TODO: else, if island is being invaded...
				} else if ( false ) {

					// wake & attack & defend

				// ******************************************************
				// TODO: else, if island contains an identified unoccupied city or an enemy city...
				} else if ( false ) {

					// wake & capture city

				} else {
					setMovesLeftToday(0);		
				}

				break;				
		}
		
	}

	
	
	void identifyNextMoveTransportAI(int iUnitListId_) {

		//println("===================");
		//println("in unit.identifyNextMoveTransportAI("+iUnitListId_+"), getTaskStatus()="+getTaskStatus() );
		//println("===================");

		int x, y;
		int sx, sy;
		int ex, ey;
		ArrayList possibleMoves = new ArrayList();

		int iTargetCargoCount=2;
		if ( oGameEngine.getDayNumber() > 140 ) iTargetCargoCount=5;
		else if ( oGameEngine.getDayNumber() > 100 ) iTargetCargoCount=4;
		else if ( oGameEngine.getDayNumber() > 60 ) iTargetCargoCount=3;



		// ******************************************************
		// identify next move

		
		switch ( getTaskStatus() ) {
		
			//TODO: if transport is beside enemy unit, run away
			//...
			
			case 0:
				// 0=move to position beside player island (not under attack) where unit can accept cargo
				if ( oCityList.isCity(intCellX, intCellY) ) {
				
					// move one cell away (to a sea location beside player island)
					if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport status=0, move to a position next to island, where unit can accept cargo");
					// ******************************************************
					// define possible moves search area
					if( intCellX-1>=1) sx=intCellX-1;
					else sx=intCellX;

					if( intCellX+1< oGrid.getCellCountX() ) ex=intCellX+1;
					else ex=intCellX;


					if( intCellY-1>=1) sy=intCellY-1;
					else sy=intCellY;

					if( intCellY+1< oGrid.getCellCountY() ) ey=intCellY+1;
					else ey=intCellY;

					// identify unit move at random
					for (y=sy;y<=ey;y++) {
						for (x=sx;x<=ex;x++) {
							if ( oGrid.isSea(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intUnitPlayerId, x, y)==false )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				} else {
					transportCargoLoadLocationX=intCellX;
					transportCargoLoadLocationY=intCellY;
					setTaskStatus(1);
					//oUnitList.identifyPlayerLandUnitsToMoveTo(getUnitPlayerId(), getX(), getY() );
					oUnitList.identifyPlayerLandUnitsToLoadTransport(getUnitPlayerId(), getUnitIslandListId() );
				}
				
				break;

			case 1:
				// 1=accept cargo

				if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport status=1, accept cargo");

				oUnitList.identifyPlayerLandUnitsToLoadTransport(getUnitPlayerId(), getUnitIslandListId() );

				//println("is transport ready to move? getCargoCount()="+getCargoCount());
				//printCargo();
				if ( getCargoCount() >= iTargetCargoCount ) {
					//setStartXY(intCellX, intCellY);
					setTaskStatus(2);
					oUnitList.clearMoveToTransport( getUnitPlayerId(), getUnitIslandListId() );
				}
				break;

			case 2:
				// 2=cargo loaded, move to enemy island (or player island which is under attack)

				if ( transportCargoDestinationLocationX!=-1 && transportCargoDestinationLocationY!=-1 ) {
				
					setMoveToX(transportCargoDestinationLocationX);
					setMoveToY(transportCargoDestinationLocationY);
						
				} else {

					int x, y;
					int sx, sy;
					int ex, ey;
					ArrayList possibleMoves = new ArrayList();

					// ******************************************************
					// define possible moves search area

					int iMargin=4;

					if( intCellX <= iMargin ) sx=1;
					else sx=intCellX-iMargin;

					if( intCellX+iMargin > oGrid.getCellCountX() ) ex=oGrid.getCellCountX();
					else ex=intCellX+iMargin;


					if( intCellY <= iMargin ) sy=1;
					else sy=intCellY-iMargin;

					if( intCellY+iMargin > oGrid.getCellCountY() ) ey=oGrid.getCellCountY();
					else ey=intCellY+iMargin;


					// ******************************************************
					// identify next move

					
					// if an unoccupied or enemy island/city, which is not covered by fog of war, move towards it.
					for (y=1; y<= oGrid.getCellCountY() && possibleMoves.size()==0; y=y+1) {
						for (x=1; x<=oGrid.getCellCountY() && possibleMoves.size()==0; x=x+1) {
							if (intCellX!=x && intCellY!=y && oGrid.isLand(x,y) ) {

								if ( getUnitPlayerId()==1 &&  oGrid.isFogOfWar(x, y)==false && 
										( oCityList.isEnemyOrUnoccupiedCity(getUnitPlayerId(), x, y)==true
										||  oGrid.isEnemyOrUnoccupiedIsland(getUnitPlayerId(), x, y) ) 
										)
									possibleMoves.add( new cGridCell(x, y) );
								else if ( getUnitPlayerId()==2 && oGrid.isFogOfWarP2(x, y)==false && 
										( oCityList.isEnemyOrUnoccupiedCity(getUnitPlayerId(), x, y)==true 
										|| oGrid.isEnemyOrUnoccupiedIsland(getUnitPlayerId(), x, y) ) 
										)
									possibleMoves.add( new cGridCell(x, y) );
							}
						}
					}
					

					// can unit clear fog?
					if( possibleMoves.size()==0 ) {
						for (y=sy;y<=ey;y++) {
							for (x=sx;x<=ex;x++) {
								if (intCellX!=x && intCellY!=y) {
									if (getUnitPlayerId()==1) {
										if ( oGrid.isSea(x, y) && oGrid.isFogOfWar(x, y) )
											possibleMoves.add( new cGridCell(x, y) );
									} else {
										if ( oGrid.isSea(x, y) && oGrid.isFogOfWarP2(x, y) )
											possibleMoves.add( new cGridCell(x, y) );
									}
								}
							}
						}
					}

					// else can unit move at random?
					if( possibleMoves.size()==0 ) {
						for (y=sy;y<=ey;y++) {
							for (x=sx;x<=ex;x++) {
								if (intCellX!=x && intCellY!=y) {
									if ( oGrid.isSea(x, y) )
										possibleMoves.add( new cGridCell(x, y) );
								}
							}
						}
					}

					//println("possibleMoves.size()="+possibleMoves.size());
					//
					if( possibleMoves.size()>0 ) {
						//println("unit AI move #1");
						int possibleMoveIndex = int( random(possibleMoves.size()-1) );
						//println("unit AI move #2");
						cGridCell cell = (cGridCell) possibleMoves.get(possibleMoveIndex);
						//println("unit AI move #3");
						moveTo(iUnitListId_, cell.getX(), cell.getY() );
						//println("unit AI move #4");
					} else {
						//println("note: unit was not able to move at random.");
						setMovesLeftToday(0);
					}
					
				}

				// ******************************************************
				// if transport is away from start location and is next to land, then destination location is found
				//println("in Unit.identifyNextMoveTransportAI(), debug #1 line 1720");


				if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport debug 1 at ("+intCellX+","+intCellY+")... transportCargoLoadIslandId="+transportCargoLoadIslandId);
				if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport oGrid.getIslandIdIfIsNextToLand()="+oGrid.getIslandIdIfIsNextToLand() );
				if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport oIslandList.isEnemyOrUnoccupiedIsland()="+oIslandList.isEnemyOrUnoccupiedIsland(getUnitPlayerId(), oGrid.getIslandIdIfIsNextToLand() ) );

				if ( 
					/*
					(
					 ( 
					  intCellX < (transportCargoLoadLocationX -2) || 
					  intCellX > (transportCargoLoadLocationX +2) 
					 ) 
					  ||
					 ( 
					  intCellY < (transportCargoLoadLocationY -2) ||
					  intCellY > (transportCargoLoadLocationY +2) 
					 ) 
					)
					*/

					  oGrid.getIslandIdIfIsNextToLand()>=0 
					 && oGrid.getIslandIdIfIsNextToLand()!=transportCargoLoadIslandId 
					 && oIslandList.isEnemyOrUnoccupiedIsland(getUnitPlayerId(), oGrid.getIslandIdIfIsNextToLand() )
					) {
				
						if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport ready to unload cargo...");

						//transportCargoDestinationLocationX=intCellX;
						//transportCargoDestinationLocationY=intCellY;
				
						if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport is isNextToLand...");
						if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport is isNextToLand at ("+intCellX+","+intCellY+")");
						setMoveToX(-1);
						setMoveToY(-1);
						updateMovesLeftToday();
						if (getUnitPlayerId()==1 && debugTransport ) println("debug: getCargoCount()="+getCargoCount() );
						if ( getCargoCount()>0 ) wakeCargo();					
						setTaskStatus(3);				
				
				} else {
					if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport not ready to unload cargo yet...");
				}
				//println("transport debug 2 at ("+intCellX+","+intCellY+")");
				break;

			case 3:
				// 3=unload cargo

				if (getUnitPlayerId()==1 && debugTransport ) println("debug: unload transport cargo...");
				if (getUnitPlayerId()==1 && debugTransport ) println("debug: unload transport cargo at "+intCellX+","+intCellY+"");
				
				//printCargo();
				if ( getCargoCount()>0 ) wakeCargo();
				
				if ( getCargoCount() <=1 ) {

					if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport setMoveTo "+transportCargoLoadLocationX+","+transportCargoLoadLocationY+"");
					setMoveToX(transportCargoLoadLocationX);
					setMoveToY(transportCargoLoadLocationY);
					setTaskStatus(4);
					
					//setTaskStatus(99);

					//identifyNextMoveAI(iUnitListId_);
					
					
				}
				break;	
			case 4:
				// 4=move to back to cargo load location
				//moveToIfSpecified(iUnitListId_);
				//identifyNextMoveAI(iUnitListId_);
				
				if (getUnitPlayerId()==1 && debugTransport ) println("debug: transport - move to back to cargo load location "+intCellX+","+intCellY+"");
				//printCargo();
				
				if ( intCellX==transportCargoLoadLocationX && intCellY==transportCargoLoadLocationY ) {
					setTaskStatus(1);
				} else {
					////moveToIfSpecified(iUnitListId_);
					//moveTo(iUnitListId_, transportCargoLoadLocationX, transportCargoLoadLocationY);
					setTaskStatus(99);
				}
				
				break;					
			case 99:
				// 99=sleep
				setMovesLeftToday(0);			
				break;					
		}
		

		//println("...getTaskStatus()="+getTaskStatus() );
		
		if( possibleMoves.size()>0 ) {

			int possibleMoveIndex = int( random(possibleMoves.size()-1) );

			cGridCell cell = (cGridCell) possibleMoves.get(possibleMoveIndex);

			moveTo(iUnitListId_, cell.getX(), cell.getY() );

		} else {
			//println("note: transport does not need to move today.");
			setMovesLeftToday(0);
		}	
	
	}
	
	
	
	void identifyNextMoveFighterAI(int iUnitListId_) {

		// *****************************
		// if is Fighter, move so that unit does not run out of fuel!
		// *****************************
		if ( fuel<13 ) {
			//println("is fighter and fuel < 13");
			
			//TODO: if fighter is near a player carrier (which has space), move onto it
			// else if fighter is near a player city, move onto it
			//...
			
			oCityList.moveUnitToNearestCity(intUnitPlayerId, iUnitListId_, intCellX, intCellY, fuel);
			
		} else {

			int x, y;
			int sx, sy;
			int ex, ey;
			ArrayList possibleMoves = new ArrayList();

			// ******************************************************
			// define possible moves search area
			
			int iMargin=2;

			if( intCellX <= iMargin ) sx=1;
			else sx=intCellX-iMargin;

			if( intCellX+iMargin > oGrid.getCellCountX() ) ex=oGrid.getCellCountX();
			else ex=intCellX+iMargin;


			if( intCellY <= iMargin ) sy=1;
			else sy=intCellY-iMargin;

			if( intCellY+iMargin > oGrid.getCellCountY() ) ey=oGrid.getCellCountY();
			else ey=intCellY+iMargin;


			// ******************************************************
			// identify next move



			// can unit attack a enemy unit?
			for (y=sy;y<=ey;y++) {
				for (x=sx;x<=ex;x++) {
					if (intCellX!=x && intCellY!=y) {
						if ( oUnitList.isEnemyUnitAt(intUnitPlayerId, x, y) )
							possibleMoves.add( new cGridCell(x, y) );
					}
				}
			}


			// can unit clear fog?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if (getUnitPlayerId()==1) {
								if ( oGrid.isFogOfWar(x, y) )
									possibleMoves.add( new cGridCell(x, y) );
							} else {
								if ( oGrid.isFogOfWarP2(x, y) )
									possibleMoves.add( new cGridCell(x, y) );
							}
						}
					}
				}
			}

			// else can unit move at random?
			//if( possibleMoves.size()<5 ) {
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							//if ( oGrid.isLand(x, y) )
							possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}


			if( possibleMoves.size()>0 ) {
				//println("unit AI move #1");
				int possibleMoveIndex = int( random(possibleMoves.size()-1) );
				//println("unit AI move #2");
				cGridCell cell = (cGridCell) possibleMoves.get(possibleMoveIndex);
				//println("unit AI move #3");
				moveTo(iUnitListId_, cell.getX(), cell.getY() );
				//println("unit AI move #4");
			} else {
				//println("note: unit was not able to move at random.");
				setMovesLeftToday(0);
			}
		}
	
	}





	
	void identifyNextMoveBomberAI(int iUnitListId_) {

		if ( fuel<18 ) {
			//println("is bomber and fuel < 18");
			
			//TODO: if bomber is near a player carrier (which has space), move onto it
			// else if bomber is near a player city, move onto it
			//...
			
			oCityList.moveUnitToNearestCity(intUnitPlayerId, iUnitListId_, intCellX, intCellY, fuel);
			
		} else {

			int x, y;
			int sx, sy;
			int ex, ey;
			ArrayList possibleMoves = new ArrayList();

			// ******************************************************
			// define possible moves search area
			
			int iMargin=5;

			if( intCellX <= iMargin ) sx=1;
			else sx=intCellX-iMargin;

			if( intCellX+iMargin > oGrid.getCellCountX() ) ex=oGrid.getCellCountX();
			else ex=intCellX+iMargin;


			if( intCellY <= iMargin ) sy=1;
			else sy=intCellY-iMargin;

			if( intCellY+iMargin > oGrid.getCellCountY() ) ey=oGrid.getCellCountY();
			else ey=intCellY+iMargin;


			// ******************************************************
			// identify next move


			// can unit attack a city?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oGrid.isLand(x, y) && oCityList.isEnemyOrUnoccupiedCity(intUnitPlayerId, x, y) )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}

			// can unit attack a enemy unit?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oUnitList.isEnemyUnitAt(intUnitPlayerId, x, y) )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}

			
			// can unit clear fog?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if (intUnitPlayerId==1) {
								if ( oGrid.isFogOfWar(x, y) )
									possibleMoves.add( new cGridCell(x, y) );
							} else {
								if ( oGrid.isFogOfWarP2(x, y) )
									possibleMoves.add( new cGridCell(x, y) );
							}
						}
					}
				}
			}

			// else can unit move at random?
			//if( possibleMoves.size()<5 ) {
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							//if ( oGrid.isLand(x, y) )
							possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}
			

			if( possibleMoves.size()>0 ) {
				//println("unit AI move #1");
				int possibleMoveIndex = int( random(possibleMoves.size()-1) );
				//println("unit AI move #2");
				cGridCell cell = (cGridCell) possibleMoves.get(possibleMoveIndex);
				//println("unit AI move #3");
				moveTo(iUnitListId_, cell.getX(), cell.getY() );
				//println("unit AI move #4");
			} else {
				//println("note: unit was not able to move at random.");
				setMovesLeftToday(0);
			}
		}
	
	}




	void identifyNextMoveAI(int iUnitListId_) {

		//if (intUnitPlayerId==1 && isCargoOf() ) println(" begin unit.identifyNextMoveAI, strUnitName="+strUnitName+", movesLeftToday="+movesLeftToday);
		//if (intUnitPlayerId==1 && isCargoOf() ) println(" intCellX="+intCellX+", intCellY="+intCellY);

		int x, y;
		int sx, sy;
		int ex, ey;
		ArrayList possibleMoves = new ArrayList();

		// ******************************************************
		// define possible moves search area
		
		int iMargin=4;

		if ( isDestroyer() ) iMargin=30;
			
		if( intCellX <= iMargin ) sx=1;
		else sx=intCellX-iMargin;

		if( intCellX+iMargin > oGrid.getCellCountX() ) ex=oGrid.getCellCountX();
		else ex=intCellX+iMargin;


		if( intCellY <= iMargin ) sy=1;
		else sy=intCellY-iMargin;

		if( intCellY+iMargin > oGrid.getCellCountY() ) ey=oGrid.getCellCountY();
		else ey=intCellY+iMargin;

		int numTransport=0;
		if (intUnitPlayerId==1) numTransport = oPlayer1.getUnitTypeCount(6);
		else if (intUnitPlayerId==2) numTransport = oPlayer2.getUnitTypeCount(6);
		

		if( movesOnLand==true ) {

			// ******************************************************
			// identify next move
			

			if ( isTank() && numTransport>0 ) {
				if ( oUnitList.IsTransportNearbyWaitingForUnits(intUnitPlayerId, iUnitListId_, getUnitIslandListId() )  ) {

					//if ( intUnitPlayerId==1 ) println("unit has been instructed to move towards waiting transport");
				}
			}


			// can unit attack a enemy unit?			
			for (y=sy;y<=ey;y++) {
				for (x=sx;x<=ex;x++) {
					if (intCellX!=x && intCellY!=y) {
						if ( oGrid.isLand(x, y) && oUnitList.isEnemyUnitAt(intUnitPlayerId, x, y) )
							possibleMoves.add( new cGridCell(x, y) );
					}
				}
			}


			// can unit attack a city?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oGrid.isLand(x, y) && oCityList.isEnemyOrUnoccupiedCity(intUnitPlayerId, x, y) )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}
			
			// can unit clear fog?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if (intUnitPlayerId==1) {
								if ( oGrid.isLand(x, y) && oGrid.isFogOfWar(x, y) )
									possibleMoves.add( new cGridCell(x, y) );
							} else {
								if ( oGrid.isLand(x, y) && oGrid.isFogOfWarP2(x, y) )
									possibleMoves.add( new cGridCell(x, y) );
							}
						}
					}
				}
			}
			
			// else can unit move at random?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							//if ( oGrid.isLand(x, y) && isCargoOf()==false )
							if ( oGrid.isLand(x, y) )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}
			
			
			
		} 
		
		if ( movesOnWater==true ) {
			// moves on Water
			
			// ******************************************************
			// identify next move


			// can unit attack a enemy unit?
			for (y=sy;y<=ey;y++) {
				for (x=sx;x<=ex;x++) {
					if ( oGrid.isSea(x, y) && oUnitList.isEnemyUnitAt(intUnitPlayerId, x, y) )
						possibleMoves.add( new cGridCell(x, y) );
				}
			}


			// reset iMargin to 3
			iMargin=3;

			if( intCellX <= iMargin ) sx=1;
			else sx=intCellX-iMargin;

			if( intCellX+iMargin > oGrid.getCellCountX() ) ex=oGrid.getCellCountX();
			else ex=intCellX+iMargin;


			if( intCellY <= iMargin ) sy=1;
			else sy=intCellY-iMargin;

			if( intCellY+iMargin > oGrid.getCellCountY() ) ey=oGrid.getCellCountY();
			else ey=intCellY+iMargin;



			// if ship finds land, follow (explore) coast line & clear fog.
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if (intUnitPlayerId==1) {
								if ( oGrid.isSeaNextToIsland(x, y) && oGrid.isFogOfWar(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intUnitPlayerId, x, y)==false )
									possibleMoves.add( new cGridCell(x, y) );
							} else {
								if ( oGrid.isSeaNextToIsland(x, y) && oGrid.isFogOfWarP2(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intUnitPlayerId, x, y)==false )
									possibleMoves.add( new cGridCell(x, y) );
							}
						}
					}
				}
			}

			// can unit attack a city?
			// TODO: ship could attack city, only to try to kill any enemy units
			// ...
			/*
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oGrid.isLand(x, y) && oCityList.isEnemyOrUnoccupiedCity(intUnitPlayerId, x, y) )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}
			*/

			// can unit clear fog?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if (intUnitPlayerId==1) {
								if ( oGrid.isSea(x, y) && oGrid.isFogOfWar(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intUnitPlayerId, x, y)==false )
									possibleMoves.add( new cGridCell(x, y) );
							} else {
								if ( oGrid.isSea(x, y) && oGrid.isFogOfWarP2(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intUnitPlayerId, x, y)==false )
									possibleMoves.add( new cGridCell(x, y) );
							}
						}
					}
				}
			}
			
			// else can unit move at random?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oGrid.isSea(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intUnitPlayerId, x, y)==false )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}
			
			
		}	
		

		//if (intUnitPlayerId==1 && isCargoOf() ) println("possibleMoves.size()="+possibleMoves.size() );

		if( possibleMoves.size()>0 ) {

			int possibleMoveIndex = int( random(possibleMoves.size() ) );
			cGridCell cell = (cGridCell) possibleMoves.get(possibleMoveIndex);
			moveTo(iUnitListId_, cell.getX(), cell.getY() );

		} else {
			println("note: move AI has not identified a move for unit at "+x+","+y+".");
			setMovesLeftToday(0);
		}		

	}


	
	
	// ***********************************************************
	// DRAW
	// ***********************************************************


	void Draw() {

		//println("debug: in unit.Draw()");

		int countOfPlayerUnits;

		int PlayerDrawOffSetX=220;
		int PlayerDrawOffSetY=0;
		bool PlayerCellIsFogOfWar = false;
		bool DrawUnit = false;
		bool CellWithinPlayerViewport = false;
		int ShowFromCellX, ShowFromCellY;

		if ( oGameEngine.getCurrentPlayerId()==1 ) {
			PlayerCellIsFogOfWar = oGrid.isFogOfWar(intCellX, intCellY);

			CellWithinPlayerViewport = oViewport.isCellWithinViewport(intCellX, intCellY);

			if ( intUnitPlayerId==1 || ( intUnitPlayerId==2 && oUnitList.getCountEnemyUnitNearby(intUnitPlayerId, intCellX, intCellY)>=1 ) ) 
				DrawUnit = true;

			ShowFromCellX = oPlayer1.getShowFromCellX();
			ShowFromCellY = oPlayer1.getShowFromCellY();

		} else if (debugShowPlayer2Viewport) {
			PlayerCellIsFogOfWar = oGrid.isFogOfWarP2(intCellX, intCellY);
			PlayerDrawOffSetY=350;

			CellWithinPlayerViewport = oViewportPlayer2.isCellWithinViewport(intCellX, intCellY);

			if ( intUnitPlayerId==2 || ( intUnitPlayerId==1 && oUnitList.getCountEnemyUnitNearby(intUnitPlayerId, intCellX, intCellY)>=1 ) ) 
				DrawUnit = true;

			ShowFromCellX = oPlayer2.getShowFromCellX();
			ShowFromCellY = oPlayer2.getShowFromCellY();
		}

		//println("debug: in unit.Draw(), oGameEngine.getCurrentPlayerId()="+oGameEngine.getCurrentPlayerId()+", CellWithinPlayerViewport="+CellWithinPlayerViewport+", PlayerCellIsFogOfWar="+PlayerCellIsFogOfWar+", DrawUnit="+DrawUnit);

		//if ( oViewport.isCellWithinViewport(intCellX, intCellY) ) { 
		if ( CellWithinPlayerViewport ) { 

			int DisplayX=((intCellX-ShowFromCellX+1)*cellWidth)-(cellWidth-1) + PlayerDrawOffSetX;
			int DisplayY=((intCellY-ShowFromCellY+1)*cellHeight)-(cellHeight-1) + PlayerDrawOffSetY;
			
			
			if ( PlayerCellIsFogOfWar==false ) { 
			
				//if ( intUnitPlayerId==1 || ( intUnitPlayerId==2 && oUnitList.getCountEnemyUnitNearby(intUnitPlayerId, intCellX, intCellY)>=1 ) )  {
				if (DrawUnit)  {
			
					switch(intUnitTypeId) {
						case 0:
							if (intUnitPlayerId==1) {
								//println("player 1");
								//if ( !isCargoOf() && oGameGrid.XXX() ) {

									//println("debug: in unit.draw() drawing tank at "+DisplayX+", "+DisplayY);
									image( imgTank1, DisplayX, DisplayY );

									// show player Tank count at X,Y on unit image, if more than 1
									countOfPlayerUnits = oUnitList.getCountOfPlayerTankUnitsAt(intUnitPlayerId, intCellX, intCellY);
									if ( countOfPlayerUnits > 1 && oGrid.isLand(intCellX, intCellY) ) {
										fill(200);
										if ( countOfPlayerUnits > 9 ) 
											rect(DisplayX+iNumberIndent, DisplayY+iNumberIndent, iNumberTextSize+iNumberTextSize, iNumberTextSize);
										else
											rect(DisplayX+iNumberIndent, DisplayY+iNumberIndent, iNumberTextSize, iNumberTextSize);
										fill(0);
										setTextSizeNumber();
										text(countOfPlayerUnits, DisplayX+iNumberIndent+1, DisplayY+iNumberTextSize );
										setTextSizeString();
									}

									if ( intUnitPlayerId==1 && oPlayer1.getIsAI() && debugShowUnitMoveTo && getTaskStatus()==1 ) {
										fill(200);
										rect(DisplayX+iNumberIndent, DisplayY+iNumberTextSize+iNumberIndent-1, cellWidth-iNumberIndent, iNumberTextSize);
										//fill(0);
										//setTextSizeNumber();
										//text( getMoveToX() +","+getMoveToY() , DisplayX+iNumberIndent+1, DisplayY+iNumberTextSize+iNumberTextSize+2 );
										//setTextSizeString();

									}


									if ( intUnitPlayerId==1 && oPlayer1.getIsAI() && debugShowUnitTaskStatus ) {

										// show task status
										fill(255);
										rect(DisplayX+iNumberIndent, DisplayY+cellHeight-iNumberTextSize, iNumberTextSize+iNumberTextSize, iNumberTextSize);
										fill(0);
										setTextSizeNumber();
										text(getTaskStatus(), DisplayX+iNumberIndent+1, DisplayY+cellHeight-iNumberTextSize+6 );
										setTextSizeString();
									}

								//}

							} else {
								//println("player 2");
								if (!isCargoOf()) image( imgTank2,DisplayX, DisplayY );
							}
							break;
						case 1:
							if (intUnitPlayerId==1) image( imgFighter1, DisplayX, DisplayY );
							else image( imgFighter2, DisplayX, DisplayY );
							break;
						case 2:
							if (intUnitPlayerId==1) image( imgBattleship1, DisplayX, DisplayY );
							else image( imgBattleship2, DisplayX, DisplayY );
							break;	
						case 3:
							if (intUnitPlayerId==1) image( imgBomber1, DisplayX, DisplayY );
							else image( imgBomber2, DisplayX, DisplayY );
							break;	
						case 4:
							if (intUnitPlayerId==1) image( imgCarrier1, DisplayX, DisplayY );
							else image( imgCarrier2, DisplayX, DisplayY );

							if( intUnitPlayerId==1 && getCargoCount() > 0 ) {
								// show cargo count on unit image
								fill(255);
								rect(DisplayX+iNumberIndent,DisplayY+iNumberIndent,iNumberTextSize,iNumberTextSize+1);
								fill(0);
								setTextSizeNumber();
								text(getCargoCount(), DisplayX+iNumberIndent+1, DisplayY+iNumberTextSize );
								setTextSizeString();
							}

							break;	
						case 5:
							if (intUnitPlayerId==1) image( imgDestroyer1, DisplayX, DisplayY );
							else image( imgDestroyer2, DisplayX, DisplayY );
							break;
						case 6:
							if (intUnitPlayerId==1) image( imgTransport1, DisplayX, DisplayY );
							else image( imgTransport2, DisplayX, DisplayY );

							if( intUnitPlayerId==1 && getCargoCount() > 0 ) {

								// show cargo count on unit image
								fill(255);
								rect(DisplayX+iNumberIndent,DisplayY+iNumberIndent,iNumberTextSize,iNumberTextSize+1);
								fill(0);
								setTextSizeNumber();
								text(getCargoCount(), DisplayX+iNumberIndent+1, DisplayY+iNumberTextSize );
								setTextSizeString();
							}

							if ( intUnitPlayerId==1 && debugShowUnitMoveTo && getTaskStatus()==1 ) {
								fill(200);
								rect(DisplayX+iNumberIndent, DisplayY+iNumberTextSize+iNumberIndent-1, cellWidth-iNumberIndent, iNumberTextSize);
								fill(0);
								setTextSizeNumber();
								text( getMoveToX() +","+getMoveToY() , DisplayX+iNumberIndent+1, DisplayY+iNumberTextSize+iNumberTextSize+2 );
								setTextSizeString();

							}

							if ( intUnitPlayerId==1 && debugShowUnitTaskStatus ) {

								// show task status
								fill(255);
								rect(DisplayX+iNumberIndent, DisplayY+cellHeight-iNumberTextSize, iNumberTextSize+iNumberTextSize, iNumberTextSize);
								fill(0);
								setTextSizeNumber();
								text(getTaskStatus(), DisplayX+iNumberIndent+1, DisplayY+cellHeight-iNumberTextSize+6 );
								setTextSizeString();
							}

							break;

						case 7:
							if (intUnitPlayerId==1) image( imgSubmarine1, DisplayX, DisplayY );
							else image( imgSubmarine2, DisplayX, DisplayY );						
							break;						
					}



					// indicate if unit is asleep
					if ( isAsleep() ) {

						// clear where we will draw unit asleep indicator
						fill(255);
						rect(DisplayX+cellWidth-iNumberTextSize, DisplayY+iNumberIndent, iNumberTextSize, iNumberTextSize );

						// draw unit asleep indicator
						fill(0);
						setTextSizeNumber();
						text("z", DisplayX+cellWidth-iNumberTextSize, DisplayY+iNumberTextSize );
						setTextSizeString();
					}


					if ( debugShowUnitIslandListId ) {

						// clear where we will draw unit islandListId
						fill(255);
						rect(DisplayX+cellWidth-iNumberTextSize-iNumberTextSize, DisplayY+cellHeight-iNumberTextSize, iNumberTextSize, iNumberTextSize );

						// draw unit islandListId
						fill(0);
						setTextSizeNumber();
						text(getUnitIslandListId(), DisplayX+cellWidth-iNumberTextSize-iNumberTextSize, DisplayY+cellHeight-1 );
						setTextSizeString();
					}


				}
			}	
			
		}
	}
	

	void clearFogOfWarAt(int x_, y_) {

		//println("in unit.clearFogOfWarAt()");

		int x, y;
		int sx, sy;
		int ex, ey;


		int ShowFromCellX, ShowFromCellY;

		if ( oGameEngine.getCurrentPlayerId()==1 ) { 
			ShowFromCellX = oPlayer1.getShowFromCellX();
			ShowFromCellY = oPlayer1.getShowFromCellY();
		} else {
			ShowFromCellX = oPlayer2.getShowFromCellX();
			ShowFromCellY = oPlayer2.getShowFromCellY();
		}

		
		if( x_-1>=ShowFromCellX ) sx=x_-1;
		else sx=x_;

		if( x_+1<= (ShowFromCellX + oViewport.getWidth() ) ) ex=x_+1;
		else ex=x_;


		if( y_-1>=ShowFromCellY ) sy=y_-1;
		else sy=y_;

		if( y_+1<= ( ShowFromCellY + oViewport.getHeight() ) ) ey=y_+1;
		else ey=y_;
		
		for (y=sy;y<=ey;y++) {
			for (x=sx;x<=ex;x++) {
			
				if ( getUnitPlayerId()==1 ) {
					oGrid.clearFogOfWar(x,y);
					//oGrid.DrawCell(x,y,true);
					//reDrawNearBy();
					//if (oGrid.isFogOfWar(x,y)==false) oGrid.DrawCell(x,y,true);

					//if( intUnitPlayerId==1) reDrawNearBy();

				} else if ( getUnitPlayerId()==2 ) {
					oGrid.clearFogOfWarP2(x,y);
					//oGrid.DrawCell(x,y,true);
					//if (oGrid.isFogOfWarP2(x,y)==false) oGrid.DrawCell(x,y,true);
				}
				
				//if ( oViewport.isCellWithinViewport(x,y) ) { 
					//if (oGrid.isFogOfWar(x,y)==false) oGrid.DrawCell(x,y,true);
				//}
			}
		}
	}



	void reDrawNearBy() {

		//println("in unit.reDrawNearBy()");

		int x, y;
		int sx, sy;
		int ex, ey;


		int ShowFromCellX, ShowFromCellY;

		if ( oGameEngine.getCurrentPlayerId()==1 ) { 
			ShowFromCellX = oPlayer1.getShowFromCellX();
			ShowFromCellY = oPlayer1.getShowFromCellY();
		} else {
			ShowFromCellX = oPlayer2.getShowFromCellX();
			ShowFromCellY = oPlayer2.getShowFromCellY();
		}

		
		if( intCellX-1>=ShowFromCellX ) sx=intCellX-1;
		else sx=intCellX;
		
		if( intCellX+1<= (ShowFromCellX+oGrid.getCellCountX()) ) ex=intCellX+1;
		else ex=intCellX;
		
		
		if( intCellY-1>=ShowFromCellY ) sy=intCellY-1;
		else sy=intCellY;
				
		if( intCellY+1<= (ShowFromCellY+oGrid.getCellCountY()) ) ey=intCellY+1;
		else ey=intCellY;
		
		
		for (y=sy;y<=ey;y++) {
			for (x=sx;x<=ex;x++) {
			
				

				if ( getUnitPlayerId()==1 ) {
					if (oGrid.isFogOfWar(x,y)==true) setDaysSinceLastClearedFogOfWar(0);
					oGrid.clearFogOfWar(x,y);
					if ( oViewport.isCellWithinViewport(x,y) ) { 	
						if (oGrid.isFogOfWar(x,y)==false) oGrid.DrawCell(x,y,true);
					}
				} else if ( getUnitPlayerId()==2 ) {
					if (oGrid.isFogOfWarP2(x,y)==true) setDaysSinceLastClearedFogOfWar(0);
					oGrid.clearFogOfWarP2(x,y);
					if (debugShowPlayer2Viewport) { 
						if ( oViewportPlayer2.isCellWithinViewport(x,y) ) { 	
							if (oGrid.isFogOfWarP2(x,y)==false) oGrid.DrawCell(x,y,true);
						}
					}
				}
				

			}
		}
	}
	

	
	
}


