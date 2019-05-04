--塑形
function c21520176.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_COUNT_LIMIT)
	e1:SetCode(EVENT_FREE_CHAIN)
--	e1:SetCountLimit(1)
	e1:SetCondition(c21520176.spcon)
	e1:SetTarget(c21520176.sptg)
	e1:SetOperation(c21520176.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
--	e2:SetProperty(EFFECT_FLAG_COUNT_LIMIT)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c21520176.thcon)
	e2:SetCost(c21520176.thcost)
	e2:SetTarget(c21520176.thtg)
	e2:SetOperation(c21520176.thop)
	c:RegisterEffect(e2)
end
function c21520176.spfilter(c,e,tp)
	return c:IsSetCard(0x490) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21520176.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c21520176.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21520176.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c21520176.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21520176.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e1,true)
		g:GetFirst():RegisterFlagEffect(21520176,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(g:GetFirst())
		e2:SetCondition(c21520176.descon)
		e2:SetOperation(c21520176.desop)
		Duel.RegisterEffect(e2,tp)
		Duel.SpecialSummonComplete()
	end
end
function c21520176.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(21520176)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c21520176.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c21520176.thfilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToRemove()
end
function c21520176.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520176.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,nil)>0 end
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tf=0
	if g:GetFirst():IsSetCard(0x490) then tf=1 end 
	e:SetLabel(tf)
end
function c21520176.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c21520176.thfilter,tp,LOCATION_DECK,0,1,nil) end
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	local tf=e:GetLabel()
	if tf==1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,LOCATION_GRAVE) end
end
function c21520176.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tf=e:GetLabel()
--	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c21520176.thfilter,tp,LOCATION_DECK,0,1,nil) then
	if tf==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
