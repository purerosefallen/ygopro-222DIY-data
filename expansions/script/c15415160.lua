--红符『红色不夜城』
function c15415160.initial_effect(c)	 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,15415160)
	e2:SetCost(c15415160.descost)
	e2:SetCondition(c15415160.thcon)
	e2:SetTarget(c15415160.thtg)
	e2:SetOperation(c15415160.thop)
	c:RegisterEffect(e2)   
end
function c15415160.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x16f,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x16f,2,REASON_COST)
end
function c15415160.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x165)
end
function c15415160.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15415160.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c15415160.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c15415160.thfilters(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsSetCard(0x161)
end
function c15415160.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c15415160.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15415160.thfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	and Duel.IsExistingMatchingCard(c15415160.thfilters,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c15415160.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c15415160.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	   e1:SetTargetRange(1,0)
	   e1:SetValue(c15415160.aclimit)
	   e1:SetLabel(tc:GetCode())
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e1,tp)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,c15415160.thfilters,tp,LOCATION_EXTRA,0,1,1,nil)
	   if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetTargetRange(1,0)
			e2:SetValue(c15415160.aclimit)
			e2:SetLabel(g:GetFirst():GetCode())
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
	   end
	end
end
function c15415160.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end