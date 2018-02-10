--我不是很好吃
function c1150009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1150009.tg1)
	e1:SetOperation(c1150009.op1)
	c:RegisterEffect(e1)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_ATTACK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c1150009.cost3)
	e3:SetOperation(c1150009.op3)
	c:RegisterEffect(e3)
--
end
--
function c1150009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(1150051)<1 end
	c:RegisterFlagEffect(1150051,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
--
function c1150009.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		if not c:IsCanTurnSet() then return end
		Duel.ChangePosition(c,POS_FACEDOWN)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(1150009,RESET_EVENT+0x1fe0000,0,0,fid)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EFFECT_DESTROY_REPLACE)
		e1_1:SetLabel(fid)
		e1_1:SetTarget(c1150009.tg1_1)
		e1_1:SetValue(c1150009.val1_1)
		e1_1:SetOperation(c1150009.op1_1)
		Duel.RegisterEffect(e1_1,tp)
	end
end
--
function c1150009.tfilter1_1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c1150009.tg1_1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fid=e:GetLabel()
	if chk==0 then return eg:IsExists(c1150009.tfilter1_1,1,nil,tp) and c:IsLocation(LOCATION_SZONE) and c:IsFacedown() and c:IsDestructable() and c:GetFlagEffectLabel(1150009)==fid end
	return Duel.SelectYesNo(tp,aux.Stringid(1150009,0))
end
function c1150009.val1_1(e,c)
	return c1150009.tfilter1_1(c,e:GetHandlerPlayer())
end
function c1150009.op1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
--
function c1150009.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(1150010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
--
function c1150009.op3(e,tp,eg,ep,ev,re,r,rp)
--
	local e3_1=Effect.CreateEffect(e:GetHandler())
	e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3_1:SetReset(RESET_PHASE+PHASE_END)
	e3_1:SetCountLimit(1)
	e3_1:SetOperation(c1150009.op3_1)
	Duel.RegisterEffect(e3_1,tp)
--
	local e3_2=Effect.CreateEffect(e:GetHandler())
	e3_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_2:SetCode(EVENT_PHASE+PHASE_END)
	e3_2:SetCountLimit(1)
	e3_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e3_2:SetRange(LOCATION_REMOVED)
	e3_2:SetCondition(c1150009.con3_2)
	e3_2:SetOperation(c1150009.op3_2)
	e:GetHandler():RegisterEffect(e3_2)
--
end
--
function c1150009.op3_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc and tc:IsOnField() then Duel.NegateAttack() end
end
--
function c1150009.con3_2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1150010)>0 and e:GetHandler():IsSSetable()
end
--
function c1150009.op3_2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.SSet(tp,e:GetHandler())
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
--
