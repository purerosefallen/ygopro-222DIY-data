--自残落都市的佚页
function c65050031.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65050031+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65050031.con)
	e1:SetCost(c65050031.cost)
	e1:SetTarget(c65050031.tg)
	e1:SetOperation(c65050031.op)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c65050031.tdcost)
	e2:SetTarget(c65050031.tdtg)
	e2:SetOperation(c65050031.tdop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c65050031.actcon)
	c:RegisterEffect(e3)
end
function c65050031.hdcostfil(c)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c65050031.actcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65050031.hdcostfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
end
function c65050031.confil(c)
	return c:IsFacedown() or not c:IsType(TYPE_NORMAL) or c:IsType(TYPE_TOKEN)
end
function c65050031.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c65050031.confil,tp,LOCATION_MZONE,0,nil)==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and (Duel.IsChainNegatable(ev) or Duel.IsChainDisablable(ev)) and re:GetHandlerPlayer()~=tp
end
function c65050031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local g=Duel.SelectMatchingCard(tp,c65050031.hdcostfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c65050031.tgfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function c65050031.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050031.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65050031.op(e,tp,eg,ep,ev,re,r,rp)
	local num=0
	if Duel.NegateActivation(ev) then num=1 end
	if num==0 and Duel.NegateEffect(ev) then num=1 end
	if num==1 then
		local g=Duel.SelectMatchingCard(tp,c65050031.tgfil,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c65050031.tdcostfil(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c65050031.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050031.costfil,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65050031.costfil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65050031.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c65050031.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
