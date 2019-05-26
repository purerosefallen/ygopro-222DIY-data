--虚构之炎
function c11200112.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,c11200112.filter,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,c11200112.mfilter)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c11200112.cost)
	e1:SetCountLimit(1,11200112)
end
function c11200112.filter(c)
	return c:IsCode(11200103,11200104)
end
function c11200112.mfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c11200112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetLabelObject(e)
	e2:SetTarget(c11200112.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c11200112.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end
