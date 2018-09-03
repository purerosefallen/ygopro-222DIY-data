--夢想の歌劇
local m=17060909
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddRitualProcGreater(c,cm.ritual_filter)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.IsOpera_type(c)
	local m=_G["c"..c:GetCode()]
	return m and m.is_named_with_Opera_type
end
function cm.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and cm.IsOpera_type(c)
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end