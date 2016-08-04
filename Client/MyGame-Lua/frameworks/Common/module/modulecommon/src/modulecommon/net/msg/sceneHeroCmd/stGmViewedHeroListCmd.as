package modulecommon.net.msg.sceneHeroCmd 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import modulecommon.scene.wu.WuProperty;
	public class stGmViewedHeroListCmd extends stSceneHeroCmd 
	{
		public var datas:Array;
		public function stGmViewedHeroListCmd() 
		{
			super();
			byParam = GM_PARA_VIEWED_HERO_LIST_USERCMD;
			datas = new Array();
		}
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var num:uint = byte.readUnsignedShort();
			var i:uint = 0;
			var obj:Object;
			var fData:t_HeroData;
			var list:Dictionary;
			var relationList:Vector.<ActiveHero>;
			var activeHero:ActiveHero;
			while (i < num)
			{
				obj = new Object();
				fData = new t_HeroData();
				fData.deserialize(byte);				

				list = t_ItemData.readWidthNum(byte, WuProperty.PROPTYPE_MAX);
				
				relationList = new Vector.<ActiveHero>();
				var j:int;
				for (j = 0; j < 4; j++)
				{				
					if (activeHero == null)
					{
						activeHero = new ActiveHero();
					}
					activeHero.id = byte.readUnsignedInt();
					activeHero.bOwned = byte.readBoolean();
					
					if (activeHero.id > 0)
					{
						relationList.push(activeHero);
						activeHero = null;
					}
					
				}
				obj.fData = fData;
				obj.list = list;
				obj.relationList = relationList;
				datas.push(obj);
				i++;
			}
		}
	}

}
/*const BYTE GM_PARA_VIEWED_HERO_LIST_USERCMD = 47;
    struct stGmViewedHeroListCmd : public stSceneHeroCmd
    {
        stGmViewedHeroListCmd()
        {
            byParam = GM_PARA_VIEWED_HERO_LIST_USERCMD;
            num = 0;
        }
        WORD num;
        struct{
            t_HeroData bdata;
            TypeValue vdata[PROPTYPE_MAX];
            stRelationHero relationHero[MAX_ACTIVE_HERO]; //MAX_ACTIVE_HERO = 4
        }data[0];

        WORD getSize() const
        {
            return sizeof(*this) + num*sizeof(data[0]);
        }
    };*/