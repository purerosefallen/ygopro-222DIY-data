--星之骑士拟身 英雄
function c65090052.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090052)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_WYRM),1,true,true)
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c65090052.atkcon)
	e1:SetTarget(c65090052.atktg)
	e1:SetValue(c65090052.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e2)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c65090052.immcon)
	e4:SetValue(c65090052.efilter)
	c:RegisterEffect(e4)
end
function c65090052.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget() and e:GetHandler():IsRelateToBattle()
end
function c65090052.atktg(e,c)
	return c:IsRelateToBattle() and c~=e:GetHandler()
end
function c65090052.atkval(e,c)
	local d=Duel.GetAttackTarget()
	if c:GetFlagEffect(65090052)~=0 then return 0 end
	if c:GetAttack()<d:GetAttack() then
		c:RegisterFlagEffect(65090052,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
		return 0
	else return 0 end
end
function c65090052.immcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c65090052.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end