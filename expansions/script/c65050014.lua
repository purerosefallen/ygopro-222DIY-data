--迷失水界的群游
function c65050014.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c65050014.matfilter,1,1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65050014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c65050014.hspcon)
	e1:SetTarget(c65050014.hsptg)
	e1:SetOperation(c65050014.hspop)
	c:RegisterEffect(e1)
end
function c65050014.matfilter(c)
	return c:IsLinkRace(RACE_AQUA) and c:IsLevel(3)
end
function c65050014.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65050014.hspfilter(c,e,tp)
	return c:IsSetCard(0xcda3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65050014.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65050014.hspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65050014.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65050014.hspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end