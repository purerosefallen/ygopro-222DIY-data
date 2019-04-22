--最上静香避雨中
function c81018024.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81018024+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81018024.target)
	e1:SetOperation(c81018024.operation)
	c:RegisterEffect(e1)
end
function c81018024.filter(c)
	return c:IsSetCard(0x81b) and c:IsFaceup()
end
function c81018024.tgfilter(c)
	return c:IsFaceup()
end
function c81018024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c81018024.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81018024.tgfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c81018024.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81018024.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c81018024.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c81018024.filter,tp,LOCATION_MZONE,0,nil)
		local atk=g:GetSum(Card.GetAttack)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
