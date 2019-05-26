--心之怪盗团-Mona
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873613
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_WIND)
	local e2=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"se,th",nil,cm.con,nil,rstg.target(rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	--local e3=rsef.I(c,{m,1},{1,m},"se,th",nil,LOCATION_GRAVE,nil,aux.bfgcost,rstg.target(rsop.list(cm.thfilter2,"th",LOCATION_DECK)),cm.thop2)
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
function cm.con(e,tp)
	return rscon.excard(rscf.FilterFaceUp(rsphh.mset),LOCATION_MZONE)(e,tp)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(15873634)
end
function cm.thop(e,tp)
	if not cm.con(e,tp) then return end
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end