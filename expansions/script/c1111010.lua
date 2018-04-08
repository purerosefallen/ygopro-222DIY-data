--秘谈·徜徉的乐曲
local m=1111010
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111010.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111010+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1111010.tg1)
	e1:SetOperation(c1111010.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c1111010.val3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c1111010.val3)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c1111010.tg5)
	c:RegisterEffect(e5)
--
end
--
function c1111010.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	c:SetTurnCounter(0)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetCode(EVENT_PHASE+PHASE_END)
	e1_1:SetCountLimit(1)
	e1_1:SetRange(LOCATION_SZONE)
	e1_1:SetCondition(c1111010.con1_1)
	e1_1:SetOperation(c1111010.op1_1)
	e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	c:RegisterEffect(e1_1)
	c:RegisterFlagEffect(1111010,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	c1111010[c]=e1_1
end
--
function c1111010.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c1111010.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==1 then
		Duel.SendtoGrave(c,REASON_RULE)
		c:ResetFlagEffect(1111010)
	end
end
--
function c1111010.ofilter1(c)
	return muxu.check_set_Soul(c) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and not c:IsForbidden()
end
function c1111010.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_IMMUNE_EFFECT)
	e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_2:SetRange(LOCATION_SZONE)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	e1_2:SetValue(c1111010.val1_2)
	c:RegisterEffect(e1_2)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.IsExistingMatchingCard(c1111010.ofilter1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1111010,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111010,1))
		local gn=Duel.SelectMatchingCard(tp,c1111010.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
		if gn:GetCount()>0 then
			local tc=gn:GetFirst()
			Duel.BreakEffect()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1_3=Effect.CreateEffect(c)
			e1_3:SetType(EFFECT_TYPE_SINGLE)
			e1_3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1_3:SetRange(LOCATION_SZONE)
			e1_3:SetCode(EFFECT_IMMUNE_EFFECT)
			e1_3:SetValue(c1111010.val1_3)
			e1_3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_3)
			local e1_4=Effect.CreateEffect(c)
			e1_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1_4:SetCode(EVENT_PHASE+PHASE_END)
			e1_4:SetRange(LOCATION_SZONE)
			e1_4:SetCountLimit(1)
			e1_4:SetOperation(c1111010.op1_4)
			e1_4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1_4)
		end
	end
end
--
function c1111010.val1_2(e,te)
	return te:GetHandlerPlayer()==e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
function c1111010.val1_3(e,te)
	return te:IsActiveType(TYPE_MONSTER) and e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function c1111010.op1_4(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
--
function c1111010.val3(e,ct)
	local p=e:GetHandlerPlayer()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return p==tp and tc:IsType(TYPE_SPIRIT) and tc:IsRace(RACE_PSYCHO)
end
--
function c1111010.tg5(e,c)
	return c:IsType(TYPE_SPIRIT) and c:IsRace(RACE_PSYCHO)
end
--






