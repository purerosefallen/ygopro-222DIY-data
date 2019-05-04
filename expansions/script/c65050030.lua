--在残落都市的晚宴
function c65050030.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c65050030.cost)
	e1:SetTarget(c65050030.tg)
	e1:SetOperation(c65050030.op)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c65050030.tdcost)
	e2:SetTarget(c65050030.tdtg)
	e2:SetOperation(c65050030.tdop)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c65050030.actcon)
	c:RegisterEffect(e3)
end
function c65050030.hdcostfil(c)
	return c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c65050030.actcon(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65050030.hdcostfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
end
function c65050030.confil(c)
	return c:IsFacedown() or not c:IsType(TYPE_NORMAL) 
end
function c65050030.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c65050030.confil,tp,LOCATION_MZONE,0,nil)==0
end
function c65050030.costfil(c)
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_NORMAL) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c65050030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050030.costfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,5,nil) end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		local g=Duel.SelectMatchingCard(tp,c65050030.hdcostfil,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
	local g=Duel.SelectMatchingCard(tp,c65050030.costfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,5,5,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c65050030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c65050030.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c65050030.tdcostfil(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_NORMAL) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c65050030.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65050030.costfil,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65050030.costfil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65050030.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c65050030.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
