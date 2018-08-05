--元素·金符『Sliver Dragon』
function c15415171.initial_effect(c)
	c:EnableCounterPermit(0x16f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c15415171.target)
	e1:SetOperation(c15415171.activate)
	c:RegisterEffect(e1)	
	--adup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15415171,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,15415171)
	e2:SetCost(c15415171.atkcost)
	e2:SetOperation(c15415171.atkop)
	c:RegisterEffect(e2)
	--adup
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(15415171,2))
	e11:SetCategory(CATEGORY_ATKCHANGE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetCountLimit(1,15415171)
	e11:SetCost(c15415171.atkcost2)
	e11:SetOperation(c15415171.atkop2)
	c:RegisterEffect(e11)
	--adup
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(15415171,3))
	e12:SetCategory(CATEGORY_ATKCHANGE)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetCountLimit(1,15415171)
	e12:SetCost(c15415171.atkcost3)
	e12:SetOperation(c15415171.atkop3)
	c:RegisterEffect(e12)
end
function c15415171.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,15415171,0,0x21,0,1000,6,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c15415171.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,15415171,0,0x21,0,1000,6,RACE_DRAGON,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end
function c15415171.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x16f,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x16f,1,REASON_COST)
end
function c15415171.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c15415171.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x16f,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x16f,2,REASON_COST)
end
function c15415171.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c15415171.atkcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x16f,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x16f,3,REASON_COST)
end
function c15415171.atkop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(3000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end