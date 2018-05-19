--妖精的恶作剧
function c1191003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c1191003.con1)
	e1:SetTarget(c1191003.tg1)
	e1:SetOperation(c1191003.op1)
	c:RegisterEffect(e1)
--
	if not c1191003.global_check1 then
		c1191003.global_check1=true
		local e0_1=Effect.CreateEffect(c)
		e0_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0_1:SetCode(EVENT_SSET)
		e0_1:SetOperation(c1191003.op0_1)
		Duel.RegisterEffect(e0_1,0)
	end
--
end
--
c1191003.code_available=1191003
--
function c1191003.ofilter0_1(c)
	return c.code_available==1191003
end
function c1191003.op0_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=eg:Filter(c1191003.ofilter0_1,nil)
	local sc=sg:GetFirst()
	while sc do
		local e0_1_1=sc:GetActivateEffect()
		e0_1_1:SetProperty(0,EFFECT_FLAG2_COF)
		e0_1_1:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
		e0_1_1:SetCondition(c1191003.con0_1_1)
		sc:RegisterFlagEffect(1191003,RESET_EVENT+0x1fe0000,0,1)
		local e0_1_2=Effect.CreateEffect(c)
		e0_1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0_1_2:SetCode(EVENT_ADJUST)
		e0_1_2:SetOperation(c1191003.op0_1_2)
		e0_1_2:SetLabelObject(sc)
		Duel.RegisterEffect(e0_1_2,tp)
		sc=sg:GetNext()
	end
end
--
function c1191003.con0_1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c1191003.op0_1_2(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	if sc:GetFlagEffect(1191003)~=0 then return end
	local e0_1_2_1=sc:GetActivateEffect()
	e0_1_2_1:SetProperty(nil)
	e0_1_2_1:SetHintTiming(0)
	e0_1_2_1:SetCondition(aux.TRUE)
	e:Reset()
end
--
function c1191003.cfilter1(c)
	return c:IsCode(1190003) and c:IsFaceup()
end
function c1191003.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1191003.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
--
function c1191003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and  chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
--
function c1191003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.RegisterFlagEffect(tp,1191003,RESET_PHASE+PHASE_END,0,0,1)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1_1:SetCode(EVENT_CHAINING)
		e1_1:SetCondition(c1191003.con1_1)
		e1_1:SetOperation(c1191003.op1_1)
		e1_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1_1,tp)
	end
end
--
function c1191003.con1_1(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_ONFIELD)~=0 and Duel.GetFlagEffect(tp,1191004)<Duel.GetFlagEffect(tp,1191003) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,rp,LOCATION_ONFIELD,0,1,re:GetHandler())
end
--
function c1191003.op1_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(1191003,4)) then
		Duel.RegisterFlagEffect(tp,1191004,RESET_PHASE+PHASE_END,0,0,1)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c1191003.op1_1_1)
	end
end
--
function c1191003.op1_1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,1,1,c)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Hint(HINT_CARD,0,1191003)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--
