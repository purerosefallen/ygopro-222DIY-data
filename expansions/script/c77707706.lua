--Vessel of Sin ÂíÂ¡ÌÀ³×
function c77707706.initial_effect(c)
	  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77707706+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c77707706.cost)
	e1:SetOperation(c77707706.operation)
	c:RegisterEffect(e1)
end
function c77707706.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c77707706.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c77707706.drcon1)
	e1:SetOperation(c77707706.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c77707706.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c77707706.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end