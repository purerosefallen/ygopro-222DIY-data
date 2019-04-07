--走志走爱·向井拓海
function c81009026.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--reverse damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81009026,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(c81009026.effcon)
	e2:SetTarget(c81009026.revtg)
	e2:SetOperation(c81009026.revop)
	c:RegisterEffect(e2)
end
function c81009026.effcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_EFFECT)~=0
end
function c81009026.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c81009026.revop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_REVERSE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetValue(c81009026.revval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c81009026.revval(e,re,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0
end
