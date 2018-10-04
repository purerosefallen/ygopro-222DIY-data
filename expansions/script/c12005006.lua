--六曜 与虹光丘儿的接触
function c12005006.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005006,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(c12005006.condition)
	e1:SetTarget(c12005006.target)
	e1:SetOperation(c12005006.operation)
	c:RegisterEffect(e1)
end
--function c12005006.condition(e,tp,eg,ep,ev,re,r,rp)
--  if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
--  if re:IsHasCategory(CATEGORY_NEGATE)
--  and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
--  local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
--  return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
--end
function c12005006.filter11(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c12005006.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12005006.filter11,1,nil) and Duel.IsChainDisablable(ev)
end
function c12005006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12005006.filter1(c)
	return c:IsSetCard(0xfbb)
end
function c12005006.sfilter(c,e,tp)
	return c:IsCode(12005010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12005006.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c12005006.filter1,tp,LOCATION_HAND,0,1,nil) then
			local sc=Duel.GetFirstMatchingCard(c12005006.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
			if sc and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(12005006,1)) then
			local g=Duel.SelectMatchingCard(tp,c12005006.filter1,tp,LOCATION_HAND,0,1,1,nil)
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end