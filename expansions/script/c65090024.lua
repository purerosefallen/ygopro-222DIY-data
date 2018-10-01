--星之骑士拟身 推进
function c65090024.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090024)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,true,true)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c65090024.poscon)
	e1:SetOperation(c65090024.posop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(c65090024.atkcon)
	e2:SetOperation(c65090024.atkop)
	c:RegisterEffect(e2)
end
function c65090024.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c65090024.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c65090024.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return ac==e:GetHandler() and bc 
end
function c65090024.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if c:IsFaceup() then
		local atk=bc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(atk)
		c:RegisterEffect(e1)
	end
end