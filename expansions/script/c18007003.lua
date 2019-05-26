--幻量子破坏者
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007003
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rspq.ToDeckFun(c,m)
	local e2=rspq.SpecialSummonFun(c,m,"td",rstg.target(rsop.list(Card.IsAbleToDeck,"td",LOCATION_ONFIELD,LOCATION_ONFIELD)),cm.tdop)   
end
cm.rssetcode="PhantomQuantum"
function cm.tdop(e,tp)
	rsof.SelectHint(tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end