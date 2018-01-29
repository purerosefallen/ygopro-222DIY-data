--新年的御伞-立春
function c60203.initial_effect(c)
	--umb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60203,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60203)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60203.condition)
	e1:SetCost(c60203.cost)
	e1:SetOperation(c60203.operation)
	c:RegisterEffect(e1)
	--summon+
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(60203,1))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60204+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c60203.drcost)
	e2:SetTarget(c60203.drtg)
	e2:SetOperation(c60203.drop)
	c:RegisterEffect(e2)
end
c60203.DescSetName = 0x229
function c60203.umbfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0x229 and not c:IsPublic()
end
function c60203.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c60203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c60203.umbfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c60203.umbfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c60203.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c60203.drcon1)
	e1:SetOperation(c60203.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60203.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsAttribute(ATTRIBUTE_WATER) and ep==tp
end
function c60203.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c60203.exfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c60203.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c60203.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60203.smfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c60203.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,60203)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(aux.TargetBoolFunction(c60203.smfilter))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,60203,RESET_PHASE+PHASE_END,0,1)
	end
end
