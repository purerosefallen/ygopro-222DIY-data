--望月杏奈的思量
function c81016012.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81016012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81016012.target)
	e1:SetOperation(c81016012.operation)
	c:RegisterEffect(e1)
end
function c81016012.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x81d)
end
function c81016012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81016012.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81016012.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81016012.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81016012.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(81016012,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81016012,0))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DAMAGE)
		e1:SetLabelObject(tc)
		e1:SetCondition(c81016012.rmcon1)
		e1:SetOperation(c81016012.rmop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c81016012.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(81016012)~=0 and ep~=tp
end
function c81016012.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_CARD,0,81016012)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local mg=g:Select(1-tp,1,1,nil)
	if mg:GetCount()>0 then
		Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
	end
end
