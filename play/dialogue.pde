
class cDialogue {

	int panelStartX, panelStartY, panelWidth, panelHeight;
	bool bActive;
	int iLineNumber;
	int iSpaceHeight;
	int iLeftTextIndent;
		
	cDialogue(int panelStartY_, int panelHeight_) {

		//println("in cDialogue constructor "+panelStartY_+","+ panelHeight_);
		
		panelWidth = 400;
		panelHeight = panelHeight_;	
		panelStartX = round( ((oViewport.getWidth()-(cellWidth-1))/2)-(panelWidth/2) );
		panelStartY = panelStartY_;
		//println("in cDialogue constructor... "+panelStartY+","+ panelHeight);
		
		bActive=false; // when active, system checks for mouse clicks. use if panel contains clickable items.
		
		iSpaceHeight=iStringTextSize+3;
		iLeftTextIndent=(cellWidth/2);
	}

	int getWidth() { return panelWidth; }
	
	bool isActive() { return bActive; } 
	
	void clear(int fillValue_) {
		//noStroke();
		//fill(fillValue_);
		//rect(panelStartX, panelStartY, panelWidth, panelHeight );	
	}

	
	void hide() {
		//fill(255);
		//rect(panelStartX, panelStartY, panelWidth, panelHeight );	
		//redraw();
		oViewport.draw();
		//redraw();
	}
	
	
}




/* ====================================================================================
   this dialogue enables user to view/change city production.
*/
class cDialogueCityProduction extends cDialogue {

	//cLabel oLabelCityLocation;
	cLabel oLabelPanelTitle;
	cLabel oLabelColumn2Title;
	cCheckbox oCheckboxTank;
	cCheckbox oCheckboxFighter;
	cCheckbox oCheckboxBattleship;
	cCheckbox oCheckboxBomber;
	cCheckbox oCheckboxCarrier;
	cCheckbox oCheckboxDestroyer;
	cCheckbox oCheckboxTransport;
	cCheckbox oCheckboxSubmarine;
	cLabel oLabelTank;
	cLabel oLabelFighter;
	cLabel oLabelBattleship;
	cLabel oLabelBomber;
	cLabel oLabelCarrier;
	cLabel oLabelDestroyer;
	cLabel oLabelTransport;
	cLabel oLabelSubmarine;
	cButton oButtonSave;
	int iProductionUnitTypeId;
	int iSpaceHeight;
	int iCityListId;
	bool bIsPort;
	string sCityLocation;
	
	
	cDialogueCityProduction(int panelStartY_, int panelHeight_) {
	
		super(panelStartY_, panelHeight_);
		
		//println("in cDialogueCityProduction constructor....1.. "+panelStartY+","+ panelHeight);
		iSpaceHeight=iStringTextSize+3;
		
		iLineNumber=1;
		int iColumn2LeftTextIndend=200;
				
		oLabelPanelTitle = new cLabel("City Production: ", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		//oLabelCityLocation = new cLabel("City Location: ", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;
		
		
		oLabelColumn2Title = new cLabel("Days to Produce", (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;
		
		oCheckboxTank = new cCheckbox(oUnitRef[0].getUnitTypeId(), oUnitRef[0].getUnitName(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		oLabelTank = new cLabel(oUnitRef[0].getDaysToProduce(), (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;

		oCheckboxFighter = new cCheckbox(oUnitRef[1].getUnitTypeId(), oUnitRef[1].getUnitName(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		oLabelFighter = new cLabel(oUnitRef[1].getDaysToProduce(), (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;

		oCheckboxDestroyer = new cCheckbox(oUnitRef[5].getUnitTypeId(), oUnitRef[5].getUnitName(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		oLabelDestroyer = new cLabel(oUnitRef[5].getDaysToProduce(), (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;

		oCheckboxSubmarine = new cCheckbox(oUnitRef[7].getUnitTypeId(), oUnitRef[7].getUnitName(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		oLabelSubmarine = new cLabel(oUnitRef[7].getDaysToProduce(), (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;

		oCheckboxTransport = new cCheckbox(oUnitRef[6].getUnitTypeId(), oUnitRef[6].getUnitName(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		oLabelTransport = new cLabel(oUnitRef[6].getDaysToProduce(), (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;

		oCheckboxCarrier = new cCheckbox(oUnitRef[4].getUnitTypeId(), oUnitRef[4].getUnitName(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		oLabelCarrier = new cLabel(oUnitRef[4].getDaysToProduce(), (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;

		oCheckboxBattleship = new cCheckbox(oUnitRef[2].getUnitTypeId(), oUnitRef[2].getUnitName(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		oLabelBattleship = new cLabel(oUnitRef[2].getDaysToProduce(), (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;

		//println("in cDialogueCityProduction constructor.....2. "+panelStartY+","+ panelHeight);

		oCheckboxBomber = new cCheckbox(oUnitRef[3].getUnitTypeId(), oUnitRef[3].getUnitName(), (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber)); 
		oLabelBomber = new cLabel(oUnitRef[3].getDaysToProduce(), (panelStartX+iColumn2LeftTextIndend), panelStartY+(iSpaceHeight*iLineNumber)); 
		iLineNumber++;
		
		//println("in cDialogueCityProduction constructor......3 "+panelStartY+","+ panelHeight);
		
		oButtonSave = new cButton(999, "Save", (panelStartX+iLeftTextIndent), (panelStartY+(iSpaceHeight*iLineNumber)) ); 
		
		//println("city production dialogue, button " +(panelStartX+iLeftTextIndent)+","+ (panelStartY+(iSpaceHeight*iLineNumber)) );

	}


	void show(int iCityListId_) {
		
		iCityListId = iCityListId_;
		bActive=true;
				
		textSize(iStringTextSize);
		
		iProductionUnitTypeId = oCityList.getCityProductionUnitTypeId(iCityListId);
		//println("in cDialogueCityProduction.display() iProductionUnitTypeId="+iProductionUnitTypeId);
		
		sCityLocation = oCityList.getCityLocation(iCityListId);
		oLabelPanelTitle.set("City Production ("+sCityLocation+")");
		
		
		bIsPort=oCityList.isPort(iCityListId);
		
		display();
	}
	
	private void display() {
	
		clear(255);
		noStroke();
		fill(150); 
		rect(panelStartX, panelStartY, panelWidth, panelHeight );
		
		
		//println("in cDialogueCityProduction.display() iProductionUnitTypeId="+iProductionUnitTypeId);
		
		//println("in cDialogueCityProduction.display() bIsPort="+bIsPort);
		
		bool enabled;
		if (bIsPort) enabled=true;
		else enabled=false;
		
		//oLabelCityLocation.display();
		oLabelPanelTitle.display();
		oLabelColumn2Title.display();

		if (iProductionUnitTypeId==oUnitRef[0].getUnitTypeId() ) oCheckboxTank.display(true, true);
		else oCheckboxTank.display(false, true);
		oLabelTank.display();

		if (iProductionUnitTypeId==oUnitRef[1].getUnitTypeId() ) oCheckboxFighter.display(true, true);
		else oCheckboxFighter.display(false, true);
		oLabelFighter.display();

		if (iProductionUnitTypeId==oUnitRef[2].getUnitTypeId() ) oCheckboxBattleship.display(true, enabled);
		else oCheckboxBattleship.display(false, enabled);
		oLabelBattleship.display();

		if (iProductionUnitTypeId==oUnitRef[3].getUnitTypeId() ) oCheckboxBomber.display(true, true);
		else oCheckboxBomber.display(false, true);
		oLabelBomber.display();

		if (iProductionUnitTypeId==oUnitRef[4].getUnitTypeId() ) oCheckboxCarrier.display(true, enabled);
		else oCheckboxCarrier.display(false, enabled);
		oLabelCarrier.display();

		if (iProductionUnitTypeId==oUnitRef[5].getUnitTypeId() ) oCheckboxDestroyer.display(true, enabled);
		else oCheckboxDestroyer.display(false, enabled);
		oLabelDestroyer.display();

		if (iProductionUnitTypeId==oUnitRef[6].getUnitTypeId() ) oCheckboxTransport.display(true, enabled);
		else oCheckboxTransport.display(false, enabled);
		oLabelTransport.display();

		if (iProductionUnitTypeId==oUnitRef[7].getUnitTypeId() ) oCheckboxSubmarine.display(true, enabled);
		else oCheckboxSubmarine.display(false, enabled);
		oLabelSubmarine.display();
				
		
		oButtonSave.display();
			
		redraw();
		
	}	
	
	
	void handleEvent(int x_, int y_) {
	
		
		//bool result;
		
		//result = oCheckboxTank.isClicked(x_, y_);
		if ( oCheckboxTank.isClicked(x_, y_) ) { //println("debug: clicked Tank checkbox");
			iProductionUnitTypeId = oUnitRef[0].getUnitTypeId();
			oCityList.setCityProductionUnitTypeId(iCityListId, iProductionUnitTypeId);
			display();
		}
		
		//result = oCheckboxFighter.isClicked(x_, y_);
		if ( oCheckboxFighter.isClicked(x_, y_) ) { //println("debug: clicked Fighter checkbox");
			iProductionUnitTypeId = oUnitRef[1].getUnitTypeId();
			oCityList.setCityProductionUnitTypeId(iCityListId, iProductionUnitTypeId);
			display();
		}

		//result = oCheckboxBattleship.isClicked(x_, y_);
		if ( oCheckboxBattleship.isClicked(x_, y_) ) { //println("debug: clicked Battleship checkbox");
			iProductionUnitTypeId = oUnitRef[2].getUnitTypeId();
			oCityList.setCityProductionUnitTypeId(iCityListId, iProductionUnitTypeId);
			display();
		}

		//result = oCheckboxBomber.isClicked(x_, y_);
		if ( oCheckboxBomber.isClicked(x_, y_) ) { //println("debug: clicked Bomber checkbox");
			iProductionUnitTypeId = oUnitRef[3].getUnitTypeId();
			oCityList.setCityProductionUnitTypeId(iCityListId, iProductionUnitTypeId);
			display();
		}

		//result = oCheckboxCarrier.isClicked(x_, y_);
		if ( oCheckboxCarrier.isClicked(x_, y_) ) { //println("debug: clicked Carrier checkbox");
			iProductionUnitTypeId = oUnitRef[4].getUnitTypeId();
			oCityList.setCityProductionUnitTypeId(iCityListId, iProductionUnitTypeId);
			display();
		}

		//result = oCheckboxDestroyer.isClicked(x_, y_);
		if ( oCheckboxDestroyer.isClicked(x_, y_) ) { //println("debug: clicked Desroyer checkbox");
			iProductionUnitTypeId = oUnitRef[5].getUnitTypeId();
			oCityList.setCityProductionUnitTypeId(iCityListId, iProductionUnitTypeId);
			display();
		}

		//result = oCheckboxTransport.isClicked(x_, y_);
		if ( oCheckboxTransport.isClicked(x_, y_) ) { //println("debug: clicked Transport checkbox");
			iProductionUnitTypeId = oUnitRef[6].getUnitTypeId();
			oCityList.setCityProductionUnitTypeId(iCityListId, iProductionUnitTypeId);
			display();
		}
		
		//result = oCheckboxSubmarine.isClicked(x_, y_);
		if ( oCheckboxSubmarine.isClicked(x_, y_) ) { //println("debug: clicked Submarine checkbox");
			iProductionUnitTypeId = oUnitRef[7].getUnitTypeId();
			oCityList.setCityProductionUnitTypeId(iCityListId, iProductionUnitTypeId);
			display();
		}
		
		//result = oCheckboxFighter.isClicked(x_, y_);
		if ( oButtonSave.isClicked(x_, y_) ) {
			
			hide();
			bActive=false;
			GameState=4;
			//println("city production dialogue, button clicked");
		}

	}
	
}







/* ====================================================================================
   this dialogue displays a startup splash page.
*/
class cDialogueStartup extends cDialogue {


	cLabel oLabelPanelTitle;

	cCheckbox oCheckboxPlayer1Human;
	cCheckbox oCheckboxPlayer1Computer;
	cLabel oLabelPromptPlayer1Mode;

	cCheckbox oCheckboxMapSize1Small;
	cCheckbox oCheckboxMapSize2Large;
	cLabel oLabelPromptMapSize;

	cButton oButtonContinue;
	int iSpaceHeight;
		
	cDialogueStartup(int panelStartY_, int panelHeight_) {
		
		super(panelStartY_, panelHeight_);
		
		//println("in cDialogueStartup constructor......2 "+panelStartY+","+ panelHeight);
		
		iSpaceHeight=iStringTextSize+3;
		
		iLineNumber=1;
				
		oLabelPanelTitle = new cLabel(GAMETITLE+" "+GAMEVERSION, (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));  
		iLineNumber++;
		iLineNumber++;
		

		oLabelPromptPlayer1Mode = new cLabel("Player 1 Mode:", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));  
		iLineNumber++;

		oCheckboxPlayer1Human = new cCheckbox(1, "Human v ComputerAI", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));  
		iLineNumber++;

		oCheckboxPlayer1Computer = new cCheckbox(2, "ComputerAI v ComputerAI", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));  
		iLineNumber++;
		iLineNumber++;

			
		/*
		oLabelPromptMapSize = new cLabel("Game Scenario:", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));  
		iLineNumber++;

		oCheckboxMapSize1Small = new cCheckbox(1, "an innovated version, small map", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));  
		iLineNumber++;

		oCheckboxMapSize2Large = new cCheckbox(2, "classic, large map", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));  
		iLineNumber++;
		iLineNumber++;
		*/

		oButtonContinue = new cButton(999, "Continue", (panelStartX+iLeftTextIndent), (panelStartY+(iSpaceHeight*iLineNumber)) ); 
		
		//println("cDialogueStartup, button " +(panelStartX+iLeftTextIndent)+","+ (panelStartY+(iSpaceHeight*iLineNumber)) );

	}


	void show() {
		
		bActive=true;
				
		textSize(iStringTextSize);
				
		display();
	}
	
	private void display() {
	
		clear(255);
		noStroke();
		fill(150); 
		rect(panelStartX, panelStartY, panelWidth, panelHeight );
		
		
		//println("in cDialogueCityProduction.display() iProductionUnitTypeId="+iProductionUnitTypeId);
		
		//println("in cDialogueCityProduction.display() bIsPort="+bIsPort);

		oLabelPanelTitle.display();


		oLabelPromptPlayer1Mode.display();

		if (iPlayer1Mode==1 ) oCheckboxPlayer1Human.display(true, true);
		else oCheckboxPlayer1Human.display(false, true);

		if (iPlayer1Mode==2 ) oCheckboxPlayer1Computer.display(true, true);
		else oCheckboxPlayer1Computer.display(false, true);


		/*
		oLabelPromptMapSize.display();

		if (iMapSize==1 ) oCheckboxMapSize1Small.display(true, true);
		else oCheckboxMapSize1Small.display(false, true);

		if (iMapSize==2 ) oCheckboxMapSize2Large.display(true, true);
		else oCheckboxMapSize2Large.display(false, true);
		*/
		
		oButtonContinue.display();
			
		redraw();
		
	}	
	
	
	void handleEvent(int x_, int y_) {

		if ( oCheckboxPlayer1Human.isClicked(x_, y_) ) { //println("debug: clicked Player1Human checkbox");
			iPlayer1Mode = 1;
			oPlayer1.setIsAI(false);
			display();
		}
		
		if ( oCheckboxPlayer1Computer.isClicked(x_, y_) ) { //println("debug: clicked Player1Computer checkbox");
			iPlayer1Mode = 2;
			oPlayer1.setIsAI(true);
			display();
		}


		/*
		if ( oCheckboxMapSize1Small.isClicked(x_, y_) ) { //println("debug: clicked MapSize1Small checkbox");
			iMapSize = 1;
			display();
		}
		
		if ( oCheckboxMapSize2Large.isClicked(x_, y_) ) { //println("debug: clicked MapSize2Large checkbox");
			iMapSize = 2;
			display();
		}
		*/


		if ( oButtonContinue.isClicked(x_, y_) ) {
			
			hide();
			bActive=false;
			GameState=2;
			//println("startup dialogue, button clicked");
		}

	}
	
}







/* ====================================================================================
   this dialogue displays a Surrender page.
*/
class cDialogueSurrender extends cDialogue {


	cLabel oLabelPanelTitle;

	cButton oButtonYes;
	cButton oButtonNo;
	int iSpaceHeight;
		
	cDialogueSurrender(int panelStartY_, int panelHeight_) {
		
		super(panelStartY_, panelHeight_);
		
		//println("in cDialogueStartup constructor......2 "+panelStartY+","+ panelHeight);
		
		iSpaceHeight=iStringTextSize+3;
		
		iLineNumber=1;
				
		oLabelPanelTitle = new cLabel("General, will you accept my surrender?", (panelStartX+iLeftTextIndent), panelStartY+(iSpaceHeight*iLineNumber));  
		iLineNumber++;
		iLineNumber++;
		
		oButtonYes = new cButton(999, "Yes", (panelStartX+iLeftTextIndent), (panelStartY+(iSpaceHeight*iLineNumber)) ); 
		iLineNumber++;
		iLineNumber++;
		
		oButtonNo = new cButton(998, "No", (panelStartX+iLeftTextIndent), (panelStartY+(iSpaceHeight*iLineNumber)) ); 
		
		//println("cDialogueStartup, button " +(panelStartX+iLeftTextIndent)+","+ (panelStartY+(iSpaceHeight*iLineNumber)) );

	}


	void show() {
		
		bActive=true;
				
		textSize(iStringTextSize);
				
		display();
	}
	
	private void display() {
	
		clear(255);
		noStroke();
		fill(150); 
		rect(panelStartX, panelStartY, panelWidth, panelHeight );
		
		
		//println("in cDialogueCityProduction.display() iProductionUnitTypeId="+iProductionUnitTypeId);
		
		//println("in cDialogueCityProduction.display() bIsPort="+bIsPort);

		oLabelPanelTitle.display();

		oButtonYes.display();
		oButtonNo.display();
			
		redraw();
		
	}	
	
	
	void handleEvent(int x_, int y_) {

		if ( oButtonYes.isClicked(x_, y_) ) {
			
			hide();
			bActive=false;
			//GameState=99;
			//println("Surrender dialogue, yes button clicked");
			//println("Player 1 has won!");
			//println("Thank you for playing StratConClone!");
			//println("");
			oGameEngine.gameOver(1);
		}

		if ( oButtonNo.isClicked(x_, y_) ) {
			
			hide();
			bActive=false;
			GameState=4;
			//println("Surrender dialogue, no button clicked");
			println("Continue game.");
			println("");			
		}
		
	}
	
}


