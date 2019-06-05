--最上静香的苦涩抉择
function c81018031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81018031+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81018031.atktg)
	e1:SetOperation(c81018031.atkop)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81018931)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c81018031.countertg)
	e2:SetOperation(c81018031.counterop)
	c:RegisterEffect(e2)
end
function c81018031.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x81b)
end
function c81018031.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c81018031.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c81018031.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
end
function c81018031.atkop(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==hc then tc=g:GetNext() end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if hc:IsFaceup() and hc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_ATTACK_FINAL)
			e2:SetValue(hc:GetAttack()*2)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			hc:RegisterEffect(e2)
		end
	end
end
function c81018031.cfilter(c)
	return c:IsSetCard(0x81b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c81018031.tgfilter(c,e)
	return c:IsFaceup() and c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanBeEffectTarget(e) and c:IsCanAddCounter(0x1810,1)
end
function c81018031.countertg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c81018031.tgfilter(chkc,e) end
	local tg=Duel.GetMatchingGroup(c81018031.tgfilter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and tg:GetCount()>0
		and Duel.IsExistingMatchingCard(c81018031.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81018031.cfilter,tp,LOCATION_GRAVE,0,1,tg:GetCount(),nil)
	local ct=g:GetCount()
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=tg:Select(tp,ct,ct,nil)
	Duel.SetTargetCard(sg)
end
function c81018031.counterop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1810,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c81018031.condition)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_MUST_ATTACK)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(81018031,RESET_EVENT+RESETS_STANDARD,0,0)
		tc=g:GetNext()
	end
end
function c81018031.condition(e)
	return e:GetHandler():GetCounter(0x1810)>0 and e:GetHandler():GetFlagEffect(81018031)~=0
end
