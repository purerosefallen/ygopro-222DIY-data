--绿毛
function c5012605.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c5012605.mfilter,c5012605.xyzcheck,2,2,c5012605.ovfilterx,aux.Stringid(5012605,3))
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c5012605.thcon)
	e3:SetTarget(c5012605.thtg)
	e3:SetOperation(c5012605.thop)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5012605,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCost(c5012605.cost)
	e4:SetTarget(c5012605.tg)
	e4:SetOperation(c5012605.op)
	c:RegisterEffect(e4)
	--hand
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(5012605,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetTarget(c5012605.tg2)
	e5:SetOperation(c5012605.op2)
	c:RegisterEffect(e5)
	--to deck
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(5012605,2))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetTarget(c5012605.tg3)
	e6:SetOperation(c5012605.op3)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c5012605.atkval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
end
function c5012605.mfilter(c,xyzc)
	return c:IsSetCard(0x250) and c:IsFaceup() and c:IsLevelAbove(4) and not c:IsType(TYPE_TOKEN)
end
function c5012605.xyzcheck(g)
	return g:FilterCount(Card.IsLevelAbove,nil,4)==g:GetCount()
end
function c5012605.ovfilterx(c)
	return c:IsFaceup() and c:IsSetCard(0x250) and c:IsLevelAbove(7) 
end
function c5012605.over(c,g)
	return c:IsFaceup() and c:IsSetCard(0x250) and c:IsLevelAbove(7) and not c:IsType(TYPE_TOKEN)
	and c:IsCanBeXyzMaterial(g)
end
function c5012605.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c5012605.overcon(e,c)
	if  Duel.IsExistingMatchingCard(c5012605.over,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,e:GetHandler()) then return true
	else return false end
end
function c5012605.overop(e,tp,eg,ep,ev,re,r,rp,c) 
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c5012605.over,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,1,nil,e:GetHandler())
	if g:GetCount()==1  then
	Duel.Overlay(c,g)
end
end
function c5012605.ovfilter(c,g)
	return c:IsSetCard(0x250)  and c:IsFaceup() and c:IsLevelAbove(4) and c:IsCanBeXyzMaterial(g)
end
function c5012605.spcon(e,c)
	if  Duel.IsExistingMatchingCard(c5012605.ovfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil,e:GetHandler()) then return true
	else return false end
end
function c5012605.spop(e,tp,eg,ep,ev,re,r,rp,c) 
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c5012605.ovfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,2,nil,e:GetHandler())
	if g:GetCount()==2  then
	Duel.Overlay(c,g)
end
end
function c5012605.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c5012605.thfilter(c)
	return c:IsCode(5012601)  and c:IsAbleToHand()
end
function c5012605.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c5012605.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5012605.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c5012605.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c5012605.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c5012605.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c5012605.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c5012605.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	local tc=g:RandomSelect(tp,1)
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) 
end
function c5012605.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c5012605.op3(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
end