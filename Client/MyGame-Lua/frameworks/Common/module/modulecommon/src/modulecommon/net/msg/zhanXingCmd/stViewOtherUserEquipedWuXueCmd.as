package modulecommon.net.msg.zhanXingCmd 
{
	import flash.utils.ByteArray;
	import modulecommon.scene.zhanxing.T_Star;
	/**
	 * ...
	 * @author ...
	 */
	public class stViewOtherUserEquipedWuXueCmd extends stZhanXingCmd
	{
		public var m_list:Vector.<T_Star>;
		
		public function stViewOtherUserEquipedWuXueCmd() 
		{
			super();
			
			byParam = PARA_VIEW_OTHER_USER_EQUIPED_WUXUE_CMD;
			m_list = new Vector.<T_Star>();
		}
		
		override public function deserialize(byte:ByteArray):void 
		{
			super.deserialize(byte);
			
			var num:uint = byte.readUnsignedShort();
			var i:uint = 0;
			var star:T_Star;
			
			for (i = 0; i < num; i++)
			{
				star = new T_Star();
				star.deserialize(byte);
				m_list.push(star);
			}
		}
	}

}

/*
//观察他人装备的武学
    const BYTE PARA_VIEW_OTHER_USER_EQUIPED_WUXUE_CMD = 13; 
    struct stViewOtherUserEquipedWuXueCmd : public stZhanXingCmd
    {   
        stViewOtherUserEquipedWuXueCmd()
        {   
            byParam = PARA_VIEW_OTHER_USER_EQUIPED_WUXUE_CMD;
            num = 0;
        }   
        WORD  num;
        t_ShenBingData wxlist[0];
        WORD getSize()
        {   
            return (sizeof(*this) + num*sizeof(t_ShenBingData));
        }   
    };  
*/