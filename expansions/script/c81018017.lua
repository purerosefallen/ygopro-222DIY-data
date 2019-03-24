--动物朋友·最上静香
require("expansions/script/c81000000")
function c81018017.initial_effect(c)
    Tenka.Shizuka(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81018017)
	e2:SetCondition(c81018017.spcon)
	e2:SetTarget(c81018017.sptg)
	e2:SetOperation(c81018017.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c81018017.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c81018017.cfilter(c)
	return c:IsFaceup() and c:IsLevel(9)
end
function c81018017.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81018017.cfilter,1,nil)
end
function c81018017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81018017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c81018017.indtg(e,c)
	return c:IsLevel(9)
end
