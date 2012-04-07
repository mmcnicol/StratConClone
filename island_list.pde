
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
	
	void setPlayerId(iIslandListId_, intPlayerId_) {

		//println("in cIslandList.setPlayerId("+iIslandListId_+", "+intPlayerId_+")"); 
		cIsland island = (cIsland) listIsland.get( iIslandListId_ );
		island.setPlayerId( intPlayerId_ );
	}

	int getPlayerId(iIslandListId_) {

		//println("in cIslandList.getPlayerId("+iIslandListId_+")"); 

		cIsland island = (cIsland) listIsland.get( iIslandListId_ );
		return island.getPlayerId();
	}

	void increaseUnoccupiedCityCount(int iIslandListId_) {

		cIsland island = (cIsland) listIsland.get( iIslandListId_ );
		island.increaseUnoccupiedCityCount();
	}

	void updateIslandPlayerCityCount(int iIslandListId_, int intOldPlayerId_, int intNewPlayerId_) {

		//println("in cIslandList.updateIslandPlayerCityCount("+iIslandListId_+", "+intOldPlayerId_+", "+intNewPlayerId_+")"); 
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

	int getCount() {
		return listIsland.size();
	}

	/*
	int getCountIslandPlayerCity(int iIslandId_, int iPlayerId_) {

		return oCityList.getCountIslandPlayerCity(iIslandId_, iPlayerId_);
	}
	*/

	void updateIslandStatus() {

		for (int i = 0; i < listIsland.size() && i < 50; i++) { 
			cIsland island = (cIsland) listIsland.get(i);

			if ( island.getPlayerCityCount(1)>0 || island.getPlayerCityCount(2)>0 ) {

				if ( island.getUnoccupiedCityCount()==0 ) {

					if ( island.getPlayerCityCount(1)>0 && island.getPlayerCityCount(2)==0 ) 
						island.setPlayerId(1);
					else if ( island.getPlayerCityCount(2)>0 && island.getPlayerCityCount(1)==0  ) 
						island.setPlayerId(2);
					else 
						island.setPlayerId(-1);					
				}
					
			}
		}   

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

			//oPanelIslandList.addLine("IslandId=" + i + ", PlayerId=" + island.getPlayerId() );
			//oPanelIslandList.addLine("IslandId=" + i + ", Status=" + island.getStatus() );
			oPanelIslandList.addLine("   " + strIslandId + " | " + strStatus + " | " + strP1CityCount + " | " + strP2CityCount + " | " + strUnoccupiedCityCount );
		}   

	}

	
}


