--降诞的二重阴影
function c65030026.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c65030026.matfilter,1,1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c65030026.sptg)
	e2:SetOperation(c65030026.spop)
	c:RegisterEffect(e2)
end
function c65030026.matfilter(c)
	return not c:IsLinkType(TYPE_EFFECT)
end
function c65030026.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_NORMAL)
end
function c65030026.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsType(TYPE_NORMAL)
end
function c65030026.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65030026.spfilter1(chkc,e,tp,zone) end
	if chk==0 then return Duel.IsExistingTarget(c65030026.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c65030026.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c65030026.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		if tc:IsType(TYPE_DUAL) and Duel.SelectYesNo(tp,aux.Stringid(65030026,0)) then
			tc:EnableDualState()
		end
		if Duel.SpecialSummonComplete()~=0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		end
	end
end