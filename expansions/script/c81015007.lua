--北上丽花的瞎jb吹
function c81015007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81015007+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81015007.condition)
	e1:SetCost(c81015007.cost)
	e1:SetTarget(c81015007.target)
	e1:SetOperation(c81015007.activate)
	c:RegisterEffect(e1)
end
function c81015007.sfilter(c)
	return c:GetSequence()<5 and c:IsFacedown()
end
function c81015007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81015007.sfilter,tp,LOCATION_SZONE,0,2,nil)
end
function c81015007.cfilter(c)
	return c:IsSetCard(0x81a) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c81015007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81015007.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81015007.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81015007.filter(c,e,tp)
	return c:IsSetCard(0x81a) and c:IsLinkBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c81015007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c81015007.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c81015007.sfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingTarget(c81015007.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local dg=Duel.GetMatchingGroup(c81015007.sfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81015007.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81015007.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c81015007.sfilter,tp,LOCATION_SZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)~=dg:GetCount() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e2,true)
	end
end