
class cAnimate {


	bool bAnimate;
	int iUnitListId;
	int iAnimateSwitch;
	int iLastTime, iCurrentTime;
	
	cAnimate() {
		bAnimate = false;
		iUnitListId = -1;
		iAnimateSwitch = 0;
		iLastTime = 0;
	}
	
	
	void set(int iUnitListId_) {

		if (debugAnimate) println("debug: in animate.set("+iUnitListId_+")");
		bAnimate=true;
		iUnitListId=iUnitListId_;
		iAnimateSwitch=0;
	}
	
	int getUnitListId() { return iUnitListId; }

	void setAnimationInProgress(bool value_) { bAnimate=value_; }
	bool getAnimationInProgress() { return bAnimate; }


	void clear() {
		if (debugAnimate) println("debug: in animate.clear()");

		if ( bAnimate ) {
			iAnimateSwitch=0;
			oUnitList.updateDisplay(iUnitListId, iAnimateSwitch);
			bAnimate=false;
			iUnitListId=-1;	
		}
	}
	
	
	void do() {

		//if (debugAnimate) println("debug: in animate.do() milis()="+millis() );
		
		iCurrentTime = millis();

  		// do not animate selected unit if:
  		// - no unit is currently selected
  		// - city production dialogue is active
  		// - sufficient time has not passed
		if ( bAnimate && iUnitListId!=-1 && oDialogueCityProduction.isActive()==false && iCurrentTime > iLastTime+300) {
		
			//if (debugAnimate) println("debug: bAnimate="+bAnimate+", iUnitListId="+iUnitListId+", iAnimateSwitch="+iAnimateSwitch);
			
			oUnitList.updateDisplay(iUnitListId, iAnimateSwitch);
			
			if ( iAnimateSwitch==0 ) iAnimateSwitch=1;
			else iAnimateSwitch=0;
			
			//if (debugAnimate) println("debug: in animate.do() iAnimateSwitch="+iAnimateSwitch );

			iLastTime = iCurrentTime;
			
			//println("bAnimate="+bAnimate+", iUnitListId="+iUnitListId+", iAnimateSwitch="+iAnimateSwitch);
		}
	
	}
	
  
}





class cAnimateAttack extends cAnimate {
	
	int counter;
	bool AttackAnimationInProgress;
	int AttackType;
	int AttackerObjectListId;
	int DefenderObjectX;
	int DefenderObjectY;

	cAnimateAttack() {
		super();
		counter=0;
		setAttackAnimationInProgress(false);
		setAttackType(-1); // 1=city, 2=unit
		setAttackerObjectListId(-1);
		setDefenderObjectX(-1);
		setDefenderObjectY(-1);
	}


	void set(int iUnitListId_) {

		if (debugAnimateAttack) println("debug: in animate.set("+iUnitListId_+")");
		setAttackerObjectListId(iUnitListId_);
		setAttackAnimationInProgress(true);
		counter=0;
		if (debugAnimateAttack) println("debug: leaving animate.set("+iUnitListId_+")");
	}
	

	void clear() {

		//debug();
		if (debugAnimateAttack) println("debug: in animate.clear()");
				
		if ( AttackAnimationInProgress ) { 

			if ( getAttackType()==1 ) { // city
				
				if (debugAnimateAttack) println("debug: in animate.clear() calling attack city... ");
				//unit.doAttackEnemyCity(getAttackerObjectListId(), getDefenderObjectX(), getDefenderObjectY() );
				oUnitList.doAttackEnemyCity(getAttackerObjectListId(), getDefenderObjectX(), getDefenderObjectY() );
				if (debugAnimateAttack) println("debug: in animate.clear() done calling attack city... ");

			} else if ( getAttackType()==2 ) { // unit
				
				if (debugAnimateAttack) println("debug: in animate.clear() calling attack city... ");
				//unit.doAttackEnemyCity(getAttackerObjectListId(), getDefenderObjectX(), getDefenderObjectY() );
				oUnitList.doAttackEnemyUnit(getAttackerObjectListId(), getDefenderObjectX(), getDefenderObjectY() );
				if (debugAnimateAttack) println("debug: in animate.clear() done calling attack city... ");
			}

			counter=0;
			setAttackAnimationInProgress(false);
			iAnimateSwitch=0;
			//oUnitList.updateDisplay(getAttackerObjectListId(), iAnimateSwitch);
			setAttackType(-1);
			setAttackerObjectListId(-1);
			setDefenderObjectX(-1);
			setDefenderObjectY(-1);

			oViewport.draw();
			if (debugShowPlayer2Viewport) oViewportPlayer2.draw();

		}
	}


	void setAttackAnimationInProgress(bool value_) { AttackAnimationInProgress=value_; }
	bool getAttackAnimationInProgress() { return AttackAnimationInProgress; }

	void setAttackType(int value_) { AttackType=value_; }
	int getAttackType() { return AttackType; }

	void setAttackerObjectListId(int value_) { AttackerObjectListId=value_; }
	int getAttackerObjectListId() { return AttackerObjectListId; }

	void setDefenderObjectX(int value_) { DefenderObjectX=value_; }
	int getDefenderObjectX() { return DefenderObjectX; }

	void setDefenderObjectY(int value_) { DefenderObjectY=value_; }
	int getDefenderObjectY() { return DefenderObjectY; }

	void debug() {
		println("debug: getAttackType()="+getAttackType() );
		println("debug: getAttackerObjectListId()="+getAttackerObjectListId() );
		println("debug: getDefenderObjectX()="+getDefenderObjectX() );
		println("debug: getDefenderObjectY()="+getDefenderObjectY() );
	}

	void do() {

		iCurrentTime = millis();

		if ( getAttackAnimationInProgress() && oDialogueCityProduction.isActive()==false && iCurrentTime > iLastTime+100) {
		
			if (debugAnimateAttack) println("debug: iAnimateSwitch="+iAnimateSwitch+", counter="+counter);
			
			oUnitList.updateDisplay(getAttackerObjectListId(), iAnimateSwitch);
			counter=counter+1;

			if ( iAnimateSwitch==0 ) iAnimateSwitch=1;
			else iAnimateSwitch=0;
			
			iLastTime = iCurrentTime;
		}

		if ( oDialogueCityProduction.isActive()==false && counter==6 ) {
			if (debugAnimateAttack) println("debug: calling clear()");
			clear();
		}
	}
	
  
}
