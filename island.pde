
class cIsland {

	int iPlayerId;
	int P1CityCount;
	int P2CityCount;
	int UnoccupiedCityCount;

	int[] IslandUnitCountsP1 = new int[iNumberOfUnitTypes];
	int[] IslandUnitCountsP2 = new int[iNumberOfUnitTypes];

	cIsland(int iPlayerId_) {

		iPlayerId=iPlayerId_;
		P1CityCount=0;
		P2CityCount=0;
		UnoccupiedCityCount=0;

		// initialise player unit counts
		for (int i=0; i<iNumberOfUnitTypes; i++) { IslandUnitCountsP1[i]=0; IslandUnitCountsP1[i]=0; }
	}

	int getPlayerId() { return iPlayerId; }
	int setPlayerId(iPlayerId_) { iPlayerId=iPlayerId_; }

	int getPlayerCityCount(int iPlayerId_) { 
		if ( iPlayerId_ == 1 ) {
			//println("Island.getPlayerCityCount="+P1CityCount);
			return P1CityCount; 
		} else {
			//println("Island.getPlayerCityCount="+P2CityCount);
			return P2CityCount; 
		}
	}

	void setPlayerCityCount(int iPlayerId_, int value_) { 
		if ( iPlayerId_ == 1 ) {
			//println("Island.setPlayerCityCount="+value_);
			P1CityCount=value_;
		} else {
			//println("Island.setPlayerCityCount="+value_);
			P2CityCount=value_; 
		}
	}


	void decreaseUnoccupiedCityCount() { 
		if ( UnoccupiedCityCount >= 1 ) UnoccupiedCityCount=UnoccupiedCityCount-1;
	}

	void increaseUnoccupiedCityCount() { 
		//println("in Island.increaseUnoccupiedCityCount(), before update UnoccupiedCityCount="+UnoccupiedCityCount);
		UnoccupiedCityCount=UnoccupiedCityCount+1;
	}

	int getUnoccupiedCityCount() { return UnoccupiedCityCount; }


	string getStatus() {

		string strStatus="Available";

		switch( getPlayerId() ) {

			case 1: 
				strStatus="player 1";
				break;

			case 2: 
				strStatus="player 2";
				break;
		}

		return strStatus;
	}



	// ***********************************************************
	// ISLAND PLAYER 1 UNIT COUNTS
	// ***********************************************************

	void increaseIslandUnitTypeCountP1(int iUnitType_) { IslandUnitCountsP1[iUnitType_]=IslandUnitCountsP1[iUnitType_]+1; }
	void decreaseIslandUnitTypeCountP1(int iUnitType_) { IslandUnitCountsP1[iUnitType_]=IslandUnitCountsP1[iUnitType_]-1; }

	int getUnitTypeCountP1(int iUnitType_) { return IslandUnitCountsP1[iUnitType_]; }



	// ***********************************************************
	// ISLAND PLAYER 2 UNIT COUNTS
	// ***********************************************************

	void increaseIslandUnitTypeCountP2(int iUnitType_) { IslandUnitCountsP2[iUnitType_]=IslandUnitCountsP2[iUnitType_]+1; }
	void decreaseIslandUnitTypeCountP2(int iUnitType_) { IslandUnitCountsP2[iUnitType_]=IslandUnitCountsP2[iUnitType_]-1; }

	int getUnitTypeCountP2(int iUnitType_) { return IslandUnitCountsP2[iUnitType_]; }


}




