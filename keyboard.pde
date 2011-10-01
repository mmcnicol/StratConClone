
/*
Author: matthew.mcnicol@gmail.com
Date: 02/SEP/2011
*/


void keyPressed() {
	if( key>='A' && key<='z' ) { 
	
	
		/*
		if(key <= 'Z') {
			keyIndex = key-'A';
		} else {
			keyIndex = key-'a';
		}
		*/
		
      
		//println("keyPressed() key=" + key );
		switch(key) {
		  case 78: 
		  case 110: 
		  case 'N': 
		  case 'n': 
			println("Skip"); // N
			oUnitList.selectedUnitSkip(1);
			break;
		  case 83: 
		  case 115:
		  case 'S': 
		  case 's': 		  
			println("Sleep"); // S
			oUnitList.selectedUnitSleep(1);
			break;
		  case 82: 
		  case 114:
		  case 'R': 
		  case 'r': 
			println("Random"); // R
			oUnitList.selectedUnitMoveAI(1);
			break;

		  case 'W': 
		  case 'w': 
			//println("Wake"); // W
			oGameEngine.setCommand(1);
			println("click on units to wake..."); 
			break;			

		  case 'M': 
		  case 'm': 
			//println("Move"); // W
			oGameEngine.setCommand(2);
			println("click on units to move..."); 
			break;	
		}
	}
}



