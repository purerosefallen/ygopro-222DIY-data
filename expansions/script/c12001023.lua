--六曜的霓虹丘儿
function c12001023.initial_effect(c)
   c:EnableReviveLimit()
	--synchro summon
	aux.AddSynchroMixProcedure(c,c12001023.matfilter1,nil,nil,aux.NonTuner(Card.IsType,TYPE_PENDULUM),1,99)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12001023,3))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c12001023.discon)
	e3:SetTarget(c12001023.distg)
	e3:SetOperation(c12001023.disop)
	c:RegisterEffect(e3)
end
function c12001023.matfilter1(c)
	return c:IsType(TYPE_TUNER) or (c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM))
end
function c12001023.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xfb0) and not re:GetHandler():IsCode(12001023) and Duel.IsChainNegatable(ev) and Duel.GetTurnPlayer()==1-tp
end
function c12001023.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c12001023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		ng:AddCard(tc)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function c12001023.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0xfb0) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		if not e:GetHandler():IsRelateToEffect(e) then return end
		local check=false
		for i=1,ev do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			if te:GetOwnerPlayer()==1-tp then
				check=Duel.NegateActivation(i) or check
			end
		end
		if check then
			Duel.BreakEffect()
		end
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		Duel.ShuffleDeck(tp)
	end
end
