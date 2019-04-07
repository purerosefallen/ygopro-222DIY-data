--茶话会·德川茉莉
function c26804003.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c26804003.mfilter,2)
	c:EnableReviveLimit()
	--immune effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c26804003.immunefilter)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c26804003.indes)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,26804003)
	e3:SetCondition(c26804003.spcon)
	e3:SetCost(c26804003.spcost)
	e3:SetTarget(c26804003.sptg)
	e3:SetOperation(c26804003.spop)
	c:RegisterEffect(e3)
end
function c26804003.mfilter(c)
	return c:IsAttackBelow(2000) and not c:IsLinkType(TYPE_TOKEN)
end
function c26804003.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner() and te:GetHandler():IsAttackAbove(2000)
end
function c26804003.indes(e,c)
	return c:IsAttackAbove(2000)
end
function c26804003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c26804003.spcfilter(c,tp,zone)
	return c:IsAttackBelow(2000) and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c26804003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c26804003.spcfilter,1,c,tp,zone) end
	local g=Duel.SelectReleaseGroup(tp,c26804003.spcfilter,1,1,c,tp,zone)
	Duel.Release(g,REASON_COST)
end
function c26804003.spfilter(c,e,tp)
	return c:IsSetCard(0x600) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26804003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26804003.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26804003.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c26804003.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
