--A-chasing-Y
function c81010002.initial_effect(c)
	e1=aux.AddRitualProcGreater2(c,c81010002.filter,LOCATION_HAND,c81010002.mfilter)
	e1:SetCountLimit(1,81010002+EFFECT_COUNT_CODE_OATH)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81010092)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c81010002.regop)
	c:RegisterEffect(e2)
end
function c81010002.filter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c81010002.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)
end
function c81010002.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c81010002.thcon)
	e1:SetOperation(c81010002.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81010002.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
end
function c81010002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81010002.thfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function c81010002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81010002.thfilter),tp,LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
