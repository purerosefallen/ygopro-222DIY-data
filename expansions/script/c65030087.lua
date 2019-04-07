--郁蓝色的望窗
function c65030087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65030087+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65030087.con)
	e1:SetTarget(c65030087.tg)
	e1:SetOperation(c65030087.op)
	c:RegisterEffect(e1)
end
c65030087.card_code_list={65030086}
function c65030087.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c65030087.b1fil(c)
	return aux.IsCodeListed(c,65030086) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToHand()
end
function c65030087.b2fil(c)
	return aux.IsCodeListed(c,65030086) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c65030087.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65030087.b1fil,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65030087.b2fil,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local m=3
	if b1 and b2 then
		m=Duel.SelectOption(tp,aux.Stringid(65030087,0),aux.Stringid(65030087,1))
	elseif b1 then
		m=0
	elseif b2 then
		m=1
	end
	e:SetLabel(m)
	if m==0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	elseif m==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c65030087.op(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	local b1=Duel.IsExistingMatchingCard(c65030087.b1fil,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65030087.b2fil,tp,LOCATION_DECK,0,1,nil)
	if m==0 and b1 then
		local g1=Duel.SelectMatchingCard(tp,c65030087.b1fil,tp,LOCATION_EXTRA,0,1,1,nil)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	elseif m==1 and b2 then
		local g2=Duel.SelectMatchingCard(tp,c65030087.b2fil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
end