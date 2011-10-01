
class cPlayer {

	int iPlayerId;
	bool iIsAI;
	
	cPlayer(int iPlayerId_, bool isAI_) {
	
		//println("debug#1.1 isAI_="+isAI_);
		iPlayerId = iPlayerId_;
		iIsAI = isAI_;
		//println("debug#1.2");
	}

	void setIsAI(bool value_) { iIsAI=value_; }

	int getPlayerId() { return iPlayerId; }
	
	bool getIsAI() { 
		//println("debug#1.3 iIsAI="+iIsAI);
		return iIsAI; 
	}
	
}



