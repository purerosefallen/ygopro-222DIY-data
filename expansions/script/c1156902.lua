--风雨之鸦
function c1156902.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1156902.mfilter,2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c1156902.splimit)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1156902,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1156902.con2)
	e2:SetTarget(c1156902.tg2)
	e2:SetOperation(c1156902.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
--	e3:SetCondition(c1156902.con3)
	e3:SetOperation(c1156902.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c1156902.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1156902,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CUSTOM+1156902)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c1156902.tg5)
	e5:SetOperation(c1156902.op5)
	c:RegisterEffect(e5)
--
end
--
function c1156902.mfilter(c)
	return c:IsLinkRace(RACE_WINDBEAST) and c:IsLinkAttribute(ATTRIBUTE_WIND)
end
--
function c1156902.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)~=0
end
--
function c1156902.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
--
function c1156902.tfilter2_1(c)
	return c:GetSequence()<5
end
function c1156902.tfilter2_2(c,sg)
	return sg:IsContains(c)
end
function c1156902.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then
		if not rc:IsOnField() then return false end
		if rc:IsLocation(LOCATION_FZONE) then return false end
		local rg=rc:GetColumnGroup()
		local sg=Duel.GetMatchingGroup(c1156902.tfilter2_1,tp,LOCATION_MZONE,0,nil)
		local tg=rg:Filter(c1156902.tfilter2_2,nil,sg)
		local num=tg:GetCount()
		if num~=0 then return false
		else return Duel.GetFlagEffect(tp,1156902)==0 end
	end
	Duel.RegisterFlagEffect(tp,1156902,RESET_CHAIN,0,1)
end
--
function c1156902.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not rc:IsOnField() then return end
	if rc:IsLocation(LOCATION_FZONE) then return end
	local rg=rc:GetColumnGroup()
	local sg=Duel.GetMatchingGroup(c1156902.tfilter2_1,tp,LOCATION_MZONE,0,nil)
	local tg=rg:Filter(c1156902.tfilter2_2,nil,sg)
	if tg:GetCount()>0 then return end
	local seq=aux.MZoneSequence(rc:GetSequence())
	if rc:IsControler(1-tp) then seq=4-seq end
	Duel.MoveSequence(c,seq)
end
--
function c1156902.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function c1156902.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=aux.MZoneSequence(c:GetSequence())
	local num=-1
	c:ResetFlagEffect(1156902)
	while num<seq do
		c:RegisterFlagEffect(1156902,RESET_EVENT+0x1fe0000,0,0)
		num=num+1
	end
end
--
function c1156902.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=aux.MZoneSequence(c:GetSequence())
	if c:GetFlagEffect(1156902)<1 then return end
	local num=c:GetFlagEffect(1156902)-1
	if seq~=num then
		local seqnum=-1
		c:ResetFlagEffect(1156903)
		while seqnum<num do
			c:RegisterFlagEffect(1156903,RESET_EVENT+0x1fe0000,0,0)
			seqnum=seqnum+1
		end
		Duel.RaiseEvent(c,EVENT_CUSTOM+1156902,re,r,rp,ep,ev)
	end
end
--
function c1156902.tfilter5(c,tp,all)
	local seq=aux.MZoneSequence(c:GetSequence())
	return (c:IsControler(tp) and seq==all) or (c:IsControler(1-tp) and seq==4-all) and c:IsAbleToHand()
end
function c1156902.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local num=c:GetFlagEffect(1156903)-1
	if chk==0 then
		if c:GetFlagEffect(1156903)<1 then return false end
		if num<0 then return false end
		if seq==num then return false end
		local t=0
		if seq>num then t=seq-num
		else t=num-seq end
		if t<2 then return false end
		local all=math.min(num,seq)+1
		local j=0
		while all<math.max(num,seq) do
			if Duel.IsExistingMatchingCard(c1156902.tfilter5,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,all) then j=1 end
			all=all+1
		end
		if j~=1 then return false
		else return true end
	end
	e:SetLabel(num)
end
--
function c1156902.op5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local num=e:GetLabel()
	if num==nil then return end
	if num<0 then return end
	if seq==num then return end
	local t=0
	if seq>num then t=seq-num
	else t=num-seq end
	if t<2 then return end
	local sg=Group.CreateGroup()
	local all=math.min(num,seq)+1
	while all<math.max(num,seq) do
		local tg=Duel.GetMatchingGroup(c1156902.tfilter5,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,all)
		if tg:GetCount()>0 then sg:Merge(tg) end
		all=all+1
	end
	if sg:GetCount()>0 then 
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
--
