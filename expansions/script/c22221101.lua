--急速飞行白沢球
function c22221101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22221101.target)
	e1:SetOperation(c22221101.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22221101.thtg)
	e2:SetOperation(c22221101.thop)
	c:RegisterEffect(e2)
end
function c22221101.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x50f) and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER 
end
function c22221101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22221101.filter,tp,LOCATION_SZONE,0,1,nil) end
end
function c22221101.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22221101.filter,tp,LOCATION_SZONE,0,nil)
	if g:GetCount()<0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	if ct>0 then Duel.BreakEffect() end
	if ct>1 then Duel.Recover(tp,1500,REASON_EFFECT) end
	if ct>3 and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c22221101.thfilter(c)
	return c:IsSetCard(0x50f) and c:IsFaceup()
end
function c22221101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc==0 then return c22221101.thfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c22221101.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22221101.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,0,0,LOCATION_SZONE)
end
function c22221101.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=tc:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_SZONE)
		if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) end
	end
end