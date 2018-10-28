--HappySky·日野茜
function c81007104.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81007104.matfilter,1,1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81007104+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c81007104.spcon)
	e3:SetTarget(c81007104.sptg)
	e3:SetOperation(c81007104.spop)
	c:RegisterEffect(e3)
end
function c81007104.matfilter(c)
	return not c:IsLinkType(TYPE_TOKEN)
end
function c81007104.cfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsLink(4) and c:IsControler(tp)
end
function c81007104.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81007104.cfilter,1,nil,tp)
end
function c81007104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81007104.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
