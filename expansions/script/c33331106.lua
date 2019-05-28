--神祭小狐 狐说草 
if not pcall(function() require("expansions/script/c33331100") end) then require("script/c33331100") end
local m=33331106
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,cm.lfilter,1)
	c:EnableReviveLimit()
	local e1=rsef.I(c,{m,0},1,"td,se,th",nil,LOCATION_MZONE,nil,rscost.reglabel(100),cm.tg,cm.op)
end
function cm.lfilter(c)
	return c:IsLinkType(TYPE_NORMAL) and c:IsLinkRace(RACE_BEAST) 
end
function cm.cfilter(c,tp)
	return not c:IsPublic() and rslf.filter2(c) and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter(c,code)
	return rslf.filter2(c) and c:IsAbleToHand() and not c:IsCode(code)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()==100 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp)
	local tc=rscf.GetTargetCard()
	if not tc or Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_DECK) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
