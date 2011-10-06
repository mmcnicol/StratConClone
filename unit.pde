
class cUnit {

	int intUnitTypeId;
	int intPlayerId;
	int intCellX, intCellY;
	int iMoveToCellX, iMoveToCellY;
	int iDayBuilt;

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
	int iBombBlastRadius; // -1 = N/A

	//ArrayList listCargo;
	//int thisUnitIsCargoOfUnitId; // -1 = N/A
	int[] cargoUnitListId = new int[6];
	//float[] coswave = new float[width];
	int iIsCargoOfUnitListId;

	bool bAnimate; // whether to highlight/flash so user knows which unit to move next
	int iAnimateSwitch; // 0=draw, 1=hide

	int iTaskStatus; // -1=N/A
	/*
	999=Dead.
	
	if isTransport()
	0=move to position beside player island (not under attack) where unit can accept cargo
	1=issue instruction to accept cargo
	2=cargo loaded, move to enemy island (or player island which is under attack)
	3=unload cargo
	
	if isTank()
	0=move to using basic algorithm
	1=move to waiting transport
	99=sleep
	*/

	int transportCargoLoadLocationX;
	int transportCargoLoadLocationY;
	
	int transportCargoDestinationLocationX;
	int transportCargoDestinationLocationY;

	cUnit(int intUnitTypeId_, int intPlayerId_, int intCellX_, int intCellY_) {

		if( intUnitTypeId_!=-1 ) {
			
			intUnitTypeId=intUnitTypeId_;
			intPlayerId=intPlayerId_;
			//if (intPlayerId==1) println( "in cUnit constructor begin for player " + intPlayerId_ ", intUnitTypeId_"+intUnitTypeId_);
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
			
			
			
			if (intUnitTypeId==3) {
				//println(" calling calculateBombBlastRadius() ");
				iBombBlastRadius=oUnitRef[3].calculateBombBlastRadius();
			} else iBombBlastRadius=-1;
			//println(" iBombBlastRadius="+iBombBlastRadius);
			
			//iBombBlastRadius=-1;
			
			//listCargo = new ArrayList();  // Create an empty ArrayList
			//thisUnitIsCargoOfUnitId=-1;
			cargoUnitListId[0]=-1;
			cargoUnitListId[1]=-1;
			cargoUnitListId[2]=-1;
			cargoUnitListId[3]=-1;
			cargoUnitListId[4]=-1;
			cargoUnitListId[5]=-1;
			
			iIsCargoOfUnitListId=-1;
			
			//if (intPlayerId==1) printCargo();
			
			bAnimate=false;
			iAnimateSwitch=0;
			

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
	
			//println( "in cUnit constructor ");
			//exit();
		} else {
			println( "error: cannot add unit for unit type " + intUnitTypeId_ );
			//exit();
		}
	}

	
	void setXY(int intCellX_, int intCellY_) {
	
		//if (intPlayerId==1) println("in unit.setXY("+intCellX_+","+intCellY_+") ");
		
		intCellX=intCellX_;
		intCellY=intCellY_;
		
		//if (intPlayerId==1) println("in unit.setXY() updating any associated cargo");
		// if this unit has cargo, update their XY values also
		if( isTransport() || isCarrier() ) {
		
			moveCargo(intCellX_, intCellY_);

			/*
			for (int i=0; i<6; i++)
				if ( cargoUnitListId[i] != -1 ) {
					//if (intPlayerId==1) println("in unit.setXY() updating any associated cargo for cargoUnitListId[i]="+cargoUnitListId[i]);
					oUnitList.moveCargo(cargoUnitListId[i], intCellX_, intCellY_);
				}
			*/
		}			
		/*
		for (int i = 0; i < listCargo.size(); i++) { 
			cUnit unit = (cUnit) listCargo.get(i);
			unit.setXY(intCellX_, intCellY_);
		}  
		*/
	
	};

	int getCellRow() { return intCellX; }
	int getCellCol() { return intCellY; }
	
	int getX() { return intCellX; }
	int getY() { return intCellY; }
	
	int setX(int value_) { intCellX=value_; }
	int setY(int value_) { intCellY=value_; }
	
	void setMoveToX(int value_) { iMoveToCellX=value_; }
	void setMoveToY(int value_) { iMoveToCellY=value_; }
	
	int getMoveToX() { return iMoveToCellX; }
	int getMoveToY() { return iMoveToCellY; }
	

	void setAttacksLeftToday(int value_) { attacksLeftToday=value_; }
	int getAttacksLeftToday() { return attacksLeftToday; }

	void reduceAttacksLeftToday() {
		if (attacksLeftToday>0) {
			attacksLeftToday=attacksLeftToday-1; 
			//println("intPlayerId#"+intPlayerId+" attacksLeftToday="+attacksLeftToday);
			
		} 				
	}
	
	int getPlayerId() { return intPlayerId; }
	
	int getUnitTypeId() { return intUnitTypeId; }
	
	
	int getAge() { return oGameEngine.getDayNumber()-iDayBuilt; }
	
	
	
	int getTaskStatus() { return iTaskStatus; }
	void setTaskStatus(int _value) { iTaskStatus=_value; }
	
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
		
		
		if (movesLeftToday>0) {
			movesLeftToday=movesLeftToday-1; 
			//println("intPlayerId#"+intPlayerId+" movesLeftToday="+movesLeftToday);
			
		} else {
		
			//setAnimation(false);
			
			if ( intPlayerId == 1 ) {
				oAnimate.clear();
			} 
			
		}		
				
	}
	


	
	bool isAnimated() { return bAnimate; }
	
	
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
	
	bool isTransport() {
		if (intUnitTypeId==6) return true;
		else return false;
	}

	bool isCarrier() {
		if (intUnitTypeId==4) return true;
		else return false;
	}

	bool isBomber() {
		if (intUnitTypeId==3) return true;
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
	


	
	void updateFuelLeft(int iUnitListId_) {
	
		if (fuel>0) {
			fuel=fuel-1; 
			//println("intPlayerId#"+intPlayerId+" fuel="+fuel);
			
		} else {
		
			//setAnimation(false);
			
			if ( intPlayerId == 1 ) {
				oAnimate.clear();
			} 
			
		}	
		
		
			
		// unit is a fighter or a bomber so can refuel in its own city city
		if ( oCityList.isCity(intCellX, intCellY)==true ) {
			int tempCityId = oCityList.getCityId(intCellX, intCellY);
			if ( oCityList.getCityPlayerId(tempCityId)==intPlayerId ) {
				fuel = oUnitRef[intUnitTypeId].getMaxFuel();
			}
		}

		// TODO unit is a fighter or a bomber so can refuel on its carrier ship
		// ...
		
		
		
		if (fuel==0) {
		
			if(intPlayerId==1) println(strUnitName+" ran out of fuel and crashed!");
			
			oUnitList.deleteUnit(iUnitListId_);
			oGrid.DrawCell(getX(), getY(), false);
			
		}
				
	}
	


	
		
	void updateSelectedUnitPanelInformation() {
		
		if (intPlayerId==1) {
			//if( intCellX==intCellX_ && intCellY==intCellY_ ) {
			oPanelSelectedUnit.show(strUnitName, nf(intCellX,3)+","+nf(intCellY,3), strength, fuel, movesLeftToday);
			//}
		}
	}
		
		
	

	
	
	void printRowCol() {
		println(strUnitName+" at row="+intCellX+", col="+intCellY);
	}

	bool isAt(int cellX_, int cellY_) {
		if( intCellX==cellX_ && intCellY==cellY_ ) return true
		else return false;
	}

	bool isAtXY(int x_, int y_) {
		int tempX=int(floor((x_+15)/16));
		int tempY=int(floor((y_+15)/16));

		if( intCellX==tempX && intCellY==tempY ) {
			//println("unit.isAtXY("+x_+", "+y_+"), tempX=" + tempX + ", tempY=" + tempY + ", intPlayerId="+intPlayerId+" match!");
			return true
		} else {
			//println("unit.isAtXY("+x_+", "+y_+"), tempX=" + tempX + ", tempY=" + tempY + ", intPlayerId="+intPlayerId+" no match");
			return false;
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

			if (intPlayerId==1) {
				println("attack was successful");
				println("");
			}

			oUnitList.deleteUnit(iUnitListId_);
			//oGrid.DrawCell(intCellX, intCellY, false);

			//reDrawNearBy();
			clearFogOfWarAt(intCellX_, intCellY_);
			
			oCityList.CityConquered(tempCityId, intPlayerId);
		
			
			
			//oViewport.draw();

		} else {


			updateMovesLeftToday();
			if ( oUnitRef[intUnitTypeId].canFly() ) updateFuelLeft(iUnitListId_);
			//if( intPlayerId==1) reDrawNearBy();
			updateSelectedUnitPanelInformation();				


			// if attack was not successful, 
			if (intPlayerId==1) {
				println("attack was not successful");
				println("");
			}
				
			// 50% probability unit strength is to be reduced
			if ( (int)random(1,1000)%2==0 ) {
			
				//if (intPlayerId==1) println("reducing unit strength following unsuccessful attack");
					
				oUnitList.manageUnitStrengthReduction(iUnitListId_);
			}
			//reDrawNearBy();
			clearFogOfWarAt(intCellX_, intCellY_);
		}
		
	
	}
	
	


	void doAttackEnemyUnit(int iUnitListId_, int intCellX_, int intCellY_) {

		//println("in unit.doAttackEnemyUnit() ");

		bool unitAttackSuccessful=false;
		int factor;
		int iDefendingUnitListId;

		reduceAttacksLeftToday();

		// if enemy transport exists at attack location, attack that instead of any other units at that location
		iDefendingUnitListId = oUnitList.getFirstEnemyTransportUnitIdAt(intPlayerId, intCellX, intCellY);
		if (iDefendingUnitListId==-1)
			iDefendingUnitListId = oUnitList.getFirstEnemyUnitIdAt(intPlayerId, intCellX_, intCellY_);
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
		//if( intPlayerId==1) reDrawNearBy();
		updateSelectedUnitPanelInformation();				


		if ( unitAttackSuccessful ) {

			if (intPlayerId==1) {
				println("attack was successful");
				println("");
			}
			
			//if (intPlayerId==1) println("reducing defending unit strength following successful attack");

			oUnitList.manageUnitStrengthReduction(iDefendingUnitListId);			

			// only move attacking unit to destination location if destination location contains no further enemy units
			if ( oUnitList.isEnemyUnitAt(intPlayerId, intCellX_, intCellY_)==false 
					&& oCityList.isEnemyCity(intPlayerId, intCellX_, intCellY_)==false 
					&& oUnitList.isEnemyTransportAtRowCol(intPlayerId, intCellX_, intCellY_)==false ) {
					
				//intCellX = intCellX_;
				//intCellY = intCellY_;
				//setXY(intCellX_, intCellY_);
				//Draw();
			}
			
		} else {

			// if attack was not successful, 
			if (intPlayerId==1) {
				println("attack was not successful");
				println("");
			}


			// 50% probability unit strength is to be reduced
			if ( (int)random(1,1000)%2==0 ) {

				//if (intPlayerId==1) println("reducing attacking unit strength following unsuccessful attack");

				oUnitList.manageUnitStrengthReduction(iUnitListId_);
			}
		}
		//reDrawNearBy();
		clearFogOfWarAt(intCellX_, intCellY_);

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


		// draw bomb explosion
		int DisplayX=((intCellX_-oGrid.getShowFromCellX()+1)*16)-15;
		int DisplayY=((intCellY_-oGrid.getShowFromCellY()+1)*16)-15;
		fill(126);
		
		//println("drawing bomb blast radius "+iBombBlastRadius);
		//println("drawing bomb blast radius "+(iBombBlastRadius+1));
		//println("drawing bomb blast radius "+( (iBombBlastRadius+1) * 16 ));
		//println("drawing bomb blast radius "+round( ( (iBombBlastRadius+1) * 16 ) / 2 ) );
		
		int iDisplayRadius = round( ( (iBombBlastRadius+1) * 16 )  );
		iDisplayRadius=iDisplayRadius+8;
		ellipse(DisplayX+8, DisplayY+8, iDisplayRadius, iDisplayRadius);
		
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
		

		//if (getPlayerId()==1) clearFogOfWar();
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
		
		

	}
	
	void doBombLocation(int x_, int y_) {
	
		//println("debug#1.1");
		oUnitList.killUnitsAt(x_, y_);
		//println("debug#1.2");

		// if City, change to unoccupied
		if ( oCityList.isEnemyCity(intPlayerId, x_, y_) ) {
			//println("debug#1.3");
			oCityList.CityBombed( oCityList.getCityId(x_, y_) );
		}
		//println("debug#1.4");
	}
	
	
	
	
		
	void kill() { 
	
		//println("in unit.kill()");
		setTaskStatus(999);
		movesLeftToday=0; 
		thisUnitIsCargoOfUnitId=-1;
		// hide unit
		////////oGrid.DrawCell(intCellX, intCellY, false);
		//println("leaving unit.kill()");
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
		println("in wakeCargo()");
		
		//oUnitList.commandWakePlayerUnitsAt(intPlayerId, getX(), getY() );
		
		
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
				println("in unit.deleteCargo("+iUnitListId_+") successful");
			}
			
		//println("in unit.clearCargoUnit("+iUnitListId_+") leaving function");
		//printCargo();
		
	}
	
	
	
	void deleteAllCargo() {
		
		for (int i=0; i<6; i++)
			cargoUnitListId[i]=-1;			
	}
	
	
	void doAddCargo(int iUnitListId_, int intCellX_, int intCellY_) {

		if (intPlayerId==1) println("in unit.doAddCargo(iUnitListId_="+iUnitListId_+","+intCellX_+","+intCellY_+") ");
		
		int destinationUnitId;
		
		// if unit is tank, get unit list id of destination transport
		if ( isTank() ) destinationUnitId = oUnitList.getFirstPlayerTransportUnitIdAt(intPlayerId, intCellX_, intCellY_);
		
		// if unit is fighter, get unit list id of destination carrier
		if ( isFighter() ) destinationUnitId = oUnitList.getFirstPlayerCarrierUnitIdAt(intPlayerId, intCellX_, intCellY_);
		
		if ( destinationUnitId != -1 ) {
			// add current unit to destination transport or carrier cargo
			println("adding current unit to destination transport or carrier cargo (unitListId="+destinationUnitId+")");
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
			}
			reDrawNearBy();

			
			if ( oUnitRef[intUnitTypeId].canFly() ) updateFuelLeft(iUnitListId_);
			//if( intPlayerId==1) reDrawNearBy();
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

		if ( getAge() == 25 && isAsleep()==false && isSeaVessel()==false ) {

			setMoveToX(-1);
			setMoveToY(-1);
			setMovesLeftToday(0);
			setTaskStatus(99);

		} else if ( isTransport() && getTaskStatus()==2 &&
			(( intCellX < (transportCargoLoadLocationX -5)
			|| intCellX > (transportCargoLoadLocationX +5) )
			||
			( intCellY < (transportCargoLoadLocationY -5)
			|| intCellY > (transportCargoLoadLocationY +5) )) 
			&& 
			oGrid.isNextToLand(intCellX, intCellY) 
			) {

				transportCargoDestinationLocationX=intCellX;
				transportCargoDestinationLocationY=intCellY;
				//println("************************************************");
				println("transport... is isNextToLand at ("+intCellX+","+intCellY+")");
				//println("************************************************");
				setMoveToX(-1);
				setMoveToY(-1);
				updateMovesLeftToday()
				println("getCargoCount()="+getCargoCount() );
				if ( getCargoCount()>0 ) wakeCargo();
				setTaskStatus(3);				
				
		} else if ( iMoveToCellX!=-1 && iMoveToCellY!=-1 && getMovesLeftToday()>=1 ) 
			moveTo(iUnitListId_, iMoveToCellX, iMoveToCellY);
		else {
			if (intPlayerId==2) {
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
		
		if ( intPlayerId == 1 ) {
			oAnimate.clear();
		} 		

		// store destination
		//if (iMoveToCellX==-1 && iMoveToCellY==-1) {
			iMoveToCellX=intCellX_;
			iMoveToCellY=intCellY_;
		//}


		if ( getMovesLeftToday()>=1 && ( isFighter() || isBomber() ) ) {

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

			//if (intPlayerId==1) println("calling pathfinding using "+intCellX+","+intCellY+" "+intCellX_+","+intCellY_ );

			oPathfinding = new cPathfinding();
			next_step = oPathfinding.getNextMove(intPlayerId, intCellX, intCellY, intCellX_, intCellY_, moves_on);

			//if ( isTransport() && intPlayerId==1) println("pathfinding result="+next_step.x+","+next_step.y);

			//pathfinding found next step	
			if (next_step.x!=-3 && next_step.y!=-3) {

				iNextCellX=next_step.x;
				iNextCellY=next_step.y;

			//pathfinding unable to find next step							
			} else {

				// TODO: problem, fix later
				
				//if ( !isFighter() || !isBomber() ) {
					setMoveToX(-1);
					setMoveToY(-1);
				//}
				
				////////////////////updateMovesLeftToday();
				if ( isTank() ) setTaskStatus(0);

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

			//if (intPlayerId==1) println(" in unit.moveTO(), calling unit.move("+iNextCellX+","+iNextCellY+")");
			move(iUnitListId_, iNextCellX, iNextCellY);
		}

	}


	void move(int iUnitListId_, int intCellX_, int intCellY_) {

		//println("in unit.move() ");
		//println("in unit.move() getUnitTypeId()="+getUnitTypeId() +" MoveTo="+getMoveToX()+","+getMoveToY()+" step="+intCellX_+","+intCellY_);
		
		updateSelectedUnitPanelInformation();

		if( checkPreMoveValidationRules(iUnitListId_, intCellX_, intCellY_)==false) {
		
			println("in unit.move() pre move validation failed. getUnitTypeId()="+getUnitTypeId() +" getMoveToX()="+getMoveToX()+", getMoveToY()="+getMoveToY());
			//println("intCellX_="+intCellX_+", intCellY_="+intCellY_);
			setMoveToX(-1);
			setMoveToY(-1);
			updateMovesLeftToday();
			
		} else {
		
		
			//setAnimation(false);

			if ( intPlayerId == 1 ) {
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

			

			
			
			//if( intPlayerId==1) println(" in unit.move() debug#1");

			// *********************************************
			// if unit is bomber and destination contains enemy city or enemy unit (not a fighter or bomber), bomb it
			// *********************************************
			
			
			/*
			if( intPlayerId==1) println(" isBomber()="+isBomber() );
			
			if ( isBomber() ) {
				println("oCityList.isEnemyCity()="+ oCityList.isEnemyCity(intPlayerId, intCellX_, intCellY_) );
				println("oUnitList.isBombableEnemy()="+ oUnitList.isBombableEnemy(intPlayerId, intCellX_, intCellY_) );
			}
			*/
			
			if ( isBomber() && ( ( oCityList.isEnemyCity(intPlayerId, intCellX_, intCellY_) 
						&& !oCityList.isUnoccupiedCity(intCellX_, intCellY_) ) 
						|| oUnitList.isBombableEnemy(intPlayerId, intCellX_, intCellY_) ) ) {
			
				//println("isBomber()="+isBomber());
				//println("oCityList.isEnemyCity()="+oCityList.isEnemyCity(intPlayerId, intCellX_, intCellY_));
				//println("oCityList.isUnoccupiedCity()="+oCityList.isUnoccupiedCity(intCellX_, intCellY_));
				//println("oUnitList.isBombableEnemy()="+oUnitList.isBombableEnemy(intPlayerId, intCellX_, intCellY_));
				
				//if (intPlayerId==1) println(" in unit.move() debug#2");
				doDropBomb(iUnitListId_, intCellX_, intCellY_);
				
			// *********************************************
			// if destination contains enemy unit, attack it
			// *********************************************
			} else if ( oUnitList.isEnemyUnitAt(intPlayerId, intCellX_, intCellY_) ) {
			
				//if (intPlayerId==1) println(" in unit.move() debug#3");
				doAttackEnemyUnit(iUnitListId_, intCellX_, intCellY_);
				
			// *********************************************
			// if unit is tank and destination location is enemy/unoccupied city, attack it
			// *********************************************
			} else if ( isTank() && oCityList.isEnemyOrUnoccupiedCity(intPlayerId, intCellX_, intCellY_) ) {
			
				//if (intPlayerId==1) println(" in unit.move() debug#4 attacking enemy/unoccupied city");
				doAttackEnemyCity(iUnitListId_, intCellX_, intCellY_);
			
			// *********************************************
			// if unit is tank and destination contains player transport, move into it
			// *********************************************
			} else if ( isTank() && oUnitList.isPlayerTransportAtRowCol(intPlayerId, intCellX_, intCellY_) ) {
			
				//if (intPlayerId==1) println(" in unit.move() debug#5");
				doAddCargo(iUnitListId_, intCellX_, intCellY_);
			
			// *********************************************
			// if unit is fighter and destination contains player carrier, move into it
			// *********************************************
			} else if ( isFighter() && oUnitList.isPlayerCarrierAtRowCol(intPlayerId, intCellX_, intCellY_) ) {
			
				//if (intPlayerId==1) println(" in unit.move() debug#6");
				doAddCargo(iUnitListId_, intCellX_, intCellY_);
			
			// *********************************************
			// else just do the move
			// *********************************************
			} else {
			
				////println(" in unit.move() debug#7 just do the move");
				//if (intPlayerId==1 && isTransport() ) println("in unit.move() is tranport getCargoCount()="+getCargoCount() );
				
				//if ( getCargoCount()>0 ) printCargo();
				//intCellX = intCellX_;
				//intCellY = intCellY_;
				
				//if( isTransport() || isCarrier() ) {
				//	moveCargo(intCellX_, intCellY_);
				//}
								
				//Draw();
				
				
				// if unit just stepped off a transport
				if( isCargoOf() ) {
					println("in unit.move, tank might just have stepped off a transport, clear unit from transport");
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
				//if( intPlayerId==1) reDrawNearBy();
				updateSelectedUnitPanelInformation();				
				
			}

			//println(" in unit.move() debug#8");
			
			
		}
		
		//if (getPlayerId()==1) 
		////clearFogOfWar();
		////reDrawNearBy();
		
		
		
		
	}





	// *********************************************
	// PRE-MOVE VALIDATION RULES
	// *********************************************	
	private bool checkPreMoveValidationRules(int iUnitListId_, int intCellX_, int intCellY_) {
	
		//println("in unit.checkPreMoveValidationRules() ");
		
		bool ValidMove=true;
	
		
	
		if( intCellX==intCellX_ && intCellY==intCellY_ ) {
			//if (intPlayerId==1) println("possible invalid move. unit is not moving anywhere.");
			//ValidMove=false;
		}

		if( movesLeftToday<=0 ) {
			println("invalid move. unit has no more moves left today.");
			
			ValidMove=false;

			//setAnimation(false);

			if ( intPlayerId == 1 ) {
				oAnimate.clear();
			} 
			
		}
		
		if ( oUnitRef[intUnitTypeId].canFly() ) {
			if (fuel==0) {
				println("invalid move. unit has no fuel.");
				ValidMove=false;
			}
			
		}
		
		// if destination cell is NOT a city
		if( oCityList.isCity(intCellX_, intCellY_)==false ) {
		
			//println(" destination cell is NOT a city ");
			
			if( movesOnLand==true && movesOnWater==false) {
			
				//println(" unit moves on land but not on sea ");
				
				if( oGrid.isSea(intCellX_, intCellY_)==true ) {
				
					//println(" unit destination is sea ");
					
					// an exception is a tank can move onto a transport of the same player id
					if( oUnitList.isPlayerTransportAtRowCol(intPlayerId, intCellX_, intCellY_) ) {

						//if ( intPlayerId==1 ) println(" player transport found at destination location ");
						
						if ( isTank() ) {
						
							//println(" unit is a tank ");
						
							//TODO: an exception is that if the transport is full, unit cannot move into it
							//...
						
						}
						
					} else {
					
						if ( intPlayerId==1 ) println("invalid move. unit cannot move on sea. getUnitTypeId()="+getUnitTypeId()+" isCargoOf()="+isCargoOf() );
						if ( intPlayerId==1 ) println("current location="+intCellX+","+intCellY+" moveTo="+intCellX_+","+intCellY_ );
						
						ValidMove=false;
						setMoveToX(-1);
						setMoveToY(-1);
					}
				}
			}
			
			if( movesOnLand==false && movesOnWater==true) {
			
				//println(" unit moves on water but not on land ");
				
				if( oGrid.isLand(intCellX_, intCellY_)==true ) {
				
					// destination cell is Land
					
					//println(" destination cell is Land ");
					
					
					
					//TODO: an exception is a ship can attack enemy units on land (even if they are in an emeny city)
					// ...
				
					println("invalid move. unit cannot move on land.");
					ValidMove=false;
					setMoveToX(-1);
					setMoveToY(-1);
				} else {
					// destination cell is Sea
					
					//println(" destination cell is Sea ");
					
					/*
					// an exception is a ship cannot move into another cell which is already occupied by a ship of the same player id
					if( oUnitList.isPlayerSeaVesselAtRowCol(intPlayerId, intCellX_, intCellY_) ) {
					
						println("invalid move. two sea vessels of same player cannot occupy the same location.");
						ValidMove=false;
						setMoveToX(-1);
						setMoveToY(-1);
						if ( isTank() ) {
							setMovesLeftToday(0);
							setTaskStatus(99);
						}
					}
					*/
				}
			}
			
			//TODO: if destination cell is an enemy unit, player unit can only 
			// attack a maximum of 2 times per turn
			//...
			
			
		// if destination cell is a city
		} else {
		
			// if unit is sea vessel and destination cell is an enemy city
			// which is empty, unit should not be able to move into it
			if ( oCityList.isEnemyCity(intPlayerId, intCellX_, intCellY_) 
				&& isSeaVessel() 
				&& oUnitList.isEnemyUnitAt(intPlayerId, intCellX_, intCellY_)==false ) {
				
				println("invalid move. unit cannot move into empty enemy city.");
				ValidMove=false;
			}

			//note: a sea vessel can move into same player city
			
			//TODO: if destination cell is an enemy city, player unit can only 
			// attack a maximum of 2 times per turn
			//...
			
		}
		
		if ( getAttacksLeftToday()==0 
			&& ( oCityList.isEnemyCity(intPlayerId, intCellX_, intCellY_)  
				|| oUnitList.isEnemyUnitAt(intPlayerId, intCellX_, intCellY_) )
			) {

			println("invalid move. unit can only attack twice per day.");
			ValidMove=false;
			setMoveToX(-1);
			setMoveToY(-1);
		}
		
		return ValidMove;
	}

	


	void moveAI(int iUnitListId_) {

		if ( isAsleep()==false ) {
			// if is Fighter, move so that unit does not run out of fuel!
			if ( isFighter() ) {
				identifyNextMoveFighterAI(iUnitListId_);
			} else if ( isBomber() ) {
				identifyNextMoveBomberAI(iUnitListId_);
				
			} else if ( isTransport() ) {
				identifyNextMoveTransportAI(iUnitListId_);

			} else if ( isTank() ) {
				identifyNextMoveTankAI(iUnitListId_);			
			} else {
				identifyNextMoveAI(iUnitListId_);

			}
		}
		
	}
	
	
	
	void identifyNextMoveTankAI(int iUnitListId_) {

		if (intPlayerId==1 && isCargoOf() ) println("in unit.identifyNextMoveTankAI, "+intCellX+","+intCellY+" unit status="+getTaskStatus()+", isCargoOf()="+isCargoOf() );
		
		switch ( getTaskStatus() ) {
			
			case 0:
				// 0=move to using basic algorithm
				if (intPlayerId==1 && isCargoOf() ) println("0=calling identifyNextMoveAI() ");
				//if ( isCargoOf() ) {
				//	setTaskStatus(99);
				//} else {
					//println("calling identifyNextMoveAI() ");
					identifyNextMoveAI(iUnitListId_);				
				//}
				break;
			case 1:
				// 1=move to waiting transport
				
				if (intPlayerId==1 && isCargoOf() ) println("1=move to waiting transport ");
				
				/*
				if ( getMoveToX()==-1 && getMoveToY()==-1 ) {
					println("in unit.identifyNextMoveTankAI, unit status=1, assumed to have moved onto transport, so sleep.");
					setTaskStatus(99);
				}
				*/
					

									
				if ( isCargoOf() ) {
					
					if (intPlayerId==1) println("debug: tank is cargoOf");
					setTaskStatus(99);
					setMovesLeftToday(0);
					//setMoveToX(-1);
					//setMoveToY(-1);
				} else {
					//if (intPlayerId==1) println("debug: is not cargoOf, moveto="+getMoveToX()+","+getMoveToY() );
					//identifyNextMoveAI(iUnitListId_);
					
					if ( oUnitList.getFirstPlayerTransportUnitIdAt(intPlayerId, getMoveToX(), getMoveToY())==-1 ) {
						setMoveToX(-1);
						setMoveToY(-1);
						setTaskStatus(99);
					} else {
						moveToIfSpecified(iUnitListId_);
					}
				}

				//} else {
				//	if (intPlayerId==1) println("note: tank unit possibly unable to move to waiting transport, clearing move to");
				//	setMoveToX(-1);
				//	setMoveToY(-1);
				//}

				break;
			/*
			case 98:
				// 98=move to using basic algorithm
				if (intPlayerId==1 && isCargoOf() ) println("98=identifyNextMoveAI ");
				
				//println("calling identifyNextMoveAI() ");
				identifyNextMoveAI(iUnitListId_);				
				
				break;				
			*/
			case 99:
				if (intPlayerId==1 && isCargoOf() ) println("99=unit sleep ");
				//if (intPlayerId==1) println("debug: unit is asleep");
				// 99=sleep
				setMovesLeftToday(0);			
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



		// ******************************************************
		// identify next move

		
		switch ( getTaskStatus() ) {
		
			//TODO: if transport is beside enemy unit, run away
			//...
			
			case 0:
				// 0=move to position beside player island (not under attack) where unit can accept cargo
				if ( oCityList.isCity(intCellX, intCellY) ) {
				
					// move one cell away (to a sea location beside player island)
					//println("transport status=0, move to a position next to island, where unit can accept cargo");
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
							if ( oGrid.isSea(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intPlayerId, x, y)==false )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				} else {
					transportCargoLoadLocationX=intCellX;
					transportCargoLoadLocationY=intCellY;
					setTaskStatus(1);
				}
				
				break;
			case 1:
				// 1=issue instruction to accept cargo
				//println("transport status=1, issue instruction to accept cargo");
				int iTargetCargoCount=2;
				oUnitList.identifyPlayerLandUnitsToMoveTo(intPlayerId, intCellX, intCellY, getCargoCount(), iTargetCargoCount);
				
				//println("is transport ready to move? getCargoCount()="+getCargoCount());
				//printCargo();
				if ( getCargoCount() >= iTargetCargoCount ) {
					//setStartXY(intCellX, intCellY);
					setTaskStatus(2);
				}
				break;
			case 2:
				// 2=cargo loaded, move to enemy island (or player island which is under attack)
				
				// TO IMPROVE
				// ...	
				//if (...) {
					// identify enemy island to move to (if known)
				
				//} else {
					// identify next move using basic algorithm
					//identifyNextMoveAI(iUnitListId_);
				//}
				
				//if beside island and is not near starting location
				// TO IMPROVE
				//...

				//println("transport status=2, identify next move");



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

					/*
					// if an unoccupied or enemy city is nearby, move towards it.
					for (y=sy; y<=ey; y=y+1) {
						for (x=sx; x<=ex; x=x+1) {
							if (intCellX!=x && intCellY!=y) {
								//if ( oCityList.isEnemyOrUnoccupiedCity(intPlayerId, x,y) )
								if ( oGrid.isSea(x,y) )
									possibleMoves.add( new cGridCell(x, y) );
							}
						}
					}
					*/

					// can unit clear fog?
					if( possibleMoves.size()==0 ) {
						for (y=sy;y<=ey;y++) {
							for (x=sx;x<=ex;x++) {
								if (intCellX!=x && intCellY!=y) {
									if ( oGrid.isSea(x, y) && oGrid.isFogOfWar(x, y) )
										possibleMoves.add( new cGridCell(x, y) );
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

				
				if ( 
					(( intCellX < (transportCargoLoadLocationX -5)
					|| intCellX > (transportCargoLoadLocationX +5) )
					||
					( intCellY < (transportCargoLoadLocationY -5)
					|| intCellY > (transportCargoLoadLocationY +5) )) 
					&& 
					oGrid.isNextToLand(intCellX, intCellY) 
					) {
				
						transportCargoDestinationLocationX=intCellX;
						transportCargoDestinationLocationY=intCellY;
				
				
						//println("************************************************");
						println("transport is isNextToLand at ("+intCellX+","+intCellY+")");
						//println("************************************************");
						setMoveToX(-1);
						setMoveToY(-1);
						updateMovesLeftToday()
						println("getCargoCount()="+getCargoCount() );
						if ( getCargoCount()>0 ) wakeCargo();					
						setTaskStatus(3);				
				
				}
				break;
			case 3:
				// 3=unload cargo
				//println("#################################################");
				println("unload transport cargo at "+intCellX+","+intCellY+"");
				//println("#################################################");
				
				printCargo();
				if ( getCargoCount()>0 ) wakeCargo();
				
				if ( getCargoCount() <=1 ) {
					println(" transport setMoveTo "+transportCargoLoadLocationX+","+transportCargoLoadLocationY+"");
					setMoveToX(transportCargoLoadLocationX);
					setMoveToY(transportCargoLoadLocationY);
					setTaskStatus(4);
					//identifyNextMoveAI(iUnitListId_);
					
					
				}
				break;	
			case 4:
				// 4=move to back to cargo load location
				//moveToIfSpecified(iUnitListId_);
				//identifyNextMoveAI(iUnitListId_);
				
				println("transport - move to back to cargo load location "+intCellX+","+intCellY+"");
				printCargo();
				
				if ( intCellX==transportCargoLoadLocationX && intCellY==transportCargoLoadLocationY ) {
					setTaskStatus(1);
				} else {
					//moveToIfSpecified(iUnitListId_);
					moveTo(iUnitListId_, transportCargoLoadLocationX, transportCargoLoadLocationY);
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

		if ( fuel<13 ) {
			//println("is fighter and fuel < 13");
			
			//TODO: if fighter is near a player carrier (which has space), move onto it
			// else if fighter is near a player city, move onto it
			//...
			
			oCityList.moveUnitToNearestCity(intPlayerId, iUnitListId_, intCellX, intCellY, fuel);
			
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
						if ( oUnitList.isEnemyUnitAt(intPlayerId, x, y) )
							possibleMoves.add( new cGridCell(x, y) );
					}
				}
			}


			// can unit clear fog?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oGrid.isFogOfWar(x, y) )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}

			// else can unit move at random?
			if( possibleMoves.size()<5 ) {
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
			
			oCityList.moveUnitToNearestCity(intPlayerId, iUnitListId_, intCellX, intCellY, fuel);
			
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
							if ( oGrid.isLand(x, y) && oCityList.isEnemyOrUnoccupiedCity(intPlayerId, x, y) )
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
							if ( oUnitList.isEnemyUnitAt(intPlayerId, x, y) )
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
							if ( oGrid.isFogOfWar(x, y) )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}

			// else can unit move at random?
			if( possibleMoves.size()<5 ) {
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

		if (intPlayerId==1 && isCargoOf() ) println(" begin unit.identifyNextMoveAI, strUnitName="+strUnitName+", movesLeftToday="+movesLeftToday);
		if (intPlayerId==1 && isCargoOf() ) println(" intCellX="+intCellX+", intCellY="+intCellY);

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

		

		if( movesOnLand==true ) {

			// ******************************************************
			// identify next move
			

			// can unit attack a enemy unit?			
			for (y=sy;y<=ey;y++) {
				for (x=sx;x<=ex;x++) {
					if (intCellX!=x && intCellY!=y) {
						if ( oGrid.isLand(x, y) && oUnitList.isEnemyUnitAt(intPlayerId, x, y) )
							possibleMoves.add( new cGridCell(x, y) );
					}
				}
			}


			// can unit attack a city?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oGrid.isLand(x, y) && oCityList.isEnemyOrUnoccupiedCity(intPlayerId, x, y) )
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
							if ( oGrid.isLand(x, y) && oGrid.isFogOfWar(x, y) )
								possibleMoves.add( new cGridCell(x, y) );
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
					if ( oGrid.isSea(x, y) && oUnitList.isEnemyUnitAt(intPlayerId, x, y) )
						possibleMoves.add( new cGridCell(x, y) );
				}
			}


			// TODO: if ship finds land, try to follow (explore) coast line.
			// ...
			
			
			// can unit attack a city?
			// TODO: ship could attack city to try to kill any enemy units
			// ...
			/*
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oGrid.isLand(x, y) && oCityList.isEnemyOrUnoccupiedCity(intPlayerId, x, y) )
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
							if ( oGrid.isSea(x, y) && oGrid.isFogOfWar(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intPlayerId, x, y)==false )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}
			
			// else can unit move at random?
			if( possibleMoves.size()==0 ) {
				for (y=sy;y<=ey;y++) {
					for (x=sx;x<=ex;x++) {
						if (intCellX!=x && intCellY!=y) {
							if ( oGrid.isSea(x, y) && oUnitList.isPlayerSeaVesselAtRowCol(intPlayerId, x, y)==false )
								possibleMoves.add( new cGridCell(x, y) );
						}
					}
				}
			}
			
			
		}	
		

		if (intPlayerId==1 && isCargoOf() ) println("possibleMoves.size()="+possibleMoves.size() );

		if( possibleMoves.size()>0 ) {
			//println("unit AI move #1");
			int possibleMoveIndex = int( random(possibleMoves.size() ) );
			//println("unit AI move #2");
			cGridCell cell = (cGridCell) possibleMoves.get(possibleMoveIndex);
			//println("unit AI move #3");
			moveTo(iUnitListId_, cell.getX(), cell.getY() );
			//println("unit AI move #4");
		} else {
			println("note: move AI has not identified a move for unit at "+x+","+y+".");
			setMovesLeftToday(0);
		}		

	}


	
	
	// ***********************************************************
	// DRAW
	// ***********************************************************


	void Draw() {

		//println("drawing unit, intPlayerId="+intPlayerId+", intUnitTypeId=" + intUnitTypeId + ", strUnitName=" + strUnitName);
		
		int countOfPlayerUnits;
		
		//if ( intCellX >= oGrid.getShowFromCellX() && intCellX <= (oGrid.getShowFromCellX()+oGrid.getCellCountX())   &&   intCellY >= oGrid.getShowFromCellY() && intCellY <= (oGrid.getShowFromCellY()+oGrid.getCellCountY()) )  {
		if ( oViewport.isCellWithinViewport(intCellX, intCellY) ) { 
		
			//int DisplayY=(intCellX*16)-15;
			//int DisplayX=(intCellY*16)-15;
			
			int DisplayX=((intCellX-oGrid.getShowFromCellX()+1)*16)-15;
			int DisplayY=((intCellY-oGrid.getShowFromCellY()+1)*16)-15;
			
			if ( oGrid.isFogOfWar(intCellX, intCellY)==false ) { // for testing purposes
			
				if ( intPlayerId==1 || ( intPlayerId==2 && oUnitList.getCountEnemyUnitNearby(intPlayerId, intCellX, intCellY)>=1 ) )  {
			
					switch(intUnitTypeId) {
						case 0:
							//println("drawing Tank, player="+intPlayerId);
							if (intPlayerId==1) {
								//println("player 1");
								//if ( !isCargoOf() && oGameGrid.XXX() ) {

									image( imgTank1, DisplayX, DisplayY );

									// show player Tank count at X,Y on unit image, if more than 1
									countOfPlayerUnits = oUnitList.getCountOfPlayerTankUnitsAt(intPlayerId, intCellX, intCellY);
									if ( countOfPlayerUnits > 1 && oGrid.isLand(intCellX, intCellY) ) {
										fill(255);
										rect(DisplayX+1,DisplayY+1,5,7);
										fill(0);
										textSize(8);
										text(countOfPlayerUnits, DisplayX+2, DisplayY+7 );
										textSize(12);
									}
								//}

							} else {
								//println("player 2");
								if (!isCargoOf()) image( imgTank2,DisplayX, DisplayY );
							}
							//println("DONE drawing Tank, player="+intPlayerId);
							break;
						case 1:
							//println("drawing Fighter");
							if (intPlayerId==1) image( imgFighter1, DisplayX, DisplayY );
							else image( imgFighter2, DisplayX, DisplayY );
							break;
						case 2:
							//println("drawing Battleship");
							if (intPlayerId==1) image( imgBattleship1, DisplayX, DisplayY );
							else image( imgBattleship2, DisplayX, DisplayY );
							break;	
						case 3:
							//println("drawing Bomber");
							if (intPlayerId==1) image( imgBomber1, DisplayX, DisplayY );
							else image( imgBomber2, DisplayX, DisplayY );
							break;	
						case 4:
							//println("drawing Carrier");
							if (intPlayerId==1) image( imgCarrier1, DisplayX, DisplayY );
							else image( imgCarrier2, DisplayX, DisplayY );

							if( intPlayerId==1 && getCargoCount() > 0 ) {
								// show cargo count on unit image
								fill(255);
								rect(DisplayX+1,DisplayY+1,5,7);
								fill(0);
								textSize(8);
								text(getCargoCount(), DisplayX+2, DisplayY+7 );
								textSize(12);
							}

							break;	
						case 5:
							//println("drawing Destroyer");
							if (intPlayerId==1) image( imgDestroyer1, DisplayX, DisplayY );
							else image( imgDestroyer2, DisplayX, DisplayY );
							break;
						case 6:
							//println("drawing Transport");
							if (intPlayerId==1) image( imgTransport1, DisplayX, DisplayY );
							else image( imgTransport2, DisplayX, DisplayY );

							if( intPlayerId==1 && getCargoCount() > 0 ) {
								// show cargo count on unit image
								fill(255);
								rect(DisplayX+1,DisplayY+1,5,7);
								fill(0);
								textSize(8);
								text(getCargoCount(), DisplayX+2, DisplayY+7 );
								textSize(12);
							}

							break;

						case 7:
							//println("drawing Submarine");
							if (intPlayerId==1) image( imgSubmarine1, DisplayX, DisplayY );
							else image( imgSubmarine2, DisplayX, DisplayY );						
							break;						
					}
				}
			}	
			
			/*
			if ( oGrid.isFogOfWar(intCellX, intCellY)==true ) { // for testing purposes
				fill(0);
				textSize(10);
				text("F", DisplayX+2, DisplayY+9 );
				textSize(12);
			}
			*/
			
		}
	}
	

	void clearFogOfWarAt(int x_, y_) {
		int x, y;
		int sx, sy;
		int ex, ey;
		
		if( x_-1>=oGrid.getShowFromCellX() ) sx=x_-1;
		else sx=x_;

		if( x_+1<= (oGrid.getShowFromCellX() + oViewport.getWidth() ) ) ex=x_+1;
		else ex=x_;


		if( y_-1>=oGrid.getShowFromCellY() ) sy=y_-1;
		else sy=y_;

		if( y_+1<= ( oGrid.getShowFromCellY() + oViewport.getHeight() ) ) ey=y_+1;
		else ey=y_;
		
		for (y=sy;y<=ey;y++) {
			for (x=sx;x<=ex;x++) {
			
				if (getPlayerId()==1) oGrid.clearFogOfWar(x,y);
				
				//if ( oViewport.isCellWithinViewport(x,y) ) { 
					if (oGrid.isFogOfWar(x,y)==false) oGrid.DrawCell(x,y,true);
				//}
			}
		}
	}


	void reDrawNearBy() {
		int x, y;
		int sx, sy;
		int ex, ey;
		
		if( intCellX-1>=oGrid.getShowFromCellX() ) sx=intCellX-1;
		else sx=intCellX;
		
		if( intCellX+1<= (oGrid.getShowFromCellX()+oGrid.getCellCountX()) ) ex=intCellX+1;
		else ex=intCellX;
		
		
		if( intCellY-1>=oGrid.getShowFromCellY() ) sy=intCellY-1;
		else sy=intCellY;
				
		if( intCellY+1<= (oGrid.getShowFromCellY()+oGrid.getCellCountY()) ) ey=intCellY+1;
		else ey=intCellY;
		
		//if ( intCellX >= oGrid.getShowFromCellX() && intCellX <= (oGrid.getShowFromCellX()+oGrid.getCellCountX())   &&   intCellY >= oGrid.getShowFromCellY() && intCellY <= (oGrid.getShowFromCellY()+oGrid.getCellCountY()) )  {
		
		for (y=sy;y<=ey;y++) {
			for (x=sx;x<=ex;x++) {
			
				if (getPlayerId()==1) oGrid.clearFogOfWar(x,y);
				
				if ( oViewport.isCellWithinViewport(x,y) ) { 	
					if (oGrid.isFogOfWar(x,y)==false) oGrid.DrawCell(x,y,true);
				}
			}
		}
	}
	

	
	
}


