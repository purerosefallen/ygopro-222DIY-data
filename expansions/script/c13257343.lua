--隐藏的折跃星
function c13257343.initial_effect(c)
	c:SetUniqueOnField(1,0,13257343)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c13257343.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257343,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c13257343.thtg)
	e2:SetOperation(c13257343.thop)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c13257343.sdcon)
	c:RegisterEffect(e3)
	
end
function c13257343.filter(c)
	return (c:IsCode(13257326) or c:IsCode(13257336)) and c:IsAbleToHand()
end
function c13257343.activate(e,tp,eg,ep,ev,re,r,rp)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if not e:GetHandler():IsRelateToEffect(e) or dcount==0 then return end
	Duel.Hint(11,0,aux.Stringid(13257343,7))
	local g=Duel.GetMatchingGroup(c13257343.filter,tp,LOCATION_DECK,0,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(13257343,0)) then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		if g:GetCount()==0 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		local seq=-1
		local tc=g:GetFirst()
		local spcard=nil
		while tc do
			if tc:GetSequence()>seq then 
				seq=tc:GetSequence()
				spcard=tc
			end
			tc=g:GetNext()
		end
		Duel.ConfirmDecktop(tp,dcount-seq)
		if spcard:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(spcard,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,spcard)
			Duel.ShuffleHand(tp)
		end
	end
end
function c13257343.check(c,tp)
	return c and c:IsControler(tp) and (c:IsSetCard(0x351) or c:IsCode(93130022))
end
function c13257343.filter1(c)
	return (c:IsCode(13257341) or c:IsCode(13257342)) and c:IsAbleToHand()
end
function c13257343.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c13257343.check(Duel.GetAttacker(),tp) or c13257343.check(Duel.GetAttackTarget(),tp) and Duel.IsExistingMatchingCard(c13257343.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c13257343.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13257343.filter1,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(spcard,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,spcard)
		Duel.ShuffleHand(tp)
	end
end
function c13257343.sdcon(e)
	return Duel.GetTurnPlayer()~=e:GetOwnerPlayer() and Duel.GetCurrentPhase()==PHASE_END
end
