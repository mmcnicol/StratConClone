
class cUnitList {

	ArrayList listUnit;

	cUnitList() {
		listUnit = new ArrayList();  // Create an empty ArrayList
	}

	int getCount() {
		return listUnit.size()-1;
	}

	void AddUnit(int intUnitTypeId_, int intPlayerId_, int intcellX_, int intcellY_) {
	
		//println( "add unit for player " + intPlayerId_ + ", intUnitTypeId_=" + intUnitTypeId_);
		listUnit.add( new cUnit(intUnitTypeId_, intPlayerId_, intcellX_, intcellY_) );  
		//println( "unit list debug#1");
	}

	/*
	void printPlayerUnitLocations(int iPlayerId_) {
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if ( unit.getPlayerId()==iPlayerId_ ) unit.printRowCol();
		}  
	}
	*/

	int getCountEnemyUnitNearby(int intPlayerId_, int intRow_, int intCol_) {
	
		int TempCount=0;
		int iEnemyPlayerId;
		
		if (intPlayerId_==1) iEnemyPlayerId=2;
		else iEnemyPlayerId=1;
		
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if ( unit.getPlayerId()==iEnemyPlayerId && unit.isNearby(intRow_, intCol_,1)==true && unit.isAlive() ) TempCount++;
		}  
		return TempCount;	
	}
	
	int getCountOfPlayerUnitsAt(int iPlayerId_, int x_, int y_) {
	
		int counter=0;
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(x_, y_)==true && unit.isAlive() ) {
				counter++;
			}
		}  
		return counter;	
	}


	int getCountOfPlayerTankUnitsAt(int iPlayerId_, int x_, int y_) {
	
		int counter=0;
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(x_, y_)==true && unit.isTank() && unit.isAlive() ) {
				counter++;
			}
		}  
		return counter;	
	}
	
	
	int getPlayerUnitNumberAtRowCol(int iPlayerId_, int x_, int y_) {
		int temp=-1;
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(x_, y_)==true && unit.getMovesLeftToday() > 0 && unit.isAlive() ) {
				return i;
			}
		}  
		return temp;	
	}
	
	void commandWakePlayerUnitsAt(int iPlayerId_, int x_, int y_) {
	
		//println("in oUnitist.commandWakePlayerUnitsAt("+iPlayerId_+","+x_+","+y_+")");

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(x_, y_)==true && unit.isAlive() ) {
			
				unit.setTaskStatus(0);
				unit.setMoveToX(-1);
				unit.setMoveToY(-1);
				//println("unit.getMovesPerDay() ="+unit.getMovesPerDay() );
				unit.setMovesLeftToday( unit.getMovesPerDay() );
				println("found unit to wake");
			}
		}  
		oGameEngine.setCommand(-1);
		//println("leaving oUnitist.commandWakePlayerUnitsAt()");
	}
	

	int getHumanUnitNumberAtXY(int x_, int y_) {
	
		int temp=-1;
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			//unit.printRowCol();
			if( unit.getPlayerId()==1 && unit.isAtXY(x_, y_) && unit.isAlive() ) {
				println("in getHumanUnitNumberAtXY, return i="+i);
				return i;
			}
		}  
		println("in getHumanUnitNumberAtXY, return i="+temp);
		return temp;
	}



	bool isUnit(int cellX_, int cellY_) {
		
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			//if( unit.getPlayerId()==1 && unit.isAt(cellX_, cellY_)==true && unit.isAlive() ) {
			if( unit.isAt(cellX_, cellY_)==true ) {
				return true;	
			}
		}  
		
		return false;	
	}
	
	
	bool isPlayerSeaVesselAtRowCol(int iPlayerId_, int x_, int y_) {
	
		//println("debug: in unlitlist.isPlayerSeaVesselAtRowCol() ");
		
		//bool result = false;

		for (int i = 0; i < listUnit.size(); i++) { 
		
			cUnit unit = (cUnit) listUnit.get(i);

			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(x_, y_) && unit.isSeaVessel() && unit.isAlive() ) {

				return true;
				//result = true;
				
				// exit loop;
				//i = listUnit.size();
			}
		}  
		
		return false;
	}



	void isFighter(int iUnitListId_) {

		//println("in unitlist.isFighter iUnitListId_="+iUnitListId_);
		if ( iUnitListId_>=0 ) {
			cUnit unit = (cUnit) listUnit.get(iUnitListId_);
			return unit.isFighter();
		} else {
			println("error: unitlist.isFighter() called with invalid list unit id.");
		}
		return false;
	}



	bool isPlayerTransportAtRowCol(int iPlayerId_, int x_, int y_) {
	
		//println("debug: in unlitlist.isPlayerTransportAtRowCol() ");
		
		//bool result = false;

		for (int i = 0; i < listUnit.size(); i++) { 
		
			cUnit unit = (cUnit) listUnit.get(i);

			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(x_, y_) && unit.isTransport() && unit.isAlive() ) {

				//println("debug: in unlitlist.isPlayerTransportAtRowCol() ...yes");
				return true;
				
				// exit loop;
				//i = listUnit.size();
			}
		}  
		
		return false;
	}	



	bool isEnemyTransportAtRowCol(int iPlayerId_, int x_, int y_) {
	
		//println("debug: in unlitlist.isPlayerTransportAtRowCol() ");
		
		//bool result = false;

		for (int i = 0; i < listUnit.size(); i++) { 
		
			cUnit unit = (cUnit) listUnit.get(i);

			if( unit.getPlayerId()!=iPlayerId_ && unit.isAt(x_, y_) && unit.isTransport() && unit.isAlive() ) {

				//println("debug: in unlitlist.isPlayerTransportAtRowCol() ...yes");
				return true;
				
				// exit loop;
				//i = listUnit.size();
			}
		}  
		
		return false;
	}	


	bool isPlayerCarrierAtRowCol(int iPlayerId_, int x_, int y_) {
	
		//println("debug: in unlitlist.isPlayerCarrierAtRowCol() ");
		
		//bool result = false;

		for (int i = 0; i < listUnit.size(); i++) { 
		
			cUnit unit = (cUnit) listUnit.get(i);

			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(x_, y_) && unit.isCarrier() && unit.isAlive() ) {

				//println("debug: in unlitlist.isPlayerCarrierAtRowCol() ...yes");
				return true;
				
				// exit loop;
				//i = listUnit.size();
			}
		}  
		
		return false;
	}
	
	
	void addUnitCargo(int cargoListUnitId_, int destinationUnitId_) {
	
		//println("in unitList.addUnitCargo()...");
		
		cUnit unit = (cUnit) listUnit.get(destinationUnitId_);

		unit.addCargo(cargoListUnitId_);
		
		//unit.setMoveToX(-1);
		//unit.setMoveToY(-1);
		//unit.printCargo();
		
		
		/* 
		cUnit cargoUnit = (cUnit) listUnit.get(cargoListUnitId_);
		
		cargoUnit.setIsCargoOf(destinationUnitId_);
		cargoUnit.setMoveToX(-1);
		cargoUnit.setMoveToY(-1);
		*/
		
	}	
	
	void clearUnitFromCargoOf(int UnitListId_, int CargoUnitListId_) {
		//println("in clearUnitFromCargoOf("+UnitListId_+","+CargoUnitListId_+")");
		cUnit unit = (cUnit) listUnit.get(UnitListId_);
		unit.clearCargoUnit(CargoUnitListId_);
		//println("end clearUnitFromCargoOf("+UnitListId_+","+CargoUnitListId_+")");
	}



	void wake(int UnitListId_) {

		//println("in unit_list.wake, UnitListId_=("+UnitListId_+")");
		cUnit unit = (cUnit) listUnit.get(UnitListId_);
		unit.setTaskStatus(0);
		unit.setMoveToX(-1);
		unit.setMoveToY(-1);
		unit.setMovesLeftToday( unit.getMovesPerDay() );
		
	}

	
	// ****************************************************************
	// BATTLE
	// ****************************************************************

	bool isEnemyUnitAt(int iPlayerId_, int cellX_, int cellY_) {

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()!=iPlayerId_ && unit.isAt(cellX_, cellY_) && unit.isAlive() ) {
				return true;
			}
		}  
		return false;	
	}
	
	
	int getFirstEnemyUnitIdAt(int iPlayerId_, int cellX_, int cellY_) {

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()!=iPlayerId_ && unit.isAt(cellX_, cellY_) && unit.isAlive() ) {
				return i;
			}
		}  
		return -1;	
	}

	int getFirstPlayerTransportUnitIdAt(int iPlayerId_, int cellX_, int cellY_) {

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(cellX_, cellY_) && unit.isTransport() && unit.isAlive() ) {
				return i;
			}
		}  
		return -1;	
	}

	int getFirstEnemyTransportUnitIdAt(int iPlayerId_, int cellX_, int cellY_) {

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()!=iPlayerId_ && unit.isAt(cellX_, cellY_) && unit.isTransport() && unit.isAlive() ) {
				return i;
			}
		}  
		return -1;	
	}
	
	int getFirstPlayerCarrierUnitIdAt(int iPlayerId_, int cellX_, int cellY_) {
	
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(cellX_, cellY_) && unit.isCarrier() && unit.isAlive() ) {
				return i;
			}
		}  
		return -1;	
	}
	
	void deleteUnit(int iUnitListId_) {
	
		//println("in unitList.deleteUnit("+iUnitListId_+")...");
		
		//println("debug#1");
		cUnit unit = (cUnit) listUnit.get(iUnitListId_);
		//println("debug#2");
			
		if ( unit.hasCargo() ) {
			//println("debug#3");
			unit.deleteAllCargo();		
		} else if ( unit.isCargoOf() ) {
			cUnit unitTransport = (cUnit) listUnit.get( unit.getIsCargoOf() );
			unitTransport.clearCargoUnit(iUnitListId_);
		}
		
		//println("debug#4");
		int x,y;
		//println("debug#5");
		x=unit.getX();
		//println("debug#6");
		y=unit.getY();
		//println("debug#7");
		unit.kill();
		//println("debug#8");
		//listUnit.remove(iUnitListId_);
		//println("debug#9");
		
		//println("leaving unitList.deleteUnit()...");
	}
	
	/*
	void RemoveUnit(int i) {
		listUnit.remove(i);
	}
	*/
	
	void killUnitsAt(int cellX_, int cellY_) {

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.isAt(cellX_, cellY_)==true && unit.isAlive() ) {
				deleteUnit(i);
			}
		}  
	}

	bool isBombableEnemy(iPlayerId_, intCellX_, intCellY_) {

		//println("in isBombableEnemy()");
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if ( unit.getPlayerId()!=iPlayerId_  && unit.isAt(intCellX_, intCellY_) && unit.isBombable() && unit.isAlive() ) return true;
		}  
		return false;
	}
	
	void manageUnitStrengthReduction(int iUnitListId_) {
	
		//println("in manageUnitStrengthReduction()...");
	
		// following a defense/attack, unit strength might be reduced, and then is strength is zero unit is killed 
	
		cUnit unit = (cUnit) listUnit.get(iUnitListId_);
		unit.reduceStrength();
		if ( unit.getStrength()==0 ) {
			if ( unit.getPlayerId()==1 ) {
				println("Unit destroyed!");
				println("");
			}
			unit.kill();
			/////////listUnit.remove(iUnitListId_);
		}
			
	}	

	
	int getUnitStrength(int iUnitListId_) {
	
		//println("in unitList.getUnitStrength()...");
		
		cUnit unit = (cUnit) listUnit.get(iUnitListId_);

		return unit.getStrength();
	}




	void identifyPlayerLandUnitsToMoveTo(int iPlayerId_, int x_, int y_, int iCargoCount_, int iTargetCargoCount_) {
	
		//if (iPlayerId_==1) println("in identifyPlayerTankUnitsToMoveTo("+x_+","+y_+")... iCargoCount_="+iCargoCount_);

		int i, countLandUnitsIdentified, cellCount=7;
		

		countLandUnitsIdentified=0;

		countLandUnitsIdentified = countLandUnitsIdentified + getCountPlayerLandUnitsWithToMoveTo(iPlayerId_, x_, y_);
		
		countLandUnitsIdentified = countLandUnitsIdentified + iCargoCount_;

		for (i = 0; i < listUnit.size() && countLandUnitsIdentified<=iTargetCargoCount_+1; i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			
			//if (iPlayerId_==1) println("can tank at "+unit.getX()+","+unit.getY()+" be moved onto transport at "+x_+","+y_+"?");
			
			if( unit.getPlayerId()==iPlayerId_ 
				&& unit.isTank() 
				&& unit.isCargoOf()==false 
				&& unit.isAlive()
				&& unit.getMoveToX()==-1
				&& unit.getMoveToY()==-1 
				) {
			
				// && unit.isAsleep()==false 

				//if (iPlayerId_==1) println("can tank at "+unit.getX()+","+unit.getY()+" be moved onto transport at "+x_+","+y_+"?");
				
				if ( 	   unit.getX() >= x_-cellCount
					&& unit.getY() >= y_-cellCount
					&& unit.getX() <= x_+cellCount
					&& unit.getY() <= y_+cellCount
					) {
				
					//if (iPlayerId_==1) println(" yes, setting tank at "+unit.getX()+","+unit.getY()+" to move to transport at "+x_+","+y_+"");
					unit.setMoveToX(x_);
					unit.setMoveToY(y_);
					unit.setTaskStatus(1);
					countLandUnitsIdentified++;				
				} else {
					//if (iPlayerId_==1) println(" no, not setting tank at "+unit.getX()+","+unit.getY()+" to move to transport at "+x_+","+y_+"");
				}
			} else {
				//println(" no, not setting tank at "+unit.getX()+","+unit.getY()+" to move to transport at "+x_+","+y_+"");
			}
		}  
		
		//if (iPlayerId_==1) println("countLandUnitsIdentified=" + countLandUnitsIdentified);
			
	}
	


	void getCountPlayerLandUnitsWithToMoveTo(int iPlayerId_, int x_, int y_) {
	
		//if (iPlayerId_==1) println("in getCountPlayerLandUnitsWithToMoveTo()...");

		int i, counter=0;
		
		for (i = 0; i < listUnit.size() && counter<6; i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			
			if( unit.getPlayerId()==iPlayerId_ 
				&& unit.isTank() 
				&& unit.isAlive()
				&& unit.getMoveToX()==x_
				&& unit.getMoveToY()==y_
				) {
				
				counter++;
			}
		}  
		
		//if (iPlayerId_==1) println("counter=" + counter);
		return counter;
			
	}	
	
	
	
	// ****************************************************************
	// MOVE
	// ****************************************************************


	int getCountUnitsWithMovesLeftToday(int intPlayerId_) {
		int TempCount=0;
		//println("in getCountUnitsWithMovesLeftToday()");
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==intPlayerId_ && unit.isAsleep()==false && unit.getMovesLeftToday() >0 && unit.isAlive() ) {
				TempCount=TempCount + 1;
			}
		}  
		//println("getCountUnitsWithMovesLeftToday=" + TempCount);
		return TempCount;	
	}
	
	void moveNextUnitWithMovesLeftToday(int intPlayerId_) {
		//println("in moveNextUnitWithMovesLeftToday()...");
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==intPlayerId_ && unit.getMovesLeftToday() >0 && unit.isAsleep()==false && unit.isAlive() ) {
				
				//unit.moveAI(i);
				unit.moveToIfSpecified(i);
				
				// exit loop
				i=listUnit.size();
			}
		}  

	}


/*
	void move(int UnitListId_, int x_, iny y_) {

		//println("in unit_list.move, UnitListId_=("+UnitListId_+")");
		cUnit unit = (cUnit) listUnit.get(UnitListId_);
		unit.setX(x_);
		unit.setY(y_);
	}
*/


	void move(int iUnitListId_, int Row_, int Col_) {

		//println("in unitlist.move iUnitListId_="+iUnitListId_+" ("+Row_+","+Col_+")");
		if ( iUnitListId_>=0 ) {
			cUnit unit = (cUnit) listUnit.get(iUnitListId_);
			//println("debug 2");
			unit.move(iUnitListId_, Row_, Col_);
			//println("debug 3");
		} else {
			println("error: unitlist.move() called with invalid list unit id.");
		}

	}

	void moveCargo(int iUnitListId_, int Row_, int Col_) {

		//println("in unitlist.moveCargo iUnitListId_="+iUnitListId_+" ("+Row_+","+Col_+")");
		if ( iUnitListId_>=0 ) {
			cUnit unit = (cUnit) listUnit.get(iUnitListId_);
			//println("debug 2");
			unit.setX(Row_);
			unit.setY(Col_);
			//println("debug 3");
		} else {
			println("error: unitlist.moveCargo() called with invalid list unit id.");
		}

	}
	
	void moveTo(int iUnitListId_, int x_, int y_) {

		//println("in unitlist.moveTo x="+x_+",y="+y_);
		
		cUnit unit = (cUnit) listUnit.get(iUnitListId_);
		//println("debug 2");
		unit.moveTo(iUnitListId_, x_, y_);
		//println("debug 3");

	}
	
	void resetMovesLeftToday() {
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			
			
			//if ( unit.getTaskStatus()!=99 && unit.isAlive() ) { // if unit is not asleep
			if ( unit.isAsleep()==false && unit.isAlive() ) { // if unit is not asleep
				unit.resetMovesLeftToday();
				unit.setAttacksLeftToday(2);
			} 
			
		} 
	}

	void commandMovePlayerUnitsAt(int iPlayerId_, int sx_, int sy_, int ex_, int ey_) {
	
		//println("in oUnitist.commandMovePlayerUnitsAt("+iPlayerId_+","+sx_+","+sy_+")");

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isAt(sx_, sy_)==true && unit.isAlive() ) {
			
				//unit.setTaskStatus(0);
				//println("unit.getMovesPerDay() ="+unit.getMovesPerDay() );
				//unit.setMovesLeftToday( unit.getMovesPerDay() );
				
				println("found unit to move");
				unit.moveTo(i, ex_, ey_);
				
			}
		}  
		oGameEngine.setCommand(-1);
		//println("leaving oUnitist.commandWakePlayerUnitsAt()");
	}
	

	// ****************************************************************
	// DRAW
	// ****************************************************************

	void Draw(int cellX_, int cellY_) {
		
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			//if( unit.getPlayerId()==1 && unit.isAt(cellX_, cellY_)==true ) {
			if( unit.isAt(cellX_, cellY_)==true && unit.isAlive() ) {
			
				if ( unit.isCargoOf()==false || oGameEngine.getSelectedUnitListId()==i ) {
					unit.Draw();
				}
			}
		}  
		
	}
	
	void drawTransportAt(int iPlayerId_, int cellX_, int cellY_) {

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isTransport() && unit.isAt(cellX_, cellY_)==true && unit.isAlive() ) {
				unit.Draw();
			}
		}  	
	}
	
	void drawCarrierAt(int iPlayerId_, int cellX_, int cellY_) {

		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isCarrier() && unit.isAt(cellX_, cellY_)==true && unit.isAlive() ) {
				unit.Draw();
			}
		}  	
	}

	// ****************************************************************
	// HIGHLIGHT / SELECT / ANIMATE
	// ****************************************************************

	void highlightNextUnitWithMovesLeftToday(int intPlayerId_) {
		//println("in highlightNextUnitWithMovesLeftToday()...");
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==intPlayerId_ && unit.getMovesLeftToday() >0 && unit.isAlive() ) {
				
				//println("calling unit.highlight()...");
				
				if ( intPlayerId_==1 ) oViewport.scrollIfAppropriate(unit.getX(), unit.getY());
				
				//if (intPlayerId_==1) unit.setAnimation(true);
				//unit.setAnimation(true);
				
				if (intPlayerId_==1) oAnimate.set(i);

				
				// if testing, comment out this section so that player 1 is moved by computer
				//if (intPlayerId_==1) 
					unit.moveToIfSpecified(i);
				
				// exit loop
				i=listUnit.size();
			}
		}  

	}



	void updateDisplay(int iUnitListId_, int iAnimateSwitch_) {

		cUnit unit = (cUnit) listUnit.get(iUnitListId_);
		
		unit.updateSelectedUnitPanelInformation();
		
		oViewport.scrollIfAppropriate(unit.getX(), unit.getY());

		switch( iAnimateSwitch_ ) {
			case 0:
				//println("Animating unit DRAW, "+unit.getX()+","+unit.getY());
				unit.Draw();
				break;
			case 1:
				//println("Animating unit HIDE, "+unit.getX()+","+unit.getY());
				//oGrid.DrawCell(intCellX, intCellY, false);
				if ( unit.isCargoOf() ) {
					drawTransportAt(unit.getPlayerId(), unit.getX(), unit.getY() );
					drawCarrierAt(unit.getPlayerId(), unit.getX(), unit.getY() );
				} else {
					oGrid.DrawCell(unit.getX(), unit.getY(), false);
				}
				break;					
		}	
		
	}
	
	
	
	void selectedUnitSkip(int intPlayerId_) {
	
		int iUnitListId = oAnimate.getUnitListId();
		
		if ( iUnitListId != -1 ) {
		
			cUnit unit = (cUnit) listUnit.get(iUnitListId);
			
			oAnimate.clear();
			
			unit.setMovesLeftToday(0);
			unit.Draw();
			
			if ( oUnitRef[ unit.getUnitTypeId() ].canFly() ) unit.updateFuelLeft(iUnitListId);			
		}		
		
		oPanelSelectedUnit.clear(255);

	}
	

	void selectedUnitSleep(int intPlayerId_) {
		
		//println("in oUnitList.selectedUnitSleep, playerid="+intPlayerId_+", unitlistid="+oAnimate.getUnitListId());
		
		int iUnitListId = oAnimate.getUnitListId();
		
		if ( iUnitListId != -1 ) {
		
			cUnit unit = (cUnit) listUnit.get(iUnitListId);
			
			oAnimate.clear();
			
			unit.setMovesLeftToday(0);
			unit.setTaskStatus(99);
			println("... unit found, set to sleep, at "+unit.getX()+","+unit.getY() );
			unit.Draw();
			
			if ( oUnitRef[ unit.getUnitTypeId() ].canFly() ) unit.updateFuelLeft(iUnitListId);			
		}
		
		oPanelSelectedUnit.clear(255);

	}


	void selectedUnitMoveAI(int intPlayerId_) {
	
		int iUnitListId = oAnimate.getUnitListId();
		
		if ( iUnitListId != -1 ) {
		
			cUnit unit = (cUnit) listUnit.get(iUnitListId);
			
			oAnimate.clear();
			
			unit.moveAI(iUnitListId);
			
		}		
		
		oPanelSelectedUnit.clear(255);

	}



	// ****************************************************************
	// GAVE OVER?
	// ****************************************************************

	int getCountOfPlayerUnits(int iPlayerId_) {
	
		//println("in unit_list.getCountOfPlayerUnits() ");
	
		int counter=0;
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.isAlive() ) {
				counter++;
			}
		}  
		return counter;	
	}
	


	// ****************************************************************
	// PRODUCTION
	// ****************************************************************


	int getCountOfPlayerUnitsByUnitType(int iPlayerId_, int iUnitType_) {
		int counter=0;
		for (int i = 0; i < listUnit.size(); i++) { 
			cUnit unit = (cUnit) listUnit.get(i);
			if( unit.getPlayerId()==iPlayerId_ && unit.getUnitTypeId()==iUnitType_ && unit.isAlive() ) {
				counter++;
			}
		}  
		return counter;	
	}	
}





