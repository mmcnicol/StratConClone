
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

	//println("mouseReleased() mouseX=" + mouseX + ", mouseY=" + mouseY );
	
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
			
			
			int tempX=oGrid.getShowFromCellX()-1+int(floor((clickStartX+(cellWidth-1))/cellWidth));
			int tempY=oGrid.getShowFromCellY()-1+int(floor((clickStartY+(cellHeight-1))/cellHeight));

			if (mouseX==clickStartX && mouseY==clickStartY) {
			
				//println("mouse click, release location same location as press "+tempX+","+tempY+"");
				
				if ( oVScrollBar.isClicked(clickStartX, clickStartY) ) {
					//println("clicked VScrollBar");
					oVScrollBar.handleClick(clickStartX, clickStartY);
					
				} else if ( oHScrollBar.isClicked(clickStartX, clickStartY) ) {
					//println("clicked HScrollBar");
					oHScrollBar.handleClick(clickStartX, clickStartY);
				
				} else {

					// ********************************************
					// did user click on a city?
					
					//println("did user click on a city?");

					int iCityListId = oCityList.getCityId(tempX, tempY);

					//println("...iCityListId="+iCityListId);

					if (iCityListId>=0) {
					
						oCityList.updateSelectedCityPanelInformation(iCityListId);
						oGameEngine.setSelectedCityListId(iCityListId);
						
					}
					
					
					
					
					// ********************************************
					// or did user click on a unit?
					
					//println("did user click on a unit? at "+tempX+","+tempY);
					
					int iUnitCount = oUnitList.getCountOfPlayerUnitsAt(1, tempX, tempY);
					
					//println("...iUnitCount="+iUnitCount);

					if( iUnitCount>0 ) { // user has clicked on a unit

						//println("yes");
						//println("human unit number at "+clickStartX+","+clickStartY);

						//int targetCellX=oGrid.getShowFromCellX()-1+int(floor((mouseX+15)/16));
						//int targetCellY=oGrid.getShowFromCellY()-1+int(floor((mouseY+15)/16));

						//println("oGameEngine.getCommand()= "+oGameEngine.getCommand() );
						
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
				
				
				//println("did user click & drag on a unit? ("+clickStartX+","+clickStartY+")");
				//println("target tempX="+tempX+", tempY="+tempY);

				//oCityList.printHumanCityLocations();
				//oUnitList.printHumanUnitLocations();

				//int temp = oUnitList.getPlayerUnitNumberAtXY(1,clickStartX, clickStartY);

				int intUnitListId = oUnitList.getPlayerUnitNumberAtRowCol(1, tempX, tempY);
				
				//println(" intUnitListId="+intUnitListId);
				
				if( intUnitListId>-1 ) { // user has clicked on a unit
				
					//println("human unit number at ("+clickStartX+","+clickStartY+")="+intUnitListId);
				
					int targetCellX=oGrid.getShowFromCellX()-1+int(floor((mouseX+(cellWidth-1))/cellWidth));
					int targetCellY=oGrid.getShowFromCellY()-1+int(floor((mouseY+(cellHeight-1))/cellHeight));
					
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



