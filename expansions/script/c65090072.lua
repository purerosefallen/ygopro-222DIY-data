--天邪逆鬼的碎面
function c65090072.initial_effect(c)
	c:SetUniqueOnField(1,0,65090072)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c65090072.condition)
	e1:SetCost(c65090072.cost)
	e1:SetTarget(c65090072.target)
	e1:SetOperation(c65090072.activate)
	c:RegisterEffect(e1)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9da7))
	e3:SetValue(c65090072.val)
	c:RegisterEffect(e3)
end
function c65090072.confil(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9da7) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c65090072.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c65090072.confil,1,nil,tp)
		and Duel.IsChainNegatable(ev) 
end
function c65090072.costfil(c)
	return c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c65090072.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65090072.costfil,tp,LOCATION_REMOVED,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,c65090072.costfil,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c65090072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c65090072.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
end
function c65090072.valc(c)
	return c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c65090072.val(e,c)
	local tp=e:GetHandler():GetControler()
	local num=Duel.GetMatchingGroupCount(c65090072.valc,tp,LOCATION_REMOVED,0,nil)
	return num*100
end