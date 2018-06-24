--兔符『因幡的白兔』
function c11200067.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200067+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c11200067.cost1)
	e1:SetTarget(c11200067.tg1)
	e1:SetOperation(c11200067.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200067,2))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c11200067.con2)
	e2:SetOperation(c11200067.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
--
end
--
function c11200067.sfilter1(c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsReleasable()
end
function c11200067.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200067.sfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c11200067.sfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Release(sg,REASON_EFFECT)
end
--
function c11200067.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(11200067,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(11200067,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
	else
		e1:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD)
	end
end
--
function c11200067.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1_1:SetType(EFFECT_TYPE_FIELD)
		e1_1:SetCode(EFFECT_DRAW_COUNT)
		e1_1:SetTargetRange(1,0)
		e1_1:SetValue(2)
		e1_1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		Duel.RegisterEffect(e1_1,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
--
function c11200067.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
--
function c11200067.ofilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c11200067.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c11200067.ofilter2,tp,LOCATION_MZONE,0,nil)
	local sc=sg:GetFirst()
	while sc do
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_ATTACK)
		e2_1:SetValue(400)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2_1)
		local e2_2=Effect.CreateEffect(c)
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2_2:SetValue(400)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2_2)
		sc=sg:GetNext()
	end
end
--
