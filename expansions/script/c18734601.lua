--绀碧之境界 鹭泽文香
function c18734601.initial_effect(c)
	c:EnableReviveLimit()
   --negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35952884,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c18734601.discon2)
	e3:SetTarget(c18734601.distg2)
	e3:SetOperation(c18734601.disop2)
	c:RegisterEffect(e3)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17266660,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,18734601)
	e2:SetCondition(c18734601.discon)
	e2:SetCost(c18734601.discost)
	e2:SetTarget(c18734601.target)
	e2:SetOperation(c18734601.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function c18734601.discon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c18734601.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,tp,3)
end
function c18734601.disop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(re:GetHandler():GetType()) then
		   Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
		   Duel.Destroy(eg,REASON_EFFECT)
		end
		else
		   Duel.DiscardDeck(tp,3,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
function c18734601.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c18734601.costfilter(c)
	return c:IsSetCard(0xab4) and c:IsDestructable()
end
function c18734601.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c18734601.filter(c,e,tp)
	return c:IsSetCard(0xab4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18734601.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18734601.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c18734601.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18734601.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
