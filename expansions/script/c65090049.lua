--星之骑士拟身 针刺
function c65090049.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090049)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),1,true,true)
	--change target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65090049.tgcon)
	e1:SetTarget(c65090049.tgtg)
	e1:SetOperation(c65090049.tgop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e3)
end
function c65090049.tgfil(c,tp)
	return c:IsControler(tp) and c:IsOnField()
end
function c65090049.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g:IsExists(c65090049.tgfil,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c65090049.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c65090049.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
	end
end