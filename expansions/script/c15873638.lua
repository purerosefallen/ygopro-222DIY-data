--心之怪盗团-反抗神的人们
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873638
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x2b)
	rsphh.SetCode(c) 
	local e1=rsef.ACT(c)
	local e2=rsef.SV_INDESTRUCTABLE(c,"effect")
	local e3=rsef.FC(c,EVENT_LEAVE_FIELD)
	rsef.RegisterSolve(e3,cm.ctcon,nil,nil,cm.ctop)
	local e4=rsef.I(c,{m,0},nil,"sp",nil,LOCATION_SZONE,nil,rscost.cost(cm.cfilter,"tg"),rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_DECK+LOCATION_HAND)),cm.spop)
end
function cm.ctcon(e,tp,eg)
	return true--eg:IsExists(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),1,nil)
end
function cm.ctop(e,tp)
	e:GetHandler():AddCounter(0x2b,1)
end
function cm.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:GetCounter(0x2b)>=10
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCode(15873621) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function cm.spop(e,tp)
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end