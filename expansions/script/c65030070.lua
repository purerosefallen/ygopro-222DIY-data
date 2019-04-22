--终景见证·序
function c65030070.initial_effect(c)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65030070+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65030070.tg)
	e1:SetOperation(c65030070.op)
	c:RegisterEffect(e1)
end
function c65030070.stfil(c)
	return c:IsSetCard(0x6da2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function c65030070.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030070.stfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and ((e:GetHandler():IsLocation(LOCATION_SZONE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1)) end
end
function c65030070.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65030070.stfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end