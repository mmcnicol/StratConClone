
class cPathfinding {

	cPathfinding() {
	
	}


	cGridCell getNextMove(int intPlayerId, int CurrentX, int CurrentY, int DestinationX, int DestinationY, int moves_on) {
	
		next_step = new cGridCell(-3,-3);
		
		if (CurrentX==DestinationX && CurrentY==DestinationY) {
			next_step.x=CurrentX;
			next_step.y=CurrentY;
			
		} else {
			oPathfindingAstar = new cPathfindingAstar();
			next_step = oPathfindingAstar.returnStepMoveTowardsDestination(intPlayerId, CurrentX, CurrentY, DestinationX, DestinationY, moves_on);
		}
		
		return next_step;
	}

}


