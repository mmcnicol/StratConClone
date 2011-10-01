
class cIslandList {

	ArrayList listIsland;

	cIslandList() {
		listIsland = new ArrayList();  // Create an empty ArrayList
	}

	void AddIsland(int intPlayerId_) {
		
		//if ( intPlayerId_ != 0 )
			//println("add city for player " + intPlayerId_ +" at row="+intCellRow_+" col="+ intCellCol_);
			
		listIsland.add( new cIsland(intPlayerId_) );  
	}
	

	int getCount() {
		return listIsland.size();
	}
	
}


