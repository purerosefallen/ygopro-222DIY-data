--ArTonelico Meimei
function c98300040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98300040,0))
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98300040)
	e1:SetCost(c98300040.ancost)
	e1:SetTarget(c98300040.antg)
	e1:SetOperation(c98300040.anop)
	c:RegisterEffect(e1)
end
function c98300040.ancost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c98300040.anfilter(c)
	return c:IsFaceup()
end
function c98300040.actfilter(c)
	return c:IsSetCard(0xad1) and c:IsFaceup()
end
function c98300040.antg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c98300040.actfilter,tp,LOCATION_FZONE,0,1,nil) and Duel.IsExistingMatchingCard(c98300040.anfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c98300040.anop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98300040.actfilter,tp,LOCATION_FZONE,0,1,nil) then return false end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_ONFIELD,1,nil,ac) then
	--forbidden
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(c98300040.distg)
		e1:SetLabel(ac)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c98300040.discon)
		e2:SetOperation(c98300040.disop)
		e2:SetLabel(ac)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.BreakEffect()
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c98300040.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c98300040.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return code1==code or code2==code
end
function c98300040.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end