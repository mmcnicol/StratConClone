
class cPathfindingAstar extends cPathfinding {


	ArrayList listOpen;
	ArrayList listClosed;

	cPathfindingAstar(int intPlayerId_) {
		listOpen = new ArrayList();
		listClosed = new ArrayList();	
		oGrid.createValidMoveGrid(intPlayerId_);
		//if ( oGameEngine.getCurrentPlayerId()==1 ) oPanelMapMatrixValidMovesPlayer1.show();
		//if ( oGameEngine.getCurrentPlayerId()==2 ) oPanelMapMatrixValidMovesPlayer2.show();
	}



	/*
	//==========================================================================================
	void printListItem(sqlite3* db, int x, int y) {

	  int rows, columns, i, j, count, x2, y2, f2, g2, h2;

	    sprintln(strSQL1, "select f, g, h from listOpen where x=%d and y=%d; ", x, y);


	    //println("get cells which unit can move to... count=%d\n", rows);
	    //println("strSQL1=%s\n", strSQL1);

	    for (j = 0; j < rows; ++j) {
		f2 = atoi( resultTable[(j+1)*columns+0] );
		g2 = atoi( resultTable[(j+1)*columns+1] );
			h2 = atoi( resultTable[(j+1)*columns+2] );

			println(" current f=%d, g=%d, h=%d ", f2, g2, h2);
		}
	}
	*/



	void print_astar_steps() {

		//sprintln(strSQL1, "select x, y, parent_x, parent_y from listClosed; ");

		for (int i = 0; i < listClosed.size(); i=i+1) { 

			cAStarClosed temp = (cAStarClosed) listClosed.get(i);

			x1 = temp.x;
			y1 = temp.y;
			x2 = temp.parent_x;
			y2 = temp.parent_y;

			//draw_line( x2*CELL_WIDTH, y2*CELL_HEIGHT, x1*CELL_WIDTH, y1*CELL_HEIGHT, 255, 0, 0);

			//println(" %d,%d to %d,%d\n", x1, y1, x2, y2);
			println(" "+x1+","+y1+" to "+x2+","+y2+" ");

			//draw_line( x2*CELL_WIDTH, y2*CELL_HEIGHT, x1*CELL_WIDTH, y1*CELL_HEIGHT, 255, 0, 0);
			//draw_cell(x1, y1, 0, 0, 0, true);
			//fill(255);
			//line(x*cellWidth,y*cellHeight, x1*cellWidth,y1*cellHeight);
			//redraw();

		}
		//update_screen();

	}




	int listClosed_count_at(int x, int y) {

		int counter=0;

		for (int i = 0; i < listClosed.size(); i++) { 

			cAStarClosed temp = (cAStarClosed) listClosed.get(i);
			if ( temp.x==x && temp.y==y ) {

				counter=counter+1;	
			}
		}

		return counter;
	}

	int listOpen_count_at(int x, int y) {

		int counter=0;

		for (int i = 0; i < listOpen.size(); i++) { 

			cAStarOpen temp = (cAStarOpen) listOpen.get(i);
			if ( temp.x==x && temp.y==y ) {

				counter=counter+1;	
			}
		}

		return counter;
	}


	int listOpen_get_min_f() {

		int f=999;

		for (int i = 0; i < listOpen.size(); i=i+1) { 

			cAStarOpen temp = (cAStarOpen) listOpen.get(i);

			f = min(f,temp.f);
		}

		return f;
	}

	cAStarOpen listOpen_get_using_f(int f) {


		for (int i = 0; i < listOpen.size(); i=i+1) { 

			cAStarOpen temp = (cAStarOpen) listOpen.get(i);

			if ( temp.getF()==f) {
				//println("debug#C4");
				return temp;
			}
		}

		println("error: in listOpen_get_using_f, not found, f="+f);
		//return new cAStarOpen(1, 1, 2, 2, 3, 4, 5); 

	}



	void update_listOpen_if_better(int x, int y, int f, int g, int h) {

		//println("update listOpen set f="+f+", g="+g+", h="+h+" where x="+x+" and y="+y+" and f>"+f+"; ");

		for (int i = 0; i < listOpen.size(); i++) { 

			cAStarOpen temp = (cAStarOpen) listOpen.get(i);
			if ( temp.x==x && temp.y==y && temp.f>f ) {

				temp.f = f;
				temp.g = g;
				temp.h = h;			
			}
		}

		//println("   in update_listOpen_if_better(%d, %d) records affected=%d\n", x, y, sqlite3_changes(db) );

	}


	void add_listOpen(int x, int y, int parent_x, int parent_y, int g, int h) {

		int f=g+h;

		if ( x > 0 && y > 0 ) {
			//println("insert into listOpen ( x, y, parent_x, parent_y, f, g, h) values ("+x+", "+y+", "+parent_x+", "+parent_y+", "+f+", "+g+", "+h+" ); ");

			listOpen.add( new cAStarOpen(x, y, parent_x, parent_y, f, g, h) ); 

			//draw_cell(x, y, f, g, h, false);

		}
	}


	void add_listClosed(int x, int y, int parent_x, int parent_y, int g, int h) {

		int f=g+h;

		if ( x > 0 && y > 0 ) {
			//println("insert into listClosed ( x, y, parent_x, parent_y, f, g, h) values ("+x+", "+y+", "+parent_x+", "+parent_y+", "+f+", "+g+", "+h+" ); ");

			listClosed.add( new cAStarClosed(x, y, parent_x, parent_y, f, g, h) ); 

			//draw_cell(x, y, f, g, h, false);

		}
	}


	void update_listOpen(int x, int y, int parent_x, int parent_y, int g, int h) {

		int f=g+h;

		//sprintln(strSQL1, "update listOpen set parent_x=%d, parent_y=%d, f=%d, g=%d, h=%d where x=%d and y=%d; ", parent_x, parent_y, f, g, h, x, y);

		for (int i = 0; i < listOpen.size(); i++) { 

			cAStarOpen temp = (cAStarOpen) listOpen.get(i);
			if ( temp.x==x && temp.y==y ) {

				temp.parent_x = parent_x;
				temp.parent_y = parent_y;
				temp.f = f;	
				temp.g = g;
				temp.h = h;
			}
		}

		//println("   in add_astar_update() records affected=%d\n", sqlite3_changes(db) );
	}


	void delete_listOpen(int x, int y) {

		//sprintln(strSQL1, "delete from listOpen where x=%d and y=%d; ", x, y);

		for (int i = 0; i < listOpen.size(); i++) { 

			cAStarOpen temp = (cAStarOpen) listOpen.get(i);
			if ( temp.x==x && temp.y==y ) {

				listOpen.remove(i);
			}
		}

		//println("   in delete_listOpen(%d, %d) records affected=%d\n", x, y, sqlite3_changes(db) );
	}


	void listOpen_delete_all() {

		for (int i = 0; i < listOpen.size(); i++) { 

			cAStarOpen temp = (cAStarOpen) listOpen.get(i);
			listOpen.remove(i);
		}
	}

	void listClosed_delete_all() {

		for (int i = 0; i < listClosed.size(); i++) { 

			cAStarClosed temp = (cAStarClosed) listClosed.get(i);
			listClosed.remove(i);
		}
	}

	int get_astar_g_cost(int start_x, int start_y, int x, int y, int g) {

		// G is the movement cost to move from the starting point to the given square using
		// the path generated to get there.
		// In this example, we will assign a cost of 10 to each horizontal or vertical square moved,
		// and a cost of 14 for a diagonal move.
		// We use these numbers because the actual distance to move diagonally is the square root
		// of 2 (don't be scared), or roughly 1.414 times the cost of moving horizontally or vertically.
		// We use 10 and 14 for simplicity's sake.
		// The ratio is about right, and we avoid having to calculate square roots and we avoid decimals.
		// This isn't just because we are dumb and don't like math. Using whole numbers like these is a lot
		// faster for the computer, too. As you will soon find out, pathfinding can be very slow if you don't
		// use short cuts like these.

		if ( start_x==x && start_y!=y) return g+10;
		else if ( start_x!=x && start_y==y ) return g+10;
		else return g+14;

	}


	int get_astar_h_cost(int x, int y, int end_x, int end_y) {

		// H can be estimated in a variety of ways. The method we use here is called the Manhattan method,
		// where you calculate the total number of squares moved horizontally and vertically to reach the
		// target square from the current square, ignoring diagonal movement, and ignoring any obstacles
		// that may be in the way. We then multiply the total by 10, our cost for moving one square
		// horizontally or vertically. This is (probably) called the Manhattan method because it is like
		// calculating the number of city blocks from one place to another, where you can't cut across
		// the block diagonally.

		return ( abs(end_x-x) + abs(end_y-y) )  * 10;

	}


	int do_astar1(int intPlayerId, int start_x, int start_y, int end_x, int end_y, int x, int y, int parent_x, int parent_y, int g, int h, int cell_type) {

		// cell_type = moves_on
		// cell_type:
		// 0 = moves on Sea
		// 1 = moves on Land

		//// 2 c * If it is not walkable or if it is on the closed list, ignore it. Otherwise do the following.

		int rows, columns, i, j, count, x2, y2, g2, h2, new_g, new_h;

		//// TODO the algorithm should take into account player fog, so that it is not able to path find where the fog still exists for that player.

		//// TODO add if else re moves_on (cell_type) so that only valid cells are returned for valid moves_on
		////sprintln(strSQL1, "select colx, coly from grid where cell_type='%s' and colx>=%d and colx<=%d and coly>=%d and coly<=%d and colx!=%d and coly!=%d; ", cell_type, x-1, x+1, y-1, y+1, x, y);
		//sprintln(strSQL1, "select colx, coly from grid 
		//			where cell_type='%s' 
		//			and colx>=%d and colx<=%d 
		//			and coly>=%d and coly<=%d; ", 
		//			cell_type, x-1, x+1, y-1, y+1);

		//println("debug#D2, x="+x+", y="+y+"");
		int tempX=x-1,tempY=y-1;
		if (x-1<1) tempX=1;
		if (y-1<1) tempY=1;
		for (int i = tempX; i <= x+1; i++) { 
			for (int j = tempY; j <= y+1; j++) { 

				//println("debug#D3, cell_type="+cell_type);

				// 1 = default to valid move
				// 2 = valid move on land
				// 3 = valid move on sea
				// 4 = valid move on transport
				// 5 = valid move on carrier  

				if (i>=0 && j>=0)
				 //if ( oGrid.getGridCellType(i,j)==1 || 
				 //	(oGrid.getGridCellType(i,j)==0 && oUnitList.isPlayerSeaVesselAtRowCol(intPlayerId, i, j)==false) )
				  //if ( intGridCellType[i][j]==cell_type) {
				     //if ( oGrid.getGridCellType(i,j)==cell_type
				     if ( oGrid.getIsValidMove(i, j, cell_type)==true ) {
				   	//|| 
				   	//( cell_type==1 && oUnitList.isPlayerTransportAtRowCol(intPlayerId, i, j) ) // tank moving onto transport
				   	//) {

					x2=i;
					y2=j;

					//sprintln(strSQL2, "select count(*) from listClosed where x=%d and y=%d; ", x2, y2);
					//count = sql_stmt_get_value(db, strSQL2);
					//println("debug#D4.2");
					count = listClosed_count_at(x2, y2);

					//println("   in loop, x2,y2=%d,%d\n", x2, y2);


					// is not on the closed list
					if ( count==0 ) {

					    //println("   in loop, x2,y2=%d,%d cell is not on closed list.\n", x2, y2);

					    //// If it isn't on the open list, add it to the open list.
					    //// Make the current square the parent of this square.
					    //// Record the F, G, and H costs of the square.
					    //sprintln(strSQL3, "select count(*) from listOpen where x=%d and y=%d; ", x2, y2);
					    //count = sql_stmt_get_value(db, strSQL3);

					    count = listOpen_count_at(x2, y2);


					    if ( count==0 ) {
						//println("   in loop, x2,y2=%d,%d is not on open list, so add it to open list.\n", x2, y2);

						g2 = get_astar_g_cost(start_x, start_y, x2, y2, g);
						//println(" g2=%d", g2);

						h2 = get_astar_h_cost(x2, y2, end_x, end_y);

						//println(" h2=%d\n", h2);
						add_listOpen(x2, y2, x, y, g2, h2);



					    // * If it is on the open list already,
					    // check to see if this path to that square is better, using G cost as the measure.
					    // a lower G cost means that this is a better path.
					    // If so, change the parent of the square to the current square,
					    //      and recalculate the G and F scores of the square.
					    } else {
								//println("debug#D12");
								g2 = get_astar_g_cost(start_x, start_y, x2, y2, g);
								h2 = get_astar_h_cost(x2, y2, end_x, end_y);
								//println("   in loop, x2,y2=%d,%d is on the open list already... so update it?? ", x2, y2);
								//printListItem(db, x2,y2);
								//println("  new f=%d g=%d h=%d\n", g2+h2, g2, h2);
								//println("debug#D13");
								update_listOpen_if_better(x2, y2, g2+h2, g2, h2);
								//println("debug#D14");

					    }

					}



				}
			}
		}    




		//println("calling forceUpdateOfNearbyCells()\n");
		//forceUpdateOfNearbyCells(db, x, y, 2);
		//update_screen();
		//println("back from forceUpdateOfNearbyCells()\n");

	}


	cAStar get_astar_parent(int x, int y) {

		int counter=0, i, rows1, columns1, x1, y1, x2, y2;

		//sprintln(strSQL1, "select x, y, parent_x, parent_y from listClosed where x=%d and y=%d; ", x, y);

		for (int i = 0; i < listClosed.size(); i++) { 

			cAStarClosed temp = (cAStarClosed) listClosed.get(i);
			//println("...in get_astar_parent, x,y= "+x+","+y+"   tempx,y="+temp.x+","+temp.y);
			if ( temp.x==x && temp.y==y ) {

				x1 = temp.x;
				y1 = temp.y;
				x2 = temp.parent_x;
				y2 = temp.parent_y;

				//println("...... %d,%d to %d,%d\n", x1, y1, x2, y2);

				//struct astar next_step = {x1, y1, x2, y2};
				next_step = new cAStar(x1, y1, x2, y2);

				return next_step;
			}
		}
		println("error in get_astar_parent, no result found for "+x+","+y);
		next_step = new cAStar(-3, -3, -3, -3);
		return next_step;
	}




	cGridCell get_astar_next_step(int CurrentX, int CurrentY, int DestinationX, int DestinationY) {

		//println("in get_astar_next_step("+CurrentX+", "+CurrentY+", "+DestinationX+", "+DestinationY+")");

		//struct cell next_step = {0,0};
		next_step = new cGridCell(0,0);

		//struct astar step = {0,0,0,0};
		step = new cAStar(0,0,0,0);

		//step = get_astar_parent(db, DestinationX, DestinationY);
		step = get_astar_parent(DestinationX, DestinationY);

		//println(" step = "+step.x1+","+step.y1+" to "+step.x2+","+step.y2+" ");

		while ( 
			( step.x2!=CurrentX || step.y2!=CurrentY ) 
			&& (step.x2!=-3 && step.y2!=-3)
			) {

			//println("debugA3");
			step = get_astar_parent(step.x2, step.y2);
			//println(" step = "+step.x1+","+step.y1+" to "+step.x2+","+step.y2+" ");
		}


		next_step.x=step.x1;
		next_step.y=step.y1;
		
		return next_step;
	}




	//struct cell returnStepMoveTowardsDestination(sqlite3* db, int CurrentX, int CurrentY, int DestinationX, int DestinationY, const char *moves_on) {
	cGridCell returnStepMoveTowardsDestination(int intPlayerId, int CurrentX, int CurrentY, int DestinationX, int DestinationY, int moves_on) {

		//println("in returnStepMoveTowardsDestination from "+CurrentX+","+CurrentY+" to "+DestinationX+","+DestinationY);
		bool done=false;
		int count, x, y, parent_x, parent_y, g, h;
		//struct cell next_step = {1, 1};
		next_step = new cGridCell(-3,-3);

		//println("debug D1");

		cell_type = moves_on;

		////else "%"; // any... can move on land and sea (e.g. bomber)


		//// clear temp tables
		//sql_stmt(db, "delete from listOpen; ");
		//sql_stmt(db, "delete from listClosed; ");
		//listOpen_delete_all(); 
		//listClosed_delete_all(); 



		// 1. Add the starting square (or node) to the open list.
		g=0;
		h=0;
		//add_listOpen(db, CurrentX, CurrentY, CurrentX, CurrentY, g, h);
		//println("debug D2");
		add_listOpen(CurrentX, CurrentY, CurrentX, CurrentY, 0, 0, g, h);
		//println("debug D3");

		// 2 Repeat the following:


		// *************************************************************************//
		// begin: loop
		// *************************************************************************//

		temp = new cAStarOpen(0,0,0,0,0,0,1000);

		//println("debug D4");
		int counter=0;
		
		while( done==false ) {

			counter=counter+1;
			
			

			//println("debug#A4 in while loop, done="+done+", listOpen.size()="+listOpen.size() );
			//println("try to get lowest F cost from open list (LIMIT 1)...\n");

			// 2 a) Look for the lowest F cost square on the open list. We refer to this as the current square.
			//if (sqlite3_get_table(db, "select x, y, parent_x, parent_y, g, h from listOpen order by f LIMIT 1; ", &resultTable, &rows, &columns, &msgErro) != SQLITE_OK) {

			if ( listOpen_get_min_f()!=999 ) {
				cAStarOpen temp = (cAStarOpen) listOpen_get_using_f( listOpen_get_min_f() );
			}
			//println("try to get lowest F cost from open list (LIMIT 1)...count=%d\n", rows);

			//for (j = 0; j < rows; ++j) {

			x = temp.getX();
			y = temp.getY();
			parent_x = temp.getParentX();
			parent_y = temp.getParentY();
			g = temp.getG();
			h = temp.getH();


			// 2 b) Switch it to the closed list.
			//println(" got lowest F cost from open list "+x+","+y+"... switch it to the closed list");

			delete_listOpen(x, y);
			//add_listClosed(db, CurrentX, CurrentY, CurrentX, CurrentY, g, h);

			add_listClosed(x, y, parent_x, parent_y, g, h);
			//println(" added to closed %d,%d %d,%d\n", x, y, parent_x, parent_y);


			// 2 d) Stop when you: * Add the target square to the closed list, in which case the path has been found
			if ( x==DestinationX && y==DestinationY ) {
				//println("stop when you add the target cell to the closed list. path has been found\n");
				//println("contents of closed table:\n");
				//////////////print_astar_steps();


				//println("wait for 3 seconds...\n");
				//wait(3000);


				//println("try to retreive next step...");
				next_step = get_astar_next_step(CurrentX, CurrentY, DestinationX, DestinationY);

				if (next_step.x!=-3 && next_step.y!=-3) {
					//println("next step calculated as "+next_step.x+","+next_step.y+"\n");

					return next_step;
				}
				//exit(1);
			}


			// c) For each of the 8 squares adjacent to this current square...
			do_astar1(intPlayerId, CurrentX, CurrentY, DestinationX, DestinationY, x, y, parent_x, parent_y, g, h, cell_type);

			//draw_line( x*CELL_WIDTH, y*CELL_HEIGHT, parent_x*CELL_WIDTH, parent_y*CELL_HEIGHT, 255, 0, 0);
			//update_screen();
			//draw_cell(x, y, f, g, h, false);




			//// 2 d) Stop when you: Fail to find the target square, and the open list is empty. In this case, there is no path.
			//count = sql_stmt_get_value(db, "select count(*) from listOpen; ");

			count = listOpen.size();

			
			if ( count==0 || counter>60) {
				//println("stop when the open list is empty. there is no path...\n");
				next_step.x=-3;
				next_step.y=-3;
				done=true;
			}

		// *************************************************************************//
		// end: loop
		// *************************************************************************//

		}

		return next_step;
	}

}




class cAStar {

	int x1,y1, x2,y2;

	cAStar(int x1_,int y1_, int x2_,int y2_) {
		x1=x1_;
		y1=y1_;
		x2=x2_;
		y2=y2_;
	}
}


class cAStarClosed {

	int x,y, parent_x,parent_y;

	cAStarClosed(int x_, int y_, int parent_x_, int parent_y_, int f_, int g_, int h_) {
		x=x_;
		y=y_;
		parent_x=parent_x_;
		parent_y=parent_y_;
		f=f_;
		g=g_;
		h=h_;
	}
	int getX() { return x; }
	int getY() { return y; }	
}


class cAStarOpen {

	int x,y, parent_x, parent_y, f,j,h;

	cAStarOpen(int x_, int y_, int parent_x_, int parent_y_, int f_, int g_, int h_) {
		x=x_;
		y=y_;
		parent_x=parent_x_;
		parent_y=parent_y_;
		f=f_;
		g=g_;
		h=h_;
	}
	int getX() { return x; }
	int getY() { return y; }

	int getParentX() { return parent_x; }
	int getParentY() { return parent_y; }

	int getF() { return f; }
	int getG() { return g; }
	int getH() { return h; }
}

