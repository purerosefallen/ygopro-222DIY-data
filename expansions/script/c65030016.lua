--伤痛的晦暗云层
function c65030016.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c65030016.accost)
	c:RegisterEffect(e0)
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-800)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c65030016.atkcon)
	e2:SetCost(c65030016.atkcost)
	e2:SetOperation(c65030016.atkop)
	c:RegisterEffect(e2)
end
c65030016.card_code_list={65030020}
function c65030016.costfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsReleasable() and aux.IsCodeListed(c,65030020)
end
function c65030016.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030016.costfil,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65030016.costfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c65030016.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetAttacker()
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE and b and b:IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and not Duel.IsDamageCalculated()
end
function c65030016.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():GetFlagEffect(65030016)==0 end
	e:GetHandler():RegisterFlagEffect(65030016,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c65030016.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if tc and not tc:IsImmuneToEffect(e) then
		 local preatk=tc:GetAttack()
		if preatk<=2100 then
			local dam=2100-preatk
			Duel.SendtoGrave(tc,REASON_EFFECT)
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
