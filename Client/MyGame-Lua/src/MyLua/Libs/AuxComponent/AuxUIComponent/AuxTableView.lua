local M = GlobalNS.Class(GlobalNS.AuxWindow);
M.clsName = "AuxTableView";
GlobalNS[M.clsName] = M;

function M:ctor()
	self.mTableViewX = 0;
	self.mTableViewY = 0;
	
	self.mTableViewWidth = 500;
	self.mTableViewHeight = 500;
	
	self.mDirection = cc.SCROLLVIEW_DIRECTION_VERTICAL;
	self.mVordering = cc.TABLEVIEW_FILL_TOPDOWN;
	
	self.mCellItemTag = 1000;
	--使用 CocosStudio 制作 TableView Item 的时候， Layer 直属子节点一定不能是 Node，否则会导致添加到表中显示错乱
	self.mCellItemPath = "";
	self.mTableView = nil;
end

function M:dtor()
	
end

function M:init()
	self:createTableView();
end

function M:getNativeTableView()
	return self.mTableView;
end

function M:createTableView()
	self.mTableView = cc.TableView:create(cc.size(self.mTableViewWidth, self.mTableViewHeight));
	--类型是 cc.TableView, 不是 ccui.TableView
	--self.mTableView = cc.TableView:create();
	--self.mTableView:setContentSize(cc.size(self.mTableViewWidth, self.mTableViewHeight));
	self.mTableView:setDirection(self.mDirection);
	self.mTableView:setPosition(cc.p(self.mTableViewX, self.mTableViewY));
	self.mTableView:setDelegate();
	self.mTableView:setVerticalFillOrder(self.mVordering);
	self.mTableView.pThis = self;
	
	--[[
	self.mTableView:registerScriptHandler(M.onGlobalScrollViewDidScroll, cc.SCROLLVIEW_SCRIPT_SCROLL);
	self.mTableView:registerScriptHandler(M.onGlobalScrollViewDidZoom, cc.SCROLLVIEW_SCRIPT_ZOOM);
	self.mTableView:registerScriptHandler(M.onGlobalTableCellTouched, cc.TABLECELL_TOUCHED);
	self.mTableView:registerScriptHandler(M.onGlobalCellSizeForTable, cc.TABLECELL_SIZE_FOR_INDEX);
	self.mTableView:registerScriptHandler(M.onGlobalTableCellAtIndex, cc.TABLECELL_SIZE_AT_INDEX);
	self.mTableView:registerScriptHandler(M.onGlobalNumberOfCellsInTableView, cc.NUMBER_OF_CELLS_IN_TABLEVIEW);
	]]
	
	--[[
	--设置要使用 self，不要使用 M ，否则不会调用子类的函数
	local functor = nil;
	functor = handler(self, M.onScrollViewDidScroll);
	self.mTableView:registerScriptHandler(functor, cc.SCROLLVIEW_SCRIPT_SCROLL);
	
	functor = handler(self, M.onScrollViewDidZoom);
	self.mTableView:registerScriptHandler(functor, cc.SCROLLVIEW_SCRIPT_ZOOM);
	
	functor = handler(self, M.onTableCellTouched);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_TOUCHED);
	
	functor = handler(self, M.onCellSizeForTable);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_SIZE_FOR_INDEX);
	
	functor = handler(self, M.onTableCellAtIndex);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_SIZE_AT_INDEX);
	
	functor = handler(self, M.onNumberOfCellsInTableView);
	self.mTableView:registerScriptHandler(functor, cc.NUMBER_OF_CELLS_IN_TABLEVIEW);
	]]
	
	local functor = nil;
	functor = handler(self, self.onScrollViewDidScroll);
	self.mTableView:registerScriptHandler(functor, cc.SCROLLVIEW_SCRIPT_SCROLL);
	
	functor = handler(self, self.onScrollViewDidZoom);
	self.mTableView:registerScriptHandler(functor, cc.SCROLLVIEW_SCRIPT_ZOOM);
	
	functor = handler(self, self.onTableCellTouched);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_TOUCHED);
	
	functor = handler(self, self.onCellSizeForTable);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_SIZE_FOR_INDEX);
	
	functor = handler(self, self.onTableCellAtIndex);
	self.mTableView:registerScriptHandler(functor, cc.TABLECELL_SIZE_AT_INDEX);
	
	functor = handler(self, self.onNumberOfCellsInTableView);
	self.mTableView:registerScriptHandler(functor, cc.NUMBER_OF_CELLS_IN_TABLEVIEW);
end

--Self 接口
function M:onScrollViewDidScroll(tableView)
	
end

function M:onScrollViewDidZoom(tableView)
	
end

function M:onTableCellTouched(tableView, cell)
	
end

function M:onCellSizeForTable(tableView, cellIdx)
	return 500, 100;
end

function M:onTableCellAtIndex(tableView, cellIdx)
	local cell = tableView:dequeueCell();
	if(nil == cell) then
		cell = cc.TableViewCell:new();
	end
	
	local cellItem = cell:getChildByTag(1000);
	if(nil == cellItem) then
		local uiModule = require(self.mCellItemPath); 	--require "path"
		local uiNode = uiModule.create();
		cellItem = uiNode.root;
		cellItem:setTag(self.mCellItemTag);
		cell:addChild(cellItem);
	end

	return cell;
end

function M:onNumberOfCellsInTableView(tableView)
	return 1;
end

--[[
--非 Self 接口
function M.onGlobalScrollViewDidScroll(tableView)
	
end

function M.onGlobalScrollViewDidZoom(tableView)
	
end

function M.onGlobalTableCellTouched(tableView, cell)
	
end

function M.onGlobalCellSizeForTable(tableView, idx)
	return 500, 100;
end

function M.onGlobalTableCellAtIndex(tableView, idx)
	local this = tableView.pThis;
	local cell = this:getOrCreateCell(tableView);
	local listCell = this:getOrCreateCellItem(cell);
	
	return cell;
end

function M.onGlobalNumberOfCellsInTableView(tableView)
	return 1;
end
]]

--设置位置
function M:setPosition(posX, posY)
	if(nil ~= self.mTableView) then
		self.mTableViewX = posX;
		self.mTableViewY = posY;
		self.mTableView:setPosition(cc.p(self.mTableViewX, self.mTableViewY));
	end
end

--设置位置, animated:true 会设置位置会有动画，并且会判断是否超越边界，如果不做动画，就需要自己判断是否移动出界限
function M:setContentOffset(offset, animated)
	if(false == animated) then
		local minOffset = self.mTableView:minContainerOffset();
		local maxOffset = self.mTableView:maxContainerOffset();
		
		offset.x = GlobalNS.UtilApi.max(minOffset.x, GlobalNS.UtilApi.min(maxOffset.x, offset.x));
		offset.y = GlobalNS.UtilApi.max(minOffset.y, GlobalNS.UtilApi.min(maxOffset.y, offset.y));
	end
	
	self.mTableView:setContentOffset(offset, animated);
end

function M:getContentOffset()
	if(nil ~= self.mTableView) then
		return self.mTableView:getContentOffset();
	end
	
	return nil;
end

--注意 TableView 继承 Layer，而 Layer 设置是否 Swallow 的接口是 setSwallowsTouches ，不是 setSwallowTouches， 而 Listener 的接口是 setSwallowTouches
function M:setSwallowTouches(swallow)
	if(self.mTableView ~= nil) then
		self.mTableView:setSwallowsTouches(swallow);
	end
end

function M:setTouchEnabled(enabled)
	if(self.mTableView ~= nil) then
		self.mTableView:setTouchEnabled(enabled);
	end
end

function M:reloadData()
	if(self.mTableView ~= nil) then
		self.mTableView:reloadData();
	end
end

--重新加载数据，但是移动的偏移仍然保持不变
function M:reloadDataNoResetOffset()
	if(self.mTableView ~= nil) then
        --local isEmpty = self:onNumberOfCellsInTableView(self.mTableView);
        local isEmpty = self.mTableView:cellAtIndex(0) == nil;
		local offset = nil;
		if(not isEmpty) then
            offset = self.mTableView:getContentOffset();
		end
		
		self.mTableView:reloadData();
		
		if(not isEmpty) then
            self.mTableView:setContentOffset(offset);
		end
	end
end

function M:getOrCreateCell(tableView)
	local cell = tableView:dequeueCell();
	if(nil == cell) then
		cell = GlobalNS.UtilApi.createTableViewCell();
	end
	
	return cell;
end

function M:getOrCreateCellItem(cell)
	local cellItem = cell:getChildByTag(1000);
	if(nil == cellItem) then
		cellItem = GlobalNS.UtilApi.getAndLoadLuaRoot(self.mCellItemPath);
		cellItem:setTag(self.mCellItemTag);
		GlobalNS.UtilApi.addChild(cell, cellItem);
	end
	
	return cellItem;
end

function M:aaaa()
    local offsetBeforeReload = self.mTableView:getContentOffset();
    local contentSizeBeforeReload = self.mTableView:getContentSize();
    local viewSize = self.mTableView:getViewSize();
    
    self.mTableView:reloadData();
    
    local offsetAfterReload = self.mTableView:getContentOffset();
    local contentSizeAfterReload = self.mTableView:getContentOffset();
    
    if(viewSize.height == contentSizeAfterReload.height) then
        if(offsetBeforeReload.height == contentSizeAfterReload.height) then
            self.mTableView:setContentOffset(offsetBeforeReload);
        else
            local distY = contentSizeAfterReload.height - contentSizeBeforeReload.height;
            offsetBeforeReload.y = offsetBeforeReload.y - distY;
            self.mTableView:setContentOffset(offsetBeforeReload);
        end
    end
end

return M;