--幻量子疾驰者
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007002
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rspq.ToDeckFun(c,m)
	local e2=rspq.SpecialSummonFun(c,m,"th",rstg.target(rsop.list(cm.thfilter,"th",LOCATION_GRAVE)),cm.thop)	
end
cm.rssetcode="PhantomQuantum"
function cm.thfilter(c)
	return c:CheckSetCard("PhantomQuantum") and c:IsAbleToHand()
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end