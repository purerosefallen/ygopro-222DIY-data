--秘谈·湛蓝的幻想
local m=1111008
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111008.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111008+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1111008.tg1)
	e1:SetOperation(c1111008.op1)
	c:RegisterEffect(e1)
	if not c1111008.global_check then
		c1111008.global_check=true
		muxu11008_check={}
		muxu11008_check[1]=0
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(c1111008.op2)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetOperation(c1111008.op3)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c1111008.op4)
		Duel.RegisterEffect(e4,0)
	end
--
end
--
function c1111008.op2(e,tp,eg,ep,ev,re,r,rp)
	muxu11008_check[#muxu11008_check+1]=re:GetHandler():GetCode()
end
function c1111008.op3(e,tp,eg,ep,ev,re,r,rp)
	for k,v in ipairs(muxu11008_check) do
		if v==re:GetHandler():GetCode() then
		return end
	end
	muxu11008_check[#muxu11008_check+1]=re:GetHandler():GetCode()
end
function c1111008.op4(e,tp,eg,ep,ev,re,r,rp)
	muxu11008_check={}
	muxu11008_check[1]=0
end
--
function c1111008.tfilter1_1(c)
	return muxu.check_set_Soul(c) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and not c:IsForbidden()
end
function c1111008.tfilter1_2(c)
	return not (c:IsPreviousLocation(LOCATION_HAND) and bit.band(c:GetSummonType(),TYPE_SPSUMMON)~=0) 
end
function c1111008.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1111008.tfilter1_1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c1111008.tfilter1_2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c1111008.tfilter1_2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
--
function c1111008.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111008,1))
	local gn=Duel.SelectMatchingCard(tp,c1111008.tfilter1_1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if gn:GetCount()<=0 then return end
	local tc=gn:GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local g=Duel.GetMatchingGroup(c1111008.tfilter1_2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end
	if Duel.SendtoHand(g,nil,REASON_EFFECT)<=0 then return end
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetTargetRange(1,1)
	e1_1:SetValue(0)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	e1_2:SetTargetRange(1,0)
	e1_2:SetTarget(c1111008.tg1_2)
	Duel.RegisterEffect(e1_2,tp)
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_FIELD)
	e1_3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_3:SetTargetRange(1,0)
	e1_3:SetTarget(c1111008.tg1_3)
	e1_3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_3,tp)
	local e1_4=Effect.CreateEffect(c)
	e1_4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1_4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1_4:SetCondition(c1111008.con1_4)
	e1_4:SetOperation(c1111008.op1_4)
	e1_4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_4,tp)
	local e1_5=Effect.CreateEffect(c)
	e1_5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1_5:SetCode(EVENT_CHAIN_SOLVED)
	e1_5:SetCondition(c1111008.con1_5)
	e1_5:SetOperation(c1111008.op1_5)
	e1_5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_5,tp)
	local e1_6=Effect.CreateEffect(c)
	e1_6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1_6:SetProperty(EFFECT_FLAG_DELAY)
	e1_6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1_6:SetCondition(c1111008.con1_6)
	e1_6:SetOperation(c1111008.op1_5)
	e1_6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_6,tp)
	Duel.RegisterFlagEffect(tp,1111009,RESET_PHASE+PHASE_END,0,1)
	local e1_7=Effect.CreateEffect(c)
	e1_7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1_7:SetCode(EVENT_SSET)
	e1_7:SetCondition(c1111008.con1_7)
	e1_7:SetOperation(c1111008.op1_7)
	e1_7:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_7,tp)
end
--
function c1111008.tg1_2(e,c)
	return not c:IsType(TYPE_SPIRIT)
end
function c1111008.tg1_3(e,re,tp)
	return muxu11008_check and re:GetHandler():IsCode(table.unpack(muxu11008_check)) and not re:GetHandler():IsImmuneToEffect(e)
end
--
function c1111008.cfilter1_4(c)
	return c:IsType(TYPE_SPIRIT)
end
function c1111008.con1_4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111008.cfilter1_4,1,nil) and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c1111008.op1_4(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,1111008,RESET_CHAIN,0,1)
end
--
function c1111008.con1_5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1111008)>0
end
function c1111008.ofilter1_5(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function c1111008.op1_5(e,tp,eg,ep,ev,re,r,rp)
	local num1=Duel.GetFlagEffect(tp,1111009)
	local num2=Duel.GetFlagEffect(tp,1111010)
	if num1==num2 then return end
	if Duel.IsExistingMatchingCard(c1111008.ofilter1_5,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1111008,1)) then
		Duel.RegisterFlagEffect(tp,1111010,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1111008.ofilter1_5,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--
function c1111008.con1_6(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111008.cfilter1_4,1,nil) and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
--
function c1111008.cfilter1_7(c,tp)
	return c:IsControler(tp) and c:GetType()==TYPE_SPELL and muxu.check_set_Legend(c) and c:IsLocation(LOCATION_SZONE) and not c:IsCode(1111008)
end
function c1111008.con1_7(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111008.cfilter1_7,1,nil) 
end
function c1111008.op1_7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c1111008.cfilter1_7,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	while tc do
		local e1_7_1=tc:GetActivateEffect()
		e1_7_1:SetProperty(0,EFFECT_FLAG2_COF)
		e1_7_1:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
		e1_7_1:SetCondition(c1111008.con1_7_1)
		tc:RegisterFlagEffect(1111008,RESET_EVENT+0x1fe0000,0,1)
		local e1_7_2=Effect.CreateEffect(c)
		e1_7_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_7_2:SetCode(EVENT_ADJUST)
		e1_7_2:SetOperation(c1111008.op1_7_2)
		e1_7_2:SetLabelObject(tc)
		Duel.RegisterEffect(e1_7_2,tp)
		tc=g:GetNext()
	end
end
--
function c1111008.con1_7_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c1111008.op1_7_2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(1111008)~=0 then return end
	local e1_7_2_1=tc:GetActivateEffect()
	e1_7_2_1:SetProperty(nil)
	e1_7_2_1:SetHintTiming(0)
	e1_7_2_1:SetCondition(aux.TRUE)
	e:Reset()   
end
--

