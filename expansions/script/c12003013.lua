--无眠的海底之都
function c12003013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12003013,0))
	e1:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12003013.target)
	e1:SetOperation(c12003013.activate)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12003013,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(c12003013.reptg)
	e4:SetValue(c12003013.repval)
	c:RegisterEffect(e4)
end
function c12003013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c12003013.filter(c)
	return c:IsAbleToHand() and c:IsRace(RACE_SEASERPENT) and c:GetAttack()==800
end
function c12003013.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c12003013.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12003013,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c12003013.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			Duel.ShuffleDeck(tp)
			g:Sub(sg)
		end
	end
end
function c12003013.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:GetDestination()==LOCATION_DECK and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end
function c12003013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0xfb8) and eg:IsExists(c12003013.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(12003013,3)) then
		local g=eg:Filter(c12003013.repfilter,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,ct,nil)
		end
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_DECK_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(12003013,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(c12003013.thcon)
		e1:SetOperation(c12003013.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		return true
	else return false end
end
function c12003013.repval(e,c)
	return false
end
function c12003013.thfilter(c)
	return c:GetFlagEffect(12003013)~=0
end
function c12003013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12003013.thfilter,1,nil)
end
function c12003013.opfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function c12003013.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c12003013.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hg:GetCount()>=5 then
		Duel.BreakEffect()
		Duel.SendtoDeck(hg,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,5,REASON_EFFECT)
		local hc=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local gn=Group.CreateGroup()
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local sg=hc:Filter(c12003013.opfilter,nil)
		if ft>0 and sg:GetCount()>0 then
			local tc=sg:GetFirst()
			while tc do
				gn:AddCard(tc)
				tc=sg:GetNext()
			end
			if gn:GetCount()>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local tg=gn:Select(tp,ft,ft,nil)
				Duel.SSet(tp,tg)
			else
				if gn:GetCount()>0 then Duel.SSet(tp,gn) end
			end
		end
	end
end