--一炎入魂·日野茜
function c81009019.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c81009019.mfilter,c81009019.xyzcheck,2,99)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81009019.condition)
	e1:SetCost(c81009019.cost)
	e1:SetOperation(c81009019.operation)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81009019.dicecon)
	e2:SetOperation(c81009019.diceop)
	c:RegisterEffect(e2)	
end
function c81009019.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN)
end
function c81009019.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c81009019.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81099919)==0
end
function c81009019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,81099919,RESET_PHASE+PHASE_END,0,1)
end
function c81009019.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TOSS_DICE_NEGATE)
		e1:SetCondition(c81009019.coincon)
		e1:SetOperation(c81009019.coinop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c81009019.coincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81009919)==0
end
function c81009019.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,81009919)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(81009019,0)) then
		Duel.Hint(HINT_CARD,0,81009019)
		Duel.RegisterFlagEffect(tp,81009919,RESET_PHASE+PHASE_END,0,1)
		local ct1=bit.band(ev,0xff)
		local ct2=bit.rshift(ev,16)
		Duel.TossDice(ep,ct1,ct2)
	end
end
function c81009019.dicecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(81009019)==0
end
function c81009019.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if c81009019[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(81009019,1)) then
		Duel.Hint(HINT_CARD,0,81009019)
		e:GetHandler():RegisterFlagEffect(81009019,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81009019,2))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
			ac=idx+1
		end
		dc[ac]=8
		Duel.SetDiceResult(table.unpack(dc))
		c81009019[0]=cid
	end
end
