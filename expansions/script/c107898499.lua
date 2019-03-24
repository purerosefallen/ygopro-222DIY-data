--STSS·神话
function c107898499.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(c107898499.effectfilter)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e2)
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(c107898499.etarget)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,0)
	e5:SetTarget(c107898499.etarget)
	e5:SetValue(c107898499.efilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c107898499.indtg)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	--avoid battle damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c107898499.abdtg)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(107898499,3))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_DAMAGE_STEP_END)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCondition(c107898499.atcon)
	e8:SetOperation(c107898499.atop)
	c:RegisterEffect(e8)
end
function c107898499.atcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return at and a:IsSetCard(0x575a) and a:IsControler(tp) and at:IsRelateToBattle() and at:GetAttack()>0
end
function c107898499.atop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	if at:IsRelateToBattle() and not at:IsImmuneToEffect(e) then
		if at:GetAttack()>0 and at:IsAttackPos() then
			local e1=Effect.CreateEffect(at)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-a:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			at:RegisterEffect(e1)
		end
		if at:GetDefense()>0 and at:IsDefensePos() then
			local e2=Effect.CreateEffect(at)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(-a:GetAttack())
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			at:RegisterEffect(e2)
		end
	end
end
function c107898499.abdtg(e,c)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and c:IsSetCard(0x575a)
end
function c107898499.indtg(e,c)
	return c:IsSetCard(0x575)
end
function c107898499.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	return p==tp and (tc:IsSetCard(0x575) or tc:IsCode(107898100)) and (bit.band(loc,LOCATION_GRAVE)~=0 or bit.band(loc,LOCATION_MZONE)~=0)
end
function c107898499.etarget(e,c)
	return c:IsSetCard(0x575) or c:IsCode(107898100)
end
function c107898499.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575) and not te:GetOwner():IsCode(107898100)
end