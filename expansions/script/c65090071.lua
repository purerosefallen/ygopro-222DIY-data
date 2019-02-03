--天邪逆鬼的引诱
function c65090071.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65090071+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65090071.cost)
	e1:SetTarget(c65090071.tg)
	e1:SetOperation(c65090071.op)
	c:RegisterEffect(e1)
end
function c65090071.costfil(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x9da7) and c:IsType(TYPE_MONSTER)
end
function c65090071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetMatchingGroupCount(Card.IsCanBeEffectTarget,tp,0,LOCATION_ONFIELD,nil)
	if num>3 then num=3 end
	if chk==0 then return Duel.IsExistingMatchingCard(c65090071.costfil,tp,LOCATION_REMOVED,0,1,nil) and num>0 end
	local g=Duel.SelectMatchingCard(tp,c65090071.costfil,tp,LOCATION_REMOVED,0,1,num,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c65090071.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local num=e:GetLabel()
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,num,num,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c65090071.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end