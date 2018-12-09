--雷与火之歌
function c75646201.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646201+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75646201.target)
	e1:SetOperation(c75646201.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,5646201)
	e2:SetCost(c75646201.cost)
	e2:SetTarget(c75646201.tg)
	e2:SetOperation(c75646201.op)
	c:RegisterEffect(e2)
end
function c75646201.filter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c75646201.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c75646201.filter,tp,LOCATION_DECK,0,1,nil,75646164)
	local b2=Duel.IsExistingMatchingCard(c75646201.filter,tp,LOCATION_DECK,0,1,nil,75646165)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(75646201,0),aux.Stringid(75646201,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(75646201,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(75646201,1))+1
	end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75646201.filter1(c)
	return c:IsAbleToRemove()
end
function c75646201.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75646201.filter,tp,LOCATION_DECK,0,1,1,nil,75646164)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c75646201.filter1),tp,0,LOCATION_GRAVE,nil)
			if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75646201,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=mg:Select(tp,1,1,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c75646201.filter,tp,LOCATION_DECK,0,1,1,nil,75646165)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c75646201.cfilter(c)
	return (c:IsCode(75646164) or c:IsCode(75646165)) and c:IsAbleToRemoveAsCost()
end
function c75646201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c75646201.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75646165.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c75646201.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c75646201.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end