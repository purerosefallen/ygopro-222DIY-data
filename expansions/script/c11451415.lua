--dragon-king palace,the crystal city
function c11451415.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effect1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451415,4))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11451415.condition)
	e2:SetTarget(c11451415.target)
	e2:SetOperation(c11451415.operation)
	c:RegisterEffect(e2)
	--effect2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11451415,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c11451415.condition2)
	e3:SetTarget(c11451415.target2)
	e3:SetOperation(c11451415.operation2)
	c:RegisterEffect(e3)
end
function c11451415.cfilter(c,tp)
	return c:IsSetCard(0x6978) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c11451415.thfilter(c)
	return c:IsSetCard(0x6978)
end
function c11451415.sfilter(c)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c11451415.mfilter(c)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_MONSTER)
end
function c11451415.rfilter(c,e,tp)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c11451415.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11451415.cfilter,1,nil,tp)
end
function c11451415.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c11451411.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return true end
	local op=0
	if b1 then
		op=Duel.SelectOption(tp,aux.Stringid(11451415,0),aux.Stringid(11451415,1),aux.Stringid(11451415,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(11451415,1),aux.Stringid(11451415,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451415,0))
		Duel.SetOperationInfo(0,nil,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451415,1))
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451415,2))
	end
end
function c11451415.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetTarget(c11451415.target3)
		e4:SetOperation(c11451415.operation3)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	elseif e:GetLabel()==1 then
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetCountLimit(1)
		e5:SetCondition(c11451415.condition4)
		e5:SetOperation(c11451415.operation4)
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	else
		local turnp=Duel.GetTurnPlayer()
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_SKIP_M1)
		e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e6:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp then
			e6:SetLabel(Duel.GetTurnCount())
			e6:SetCondition(c11451415.skip)
			e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e6,tp)
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_SKIP_M2)
		e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e7:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp then
			e7:SetLabel(Duel.GetTurnCount())
			e7:SetCondition(c11451415.skip)
			e7:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e7:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e7,tp)
	end
end
function c11451415.skip(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c11451415.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11451415.sfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c11451415.operation3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c11451415.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c11451415.condition4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11451415.mfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c11451415.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,HINTMSG_RTOHAND)
	local rg=Duel.SelectMatchingCard(tp,c11451415.mfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if rg:GetCount()>0 then
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
	end
end
function c11451415.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY)
end
function c11451415.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11451415.rfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11451415.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11451415.rfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP) then
		tc:CompleteProcedure()
	end
end