--超时空填充胶囊
function c13257342.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c13257342.target)
	e1:SetOperation(c13257342.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c13257342.tdcon)
	e2:SetTarget(c13257342.tdtg)
	e2:SetOperation(c13257342.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	
end
function c13257342.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x351)
end
function c13257342.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c13257342.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c13257342.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c13257342.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13257342.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,c13257342,RESET_PHASE+PHASE_END,0,1)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(12,0,aux.Stringid(13257342,7))
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,13257342)>=3 then
			local code=tc:GetCode()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c13257342.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(12,0,aux.Stringid(13257341,7))
				Duel.SendtoHand(g,tp,REASON_EFFECT)
			end
		end
	end
end
function c13257342.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c13257342.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13257342.cfilter,1,nil,1-tp)
end
function c13257342.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c13257342.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end


