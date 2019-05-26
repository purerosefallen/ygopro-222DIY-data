--心之怪盗团-英雄回归
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873639
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c) 
	local e1=rsef.ACT(c,nil,nil,{1,m},"sp","tg",nil,nil,rstg.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	local e2=rsef.I(c,{m,0},{1,m},"th",nil,LOCATION_GRAVE,nil,aux.bfgcost,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_GRAVE)),cm.thop)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and rsphh.set(c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then
		rssf.SpecialSummon(tc)
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and rsphh.mset(c)
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end