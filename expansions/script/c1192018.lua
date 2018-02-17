--莉莉 -春节庆典-
function c1192018.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1192018)
	e1:SetCost(c1192018.cost1)
	e1:SetOperation(c1192018.op1)
	c:RegisterEffect(e1)
--
	if c1192018.checklp==nil then
		c1192018.checklp=true
		c1192018.lplist={[0]=Duel.GetLP(tp),[1]=Duel.GetLP(tp),}
		c1192018.eList={[0]={},[1]={},}
	end
--
end
--
function c1192018.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--
function c1192018.op1(e,tp,eg,ep,ev,re,r,rp)
--
	local c=e:GetHandler()
	local e1_3=Effect.CreateEffect(e:GetHandler())
	e1_3:SetType(EFFECT_TYPE_FIELD)
	e1_3:SetCode(EFFECT_CHANGE_DAMAGE)
	e1_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_3:SetTargetRange(1,1)
	e1_3:SetValue(0)
	e1_3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1_3,tp)
	local e1_4=e1_3:Clone()
	e1_4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e1_4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1_4,tp)
--
	if Duel.GetFlagEffect(tp,1192018)>0 then return end
	Duel.RegisterFlagEffect(tp,1192018,0,0,0)
--
	Duel.BreakEffect()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1_1:SetCountLimit(1)
	e1_1:SetCondition(c1192018.con1_1)
	e1_1:SetOperation(c1192018.op1_1)
	Duel.RegisterEffect(e1_1,tp)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_2:SetCode(EVENT_ADJUST)
	e1_2:SetOperation(c1192018.op1_2)
	Duel.RegisterEffect(e1_2,tp)
	c1192018.eList[tp]={e1_1,e1_2}
--
end
--
function c1192018.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1192018.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp>=c1192018.lplist[tp] then return end 
	local num=c1192018.lplist[tp]-lp
	if num>2018 then Duel.Recover(tp,2018,REASON_EFFECT)
	elseif num>0 then Duel.Recover(tp,num,REASON_EFFECT)
	end
end
--
function c1192018.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp>=c1192018.lplist[tp] then
		for _,v in pairs(c1192018.eList[tp]) do v:Reset() end
		c1192018.eList[tp]={}
		Duel.ResetFlagEffect(tp,1192018)
	end
end
--
