--秘谈·生命的旅路
local m=1111018
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Legend=true
--
function c1111018.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1111018.op1)
	c:RegisterEffect(e1)
--
	if not c1111018.global_check then
		c1111018.global_check=true
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetCondition(c1111018.con3)
		e3:SetOperation(c1111018.op3)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAINING)
		e4:SetOperation(c1111018.op4)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.GlobalEffect()
		e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_SSET)
		e5:SetOperation(c1111018.op5)
		Duel.RegisterEffect(e5,0)
	end
--
end
--
function c1111018.ofilter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsCode(1111502)
end
function c1111018.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1_1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1_1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_1,tp)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1_2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1_2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e1_2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1_2,tp)
	local sg=Duel.GetMatchingGroup(c1111018.ofilter1,tp,LOCATION_DECK,0,nil,tp)
	if sg:GetCount()<1 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(1111018,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111018,1))
		local tg=Duel.SelectMatchingCard(tp,c1111018.ofilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
		if tg:GetCount()<1 then return end
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
--
function c1111018.cfilter3(c)
	return c:IsType(TYPE_MONSTER)
end
function c1111018.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111018.cfilter3,1,nil)
end
--
function c1111018.ofilter3(c)
	return c:GetFlagEffect(1111019)>0
end
function c1111018.op3(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c1111018.cfilter3,nil)
	if sg:GetCount()>0 then
		local kg=Duel.GetMatchingGroup(c1111018.ofilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if kg:GetCount()>0 then
			local kc=kg:GetFirst()
			while kc do
				kc:ResetFlagEffect(1111019)
				kc=kg:GetNext()
			end
		end
		local tc=sg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(1111019,RESET_EVENT+0x1fe0000,0,0)
			tc=sg:GetNext()
		end
	end
end
--
function c1111018.ofilter4(c,e,tp)
	return c:GetFlagEffect(1111019)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1111018.op4(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local p=rc:GetControler()
	if Duel.GetMZoneCount(p)<1 then return end
	if rc:GetFlagEffect(1111018)<1 then return end
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	if Duel.GetMatchingGroupCount(c1111018.ofilter4,p,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,p)<1 then return end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c1111018.op4_1)
end
--
function c1111018.op4_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetHandler():GetControler()
	local sg=Duel.GetMatchingGroup(c1111018.ofilter4,p,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,p)
	local num=sg:GetCount()
	local ct=Duel.GetMZoneCount(p)
	local ct=math.min(num,ct)
	if ct<1 then return end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
	local tg=sg:Select(p,ct,ct,nil)
	local tc=tg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,p,p,false,false,POS_FACEUP)
		local e4_1_1=Effect.CreateEffect(c)
		e4_1_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1_1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e4_1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4_1_1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e4_1_1:SetValue(LOCATION_HAND)
		tc:RegisterEffect(e4_1_1,true)
		tc=tg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
--
function c1111018.cfilter5(c)
	return c:GetOriginalCode()==1111018
end
function c1111018.op5(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c1111018.cfilter5,nil)
	if sg:GetCount()<1 then return end
	local tc=sg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(1111018,RESET_EVENT+0x1fe0000,0,0)
		tc=sg:GetNext()
	end
end