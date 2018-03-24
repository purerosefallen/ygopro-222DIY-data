--畅叙幽情 疑雾
function c10920404.initial_effect(c)
	 --activate trap in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(c10920404.operation)
	c:RegisterEffect(e1)
	--excavate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10920404,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10920404)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10920404.thtg)
	e2:SetOperation(c10920404.thop)
	c:RegisterEffect(e2)
end
function c10920404.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c10920404.target)
	Duel.RegisterEffect(e1,tp)
end 
function c10920404.target(e,c)
	return c:IsType(TYPE_COUNTER) 
end
function c10920404.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c10920404.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c10920404.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
	   if g:IsExists(c10920404.filter,1,nil) then
		  if Duel.SelectYesNo(tp,aux.Stringid(10920404,2)) then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:FilterSelect(tp,c10920404.filter,1,1,nil)
			 if sg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			 else
				Duel.SendtoGrave(sg,REASON_RULE)
			 end
		  end
		  Duel.ShuffleDeck(tp)
	   end
	end
end