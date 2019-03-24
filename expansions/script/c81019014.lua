--青色天使·SUKIA
function c81019014.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,81019014)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c81019014.cost)
	e1:SetTarget(c81019014.sptg)
	e1:SetOperation(c81019014.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c81019014.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c81019014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c81019014.spfilter(c,e,tp)
	return c:IsLevel(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81019014.filter(c)
	return c:IsCode(81019013) and c:IsFaceup()
end
function c81019014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local loc=LOCATION_HAND
		if Duel.IsExistingMatchingCard(c81019014.filter,tp,LOCATION_MZONE,0,1,nil) then
			loc=loc+LOCATION_DECK
		end
		return Duel.IsExistingMatchingCard(c81019014.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c81019014.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND
	if Duel.IsExistingMatchingCard(c81019014.filter,tp,LOCATION_MZONE,0,1,nil) then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81019014.spfilter),tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c81019014.indfilter(c)
	return c:IsFaceup() and c:IsCode(81019013)
end
function c81019014.indcon(e)
	return Duel.IsExistingMatchingCard(c81019014.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
