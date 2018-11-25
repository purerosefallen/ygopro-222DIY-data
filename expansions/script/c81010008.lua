--赤城米莉亚
function c81010008.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c81010008.mfilter,1,1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,81010008,EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c81010008.spcon)
	e1:SetTarget(c81010008.sptg)
	e1:SetOperation(c81010008.spop)
	c:RegisterEffect(e1)
end
function c81010008.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkAttribute(ATTRIBUTE_WIND)
end
function c81010008.cfilter(c)
	return c:IsFacedown() or not (c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLinkAbove(4))
end
function c81010008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c81010008.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81010008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81010008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end