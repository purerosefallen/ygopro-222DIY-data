--Answer·村松樱
function c81012026.initial_effect(c)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c81012026.chainop)
	c:RegisterEffect(e1)
end
function c81012026.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and rc:IsRace(RACE_FAIRY) then
		Duel.SetChainLimit(c81012026.chainlm)
	end
end
function c81012026.chainlm(e,rp,tp)
	return tp==rp
end
