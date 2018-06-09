--黑之御龙骑士
function c11115002.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x115e),aux.NonTuner(Card.IsSetCard,0x215e),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11115002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11115002)
	e1:SetCost(c11115002.thcost)
	e1:SetTarget(c11115002.thtg)
	e1:SetOperation(c11115002.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11115002,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,111150020)
	e2:SetCondition(c11115002.spcon)
	e2:SetTarget(c11115002.sptg)
	e2:SetOperation(c11115002.spop)
	c:RegisterEffect(e2)
end
function c11115002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11115002.thfilter(c)
	return c:IsSetCard(0x115e) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c11115002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11115002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11115002.sumfilter(c)
	return c:IsSetCard(0x115e) and c:IsType(TYPE_TUNER) and c:IsSummonable(true,nil)
end
function c11115002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11115002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	    Duel.ConfirmCards(1-tp,g) 
        local sg=Duel.GetMatchingGroup(c11115002.sumfilter,tp,LOCATION_HAND,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11115002,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.ShuffleHand(tp)
			Duel.Summon(tp,sc,true,nil)
		else
		    Duel.ShuffleHand(tp)
		end	
	end
end
function c11115002.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousTypeOnField(),TYPE_SYNCHRO)~=0
		and c:IsPreviousSetCard(0xa15e) and (c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT)))
end
function c11115002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11115002.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c11115002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11115002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end