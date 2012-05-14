
class cIslandList {

	ArrayList listIsland;

	cIslandList() {
		listIsland = new ArrayList();  // Create an empty ArrayList
	}

	void AddIsland(int intPlayerId_) {
		
		//if ( intPlayerId_ != 0 )
			//println("add island for player " + intPlayerId_ );
			
		listIsland.add( new cIsland(intPlayerId_) );  
	}
	
	void setPlayerId(int iIslandListId_, int intPlayerId_) {

		//println("in cIslandList.setPlayerId("+iIslandListId_+", "+intPlayerId_+")"); 

		if ( iIslandListId_ > 0 ) {
			cIsland island = (cIsland) listIsland.get( iIslandListId_ );
			island.setIslandPlayerId( intPlayerId_ );
		} 
	}

	int getPlayerId(int iIslandListId_) {

		//println("in cIslandList.getPlayerId("+iIslandListId_+")"); 

		int iReturnValue=-1;
		if ( iIslandListId_ > 0 ) {
			cIsland island = (cIsland) listIsland.get( iIslandListId_ );
			iReturnValue=island.getIslandPlayerId();
		}

		return iReturnValue;
	}



	void increaseUnoccupiedCityCount(int iIslandListId_) {

		if ( iIslandListId_ > 0 ) {
			cIsland island = (cIsland) listIsland.get( iIslandListId_ );
			island.increaseUnoccupiedCityCount();
		}
	}

	void updateIslandPlayerCityCount(int iIslandListId_, int intOldPlayerId_, int intNewPlayerId_) {

		//println("in cIslandList.updateIslandPlayerCityCount("+iIslandListId_+", "+intOldPlayerId_+", "+intNewPlayerId_+")"); 

		if ( iIslandListId_ > 0 ) {
			cIsland island = (cIsland) listIsland.get( iIslandListId_ );

			//println("debug#1"); 

			// if city was not unoccupied...
			if (intOldPlayerId_ != -1) {
				//println("debug#2"); 
				island.setPlayerCityCount( intOldPlayerId_, island.getPlayerCityCount(intOldPlayerId_)-1 );
			}

			//println("debug#3"); 
			island.setPlayerCityCount( intNewPlayerId_, island.getPlayerCityCount(intNewPlayerId_)+1 );

			island.decreaseUnoccupiedCityCount();
		}
	}

	int getCount() {
		return listIsland.size();
	}

	/*
	int getCountIslandPlayerCity(int iIslandId_, int iPlayerId_) {

		return oCityList.getCountIslandPlayerCity(iIslandId_, iPlayerId_);
	}
	*/



	void increaseIslandUnitTypeCount(int iUnitType_, int iIslandListId_, int iPlayerId_) { 

		if ( iIslandListId_ > 0 ) { 
			cIsland island = (cIsland) listIsland.get( iIslandListId_ ); 

			if ( iPlayerId_==1 ) island.increaseIslandUnitTypeCountP1(iUnitType_);
			else if ( iPlayerId_==2 ) island.increaseIslandUnitTypeCountP2(iUnitType_);
		}
	}


	void decreaseIslandUnitTypeCount(int iUnitType_, int iIslandListId_, int iPlayerId_) { 

		if ( iIslandListId_ > 0 ) {
			cIsland island = (cIsland) listIsland.get( iIslandListId_ ); 

			if ( iPlayerId_==1 ) island.decreaseIslandUnitTypeCountP1(iUnitType_);
			else if ( iPlayerId_==2 ) island.decreaseIslandUnitTypeCountP2(iUnitType_);
		}
	}


	int getIslandUnitTypeCount(int IslandListId_, int iPlayerId_, int iUnitType_) { 

		//cIsland island = (cIsland) listIsland.get( iIslandListId_ ); 

		//if ( iPlayerId_==1 ) return island.getUnitTypeCountP1(iUnitType_);
		//else if ( iPlayerId_==2 ) return island.getUnitTypeCountP2(iUnitType_);

		return 0;

	}



	void updateIslandStatus() {

		for (int i = 0; i < listIsland.size() && i < 50; i++) { 
			cIsland island = (cIsland) listIsland.get(i);

			if ( island.getPlayerCityCount(1)>0 || island.getPlayerCityCount(2)>0 ) {

				if ( island.getUnoccupiedCityCount()==0 ) {

					if ( island.getPlayerCityCount(1)>0 && island.getPlayerCityCount(2)==0 ) 
						island.setIslandPlayerId(1);
					else if ( island.getPlayerCityCount(2)>0 && island.getPlayerCityCount(1)==0  ) 
						island.setIslandPlayerId(2);
					else 
						island.setIslandPlayerId(-1);					
				}
					
			}
		}   

	}


	bool isEnemyOrUnoccupiedIsland(int iPlayerId_, int IslandListId_) {

		int enemyPlayerId=-1;

		if (iPlayerId_==1) enemyPlayerId=2;
		else enemyPlayerId=1;

		if ( IslandListId_ > 0 ) {

			cIsland island = (cIsland) listIsland.get(IslandListId_);

			if ( island.getIslandPlayerId()!=iPlayerId_ && 
					( 
						island.getUnoccupiedCityCount(iPlayerId_)>0 
						|| island.getPlayerCityCount(enemyPlayerId)>0 )  
					) {

				return true;
			}
		}

		return false;
	}


	void printIslandListToPanelIslandList() {
		
		string strIslandId="";
		string strStatus="";
		string strP1CityCount="";
		string strP2CityCount="";
		string strUnoccupiedCityCount="";

		for (int i = 0; i < listIsland.size() && i < 50; i++) { 
			cIsland island = (cIsland) listIsland.get(i);

			strIslandId = " "+LPAD(""+i,4);
			strStatus = RPAD(""+island.getStatus(),10);

			//strP1CityCount = RPAD(""+oCityList.getCountIslandPlayerCity(i,1),2);
			//strP2CityCount = RPAD(""+oCityList.getCountIslandPlayerCity(i,2),2);

			strP1CityCount = LPAD(""+island.getPlayerCityCount(1),6);
			strP2CityCount = LPAD(""+island.getPlayerCityCount(2),6);

			strUnoccupiedCityCount=LPAD(""+island.getUnoccupiedCityCount(),14);

			//oPanelIslandList.addLine("IslandId=" + i + ", PlayerId=" + island.getIslandPlayerId() );
			//oPanelIslandList.addLine("IslandId=" + i + ", Status=" + island.getStatus() );
			oPanelIslandList.addLine("   " + strIslandId + " | " + strStatus + " | " + strP1CityCount + " | " + strP2CityCount + " | " + strUnoccupiedCityCount );
		}   

	}

	
}


