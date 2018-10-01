--星之骑士拟身 光鞭
function c65090008.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090008)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),1,true,true)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c65090008.destg)
	e2:SetOperation(c65090008.desop)
	c:RegisterEffect(e2)
end
function c65090008.filter(c,atk)
	return c:IsFaceup() and (c:IsAttackBelow(atk) or c:IsDefenseBelow(atk))
end
function c65090008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65090008.filter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c65090008.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c65090008.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c65090008.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SendtoGrave(g,REASON_EFFECT)
end