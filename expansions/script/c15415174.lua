--光符·彩符『彩光乱舞』
function c15415174.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c15415174.spcon)
	e1:SetTarget(c15415174.target)
	e1:SetOperation(c15415174.activate)
	c:RegisterEffect(e1)	
end
function c15415174.cfilter(c)
	return c:IsPreviousSetCard(0x167) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP)
end
function c15415174.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c15415174.cfilter,1,nil)
end
function c15415174.filter(c)
	return c:IsSetCard(0x161) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c15415174.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c15415174.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15415174.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c15415174.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c15415174.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	  if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,aux.ExceptThisCard(e))
		local tc=g:GetFirst()
		while tc do
		tc:AddCounter(0x16f,1)
		tc=g:GetNext()
		end
	  end
	end
end