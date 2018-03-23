--六曜 与霓虹丘儿的接触
function c12005007.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005007,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c12005007.condition)
	e1:SetTarget(c12005007.target)
	e1:SetOperation(c12005007.operation)
	c:RegisterEffect(e1)
end
function c12005007.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsHasCategory(CATEGORY_DISABLE) or re:IsHasCategory(CATEGORY_NEGATE) or re:IsHasCategory(CATEGORY_DISABLE_SUMMON)
end
function c12005007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12005007.filter1(c)
	return c:IsSetCard(0xfbb)
end
function c12005007.sfilter(c,e,tp)
	return c:IsCode(12005011) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12005007.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) and Duel.IsExistingMatchingCard(c12005007.filter1,tp,LOCATION_HAND,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c12005007.filter1,tp,LOCATION_HAND,0,1,1,nil)
			local sc=Duel.GetFirstMatchingCard(c12005007.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
			if sc and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(12005007,1)) then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
