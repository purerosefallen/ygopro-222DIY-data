--心之怪盗团-Panther
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873614
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_FIRE)
	local e2=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},"se,th",nil,nil,rscost.cost(Card.IsDiscardable,"dish",LOCATION_HAND),rstg.target(rsop.list(cm.thfilter2,"th",LOCATION_DECK)),cm.thop2)
end
function cm.thfilter2(c)
	return c:IsAbleToHand() and rsphh.stset(c)
end
function cm.thop2(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end