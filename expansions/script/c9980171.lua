--魔法纪录·奉献之七海八千代
function c9980171.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9980171.lcheck)
	--link success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980171,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9980171.addcc)
	e2:SetTarget(c9980171.addct)
	e2:SetOperation(c9980171.addc)
	c:RegisterEffect(e2)
	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980171,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(c9980171.atkcost)
	e1:SetOperation(c9980171.atkop)
	c:RegisterEffect(e1)
	--efilter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c9980171.efilter)
	c:RegisterEffect(e1)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c9980171.aclimit1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c9980171.aclimit2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c9980171.econ)
	e5:SetValue(c9980171.elimit)
	c:RegisterEffect(e5)
end
c9980171.counter_add_list={0x1}
function c9980171.lcheck(g,lc)
	return g:IsExists(c9980171.mzfilter,1,nil)
end
function c9980171.mzfilter(c)
	return c:IsSetCard(0xbc4) and c:IsType(TYPE_TUNER)
end
function c9980171.addcc(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980171.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x1)
end
function c9980171.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,2)
	end
end
function c9980171.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,1,REASON_COST)
end
function c9980171.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c9980171.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP+TYPE_SPELL)
end
function c9980171.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(9980171,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c9980171.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():ResetFlagEffect(9980171)
end
function c9980171.econ(e)
	return e:GetHandler():GetFlagEffect(9980171)~=0
end
function c9980171.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end