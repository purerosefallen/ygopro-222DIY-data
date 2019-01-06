--秽血蜘蛛
function c65080050.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65080050)
	e1:SetCost(c65080050.cost)
	e1:SetTarget(c65080050.tg)
	e1:SetOperation(c65080050.op)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(65080050,ACTIVITY_SPSUMMON,c65080050.counterfilter)
end
function c65080050.counterfilter(c)
	return c:IsRace(RACE_INSECT)
end
function c65080050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65080050,tp,ACTIVITY_SPSUMMON)==0 and e:GetHandler():IsDiscardable(REASON_COST) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65080050.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c65080050.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_INSECT 
end
function c65080050.filter(c,e,tp)
	return ((c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and c:IsLevel(4)) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_INSECT) and c:IsType(TYPE_TUNER))) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsAbleToHand())
end
function c65080050.filter1(c,e,tp)
	return ((c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and c:IsLevel(4)) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_INSECT) and c:IsType(TYPE_TUNER))) and c:IsAbleToHand()
end
function c65080050.filter2(c,e,tp)
	return ((c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_INSECT) and c:IsLevel(4)) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_INSECT) and c:IsType(TYPE_TUNER))) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c65080050.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080050.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65080050.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c65080050.filter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	local b1=Duel.IsExistingMatchingCard(c65080050.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c65080050.filter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	local m=0
	if b1 and not b2 then m=0 end
	if b1 and b2 then
		local p=Duel.SelectOption(tp,aux.Stringid(65080050,0),aux.Stringid(65080050,1))
		m=p
	end
	if m==0 then
		local g=Duel.SelectMatchingCard(tp,c65080050.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif m==1 then
		local gn=Duel.SelectMatchingCard(tp,c65080050.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(gn,0,tp,tp,false,false,POS_FACEUP)
	end
end
