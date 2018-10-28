--Answer·浅野风香
function c81011044.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c81011044.mfilter,c81011044.xyzcheck,2,99)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TOSS_DICE_NEGATE)
	e1:SetCountLimit(1,81011044)
	e1:SetCondition(c81011044.coincon)
	e1:SetOperation(c81011044.coinop)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81011044.dicecon)
	e2:SetOperation(c81011044.diceop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c81011044.reptg)
	c:RegisterEffect(e3)
end
function c81011044.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER)
end
function c81011044.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c81011044.coincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81011044)==0
end
function c81011044.coinop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,81011044)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(81011044,0)) then
		Duel.Hint(HINT_CARD,0,81011044)
		Duel.RegisterFlagEffect(tp,81011044,RESET_PHASE+PHASE_END,0,1)
		local ct1=bit.band(ev,0xff)
		local ct2=bit.rshift(ev,16)
		Duel.TossDice(ep,ct1,ct2)
	end
end
function c81011044.dicecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and c:GetFlagEffect(81011044)==0
end
function c81011044.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if c81011044[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(81011044,1)) then
		Duel.Hint(HINT_CARD,0,81011044)
		e:GetHandler():RegisterFlagEffect(81011044,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81011044,2))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
			ac=idx+1
		end
		dc[ac]=8
		Duel.SetDiceResult(table.unpack(dc))
		c81011044[0]=cid
	end
end
function c81011044.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
