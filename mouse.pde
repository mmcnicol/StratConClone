
int clickStartX=-1;
int clickStartY=-1;
bool mousePrsd=false;


void mouseMoved() {
	//oPanel1.displayMouseXY();
}

void mousePressed() {
	//println("mousePressed() mouseX=" + mouseX + ", mouseY=" + mouseY );
	clickStartX=mouseX;
	clickStartY=mouseY;
	mousePrsd=true;
}


void mouseReleased() {

	oGeometry.distanceDragEnd();

	if (debugMouseClick) println("");
	if (debugMouseClick) println("debug: mouseReleased() mouseX=" + mouseX + ", mouseY=" + mouseY );
	
	if( mousePrsd ) {

		mousePrsd=false;

		if ( oDialogueStartup.isActive() ) {
			oDialogueStartup.handleEvent(mouseX, mouseY);
			
		} else if ( GameState>2 && oDialogueCityProduction.isActive() ) {
			oDialogueCityProduction.handleEvent(mouseX, mouseY);

			
		} else if ( oDialogueSurrender.isActive() ) {
			oDialogueSurrender.handleEvent(mouseX, mouseY);
		
			
		//} else if ( cPanelSelectedCity.isActive() ) {
		//	oPanelSelectedCity.handleEvent(mouseX, mouseY);
		
		// prevent human player 1 moving units when computer player 2 is moving
		} else if ( GameState==4 && oGameEngine.getCurrentPlayerId()==1 ) {


			//if ( cPanelSelectedCity.isActive() ) 
			oPanelSelectedCity.handleEvent(mouseX, mouseY);
			
			if (debugMouseClick) println("debug: oPlayer1.getShowFromCellX()="+oPlayer1.getShowFromCellX());
			if (debugMouseClick) println("debug: oPlayer1.getShowFromCellY()="+oPlayer1.getShowFromCellY());

			int tempX=oPlayer1.getShowFromCellX()-1+int(floor( (clickStartX+(cellWidth-1)-220 ) /cellWidth));
			int tempY=oPlayer1.getShowFromCellY()-1+int(floor( (clickStartY+(cellHeight-1) ) /cellHeight));

			if (debugMouseClick) println("debug: mouse click at cell "+tempX+","+tempY+"");

			if (mouseX==clickStartX && mouseY==clickStartY) {
			
				if (debugMouseClick) println("debug: mouse click, release location same location as press");
				
				if ( oVScrollBar.isClicked(clickStartX, clickStartY) ) {
					//println("clicked VScrollBar");
					oVScrollBar.handleClick(clickStartX, clickStartY);
					
				} else if ( oHScrollBar.isClicked(clickStartX, clickStartY) ) {
					//println("clicked HScrollBar");
					oHScrollBar.handleClick(clickStartX, clickStartY);
				
				} else {

					// ********************************************
					// did user click on a city?
					
					if (debugMouseClick) println("debug: did user click on a city?");

					int iCityListId = oCityList.getCityId(tempX, tempY);

					if (debugMouseClick) println("debug: ...iCityListId="+iCityListId);

					if (iCityListId>=0) {
					
						oCityList.updateSelectedCityPanelInformation(iCityListId);
						oGameEngine.setSelectedCityListId(iCityListId);
						
					}
					
					
					
					
					// ********************************************
					// or did user click on a unit?
					
					if (debugMouseClick) println("debug: did user click on a unit? at "+tempX+","+tempY);
					
					int iUnitCount = oUnitList.getCountOfPlayerUnitsAt(1, tempX, tempY);
					
					if (debugMouseClick) println("debug: ...iUnitCount="+iUnitCount);

					if( iUnitCount>0 ) { // user has clicked on a unit

						if (debugMouseClick) println("debug: yes");
						if (debugMouseClick) println("debug: human unit number at "+clickStartX+","+clickStartY);

						if (debugMouseClick) println("debug: oGameEngine.getCommand()= "+oGameEngine.getCommand() );
						
						switch( oGameEngine.getCommand() ) {

							case 1: // wake
								
								//oUnitList.commandWakePlayerUnitsAt(1, targetCellX, targetCellY);
								oUnitList.commandWakePlayerUnitsAt(1, tempX, tempY);
								break;

						} 
					}					
					
				}

			}  else {
			
				// ********************************************
				// or did user click & drag on a unit?
				
				
				//if (debugMouseClick) println("debug: did user click & drag on a unit? ("+clickStartX+","+clickStartY+")");
				if (debugMouseClick) println("debug: did user click & drag on a unit?  ("+tempX+", "+tempY+")");
				//if (debugMouseClick) println("debug: target tempX="+tempX+", tempY="+tempY);

				//oCityList.printHumanCityLocations();
				//oUnitList.printHumanUnitLocations();

				//int temp = oUnitList.getPlayerUnitNumberAtXY(1,clickStartX, clickStartY);

				int intUnitListId = oUnitList.getPlayerUnitNumberAtRowCol(1, tempX, tempY);
				
				if (debugMouseClick) println("debug: intUnitListId="+intUnitListId);
				
				if( intUnitListId>-1 ) { // user has clicked on a unit
				
					if (debugMouseClick) println("debug: human unit number at ("+clickStartX+","+clickStartY+")="+intUnitListId);
				
					int targetCellX=oPlayer1.getShowFromCellX()-1+int(floor( (mouseX+(cellWidth-1)-220 )/cellWidth));
					int targetCellY=oPlayer1.getShowFromCellY()-1+int(floor((mouseY+(cellHeight-1))/cellHeight));
					
					if ( targetCellX<oGrid.getCellCountX()+1 && targetCellY<oGrid.getCellCountY()+1 ) {

						switch( oGameEngine.getCommand() ) {
							
							case 2: // move stack
								println("move stack");
								oUnitList.commandMovePlayerUnitsAt(1, tempX, tempY, targetCellX, targetCellY);
								break;
							
							default:							
								//println("debug B moving to row="+targetCellX+", col="+targetCellY);
								oUnitList.moveTo(intUnitListId, targetCellX, targetCellY);
								break;
						} 
					}
				}
				
		
			
			}

		}
		
		clickStartX=-1;
		clickStartY=-1;
	}
}


void mouseDragged() {
	//println("mouseDragged() mouseX=" + mouseX + ", mouseY=" + mouseY );
	if (mousePrsd==false) {
		mousePrsd=true;
		//clickStartX=mouseX;
		//clickStartY=mouseY;
	} else {
		if( clickStartX>-1 && clickStartY>-1 ) {
			//line(clickStartX, clickStartY, mouseX, mouseY);
		}
	}

	oGeometry.distanceDragBegin(clickStartX, clickStartY, mouseX, mouseY);
}



