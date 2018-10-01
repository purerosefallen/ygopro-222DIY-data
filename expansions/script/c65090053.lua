--星之骑士拟身 魔术
function c65090053.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090053)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,false,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65090053,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetTarget(c65090053.target)
	e1:SetOperation(c65090053.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65090053,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c65090053.cost)
	e2:SetTarget(c65090053.tg)
	e2:SetOperation(c65090053.op)
	c:RegisterEffect(e2)
end
function c65090053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c65090053.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65090053.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,5,5,nil)
	if g:GetCount()==5 then
		Duel.ConfirmCards(1-tp,g)
		local gc=g:RandomSelect(1-tp,1)
		Duel.SendtoHand(gc,tp,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end
function c65090053.filter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c65090053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c65090053.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65090053.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65090053.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c65090053.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end