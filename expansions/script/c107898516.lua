--STSP·计划妥当
function c107898516.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898516,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c107898516.cost)
	e1:SetTarget(c107898516.target)
	e1:SetOperation(c107898516.operation)
	c:RegisterEffect(e1)
end
function c107898516.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898516.filter(c)
	return c:IsCode(107898102) and c:IsFaceup()
end
function c107898516.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and not e:GetHandler():IsPublic() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
end
function c107898516.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898516.filter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove(tp) and Duel.IsExistingTarget(c107898516.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898516.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898516.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		if not tc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
		end
		--tohand
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(107898516,1))
		e3:SetCategory(CATEGORY_TOHAND)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(c107898516.regcon)
		e3:SetTarget(c107898516.regtg)
		e3:SetOperation(c107898516.regop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(107898516,0))
	end
end
function c107898516.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and bit.band(r,REASON_ADJUST)~=0
end
function c107898516.regtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and chkc:IsAbleToHand() end
	if chk==0 then return eg:IsExists(Card.IsAbleToHand,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=eg:FilterSelect(tp,Card.IsAbleToHand,1,2,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c107898516.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		e1:SetCondition(c107898516.thcon)
		e1:SetOperation(c107898516.thop)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c107898516.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c107898516.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end