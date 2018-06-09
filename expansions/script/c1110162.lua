--飘零的幻梦
function c1110162.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1110162.mfilter,1,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(c1110162.cost1)
	c:RegisterEffect(e1)
--
	if not c1110162.gchk then
		c1110162.gchk=true
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCondition(c1110162.con2)
		e2:SetOperation(c1110162.op2)
		Duel.RegisterEffect(e2,0)
	end 
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1110162,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c1110162.cost3)
	e3:SetTarget(c1110162.tg3)
	e3:SetOperation(c1110162.op3)
	c:RegisterEffect(e3)
--
end
--
c1110162.code_check=1110162
--
function c1110162.mfilter(c)
	return c:IsLevel(3) and not c:IsType(TYPE_TOKEN)
end
--
function c1110162.cost1(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
--
function c1110162.cfilter2(c)
	return c.code_check==1110162
end
function c1110162.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)~=0
		and eg:IsExists(c1110162.cfilter2,1,nil)
end
--
function c1110162.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=eg:Filter(c1110162.cfilter2,1,nil)
	local tc=tg:GetFirst()
	while tc do
		local p=tc:GetSummonPlayer()
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_FIELD)
		e2_1:SetCode(EFFECT_CANNOT_SUMMON)
		e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2_1:SetTargetRange(1,0)
		e2_1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2_2=e2_1:Clone()
		e2_2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2_2,tp)
		tc=tg:GetNext()
	end
end
--
function c1110162.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c1110162.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	end
	e:SetLabel(0)
	local num1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local num2=Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	local num=math.min(num1,num2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,num,nil)
	e:SetLabel(sg:GetCount())
	Duel.SendtoGrave(sg,REASON_COST)
end
--
function c1110162.ofilter3(c)
	return c:GetType()==TYPE_SPELL and c:IsSSetable()
end
function c1110162.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()
	local num1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	num=math.min(num,num1)
	Duel.ConfirmDecktop(tp,num)
	local sg=Duel.GetDecktopGroup(tp,num)
	local tg=sg:Filter(c1110162.ofilter3,nil)
	local alln=tg:GetCount()
	local coun=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local lg=Group.CreateGroup()
	if alln>0 and coun>0 then
		if alln<=coun then 
			if Duel.SSet(tp,tg)<1 then return end
			lg=Duel.GetOperatedGroup()
			Duel.ConfirmCards(1-tp,lg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local cg=tg:Select(tp,1,coun,nil)
			if Duel.SSet(tp,cg)<1 then return end
			lg=Duel.GetOperatedGroup()
			Duel.ConfirmCards(1-tp,lg)
		end
	end
	if lg:GetCount()<1 then return end
	local lc=lg:GetFirst()
	while lc do
		local e3_1=lc:GetActivateEffect()
		e3_1:SetProperty(0,EFFECT_FLAG2_COF)
		e3_1:SetHintTiming(0,0x1e0+TIMING_CHAIN_END)
		e3_1:SetCondition(c1110162.con3_1)
		lc:RegisterFlagEffect(1110162,RESET_EVENT+0x1fe0000,0,1)
		local e3_2=Effect.CreateEffect(c)
		e3_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3_2:SetCode(EVENT_ADJUST)
		e3_2:SetOperation(c1110162.op3_2)
		e3_2:SetLabelObject(lc)
		Duel.RegisterEffect(e3_2,tp)
		lc=lg:GetNext()
	end
	local e3_3=Effect.CreateEffect(c)
	e3_3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3_3:SetType(EFFECT_TYPE_FIELD)
	e3_3:SetCode(EFFECT_DRAW_COUNT)
	e3_3:SetTargetRange(1,0)
	e3_3:SetValue(2)
	e3_3:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e3_3,tp)
end
--
function c1110162.con3_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c1110162.op3_2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(1110162)~=0 then return end
	local e4_5_1=tc:GetActivateEffect()
	e4_5_1:SetProperty(nil)
	e4_5_1:SetHintTiming(0)
	e4_5_1:SetCondition(aux.TRUE)
	e:Reset()
end
--
