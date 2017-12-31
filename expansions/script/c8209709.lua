--架空界的禁忌 四重存在
function c8209709.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8209709+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c8209709.condition)
	e1:SetCost(c8209709.cost)
	e1:SetTarget(c8209709.target)
	e1:SetOperation(c8209709.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(8209709,ACTIVITY_SPSUMMON,c8209709.counterfilter)
end
function c8209709.counterfilter(c)
	return c:IsSetCard(0x1212)
end
function c8209709.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1212) 
end
function c8209709.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c8209709.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c8209709.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(8209709,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c8209709.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c8209709.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x1212)
end
function c8209709.spfilter(c,e,tp)
	return c:IsSetCard(0x1212) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8209709.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,LOCATION_DECK)
end
function c8209709.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	if dg:GetCount()>0 and Duel.Destroy(dg,REASON_RULE)>0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c8209709.spfilter,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()<4 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,4,4,nil)
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
end