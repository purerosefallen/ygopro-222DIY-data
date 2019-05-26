--新干线的车长
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008004
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssk.SpecialSummonFun(c)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"sp",nil,nil,nil,rstg.target(rsop.list(cm.spfilter,"sp",LOCATION_DECK)),cm.spop)
end
cm.rssetcode="Shinkansen"
function cm.spfilter(c,e,tp)
	return rssk.set(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsCode(m)
end
function cm.spop(e,tp)
	rsof.SelectHint(tp,"sp")
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #sg>0 then
		rssf.SpecialSummon(sg)
	end
end