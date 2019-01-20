--crad guard of dragon palace
function c11451421.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451421,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11451406)
	e1:SetCondition(c11451421.condition)
	e1:SetCost(c11451421.cost)
	e1:SetTarget(c11451421.target2)
	e1:SetOperation(c11451421.operation2)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451421,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1,11451421)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c11451421.condition2)
	e2:SetTarget(c11451421.target)
	e2:SetOperation(c11451421.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c11451421.filter(c)
	return c:IsSetCard(0x6978) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c11451421.filter2(c)
	return bit.band(c:GetType(),0x82)==0x82
end
function c11451421.filter3(c,tp)
	return c:GetSummonPlayer()==tp
end
function c11451421.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(c11451421.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) and not e:GetHandler():IsPublic() and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c11451421.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c11451421.filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local c=g:GetFirst()
	Duel.ConfirmCards(1-tp,c)
end
function c11451421.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11451421.filter2,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c11451421.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11451421.filter2,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g2=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,g2)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g3=g2:RandomSelect(1-tp,1)
		Duel.ShuffleDeck(tp)
		Duel.SendtoHand(g3,tp,REASON_EFFECT)
	end
end
function c11451421.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11451421.filter3,1,nil,1-tp) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c11451421.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_MZONE)
end
function c11451421.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(LOCATION_ONFIELD,0)
			e3:SetReset(RESET_PHASE+PHASE_END)
			e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6978))
			e3:SetValue(c11451421.value)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c11451421.value(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end