--灵曲·年华静谧之月
local m=1111223
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Soul=true
--
function c1111223.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c1111223.tg1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111223,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1111223.cost2)
	e2:SetOperation(c1111223.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c1111223.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c1111223.op4)
	c:RegisterEffect(e4)
--
	if not c1111223.global_check then
		c1111223.global_check=true
		local e5=Effect.GlobalEffect()
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetCondition(c1111223.con5)
		e5:SetOperation(c1111223.op5)
		Duel.RegisterEffect(e5,0)
	end
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c1111223.tg6)
	c:RegisterEffect(e6)
--
end
--
function c1111223.tfilter1(c,tp)
	return c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c1111223.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1111,1,REASON_EFFECT) and eg:IsExists(c1111223.tfilter1,1,c,tp) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
--
function c1111223.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1111,1,REASON_EFFECT)
end
--
function c1111223.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local num=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return num>0 and c:IsCanAddCounter(0x1111,num) end
	c:AddCounter(0x1111,num)
end
--
function c1111223.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=true
	local b2=true
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1111223,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1111223,2)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		c:ResetFlagEffect(1111223)
		c:ResetFlagEffect(1111224)
		c:RegisterFlagEffect(1111223,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(1111223,1))
	else
		c:ResetFlagEffect(1111223)
		c:ResetFlagEffect(1111224)
		c:RegisterFlagEffect(1111224,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(1111223,2))
		c:RegisterFlagEffect(1111224,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(1111223,3))
	end
end
--
function c1111223.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1111223)<1 then return false end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
--
function c1111223.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1111224)<1 then return false end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1111223.con5(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
--
function c1111223.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) then return end
	c:RegisterFlagEffect(1111225,RESET_EVENT+0x1fe0000,0,0)
end
--
function c1111223.tg6(e,c)
	return c:GetFlagEffect(1111225)>0
end
--
