--对未来的仰望
function c81009028.initial_effect(c)
	c:EnableCounterPermit(0x81f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c81009028.ctcon)
	e2:SetOperation(c81009028.ctop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,81009028)
	e3:SetCost(c81009028.thcost)
	e3:SetTarget(c81009028.thtg)
	e3:SetOperation(c81009028.thop)
	c:RegisterEffect(e3)
	--sp summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,81009928)
	e4:SetCondition(c81009028.spcon)
	e4:SetTarget(c81009028.sptg)
	e4:SetOperation(c81009028.spop)
	c:RegisterEffect(e4)
end
function c81009028.ctfilter(c,tp)
	return c:IsFaceup() and c:IsCode(81010019) and c:IsControler(tp)
end
function c81009028.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81009028.ctfilter,1,nil,tp)
end
function c81009028.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x81f,1)
end
function c81009028.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x81f,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x81f,3,REASON_COST)
end
function c81009028.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c81009028.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81009028.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81009028.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81009028.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81009028.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_FZONE)
end
function c81009028.spfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_FAIRY) and c:IsLevel(7) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c81009028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81009028.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81009028.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81009028.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
