--光符·彩符『极彩台风』
function c15415173.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c15415173.target)
	e1:SetOperation(c15415173.activate)
	c:RegisterEffect(e1)	
end
function c15415173.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c15415173.filters(c,e,tp)
	return c:IsSetCard(0x161) and c:IsLevelBelow(4) and c:IsType(TYPE_PENDULUM)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c15415173.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c15415173.filter(chkc) and chkc~=e:GetHandler() and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c15415173.filters,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c15415173.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) 
		and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c15415173.filters,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c15415173.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c15415173.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		  if Duel.GetLocationCountFromEx(tp)<=0 then return end
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local g=Duel.SelectMatchingCard(tp,c15415173.filters,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		  local tc=g:GetFirst()
		  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end