--元素·日符『Royal Flare』
function c15415167.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15415167+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c15415167.thcon)
	e1:SetCost(c15415167.cost)
	e1:SetTarget(c15415167.destg)
	e1:SetOperation(c15415167.desop)
	c:RegisterEffect(e1)	
end
function c15415167.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x163)
end
function c15415167.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15415167.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.GetCounter(tp,1,1,0x16f)>=5
end
function c15415167.filter(c)
	return c:GetCounter(0x16f)>0
end
function c15415167.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15415167.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	if Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x16f)==0 then return end
	local g=Duel.GetMatchingGroup(c15415167.filter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		local sct=tc:GetCounter(0x16f)
		tc:RemoveCounter(tp,0x16f,sct,REASON_COST)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c15415167.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c15415167.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end