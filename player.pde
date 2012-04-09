
class cPlayer {

	int iPlayerId;
	bool iIsAI;
	int[] unitCounts = new int[iNumberOfUnitTypes];
	
	cPlayer(int iPlayerId_, bool isAI_) {
	
		//println("debug#1.1 isAI_="+isAI_);
		iPlayerId = iPlayerId_;
		iIsAI = isAI_;
		//println("debug#1.2");

		// initialise player unit counts
		for (int i=0; i<iNumberOfUnitTypes; i++) unitCounts[i]=0;
	}

	void setIsAI(bool value_) { iIsAI=value_; }

	int getPlayerId() { return iPlayerId; }
	
	bool getIsAI() { 
		//println("debug#1.3 iIsAI="+iIsAI);
		return iIsAI; 
	}
	
	void increaseUnitTypeCount(int iUnitType_, int iIslandListId_) { 

		unitCounts[iUnitType_]=unitCounts[iUnitType_]+1; 
		oIslandList.increaseIslandUnitTypeCount(iUnitType_, iIslandListId_, getPlayerId() );
	}

	void decreaseUnitTypeCount(int iUnitType_, int iIslandListId_) {  

		unitCounts[iUnitType_]=unitCounts[iUnitType_]-1; 
		oIslandList.decreaseIslandUnitTypeCount(iUnitType_, iIslandListId_, getPlayerId() );
	}

	int getUnitTypeCount(int iUnitType_) { return unitCounts[iUnitType_]; }

	void printUnitTypeCountsToPanel() {
		
		//println(" in cPlayer.printUnitTypeCountsToPanel()");

		string strUnitName="";
		string strUnitTypeCount="";

		for (int i = 0; i < iNumberOfUnitTypes; i++) { 
			
			strUnitName = LPAD(""+oUnitRef[i].getUnitName(),10);

			strUnitTypeCount=LPAD(""+getUnitTypeCount(i),5);
			
			if (iPlayerId==1) oPanelPlayer1UnitCounts.addLine("   " + strUnitName + " | " + strUnitTypeCount + " ");
			else if (iPlayerId==2) oPanelPlayer2UnitCounts.addLine("   " + strUnitName + " | " + strUnitTypeCount + " ");
		}   

		//println(" leaving cPlayer.printUnitTypeCountsToPanel()");

	}

}



