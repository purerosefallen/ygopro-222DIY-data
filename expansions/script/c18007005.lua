--幻量子驱动器
if not pcall(function() require("expansions/script/c18007001") end) then require("script/c18007001") end
local m=18007005
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rspq.ToDeckFun(c,m)
	local e2=rspq.SpecialSummonFun(c,m,"sp",rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_DECK)),cm.spop)	
end
cm.rssetcode="PhantomQuantum"
function cm.spfilter(c,e,tp)
	return c:CheckSetCard("PhantomQuantum") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end