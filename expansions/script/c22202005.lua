--人体描边
function c22202005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22202005+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22202005.target)
	e1:SetOperation(c22202005.activate)
	c:RegisterEffect(e1)
end
function c22202005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	Duel.SetTargetCard(g)
	local mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local mc=g:GetFirst()
	while mc do
		if mg:IsContains(mc) then
			mg:RemoveCard(mc)
		end
		mc=g:GetNext()
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c22202005.chainlm)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,mg,mg:GetCount(),0,0)
end
function c22202005.chainlm(e,rp,tp)
	return tp~=rp
end
function c22202005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local mc=g:GetFirst()
	while mc do
		if mg:IsContains(mc) then
			mg:RemoveCard(mc)
		end
		mc=g:GetNext()
	end
	if mg:GetCount()>0 then Duel.Destroy(mg,REASON_EFFECT) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		Duel.RegisterEffect(e2,tp)
	end
end