--灵都·双生并蒂
local m=1110131
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Urban=true
--
function c1110131.initial_effect(c)
--
	aux.AddSynchroProcedure(c,nil,c1110131.Filter,1,1)
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_COST)
	e3:SetCost(c1110131.cost3)
	e3:SetOperation(c1110131.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c1110131.con4)
	e4:SetTarget(c1110131.tg4)
	e4:SetOperation(c1110131.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c1110131.op5)
	c:RegisterEffect(e5)
--
end
--
function c1110131.Filter(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_MONSTER)
end
--
function c1110131.cfilter3(c,e)
	return c:IsAbleToGrave()
end
function c1110131.cost3(e,c,tp)
	return Duel.IsExistingMatchingCard(c1110131.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler())
end
--
function c1110131.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1110131.cfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
--
function c1110131.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
--
function c1110131.tfilter4(c)
	return c:IsSSetable() and muxu.check_set_Legend(c) 
end
function c1110131.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1110131.tfilter4,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
--
function c1110131.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local lg=Duel.SelectMatchingCard(tp,c1110131.tfilter4,tp,LOCATION_DECK,0,1,1,nil)
	if lg:GetCount()>0 then
		local tc=lg:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e4_1=tc:GetActivateEffect()
		e4_1:SetProperty(0,EFFECT_FLAG2_COF)
		e4_1:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
		e4_1:SetCondition(c1110131.con4_1)
		tc:RegisterFlagEffect(1110131,RESET_EVENT+0x1fe0000,0,1)
		local e4_2=Effect.CreateEffect(c)
		e4_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4_2:SetCode(EVENT_ADJUST)
		e4_2:SetOperation(c1110131.op4_2)
		e4_2:SetLabelObject(tc)
		Duel.RegisterEffect(e4_2,tp)
	end
end
--
function c1110131.con4_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<1
end
function c1110131.op4_2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(1110131)>0 then return end
	local e4_2_1=tc:GetActivateEffect()
	if tc:IsCode(1111007) then
		e4_2_1:SetProperty(0,nil)
	else
		e4_2_1:SetProperty(nil)
	end
	e4_2_1:SetHintTiming(0)
	e4_2_1:SetCondition(aux.TRUE)
	e:Reset()
end
--
function c1110131.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local sg2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if sg1:GetCount()<1 or sg2:GetCount()<1 then return end
	local num1=sg1:GetSum(Card.GetBaseAttack)
	local num2=sg2:GetSum(Card.GetBaseAttack)
	local clj=0
	if num1>num2 then clj=num1-num2 end
	if num2>num1 then clj=num2-num1 end
	if clj>0 then
		local e5_1=Effect.CreateEffect(c)
		e5_1:SetType(EFFECT_TYPE_SINGLE)
		e5_1:SetCode(EFFECT_UPDATE_ATTACK)
		e5_1:SetValue(clj)
		e5_1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e5_1)
	end
end
--
