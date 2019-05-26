--幻量子波动
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},nil,"td","tg",nil,nil,rstg.target({cm.tdfilter,"td",LOCATION_MZONE },{Card.IsAbleToDeck,"td",0,LOCATION_ONFIELD,2}),cm.tdop)
end
cm.rssetcode="PhantomQuantum"
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:CheckSetCard("PhantomQuantum")
end
function cm.tdop(e,tp)
	local g=rsgf.GetTargetGroup()
	if #g>0 then Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
end