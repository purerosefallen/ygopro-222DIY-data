--天狐秘术-闪
function c2161006.initial_effect(c)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,2161006+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c2161006.target)
	e1:SetOperation(c2161006.activate)
	c:RegisterEffect(e1)
end
function c2161006.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c2161006.spfilter(c,e,tp)
	return c:IsSetCard(0x21e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2161006.filter2(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x21e) and c:IsControler(tp)
end
function c2161006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c2161006.filter(chkc) and chkc~=e:GetHandler() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c2161006.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c2161006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c2161006.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	 if g:IsExists(c2161006.filter2,1,nil,tp)  then
	 Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c2161006.filter3(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x21e) and c:IsControler(tp)
end
function c2161006.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local fv=0
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and
	Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	if Duel.GetOperatedGroup():IsExists(c2161006.filter3,1,nil,tp) then fv=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c2161006.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	end
	if fv==1 then
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	end
end