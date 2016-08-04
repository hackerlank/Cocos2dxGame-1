// This is the default pathfind criteria
package org.ffilmation.engine.logicSolvers.pathfindSolver
{
	// Imports
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.datatypes.fCell;
	import org.ffilmation.engine.datatypes.fPoint3d;
	import org.ffilmation.engine.interfaces.fEnginePathfindCriteria;
	//import org.ffilmation.engine.logicSolvers.lineOfSightSolver.fLineOfSightSolver;
	import org.ffilmation.utils.mathUtils;
	
	/**
	 * This is the default pathfind criteria
	 * @private
	 */
	public class fDefaultPathfindCriteria implements fEnginePathfindCriteria
	{
		/**
		 * These costs are used when finding paths in the scene. You may want to adjust them to change how your characters move.
		 * The default values will force the path to avoid going up if possible, and go down as soon as possible. For a walking person,
		 * this will result in a more human behaviour */
		private static const COST_ORTHOGONAL:Number = 0.7;
		private static const COST_DIAGONAL:Number = 0.9;
		private static const COST_GOING_UP:Number = 2;
		private static const COST_GOING_DOWN:Number = -1.1;
		
		// Private properties
		private var scene:fScene; // Scene where we are searching
		private var withDiagonals:Boolean; // Diagonal movement is allowed ?
		private var origin:fPoint3d; // Origin of the search
		private var destiny:fPoint3d; // Destiny of our search
		private var originCell:fCell; // Origin of our search (cell)
		private var destinyCell:fCell; // Destiny of our search (cell)
		
		/**
		 * Constructor for the fDefaultPathfindCriteria class
		 *
		 * @param scene Scene where we want to search
		 * @param originx Origin point
		 * @param destinyx Destination point
		 *
		 * @private
		 */
		public function fDefaultPathfindCriteria(scene:fScene, origin:fPoint3d, destiny:fPoint3d, withDiagonals:Boolean = true)
		{
			this.scene = scene;
			this.origin = origin;
			this.destiny = destiny;
			this.withDiagonals = withDiagonals;
			this.originCell = scene.translateToCell(origin.x, origin.y, origin.z);
			this.destinyCell = scene.translateToCell(destiny.x, destiny.y, destiny.z);
		}
		
		/**
		 * This method return the origin point for this search
		 * @return The origin point
		 */
		public function getOrigin():fPoint3d
		{
			return this.origin;
		}
		
		/**
		 * This method return the destiny point for this search
		 * @return The destiny point
		 */
		public function getDestiny():fPoint3d
		{
			return this.destiny;
		}
		
		/**
		 * This method return the origin cell for this search
		 * @return The origin cell
		 */
		public function getOriginCell():fCell
		{
			return this.originCell;
		}
		
		/**
		 * This method return the destiny cell for this search
		 * @return The destiny cell
		 */
		public function getDestinyCell():fCell
		{
			return this.destinyCell;
		}
		
		/**
		 * Returns a n heuristic value for any cell in the scene. The engine works with cell precision: any point inside the same cell
		 * as the destination point has to be considered the destination point.
		 *
		 *	@param cell The cell for which we must calculate its heuristic
		 * @return The heuristic score for this cell. A value of 0 indicates that we reached our objective
		 */ 
		public function getHeuristic(cell:fCell):Number
		{
			return mathUtils.distance(cell.i, cell.j, this.destinyCell.i, this.destinyCell.j);
			// KBEN: 修改成有阻挡点的，不再支持 3d ，只支持 2d 的S    
			//if (fLineOfSightSolver.calculatePt2PtVisible(scene, cell.x, cell.y, cell.z, this.destinyCell.x, this.destinyCell.y, this.destinyCell.z))
			/*if (fLineOfSightSolver.calculatePt2PtVisible(scene, cell.x, cell.y, this.destinyCell.x, this.destinyCell.y))
			{
				//return mathUtils.distance3d(cell.i, cell.j, cell.k, this.destinyCell.i, this.destinyCell.j, this.destinyCell.k);
				return mathUtils.distance(cell.i, cell.j, this.destinyCell.i, this.destinyCell.j);
			}
			else	// 如果不可见就设置成最大值   
			{
				return Number.MAX_VALUE;
			}*/
		}
		
		/**
		 * Returns a weighed list of a cells's accessible neighbours. This method updates each cell in the returned list, setting
		 * its "cost" temporal property with the cost associated to move from the input cell into that cell.
		 *
		 * @return An array of fCells.
		 */
		public function getAccessibleFrom(cell:fCell):Array
		{
			var ret:Array = new Array;
			var next:fCell;
			var nextfir:fCell;
			var nextsnd:fCell;
			
			// Up ?
			// KBEN: 不判断碰撞，之判断阻挡点  
			//if (!cell.walls.up || !cell.walls.up._visible || !fCollisionSolver.testPointCollision(cell.x, cell.y, cell.z, cell.walls.up))
			next = this.scene.getCellAt(cell.i, cell.j - 1, cell.k);
			if(next && !next.stoppoint.isStop)
			{
				//next = this.scene.getCellAt(cell.i, cell.j - 1, cell.k);
				//if (next)
				//{
					next.cost = fDefaultPathfindCriteria.COST_ORTHOGONAL;
					ret[ret.length] = next;
				//}
			}
			// Down ?
			// KBEN: 不判断碰撞，之判断阻挡点  
			//if (!cell.walls.down || !cell.walls.down._visible || !fCollisionSolver.testPointCollision(cell.x, cell.y, cell.z, cell.walls.down))
			next = this.scene.getCellAt(cell.i, cell.j + 1, cell.k);
			if(next && !next.stoppoint.isStop)
			{
				//next = this.scene.getCellAt(cell.i, cell.j + 1, cell.k);
				//if (next)
				//{
					next.cost = fDefaultPathfindCriteria.COST_ORTHOGONAL;
					ret[ret.length] = next;
				//}
			}
			// Left ?
			// KBEN: 不判断碰撞，之判断阻挡点  
			//if (!cell.walls.left || !cell.walls.left._visible || !fCollisionSolver.testPointCollision(cell.x, cell.y, cell.z, cell.walls.left))
			next = this.scene.getCellAt(cell.i - 1, cell.j, cell.k);
			if(next && !next.stoppoint.isStop)
			{
				//next = this.scene.getCellAt(cell.i - 1, cell.j, cell.k);
				//if (next)
				//{
					next.cost = fDefaultPathfindCriteria.COST_ORTHOGONAL;
					ret[ret.length] = next;
				//}
			}
			// Right ?
			// KBEN: 不判断碰撞，之判断阻挡点  
			//if (!cell.walls.right || !cell.walls.right._visible || !fCollisionSolver.testPointCollision(cell.x, cell.y, cell.z, cell.walls.right))
			next = this.scene.getCellAt(cell.i + 1, cell.j, cell.k);
			if(next && !next.stoppoint.isStop)
			{
				//next = this.scene.getCellAt(cell.i + 1, cell.j, cell.k);
				//if (next)
				//{
					next.cost = fDefaultPathfindCriteria.COST_ORTHOGONAL;
					ret[ret.length] = next;
				//}
			}
			// Top ?
			// KBEN: 不判断碰撞，之判断阻挡点，只支持 2d ，不支持 3d   
			//if (!cell.walls.top || !cell.walls.top._visible || !fCollisionSolver.testPointCollision(cell.x, cell.y, cell.z, cell.walls.top))
			//next = this.scene.getCellAt(cell.i, cell.j, cell.k + 1);
			//if(next && !next.stoppoint.isStop)
			//{
				//next = this.scene.getCellAt(cell.i, cell.j, cell.k + 1);
				//if (next)
				//{
				//	next.cost = fDefaultPathfindCriteria.COST_GOING_UP;
				//	ret[ret.length] = next;
				//}
			//}
			// Bottom ?
			// KBEN: 不判断碰撞，之判断阻挡点  
			//if (!cell.walls.bottom || !cell.walls.bottom._visible || !fCollisionSolver.testPointCollision(cell.x, cell.y, cell.z, cell.walls.bottom))
			//next = this.scene.getCellAt(cell.i, cell.j, cell.k - 1);
			//if(next && !next.stoppoint.isStop)
			//{
				//next = this.scene.getCellAt(cell.i, cell.j, cell.k - 1);
				//if (next)
				//{
				//	next.cost = fDefaultPathfindCriteria.COST_GOING_DOWN;
				//	ret[ret.length] = next;
				//}
			//}
			
			// Diagonals ?
			if (this.withDiagonals)
			{
				
				// Up Right ?
				// KBEN: 不判断碰撞，之判断阻挡点  
				//if ((!cell.walls.right || !cell.walls.right._visible) && (!cell.walls.up || !cell.walls.up._visible))
				next = this.scene.getCellAt(cell.i + 1, cell.j - 1, cell.k);
				if(next && !next.stoppoint.isStop)
				{
					// 判断是不是被阻挡点隔断
					nextfir = this.scene.getCellAt(cell.i, cell.j - 1, cell.k);
					nextsnd = this.scene.getCellAt(cell.i + 1, cell.j, cell.k);
					if (!nextfir.stoppoint.isStop && !nextsnd.stoppoint.isStop)
					{
						//next = this.scene.getCellAt(cell.i + 1, cell.j - 1, cell.k);
						//if (next)
						//{
							next.cost = fDefaultPathfindCriteria.COST_DIAGONAL;
							ret[ret.length] = next;
						//}
					}
				}
				
				// Up Left ?
				// KBEN: 不判断碰撞，之判断阻挡点  
				//if ((!cell.walls.left || !cell.walls.left._visible) && (!cell.walls.up || !cell.walls.up._visible))
				next = this.scene.getCellAt(cell.i - 1, cell.j - 1, cell.k);
				if(next && !next.stoppoint.isStop)
				{
					// 判断是不是被阻挡点隔断
					nextfir = this.scene.getCellAt(cell.i, cell.j - 1, cell.k);
					nextsnd = this.scene.getCellAt(cell.i - 1, cell.j, cell.k);
					if (!nextfir.stoppoint.isStop && !nextsnd.stoppoint.isStop)
					{
						//next = this.scene.getCellAt(cell.i - 1, cell.j - 1, cell.k);
						//if (next)
						//{
							next.cost = fDefaultPathfindCriteria.COST_DIAGONAL;
							ret[ret.length] = next;
						//}
					}
				}
				
				// Down Right ?
				// KBEN: 不判断碰撞，之判断阻挡点  
				//if ((!cell.walls.right || !cell.walls.right._visible) && (!cell.walls.down || !cell.walls.down._visible))
				next = this.scene.getCellAt(cell.i + 1, cell.j + 1, cell.k);
				if(next && !next.stoppoint.isStop)
				{
					// 判断是不是被阻挡点隔断
					nextfir = this.scene.getCellAt(cell.i + 1, cell.j, cell.k);
					nextsnd = this.scene.getCellAt(cell.i, cell.j + 1, cell.k);
					if (!nextfir.stoppoint.isStop && !nextsnd.stoppoint.isStop)
					{
						//next = this.scene.getCellAt(cell.i + 1, cell.j + 1, cell.k);
						//if (next)
						//{
							next.cost = fDefaultPathfindCriteria.COST_DIAGONAL;
							ret[ret.length] = next;
						//}
					}
				}
				
				// Down Left ?
				// KBEN: 不判断碰撞，之判断阻挡点  
				//if ((!cell.walls.left || !cell.walls.left._visible) && (!cell.walls.down || !cell.walls.down._visible))
				next = this.scene.getCellAt(cell.i - 1, cell.j + 1, cell.k);
				if(next && !next.stoppoint.isStop)
				{
					// 判断是不是被阻挡点隔断
					nextfir = this.scene.getCellAt(cell.i - 1, cell.j, cell.k);
					nextsnd = this.scene.getCellAt(cell.i, cell.j + 1, cell.k);
					if (!nextfir.stoppoint.isStop && !nextsnd.stoppoint.isStop)
					{
						//next = this.scene.getCellAt(cell.i - 1, cell.j + 1, cell.k);
						//if (next)
						//{
							next.cost = fDefaultPathfindCriteria.COST_DIAGONAL;
							ret[ret.length] = next;
						//}
					}
				}
				
			}
			
			return ret;
		}
		
		// KBEN: 获取 scene 这个场景
		public function get fscene():fScene
		{
			return scene;
		}
	}
}