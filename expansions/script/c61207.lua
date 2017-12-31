--陵冬的红伞-大雪
function c61207.initial_effect(c)
	--umb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61207,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c61207.condition)
	e1:SetCost(c61207.cost)
	e1:SetTarget(c61207.target)
	e1:SetOperation(c61207.operation)
	c:RegisterEffect(e1)
	--to grave
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(61207,1))
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,61207)
	e2:SetCost(c61207.drcost)
	e2:SetTarget(c61207.drtg)
	e2:SetOperation(c61207.drop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
c61207.DescSetName = 0x229
function c61207.umbfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return not c:IsLevelAbove(5) and c:IsDiscardable()
end
function c61207.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c61207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c61207.umbfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c61207.umbfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c61207.filter(c)
	return aux.TRUE
end
function c61207.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c:IsControler(1-tp) and c61207.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c61207.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c61207.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c61207.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c61207.exfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c61207.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c61207.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61207.exfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c61207.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c61207.exfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
