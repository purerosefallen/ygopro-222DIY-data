--传说之魂 缜密
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33350022
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	local e1=rsef.I(c,{m,0},1,"se,th",nil,LOCATION_MZONE,nil,rscost.rmxyz(1),rstg.target2(cm.fun,rsop.list(cm.thfilter,"th",LOCATION_DECK)),cm.thop)
	local e2=rsef.SC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,"cd",rscon.sumtype("xyz",cm.cfilter),cm.op)
end
cm.setname="TaleSouls"
function cm.cfilter(e,tp,re,rp,mat)
	return #mat>0 and mat:IsExists(Card.IsCode,1,nil,33350016)
end
function cm.op(e,tp)
	local e3=rsef.I({e:GetHandler()},{m,1},1,"rm","tg",LOCATION_MZONE,nil,nil,rstg.target(Card.IsFaceup,nil,LOCATION_ONFIELD,LOCATION_ONFIELD),cm.tgop)
	e3:SetReset(rsreset.est)
end
function cm.tgop(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc then return end
	if (tc:IsType(TYPE_PENDULUM) and tc:IsLocation(LOCATION_SZONE)) or not tc:IsCanTurnSet() then
		Duel.Remove(tc,POS_FACEUP,REASON_RULE)
	else
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function cm.fun(g,e,tp)
	rsof.SelectHint(tp,"tg")
	local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SendtoGrave(tg,REASON_COST)
end
function cm.thfilter(c,e,tp)
	return c:IsAbleToHand() and c.setname=="TaleSouls" and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,c,e,tp)
end
function cm.tgfilter(c,e,tp)
	return c.setname=="TaleSouls" and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function cm.thfilter2(c,e,tp)
	return c:IsAbleToHand() and c.setname=="TaleSouls" 
end
function cm.thop(e,tp)
	rsof.SelectHint(tp,"th")
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
