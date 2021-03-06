
class cGameEngine {


	int dayNumber;
	//bool bIdle;
	int selectedUnitListId=-1;
	int selectedCityListId=-1;
	int iCurrentPlayerId;
	int iCommand; // human player command e.g. (1) wake or (2) move stack
	bool iCurrentlyProcessingPlayerTurn;

	cGameEngine() {
		dayNumber=1;
		bIdle=true;
		iCurrentPlayerId=-1;
		iCommand=-1;
		setCurrentlyProcessingPlayerTurn(false);
	}


	int getDayNumber() { return dayNumber; }
	
	//bool isIdle() { return bIdle; }
	
	void setSelectedUnitListId(int value_) { selectedUnitListId=value_; }
	int getSelectedUnitListId() { return selectedUnitListId; }
	
	void setSelectedCityListId(int value_) { selectedCityListId=value_; }
	int getSelectedCityListId() { return selectedCityListId; }
	
	int getCurrentPlayerId() { return iCurrentPlayerId; }

	void setCurrentlyProcessingPlayerTurn(bool value_) { iCurrentlyProcessingPlayerTurn=value_; }
	bool getCurrentlyProcessingPlayerTurn() { return iCurrentlyProcessingPlayerTurn; }

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

		if ( getCurrentlyProcessingPlayerTurn()==false ) {

			setCurrentlyProcessingPlayerTurn(true);

			// payer 1, human, moves first
			if( oUnitList.getCountUnitsWithMovesLeftToday(1)!=0 ) {
				
				//println("in game engine.doPlayerMove(), player 1 has units to move");

				iCurrentPlayerId=1;
				oPanel2.show();
				//oGameEngine.setCommand(-1);
							
				if ( oPlayer1.getIsAI() ) {
					//println("moveNextUnitWithMovesLeftToday...");
					//oUnitList.highlightNextUnitWithMovesLeftToday(1);

					oUnitList.moveNextUnitWithMovesLeftToday(1);
				} else {
					// if (oAnimateAttack.getCanAttackUnitListId()==-1) {
					//if ( oAnimate.getUnitListId()==-1 ) oUnitList.highlightNextUnitWithMovesLeftToday(1);
					oUnitList.highlightNextUnitWithMovesLeftToday(1);
					//oViewport.draw();
				}


			// payer 2, computer, moves second		
			} else if( oUnitList.getCountUnitsWithMovesLeftToday(2)!=0 ) {


				//println("in loop, player 2 (computer) has units to move");
				
				iCurrentPlayerId=2;
				oPanel2.show();
				oPanelGameMessageLine.clear(70);
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
				
				checkforGameOver();
				
			}

			oCityList.updateSelectedCityPanelInformation( getSelectedCityListId() );
		} else {
			println("debug: in GameEngine.doPlayerMove() skipping because getCurrentlyProcessingPlayerTurn()==true");
		}

		setCurrentlyProcessingPlayerTurn(false);


		// GameState code 4=play
		if ( GameState==4 ) {

			oPanelMap.show();
			if (debugShowPlayer2Viewport) oPanelMapPlayer2.show();

			//oPanelCityList.show(); // FISH
			//oPanelIslandList.show(); // FISH
			
			oPanelPlayer1UnitCounts.show();
			if (debugShowPlayer2Viewport) oPanelPlayer2UnitCounts.show();

		}
		
		//bIdle=true;

	
	}


	void nextDay() {

		dayNumber++;
		//println("Day " + dayNumber);
		println("");

		oUnitList.resetMovesLeftToday();
		oCityList.manageProduction();

		//background(0);

		//oCityList.Draw();
		//if ( getCurrentPlayerId() > 0 ) {
			oViewport.draw();
			if (debugShowPlayer2Viewport) oViewportPlayer2.draw();
		//}

		//oPanelCityList.show();
		//oPanelIslandList.show();

		oIslandList.updateIslandStatus();
		//oPanelCityList.show();

		//oPanelPlayer1UnitCounts.show();
		//oPanelPlayer2UnitCounts.show();
	}


	void checkforGameOver() {
	
		//should player 2 surrender?
		//println("should player 2 surrender?");
		int iMinDayNumber=10;
		int iMinUnitNumber=10;
		int iMinCityNumber=0;
		
		if ( getDayNumber()>=iMinDayNumber ) {
		
			if ( oUnitList.getCountOfPlayerUnits(2)<=iMinUnitNumber && oCityList.getCountPlayerCity(2)<=iMinCityNumber ) {

				if ( oPlayer1.getIsAI() ) {
					gameOver(1);			
				} else {
					//println("display DialogueSurrender...");
					oDialogueSurrender.show();
					//println("displayed DialogueSurrender.");
				}

			} else if ( oUnitList.getCountOfPlayerUnits(1)<=iMinUnitNumber && oCityList.getCountPlayerCity(1)<=iMinCityNumber ) {
				gameOver(2);

			}
		}
	}


	void gameOver(int iPlayerIdWinner_) {
		GameState=99;	
		if (iPlayerIdWinner_==1) {
			println("");
			println("General, I surrender.");
			println("");
		}
		println("Player "+iPlayerIdWinner_+" has won!");
		println("Thank you for playing StratConClone!");
		println("");	
	}

}
