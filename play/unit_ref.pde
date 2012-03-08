
class cUnitRef {

	int intUnitTypeId;
	string strUnitName;
	int daysToProduce;
	int strength;
	int attackRange;
	bool caputuresCity;
	bool movesOnLand;
	bool movesOnWater;
	int movesPerTurn;
	int maxFuel; // -1 = N/A

	cUnitRef(int intUnitTypeId_, string strUnitName_, int daysToProduce_, int strength_, int attackRange_, bool caputuresCity_, bool movesOnLand_, bool movesOnWater_, int movesPerTurn_, int maxFuel_) {
		intUnitTypeId = intUnitTypeId_;
		strUnitName = strUnitName_;
		daysToProduce = daysToProduce_;
		strength = strength_;
		attackRange = attackRange_;
		caputuresCity = caputuresCity_;
		movesOnLand = movesOnLand_;
		movesOnWater = movesOnWater_;
		movesPerTurn = movesPerTurn_;
		maxFuel = maxFuel_; 
	}

	void print() {
		println("unitTypeId=" + intUnitTypeId + 
			", unitName=" + strUnitName + 
			", daysToProduce=" + daysToProduce + 
			", strength=" + strength + 
			", attackRange=" + attackRange +
			", caputuresCity=" + caputuresCity +
			", movesOnLand=" + movesOnLand +
			", movesOnWater=" + movesOnWater +
			", movesPerTurn=" + movesPerTurn +
			", maxFuel=" + maxFuel
			);
	}
	
	int getUnitTypeId() { return intUnitTypeId; }
	string getUnitName() { return strUnitName; }
	int getDaysToProduce() { return daysToProduce; }
	int getStrength() { return strength; }
	int getAttackRange() { return attackRange; }
	bool getCaputuresCity() { return caputuresCity; }
	bool getMovesOnLand() { return movesOnLand; }
	bool getMovesOnWater() { return movesOnWater; }
	int getMovesPerTurn() { return movesPerTurn; }
	int getMaxFuel() { return maxFuel; }
	
	bool canFly() { 
		if( maxFuel==-1) return false; 
		else return true; 
	}
	
	
	int calculateBombBlastRadius() {
	
	
		//println(" in unitref.calculateBombBlastRadius() ");
		
		/*
		Initially, the Bombers have a radius of 0, and can thus only destroy one square. However, for Bombers started after day 50, the radius of the Bomber goes up to 1, meaning that the same bomb can now destroy 9 squares and everything in them. After day 100, Bombers will have radius 2, and will destroy a total of 25 squares. 
		*/
		
		//println("debug#1 ");
		int result=0;
		//println("debug#2 ");
		int iTargetDay=0;
		//println("debug#3 ");
		
		iTargetDay = iTargetDay + 20 + 50;
		//println("debug#4 ");
		if (oGameEngine.getDayNumber() > iTargetDay ) result++;
		//println("debug#5 ");
		
		iTargetDay = iTargetDay + 5 + 50;
		//println("debug#6 ");
		if (oGameEngine.getDayNumber() > iTargetDay ) result++;
		//println("debug#7 ");
		
		iTargetDay = iTargetDay + 5 + 50;
		if (oGameEngine.getDayNumber() > iTargetDay ) result++;
		
		iTargetDay = iTargetDay + 5 + 50;
		if (oGameEngine.getDayNumber() > iTargetDay ) result++;

		iTargetDay = iTargetDay + 5 + 50;
		if (oGameEngine.getDayNumber() > iTargetDay ) result++;
		
		iTargetDay = iTargetDay + 5 + 50;
		if (oGameEngine.getDayNumber() > iTargetDay ) result++;
		
		iTargetDay = iTargetDay + 5 + 50;
		if (oGameEngine.getDayNumber() > iTargetDay ) result++;
		
		iTargetDay = iTargetDay + 5 + 50;
		if (oGameEngine.getDayNumber() > iTargetDay ) result++;
		
		//println(" result="+result);
		
		return result;
	}	
}



