--终焉之噬
function c22201003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(c,22201003+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22201003.target)
	e1:SetOperation(c22201003.activate)
	c:RegisterEffect(e1)
	--SSet
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c22201003.con)
	e2:SetOperation(c22201003.op)
	c:RegisterEffect(e2)
end
function c22201003.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c22201003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22201003.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22201003.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22201003.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22201003.rmfilter(c,p)
	return Duel.IsPlayerCanRemove(p,c) and not c:IsType(TYPE_TOKEN)
end
function c22201003.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)==0 then
			if Duel.IsPlayerAffectedByEffect(1-tp,30459350) then return end
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):FilterSelect(1-tp,c22201003.rmfilter,1,1,nil,1-tp)
			Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
		end
	else
		if Duel.IsPlayerAffectedByEffect(1-tp,30459350) then return end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):FilterSelect(1-tp,c22201003.rmfilter,1,1,nil,1-tp)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
end
function c22201003.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c22201003.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCountLimit(1)
	e1:SetOperation(c22201003.retop)
	c:RegisterEffect(e1)
end
function c22201003.retop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_REMOVED) then return end
	if c:IsSSetable(false) and Duel.SelectYesNo(tp,aux.Stringid(22201003,0)) then
		Duel.Hint(HINT_CARD,0,22201003)
		Duel.SSet(tp,c,tp)
		Duel.ConfirmCards(1-tp,c)
	end
end