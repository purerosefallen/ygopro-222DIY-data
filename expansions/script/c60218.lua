--明澈的透伞-雨水
function c60218.initial_effect(c)
	--umb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60218,0))
	e1:SetCategory(0x600000)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCondition(c60218.condition)
	e1:SetCost(c60218.cost)
	e1:SetOperation(c60218.operation)
	c:RegisterEffect(e1)
	--confirm
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetDescription(aux.Stringid(60218,1))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60218)
	e2:SetCost(c60218.drcost)
	e2:SetTarget(c60218.drtg)
	e2:SetOperation(c60218.drop)
	c:RegisterEffect(e2)
end
c60218.DescSetName = 0x229
function c60218.umbfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0x229 and not c:IsPublic()
end
function c60218.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c60218.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c60218.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c60218.tg)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(-2000)
	Duel.RegisterEffect(e2,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(c60218.tg)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(-2000)
	Duel.RegisterEffect(e2,tp)
end
function c60218.tg(e,c)
	return c:IsFaceup()
end
function c60218.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c60218.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
end
function c60218.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,2,REASON_EFFECT)<2 then return end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
	end
	local gn=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if gn:GetCount()>0 then
		Duel.ConfirmCards(1-tp,gn)
		Duel.ShuffleHand(1-tp)
	end
end
