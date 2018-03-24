--LA CY 牙月丘依儿
function c12010056.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,c12010056.matfilter,2,2)
	c:EnableReviveLimit()
--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12010056,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c12010056.drcost)
	e2:SetCondition(c12010056.drcon)
	e2:SetTarget(c12010056.sptg)
	e2:SetOperation(c12010056.spop)
	c:RegisterEffect(e2)
end
function c12010056.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_LINK 
end
function c12010056.matfilter(c)
	return c:IsSetCard(0xfba)
end
function c12010056.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c12010056.filter(c,e,tp)
	return c:IsSetCard(0xfba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c12010056.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((e:GetHandler():GetSequence()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or e:GetHandler():GetSequence()<5) and Duel.IsExistingMatchingCard(c12010056.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c12010056.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12010056.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
