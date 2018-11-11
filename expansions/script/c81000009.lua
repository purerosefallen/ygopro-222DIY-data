--Answer·横山奈绪
c81000009.dfc_front_side=81000009
c81000009.dfc_back_side=81000010
function c81000009.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81000009.mfilter,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81000009)
	e1:SetTarget(c81000009.target)
	e1:SetOperation(c81000009.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81000009)
	e2:SetCondition(c81000009.spcon)
	e2:SetTarget(c81000009.sptg)
	e2:SetOperation(c81000009.spop)
	c:RegisterEffect(e2)
end
function c81000009.mfilter(c)
	return c:IsLinkRace(RACE_FIEND) and not c:IsLinkType(TYPE_TOKEN)
end
function c81000009.filter(c,e,tp,zone)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp,zone)
end
function c81000009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c81000009.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81000009.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81000009.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE,zone)
	end
end
function c81000009.cfilter(c,tp)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsControler(tp)
end
function c81000009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81000009.cfilter,1,nil,tp)
end
function c81000009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81000009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local c=e:GetHandler()
		local tcode=c.dfc_back_side
		c:SetEntityCode(tcode,true)
		c:ReplaceEffect(tcode,0,0)
	end
end
