
class cGameEngine {

	int dayNumber;
	bool bIdle;
	int selectedUnitListId=-1;
	int selectedCityListId=-1;
	int iCurrentPlayerId;
	int iCommand; // human player command e.g. (1) wake or (2) move stack

	cGameEngine() {
		dayNumber=1;
		bIdle=true;
		iCurrentPlayerId=-1;
		iCommand=-1;
	}


	int getDayNumber() { return dayNumber; }
	
	bool isIdle() { return bIdle; }
	
	void setSelectedUnitListId(int value_) { selectedUnitListId=value_; }
	int getSelectedUnitListId() { return selectedUnitListId; }
	
	void setSelectedCityListId(int value_) { selectedCityListId=value_; }
	int getSelectedCityListId() { return selectedCityListId; }
	
	int getCurrentPlayerId() { return iCurrentPlayerId; }

	void setCommand(int value_) { 
		//println("in setCommand="+value_); 
		iCommand=value_; 
		//println("in setCommand="+value_); 
	}
	int getCommand() { 
		//println("in getCommand, return="+iCommand); 
		return iCommand; 
	}

	void doPlayerMove() {

		//println("GameEngine.loop() begin");
		
		bIdle=false;

		// payer 1, human, moves first
		if( oUnitList.getCountUnitsWithMovesLeftToday(1)!=0 ) {

			
			//println("in game engine.doPlayerMove(), player 1 has units to move");

			iCurrentPlayerId=1;
			oPanel2.show();
			//oGameEngine.setCommand(-1);
			
			oUnitList.highlightNextUnitWithMovesLeftToday(1);
			
			//println("debug#3");
			if ( oPlayer1.getIsAI() ) {
				//println("moveNextUnitWithMovesLeftToday...");
				oUnitList.moveNextUnitWithMovesLeftToday(1);
			}
		


		// payer 2, computer, moves second		
		} else if( oUnitList.getCountUnitsWithMovesLeftToday(2)!=0 ) {


			//println("in loop, player 2 (computer) has units to move");
			
			iCurrentPlayerId=2;
			oPanel2.show();
			oPanelSelectedUnit.clear();
			oAnimate.clear();

			oUnitList.highlightNextUnitWithMovesLeftToday(2);
			
			//println("debug#1");
			if ( oPlayer2.getIsAI() ) {
				//println("moveNextUnitWithMovesLeftToday...");
				oUnitList.moveNextUnitWithMovesLeftToday(2);
			}
			
			

		} else {
		
			// if payer 1 and player 2 have no units to be moved, progress to next day
			//println("debug 7: GameState="+GameState);
			nextDay();
		}

		oCityList.updateSelectedCityPanelInformation( getSelectedCityListId() );
		
		bIdle=true;
	}


	void nextDay() {
		dayNumber++;
		println("Day " + dayNumber);
		oUnitList.resetMovesLeftToday();
		oCityList.manageProduction();
		//oCityList.Draw();
		oViewport.draw();
	}


}
