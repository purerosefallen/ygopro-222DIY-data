--茜色之绊
function c1150002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1150002+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c1150002.cost1)
	e1:SetCondition(c1150002.con1)
	e1:SetTarget(c1150002.tg1)
	e1:SetOperation(c1150002.op1)
	c:RegisterEffect(e1)   
--
	if not c1150002.gchk then
		c1150002.gchk=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e0:SetCode(EVENT_SPSUMMON_SUCCESS)
		e0:SetCondition(c1150002.con0)
		e0:SetOperation(c1150002.op0)
		Duel.RegisterEffect(e0,0)
	end
--
end
--
function c1150002.con0(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(TYPE_TRAP+TYPE_MONSTER) and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:GetHandler():GetCode(1150002)
end
--
function c1150002.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,1150002,EVENT_PHASE+PHASE_END,0,1)
end
--
function c1150002.con1(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFlagEffect(tp,1150002)<1
end
--
function c1150002.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,1150002)<1 end
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_1:SetTargetRange(1,0)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTarget(c1150002.splimit1_1)
	Duel.RegisterEffect(e1_1,tp)
end
function c1150002.splimit1_1(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and se:IsHasType(TYPE_MONSTER+TYPE_TRAP) and not se:GetHandler():IsCode(1150002)
end
--
function c1150002.tfilter1_1(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c1150002.tfilter1_2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c1150002.tfilter1_2(c,e,tp,tc)
	return c:IsRace(tc:GetRace()) and c:IsAttribute(tc:GetAttribute()) and c:GetCode()~=tc:GetCode() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1150002.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1150002.tfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1150002.tfilter1_1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1150002.tfilter1_1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
--
function c1150002.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c1150002.tfilter1_2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
		if sg:GetCount()>0 then
			local sc=sg:GetFirst()
			if sc:IsLocation(LOCATION_GRAVE) and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				tc:SetCardTarget(sc)
				Duel.SpecialSummonComplete()
				Duel.BreakEffect()
--
				if tc:IsType(TYPE_EFFECT) then sc:CopyEffect(tc:GetCode(),RESET_EVENT+0x1fe0000) end
				if sc:IsType(TYPE_EFFECT) then tc:CopyEffect(sc:GetCode(),RESET_EVENT+0x1fe0000) end
--
				local fid=c:GetFieldID()
				tc:RegisterFlagEffect(1150002,0,0,0,fid)
				sc:RegisterFlagEffect(1150002,0,0,0,fid)
				local e1_5=Effect.CreateEffect(c)
				e1_5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
				e1_5:SetCode(EVENT_LEAVE_FIELD)
				e1_5:SetLabel(fid)
				e1_5:SetOperation(c1150002.op1_5)
				tc:RegisterEffect(e1_5,true)
				local e1_4=Effect.CreateEffect(c)
				e1_4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e1_4:SetRange(LOCATION_MZONE)
				e1_4:SetCode(EVENT_LEAVE_FIELD)
				e1_4:SetLabel(fid)
				e1_4:SetCondition(c1150002.con1_4)
				e1_4:SetOperation(c1150002.op1_4)
				tc:RegisterEffect(e1_4,true)
--
				local e1_2=Effect.CreateEffect(c)
				e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1_2:SetCode(EVENT_PHASE+PHASE_END)
				e1_2:SetRange(LOCATION_MZONE)
				e1_2:SetCountLimit(1)
				e1_2:SetCondition(c1150002.con1_2)
				e1_2:SetOperation(c1150002.op1_2)
				e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				sc:RegisterEffect(e1_2,true)
			end
		end
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_3:SetCode(EVENT_PHASE+PHASE_END)
		e1_3:SetRange(LOCATION_MZONE)
		e1_3:SetCountLimit(1)
		e1_3:SetCondition(c1150002.con1_2)
		e1_3:SetOperation(c1150002.op1_2)
		e1_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1_3,true)   
	end
end
--
function c1150002.con1_2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c1150002.op1_2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
--
function c1150002.op1_5(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	local fid=e:GetLabel()
	local checkc=g:GetFirst()
	while checkc do
		if checkc:GetFlagEffectLabel(1150002)==e:GetHandler():GetFlagEffectLabel(1150002) and checkc:IsLocation(LOCATION_MZONE) then
			Duel.SendtoGrave(checkc,REASON_EFFECT)
		end
		checkc=g:GetNext()
	end
end
--
function c1150002.con1_4(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	local fid=e:GetLabel()
	local checkc=g:GetFirst()
	local checknum=0
	while checkc do
		if eg:IsContains(checkc) and checkc:GetFlagEffectLabel(1150002)==e:GetHandler():GetFlagEffectLabel(1150002) then
			checknum=1
		end
		checkc=g:GetNext()
	end
	return checknum~=0
end
function c1150002.op1_4(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
--