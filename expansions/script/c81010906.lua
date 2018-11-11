--HappySky·浅利七海
function c81010906.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change race
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81010906,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,81010906)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c81010906.rctg1)
	e1:SetOperation(c81010906.rcop1)
	c:RegisterEffect(e1)
end
function c81010906.rcfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_FISH)
end
function c81010906.rctg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c81010906.rcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010906.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81010906.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c81010906.rcop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_FISH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
	end
end