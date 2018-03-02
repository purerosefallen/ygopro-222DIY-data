--不自然的冷气
function c1156605.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c1156605.lkcon)
	e0:SetOperation(c1156605.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
--  
	if not c1156605.global_check then
		c1156605.global_check=true
		c1156605[0]=0
		c1156605[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c1156605.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge2:SetOperation(c1156605.checkop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetOperation(c1156605.checkop)
		Duel.RegisterEffect(ge3,0)
	end
--
end
--
function c1156605.checkop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	if Duel.GetTurnCount()~=c1156605[2] then
		c1156605[0]=0
		c1156605[1]=0
		c1156605[2]=Duel.GetTurnCount()
	end
	local tc=eg:GetFirst()
	local p1=false
	while tc do
		if tc:GetSummonPlayer()==turnp then p1=true end
		tc=eg:GetNext()
	end
	if p1 then
		c1156605[turnp]=c1156605[turnp]+1
		if c1156605[turnp]==3 then
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+1156605,e,0,turnp,0,0)
		end
	end
end
--
function c1156605.lkfilter(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
	return flag and c:GetAttack()<901 and not c:IsType(TYPE_TOKEN)
end
function c1156605.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:GetLink()>1 then return 1+0x10000*c:GetLink()
	else return 1 
	end
end
--
function c1156605.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c1156605.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c1156605.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1156605.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156605.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1156605.lcheck2(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c1156605.lvfilter,9,ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c1156605.lkchenk2(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1156605.lcheck2(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156605.lkchenk2,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1156605.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1156605.lkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=1
	local maxc=9
	if ct>maxc then return false end
	return c1156605.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c1156605.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
--
function c1156605.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c1156605.lkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=1
	local maxc=9
	for i=ct,maxc-1 do
		local cg=mg:Filter(c1156605.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c1156605.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	ct=sg:GetCount()
	if (c1156605.lcheck2(tp,sg,c,minc,ct) or mg:IsExists(c1156605.lkchenk2,1,nil,tp,sg,mg,c,ct,minc,maxc)) and Duel.SelectYesNo(tp,aux.Stringid(1156605,0)) then
		for i=ct,maxc-1 do
			local cg=mg:Filter(c1156605.lkchenk2,sg,tp,sg,mg,c,i,minc,maxc)
			if cg:GetCount()==0 then break end
			local minct=1
			if c1156605.lcheck2(tp,sg,c,minc,i) then
				if not Duel.SelectYesNo(tp,210) then break end
				minct=0
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g=cg:Select(tp,minct,1,nil)
			if g:GetCount()==0 then break end
			sg:Merge(g)
		end
--
		c:RegisterFlagEffect(1156605,RESET_EVENT+0xfe0000,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(1156605,1))
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_1:SetRange(LOCATION_MZONE)
		e1_1:SetValue(c1156605.val1_1)
		e1_1:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e1_1,true)
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_3:SetRange(LOCATION_MZONE)
		e1_3:SetCode(EVENT_CUSTOM+1156605)
		e1_3:SetCondition(c1156605.con1_3)
		e1_3:SetOperation(c1156605.op1_3)
		e1_3:SetReset(RESET_EVENT+0xfe0000)
		c:RegisterEffect(e1_3,true)
--
	end
--
	local num=sg:GetCount()
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_2:SetRange(LOCATION_MZONE)
	e1_2:SetCode(EFFECT_SET_BASE_ATTACK)
	e1_2:SetValue(num*900)
	e1_2:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1_2,true)
--
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
--
function c1156605.val1_1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function c1156605.con1_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_END and tp~=rp
end
function c1156605.op1_3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1156605)
	local turnp=Duel.GetTurnPlayer()
	local tph=Duel.GetCurrentPhase()
	if tph==PHASE_DRAW then
		Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if tph==PHASE_STANDBY then
		Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)	 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if tph==PHASE_MAIN1 then 
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1) 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)	 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
	end
	if tph>PHASE_MAIN1 and tph<PHASE_MAIN2 then 
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
	if tph==PHASE_MAIN2 then 
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end

