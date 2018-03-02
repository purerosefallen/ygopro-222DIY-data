--一起活下去
function c75646028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(0x20008)
	e1:SetType(0x10)
	e1:SetCode(1017)
	e1:SetProperty(0x4000+EFFECT_FLAG_DELAY)
	e1:SetCondition(c75646028.condition)
	e1:SetTarget(c75646028.target)
	e1:SetOperation(c75646028.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c75646028.drcost)
	e2:SetTarget(c75646028.drtg)
	e2:SetOperation(c75646028.drop)
	c:RegisterEffect(e2)
end
function c75646028.ctfilter(c,tp)
	return c:IsReason(0x2) and c:IsPreviousLocation(0xe)
end
function c75646028.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646028.ctfilter,1,nil,tp)
end
function c75646028.filter(c)
	return c:GetAttack()==1750 and c:GetDefense()==1350 and c:IsAbleToHand()
end
function c75646028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646028.filter,tp,1,0,1,nil) end
	Duel.SetOperationInfo(0,0x8,nil,1,tp,1)
end
function c75646028.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,506)
	local g=Duel.SelectMatchingCard(tp,c75646028.filter,tp,0x1,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,0x40)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75646028.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c75646028.filter1(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToDeck()
		and c:GetAttack()==1750 and c:GetDefense()==1350
end
function c75646028.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetMatchingGroup(c75646028.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode)>3 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c75646028.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75646028.filter1,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e)
	if g:GetClassCount(Card.GetCode)>3 then
	local sg=Group.CreateGroup()
		for i=1,4 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g1=g:Select(tp,1,1,nil)
			g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
			sg:Merge(g1)
		end
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==4 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	end
end