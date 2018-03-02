--强制突破
function c22202101.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c22202101.con)
	e1:SetCost(c22202101.cost)
	e1:SetOperation(c22202101.op)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c22202101.con(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_NEGATE) or re:IsHasCategory(CATEGORY_DISABLE) or re:IsHasCategory(CATEGORY_DISABLE_SUMMON)
end
function c23002292.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return 
		if c:IsLocation(LOCATION_HAND) then
			return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,c)
		else
			return true
		end
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c22202101.filter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToGrave()
end
function c22202101.op(e,tp,eg,ep,ev,re,r,rp)
	local rtype=bit.band(re:GetActiveType(),0x7)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c22202101.repop)
	if Duel.IsExistingMatchingCard(c22202101.filter,tp,LOCATION_DECK,0,1,nil,rtype) and Duel.SelectYesNo(tp,aux.Stringid(22202101,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c22202101.filter,tp,LOCATION_DECK,0,1,1,nil,rtype)
		if sg:GetCount()>0 then Duel.SendtoGrave(sg,REASON_EFFECT) end
	end
end
function c22202101.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		c:CancelToGrave(false)
	end
	Duel.SendtoGrave(c,REASON_EFFECT)
end