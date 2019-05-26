--新干线700希望
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008002
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rssk.SpecialSummonFun(c)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"sp","tg",nil,nil,rstg.target(cm.spfilter,"sp",LOCATION_REMOVED),cm.spop)
end
cm.rssetcode="Shinkansen"
function cm.spfilter(c,e,tp)
	return c:IsFaceup() and rssk.set(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc then rssf.SpecialSummon(tc) end
end