--幻量子强袭者
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007006
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2=rspq.FusionSummonFun(c,m,false,true,5)
	local e3=rspq.LeaveFieldFun(c,m)
	local e4=rsef.I(c,{m,0},1,"td","tg",LOCATION_MZONE,nil,nil,rstg.target({cm.tdfilter,"td",LOCATION_MZONE },{Card.IsAbleToDeck,"td",LOCATION_MZONE,LOCATION_MZONE }),cm.tdop)
end
cm.rssetcode="PhantomQuantum"
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:CheckSetCard("PhantomQuantum")
end
function cm.tdop(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g>0 then Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
end