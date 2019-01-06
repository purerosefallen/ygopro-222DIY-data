--辉忆的残片 相知
function c65020056.initial_effect(c)
	c:EnableReviveLimit()
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65020056)
	e1:SetCost(c65020056.cost)
	e1:SetTarget(c65020056.target)
	e1:SetOperation(c65020056.activate)
	c:RegisterEffect(e1)
	--give effect
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCost(c65020056.gvcost)
	e2:SetTarget(c65020056.gvtg)
	e2:SetOperation(c65020056.gvop)
	c:RegisterEffect(e2)
end
function c65020056.gvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5da3) and c:GetFlagEffect(65020056)==0
end
function c65020056.gvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,65020056)==0 end
	Duel.RegisterFlagEffect(tp,65020056,RESET_CHAIN,0,1)
end
function c65020056.gvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65020056.gvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65020056.gvfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65020056.gvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65020056.gvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(65020056,1))
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(c65020056.gavcon)
		e1:SetCost(c65020056.gavcost)
		e1:SetTarget(c65020056.gavtg)
		e1:SetOperation(c65020056.gavop)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(65020056,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65020056,0))
		tc:RegisterFlagEffect(65020056,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c65020056.gavcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and Duel.IsChainNegatable(ev)
end
function c65020056.cfilter(c)
	return c:IsDiscardable()
end
function c65020056.gavcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020056.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c65020056.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c65020056.gavtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(e) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
end
function c65020056.gavop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end

function c65020056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,c) and c:IsAbleToDeckAsCost() and not c:IsPublic() end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c65020056.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5da3) and c:IsAbleToHand()
end
function c65020056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020056.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020056.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65020056.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

