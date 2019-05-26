--心之怪盗团-原初觉醒
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873637
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)  
	local e1=rsef.ACT(c,nil,nil,{1,m},"sp",nil,rscon.excard(rscf.FilterFaceUp(Card.IsCode,15873611),LOCATION_ONFIELD),nil,rstg.target3(cm.fun,rsop.list(cm.spfilter,"sp",LOCATION_DECK)),cm.activate)
end
function cm.fun(e,tp)
	return Duel.GetLP(tp)>=2000 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and rsphh.set2(c)
end
function cm.activate(e,tp)
	if not Duel.CheckLPCost(tp,2000) then return end
	Duel.PayLPCost(tp,2000)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end
