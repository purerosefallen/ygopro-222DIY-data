--周子·红叶秋风
function c81040019.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,c81040019.filter,LOCATION_HAND+LOCATION_GRAVE,c81040019.mfilter)   
	e1:SetCountLimit(1,81040019)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,81040919)
	e6:SetCondition(aux.exccon)
	e6:SetCost(c81040019.tdcost)
	e6:SetTarget(c81040019.tdtg)
	e6:SetOperation(c81040019.tdop)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(81040019,ACTIVITY_SPSUMMON,c81040019.filter)
end
function c81040019.filter(c)
	return c:IsSetCard(0x81c)
end
function c81040019.mfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c81040019.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81040019,tp,ACTIVITY_SPSUMMON)==0
		and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81040019.splimit)
	Duel.RegisterEffect(e1,tp)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c81040019.splimit(e,c)
	return not c:IsSetCard(0x81c)
end
function c81040019.tdfilter(c)
	return c:IsAbleToDeck() and not c:IsSetCard(0x81c)
end
function c81040019.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81040019.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c81040019.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c81040019.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81040019.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
