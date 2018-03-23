--六曜 与牙月丘儿的接触
function c12005008.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005008,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c12005008.condition)
	e1:SetTarget(c12005008.target)
	e1:SetOperation(c12005008.operation)
	c:RegisterEffect(e1)
end
function c12005008.condition(e,tp,eg,ep,ev,re,r,rp)
	local ex4=re:IsHasCategory(CATEGORY_DRAW)
	local ex5=re:IsHasCategory(CATEGORY_TOHAND)
	return ( ex4 or ex5 ) and Duel.IsChainDisablable(ev)
end
function c12005008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12005008.filter1(c)
	return c:IsSetCard(0xfbb)
end
function c12005008.sfilter(c,e,tp)
	return c:IsCode(12005012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12005008.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) and Duel.IsExistingMatchingCard(c12005008.filter1,tp,LOCATION_HAND,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c12005008.filter1,tp,LOCATION_HAND,0,1,1,nil)
			local sc=Duel.GetFirstMatchingCard(c12005008.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
			if sc and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(12005008,1)) then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
