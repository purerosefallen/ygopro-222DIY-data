--恶噬君王
function c65020093.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xada3),4,3)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c65020093.atkval)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(65020093)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c65020093.condition)
	e3:SetCost(c65020093.cost)
	e3:SetTarget(c65020093.target)
	e3:SetOperation(c65020093.activate)
	c:RegisterEffect(e3)
end
function c65020093.atkfil(c)
	return c:IsSetCard(0xada3) and c:IsFaceup()
end
function c65020093.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c65020093.atkfil,tp,LOCATION_MZONE,0,nil)*1000
end
function c65020093.confil(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xada3) 
end
function c65020093.condition(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return Duel.GetCurrentChain()>1 and c65020093.confil(chain:GetHandler()) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c65020093.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c65020093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65020093.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end