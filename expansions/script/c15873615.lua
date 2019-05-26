--心之怪盗团-Fox
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873615
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_WATER)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"tg",nil,nil,nil,rstg.target(rsop.list(cm.tgfilter,"th",LOCATION_DECK)),cm.tgop)   
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and rsphh.mset(c)
end
function cm.tgop(e,tp)
	rsof.SelectHint(tp,"tg")
	local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end