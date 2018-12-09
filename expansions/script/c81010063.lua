--Answer·北条加莲·Primus
c81010063.dfc_front_side=81010062
c81010063.dfc_back_side=81010063
function c81010063.initial_effect(c)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetValue(81010019)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,81010063)
	e2:SetCondition(c81010063.condition)
	e2:SetCost(c81010063.cost)
	e2:SetOperation(c81010063.activate)
	c:RegisterEffect(e2)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81010063,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81010963)
	e2:SetTarget(c81010063.tdtg)
	e2:SetOperation(c81010063.tdop)
	c:RegisterEffect(e2)
end
function c81010063.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c81010063.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c81010063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010063.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81010063.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81010063.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end
function c81010063.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c81010063.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81010063.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81010063.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81010063.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c81010063.setfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c81010063.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local g=Duel.GetMatchingGroup(c81010063.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81010063,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
