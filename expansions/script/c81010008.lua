--平行少女世界
function c81010008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81010008.cost)
	e1:SetTarget(c81010008.target)
	e1:SetOperation(c81010008.activate)
	c:RegisterEffect(e1)
end
function c81010008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,81008004) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,81008004)
	Duel.Release(g,REASON_COST)
end
function c81010008.filter(c)
	return c:IsCode(81000016,81000017,81014027,81007003) and c:IsAbleToHand()
end
function c81010008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010008.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81010008.check(g)
	if #g==1 then return true end
	local res=0x0
	if g:IsExists(Card.IsCode,1,nil,81000016) then res=res+0x1 end
	if g:IsExists(Card.IsCode,1,nil,81000017) then res=res+0x2 end
	if g:IsExists(Card.IsCode,1,nil,81014027) then res=res+0x4 end
	if g:IsExists(Card.IsCode,1,nil,81007003) then res=res+0x8 end
	return res~=0x1 and res~=0x2 and res~=0x4 and res~=0x8
end
function c81010008.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81010008.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:SelectSubGroup(tp,c81010008.check,false,1,2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end
