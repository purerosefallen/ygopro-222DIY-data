--星之骑士拟身 球
function c65090045.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090045)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),1,true,true)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c65090045.condition)
	e2:SetOperation(c65090045.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c65090045.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker()
end
function c65090045.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
		--immune
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
		e2:SetValue(c65090045.efilter)
		c:RegisterEffect(e2)
	end
end
function c65090045.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end