--Answer·水野翠
function c81010068.initial_effect(c)
	--Inactivate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81010068)
	e1:SetCondition(c81010068.discon)
	e1:SetCost(c81010068.discost)
	e1:SetTarget(c81010068.distg)
	e1:SetOperation(c81010068.disop)
	c:RegisterEffect(e1)
end
function c81010068.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and loc==LOCATION_HAND
end
function c81010068.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c81010068.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c81010068.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
