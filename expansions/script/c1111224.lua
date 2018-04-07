--灵曲·凌霜空幽之雪
local m=1111224
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Soul=true
--
function c1111224.initial_effect(c)
--
	if not c1111224.global_check then
		c1111224.global_check=true
		c1111224[0]=0
		c1111224[1]=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetOperation(c1111224.op1)
		Duel.RegisterEffect(e1,0)
	end
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1111224,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CUSTOM+1111224)
	e2:SetCondition(c1111224.con2)
	e2:SetOperation(c1111224.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1111224,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1111224.cost3)
	e3:SetOperation(c1111224.op3)
	c:RegisterEffect(e3)
--
end
--
function c1111224.op1(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if Duel.GetTurnCount()~=c1111224[2] then
		c1111224[0]=0
		c1111224[1]=0
		c1111224[2]=Duel.GetTurnCount()
	end
	local tc=eg:GetFirst()
	local p1=false
	while tc do
		if tc:GetSummonPlayer()==turnp and tc:IsType(TYPE_EFFECT) and bit.band(tc:GetPreviousLocation(),LOCATION_HAND)==0 then 
			p1=true 
		end
		tc=eg:GetNext()
	end
	if p1 then
		c1111224[turnp]=c1111224[turnp]+1
		if c1111224[turnp]~=3 then return end
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+1111224,e,0,0,0,0)
	end
end
--
function c1111224.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
--
function c1111224.op2(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e2_1=Effect.CreateEffect(e:GetHandler())
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(EFFECT_CANNOT_BP)
	e2_1:SetTargetRange(1,0)
	e2_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2_1,turnp)
end
--
function c1111224.cfilter3(c)
	return c:IsReleasable() and c:IsHasEffect(EFFECT_IMMUNE_EFFECT)
end
function c1111224.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111224.cfilter3,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c1111224.cfilter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Release(g,REASON_COST)
end
--
function c1111224.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsCanAddCounter(0x1111,2)
	local b2=true
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1111224,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1111224,3)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		c:AddCounter(0x1111,2)
	else
		local e3_1=Effect.CreateEffect(c)
		e3_1:SetType(EFFECT_TYPE_FIELD)
		e3_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3_1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3_1:SetTargetRange(1,1)
		e3_1:SetValue(c1111224.val3_1)
		e3_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3_1,tp)
	end
	local e3_2=Effect.CreateEffect(c)
	e3_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_2:SetCode(EVENT_PHASE+PHASE_END)
	e3_2:SetRange(LOCATION_SZONE)
	e3_2:SetCountLimit(1)
	e3_2:SetOperation(c1111224.op3_2)
	e3_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3_2)
end
--  
function c1111224.val3_1(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
--
function c1111224.op3_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),nil,REASON_EFFECT)
end
--
