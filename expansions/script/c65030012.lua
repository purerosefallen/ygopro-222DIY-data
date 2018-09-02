--树荫围绕的遥远耀光
function c65030012.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c65030012.condition)
	e1:SetTarget(c65030012.target)
	e1:SetOperation(c65030012.operation)
	c:RegisterEffect(e1)
	--endphase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65030012.edcon)
	e2:SetTarget(c65030012.edtg)
	e2:SetOperation(c65030012.edop)
	c:RegisterEffect(e2)
end
c65030012.card_code_list={65030020}
function c65030012.ntfil(c)
	return not c:IsType(TYPE_SPELL)
end
function c65030012.edcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(c65030012.ntfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)==0 
end
function c65030012.edfil(c)
	return c:GetAttackAnnouncedCount()==0
end
function c65030012.edtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030011.edfil,tp,0,LOCATION_MZONE,1,nil) end
end
function c65030012.edop(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetMatchingGroupCount(c65030012.edfil,tp,0,LOCATION_MZONE,nil)
	local i=0
	while i<num do
		Duel.SetLP(tp,Duel.GetLP(tp)*2)
		i=i+1
	end
end
function c65030012.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2 
end
function c65030012.tffilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and aux.IsCodeListed(c,65030020) and not c:IsForbidden() 
end
function c65030012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65030012.tffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
end
function c65030012.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c65030012.tffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
