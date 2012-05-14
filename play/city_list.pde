
class cCityList {

	ArrayList listCity;

	cCityList() {
		listCity = new ArrayList();  // Create an empty ArrayList
	}

	void AddCity(int intPlayerId_, int intCellRow_, int intCellCol_, int iCityIslandListId_) {
		
		//if ( intPlayerId_ != 0 )
			//println("add city for player " + intPlayerId_ +" at row="+intCellRow_+" col="+ intCellCol_);
			
		if (debugCityAdd) println("  debug: in cCityList.AddCity(), iCityIslandListId_ = " + iCityIslandListId_ );

		listCity.add( new cCity(intPlayerId_, intCellRow_, intCellCol_, iCityIslandListId_) );  
		//if ( intPlayerId_ != 0 ) oIslandList.setPlayerId(iCityIslandListId_, intPlayerId_);

		//println("in cCityList, AddCity for player id="+intPlayerId_);

		//if ( intPlayerId_ == -1 ) oIslandList.increaseUnoccupiedCityCount(iCityIslandListId_);
	}
	
	
	void printHumanCityLocations() {
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityPlayerId()==1 ) city.printRowCol();
		}  
	}

	void printIslandCityLocations() {
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			println("city "+city.getCellX()+","+city.getCellY()+" PlayerId="+city.getCityPlayerId()+", IslandId="+city.getCityIslandListId() );
		}  
	}

	int getCountIslandPlayerCity(int iIslandId_, int iPlayerId_) {
		
		int counter=0;
		
		//println("in cCityList.getCountIslandPlayerCity, island id=" + iIslandId_ + ", player id="+iPlayerId_); 

		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityIslandListId()==iIslandId_ && city.getCityPlayerId()==iPlayerId_ ) 
				counter=counter+1;

		}  
		//println("in cCityList.getCountIslandPlayerCity, counter="+counter); 

		return counter;	
	}

	void printIslandCityLocationsToPanelCityList() {

		string strCityId="";
		string strStatus="";
		string strLocation="";
		string strIslandId="";
		string strIsPort="";
		string strCurrentProduction="";

		for (int i = 0; i < listCity.size() && i < 80; i++) { 

			cCity city = (cCity) listCity.get(i);
			strCityId = " " + LPAD(""+i,4);
			strStatus = RPAD(""+city.getStatus(),10);	
			strLocation = LPAD(""+city.getCellX(),4) + "," + RPAD(""+city.getCellY(),3);
			strIslandId = "     " + LPAD(""+city.getCityIslandListId(),3);
			strIsPort = RPAD(""+city.isPort(),6);
			strCurrentProduction = city.getProductionUnitTypeName();

			//oPanelCityList.addLine("IslandId="+city.getCityIslandListId() + ", PlayerId="+city.getCityPlayerId() + ", city "+city.getCellX()+","+city.getCellY() );
			//oPanelCityList.addLine("CityId=" + i + ", Status="+city.getStatus() + ", Location="+city.getCellX()+","+city.getCellY() + ", IslandId="+city.getCityIslandListId() );
			oPanelCityList.addLine(" " + strCityId + " | " + strStatus + " | " + strLocation + " | " + strIslandId + " | " + strIsPort + " | " + strCurrentProduction );
		}  
	}
	
	int getPlayerFirstCityListId(int iPlayerId_) {
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityPlayerId()==iPlayerId_ ) return i;
		}  
		return -1;
	}
	
	
	/*
	void printCount() {
		console.log( "city list size=" + listCity.size() );
	}
	*/

	int getCount() {
		//return listCity.size()-1;
		return listCity.size();
	}

	int getCountCityNearby(int intPlayerId_, int intRow_, int intCol_) {
	
		int TempCount=0;
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.isNearby(intRow_, intCol_)==true ) TempCount++;
		}  
		return TempCount;	
	}


	bool isCity(int cellRow_, int cellCol_) {

		//int TempCount=0;
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.isAt(cellRow_, cellCol_)==true ) return true;
		}  

		return false;	
	}


	bool isPort(int iCityListId_) {
	
		//println("in citylist.isPort() ");
		
		cCity city = (cCity) listCity.get(iCityListId_);
		return city.isPort();	
	}
	
	bool IslandHasPortCity(int IslandListId_) {

		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityIslandListId()==IslandListId_ && city.isPort()==true ) return true;
		}  
		return false;
	}

	int getRandomIslandCityId(int IslandListId_) {

		//println("in citylist.getRandomIslandCityId("+IslandListId_+") ");

		int i=0;
		int IslandCityCount=0;
		int randomIslandCitySeqNumber=0;

		for (i=0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityIslandListId()==IslandListId_ ) IslandCityCount=IslandCityCount+1;
		}  

		//println("IslandCityCount="+IslandCityCount);

		randomIslandCitySeqNumber=(int)random(0,IslandCityCount);

		for (i=0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityIslandListId()==IslandListId_ && randomIslandCitySeqNumber==i) return i;
		}  

		return -1;
	}

	int getCityId(int cellRow_, int cellCol_) {
	
		//println("in citylist.getCityId() ");
		//int TempCount=0;
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.isAt(cellRow_, cellCol_)==true ) return i;
		}  

		return -1;	
	}

	int getCityPlayerId(int iCityListId_) {

		cCity city = (cCity) listCity.get(iCityListId_);
		return city.getCityPlayerId();	
	}

	void setCityPlayerId(int iCityListId_, int iPlayerId_) {
	
		cCity city = (cCity) listCity.get(iCityListId_);

		oIslandList.setPlayerId(city.getCityIslandListId(), iPlayerId_);			
		oIslandList.updateIslandPlayerCityCount(city.getCityIslandListId(), city.getCityPlayerId(), iPlayerId_);

		city.setCityPlayerId(iPlayerId_);
		city.setProductionUnitTypeId(0);
	}

	string getCityLocation(int iCityListId_) {

		cCity city = (cCity) listCity.get(iCityListId_);
		return city.getLocation();	
	}

	void updateSelectedCityPanelInformation(int iCityListId_) {
		
		if (iCityListId_!=-1) {
			cCity city = (cCity) listCity.get(iCityListId_);

			int iCityPlayerId = city.getCityPlayerId();
			if (iCityPlayerId==1) {

				oPanelSelectedCity.show( city.getLocation(), city.getProductionUnitTypeName(), city.getProductionDaysLeft(), oUnitList.getCountOfPlayerUnitsAt(1, city.getCellX(), city.getCellY()) );

			}
		}
	}	
	

	void moveUnitToNearestCity(int iPlayerId_, int iUnitListId_, int cellX_, int cellY_, int iFuelLeft) {

		//println("in moveUnitToNearestCity() ");
		
		ArrayList possibleDestinationCity = new ArrayList();

		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if( city.getCityPlayerId()==iPlayerId_ && city.isWithin(iFuelLeft, cellX_, cellY_) ) {
				//println("adding possible destination to list ");
				possibleDestinationCity.add( new cGridCell(city.getCellX(), city.getCellY()) );
				//println("possibleDestinationCity.size()-1="+possibleDestinationCity.size()-1);
			}
		}  

		//println("possibleDestinationCity.size()-1="+possibleDestinationCity.size()-1);
		
		if( possibleDestinationCity.size()>0 ) {
			
			int possibleCityIndex = int( random(possibleDestinationCity.size()-1) );
			//println("unit AI move #2");
			cGridCell cell = (cGridCell) possibleDestinationCity.get(possibleCityIndex);
			//println("unit AI move #3");
			oUnitList.moveTo(iUnitListId_, cell.getX(), cell.getY() );
			//println("unit AI move #4");
		} else {
			println("note: unable to identify nearest city.");
			//setMovesLeftToday(0);
			oUnitList.moveTo(iUnitListId_, cellX_, cellY_ ); // stay where you are
		}	
	}

	// ******************************************************
	// BATTLE
	// ******************************************************

	bool isUnoccupiedCity(int cellRow_, int cellCol_) {

		//println("in citylist.isEnemyCity() ");
		
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityPlayerId()==-1 && city.isAt(cellRow_, cellCol_) ) return true;
		}  
		return false;	
	}
	
	bool isEnemyCity(int iPlayerId_, int cellRow_, int cellCol_) {

		//println("in citylist.isEnemyCity() ");
		
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityPlayerId()!=iPlayerId_ && city.isAt(cellRow_, cellCol_) ) return true;
			// removed: && city.getCityPlayerId()!=-1 
		}  
		return false;	
	}

	bool isEnemyOrUnoccupiedCity(int iPlayerId_, int cellRow_, int cellCol_) {

		//println("in citylist.isEnemyCity() ");
		
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( (city.getCityPlayerId()!=iPlayerId_ || city.getCityPlayerId()==-1) && city.isAt(cellRow_, cellCol_) ) return true;
		}  
		return false;	
	}

	void CityConquered(int iCityListId_, int iPlayerId_) {
	
		cCity city = (cCity) listCity.get(iCityListId_);

		oIslandList.updateIslandPlayerCityCount(city.getCityIslandListId(), city.getCityPlayerId(), iPlayerId_);
	
		city.setCityPlayerId(iPlayerId_);
		
		// continue building unit type, else 
		// game rule: default initial production to Tank (if city was unoccupied)
		if ( city.getProductionUnitTypeId()==-1 )
			city.setProductionUnitTypeId( oUnitRef[0].getUnitTypeId() );
		
		city.clearFogOfWar();
		
		city.Draw();
		
		if ( iPlayerId_==1 ) {
			if ( oPlayer1.getIsAI()==false ) {
				//oPanelSelectedCity.show( city.getLocation(), city.getProductionUnitTypeName(), city.getProductionDaysLeft(), oUnitList.getCountOfPlayerUnits(1, city.getCellX(), city.getCellY()) );
				//oDialogueCityProduction.show( iCityListId_ );

				println("in city.CityConquered() player="+iPlayerId_+" display city production dialogue...");
				oCityList.updateSelectedCityPanelInformation(iCityListId_);
				oGameEngine.setSelectedCityListId(iCityListId_);
				oDialogueCityProduction.show(iCityListId_);
			}
		}
	}
	

	void CityBombed(int iCityListId_) {
	
		cCity city = (cCity) listCity.get(iCityListId_);
		
		city.clearFogOfWar();
		
		city.setCityPlayerId(-1);
		city.setProductionUnitTypeId( -1 );
						
		city.Draw();	
	}
	
	
	
	// ******************************************************
	// DRAW
	// ******************************************************

	void Draw() {

		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			city.Draw();
		}  
	}

	void Draw(int cellRow_, int cellCol_) {

		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if( city.isAt(cellRow_, cellCol_)==true) {
				//console.log( "cCityList.Draw(row,col) found city to draw");
				city.Draw();
				//console.log( "cCityList.Draw(row,col) found city to draw. done.");
				break;
			}
		}  

	}

	void clearFogOfWar(int iCityListId_) {
		
		cCity city = (cCity) listCity.get(iCityListId_);
		city.clearFogOfWar();	
		if ( city.getCityPlayerId()==1 ) oViewport.scrollIfAppropriate(city.getCellX(), city.getCellY());
	}

	void clearFogOfWarByPlayerId(int iPlayerId_) {

		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if( city.getCityPlayerId()==iPlayerId_) {
				city.clearFogOfWar();	
			}
		}  
	}



	// ****************************************************************
	// GAVE OVER?
	// ****************************************************************

	int getCountPlayerCity(int iPlayerId_) {

		//println("in city_list.getCountPlayerCity() ");
		
		int counter=0;
		
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityPlayerId()==iPlayerId_ ) 
				counter=counter+1;

		}  
		//println("in city_list.getCountPlayerCityProducingUnit() counter="+counter);
		return counter;	
	}

	
	
	// ******************************************************
	// PRODUCTION
	// ******************************************************

	void setCityProductionUnitTypeId(int iCityListId_, int iProductionUnitTypeId_) {

		cCity city = (cCity) listCity.get(iCityListId_);
		return city.setProductionUnitTypeId(iProductionUnitTypeId_);	
	}

	
	int getCityProductionUnitTypeId(int iCityListId_) {

		cCity city = (cCity) listCity.get(iCityListId_);
		return city.getProductionUnitTypeId();	
	}
	
	void manageProduction() {

		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);

			city.manageProduction(i);
		}  
	}

	int getCountPlayerCityProducingUnit(int iPlayerId_, int iUnitTypeId_) {

		int counter=0;
		
		for (int i = 0; i < listCity.size(); i++) { 
			cCity city = (cCity) listCity.get(i);
			if ( city.getCityPlayerId()==iPlayerId_ && city.getProductionUnitTypeId()==iUnitTypeId_ ) 
				counter=counter+1;

		}  

		return counter;	
	}	
	
	
}


