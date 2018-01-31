--白沢球的就寝
function c22221102.initial_effect(c)
	--buff
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22221102.target)
	e1:SetOperation(c22221102.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c22221102.op)
	c:RegisterEffect(e2)
end
function c22221102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c22221102.chlimit)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c22221102.chlimit(e,ep,tp)
	return not e:IsActiveType(TYPE_MONSTER)
end
function c22221102.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	e1:SetTarget(c22221102.tg)
	e1:SetValue(c22221102.efilter)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY)
	e2:SetTarget(c22221102.tg)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsExistingMatchingCard(c22221102.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(22221102,0)) then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c22221102.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22221102.spfilter(c,e,tp)
	return c:IsSetCard(0x50f) and c:IsType(TYPE_SPIRIT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22221102.tg(e,c)
	return c:IsSetCard(0x50f)
end
function c22221102.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer()
end
function c22221102.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetValue(c22221102.effectfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22221102.confilter(c)
	return c:IsSetCard(0x50f) and c:IsType(TYPE_SPIRIT) and c:IsFaceup()
end
function c22221102.effectfilter(e,tp,eg,ep,ev,re,r,rp,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	local p=e:GetHandler():GetControler()
	return tc:IsSetCard(0x50f) and tc:IsType(TYPE_MONSTER) and p==tp and Duel.IsExistingMatchingCard(c22221102.confilter,tp,LOCATION_MZONE,0,1,nil)
end