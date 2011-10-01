
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
		bAnimate=true;
		iUnitListId=iUnitListId_;
		//iAnimateSwitch=0;
	}
	
	int getUnitListId() { return iUnitListId; }

	void clear() {
		bAnimate=false;
		iUnitListId=-1;	
	}
	
	
	void do() {
	
		//println("in animate.do() milis()="+millis() );
		
		iCurrentTime = millis();

  		// do not animate selected unit if:
  		// - no unit is currently selected
  		// - city production dialogue is active
  		// - sufficient time has not passed
		if ( bAnimate && iUnitListId!=-1 && oDialogueCityProduction.isActive()==false && iCurrentTime > iLastTime+300) {
		
			//println("bAnimate="+bAnimate+", iUnitListId="+iUnitListId+", iAnimateSwitch="+iAnimateSwitch);
			
			oUnitList.updateDisplay(iUnitListId, iAnimateSwitch);
			
			if ( iAnimateSwitch==0 ) iAnimateSwitch=1;
			else iAnimateSwitch=0;
			
			iLastTime = iCurrentTime;
			
			//println("bAnimate="+bAnimate+", iUnitListId="+iUnitListId+", iAnimateSwitch="+iAnimateSwitch);
		}
	}
	
  
}
