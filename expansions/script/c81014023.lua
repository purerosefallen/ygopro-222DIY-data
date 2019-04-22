--1/5·中野二乃
function c81014023.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--attack thrice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81014023.atkcon)
	e2:SetTarget(c81014023.atktg)
	e2:SetOperation(c81014023.atkop)
	c:RegisterEffect(e2)
end
function c81014023.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c81014023.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c81014023.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81014023.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81014023.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81014023.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81014023.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c81014023.ftarget)
	e2:SetLabel(tc:GetFieldID())
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c81014023.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
