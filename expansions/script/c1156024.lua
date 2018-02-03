--接近神的蝴蝶妖精
function c1156024.initial_effect(c)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c1156024.lkcon)
	e0:SetOperation(c1156024.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)   
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c1156024.lkcon1)
	e1:SetOperation(c1156024.lkop1)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)   
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c1156024.lkcon2)
	e2:SetOperation(c1156024.lkop2)
	e2:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e2)   
--
	if not c1156024.gchk then
		c1156024.gchk=true
		c1156024[0]=5
		c1156024[1]=5
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetOperation(c1156024.op3)
		Duel.RegisterEffect(e3,0)
		local e3_1=Effect.GlobalEffect()
		e3_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3_1:SetCode(EVENT_SUMMON_SUCCESS)
		e3_1:SetOperation(c1156024.op3)
		Duel.RegisterEffect(e3_1,0)
		local e3_2=Effect.GlobalEffect()
		e3_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3_2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		e3_2:SetOperation(c1156024.op3)
		Duel.RegisterEffect(e3_2,0)
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetCountLimit(1)
		e4:SetOperation(c1156024.clear4)
		Duel.RegisterEffect(e4,0)
	end
--
end
--
function c1156024.lkfilter(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsType(TYPE_MONSTER) and c:GetControler()==tp
	return flag and c:GetPreviousLocation(LOCATION_EXTRA) and c:GetLink()~=1
end
function c1156024.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1 
	end
end
--
function c1156024.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c1156024.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c1156024.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1156024.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156024.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1156024.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1156024.lkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=1
	local maxc=1
	if ct>maxc then return false end
	return (c1156024.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c1156024.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)) and Duel.GetFlagEffect(1-tp,1156024)==Duel.GetFlagEffect(1-tp,1156025)
end
--
function c1156024.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c1156024.lkfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=1
	local maxc=1
	for i=ct,maxc-1 do
		local cg=mg:Filter(c1156024.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c1156024.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
--
function c1156024.lkfilter1(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsType(TYPE_MONSTER)
	if c:GetControler()==tp then
		return flag and c:GetPreviousLocation(LOCATION_EXTRA) and c:GetLink()~=1
	else
		return flag
	end
end
function c1156024.lvfilter1(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1 
	end
end
--
function c1156024.lcheck1(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c1156024.lvfilter1,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c1156024.lkchenk1(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1156024.lcheck1(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156024.lkchenk1,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1156024.lkcon1(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1156024.lkfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=1
	local maxc=1
	if ct>maxc then return false end
	return (c1156024.lcheck1(tp,sg,c,minc,ct) or mg:IsExists(c1156024.lkchenk1,1,nil,tp,sg,mg,c,ct,minc,maxc)) and Duel.GetFlagEffect(1-tp,1156024)~=Duel.GetFlagEffect(1-tp,1156025) and Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)>2
end
--
function c1156024.lkop1(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c1156024.lkfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=1
	local maxc=1
	for i=ct,maxc-1 do
		local cg=mg:Filter(c1156024.lkchenk1,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c1156024.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	local cnum=0
	local cc=sg:GetFirst()
	while cc do
		if cc:GetControler()~=tp then
			cnum=cnum+1
		end
		cc=sg:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
	Duel.Draw(1-tp,cnum,REASON_RULE)
end
--
function c1156024.lkfilter2(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsType(TYPE_MONSTER) and c:GetControler()==tp
	return flag and c:GetPreviousLocation(LOCATION_EXTRA) and c:GetLink()~=1
end
function c1156024.lvfilter2(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1 
	end
end
--
function c1156024.lcheck2(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c1156024.lvfilter2,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c1156024.lkchenk2(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1156024.lcheck2(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c1156024.lkchenk2,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1156024.lkcon2(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c1156024.lkfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=1
	local maxc=1
	if ct>maxc then return false end
	return (c1156024.lcheck2(tp,sg,c,minc,ct) or mg:IsExists(c1156024.lkchenk1,1,nil,tp,sg,mg,c,ct,minc,maxc)) and Duel.GetFlagEffect(1-tp,1156024)~=Duel.GetFlagEffect(1-tp,1156025) and Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)<3
end
--
function c1156024.lkop2(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c1156024.lkfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=1
	local maxc=1
	for i=ct,maxc-1 do
		local cg=mg:Filter(c1156024.lkchenk2,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c1156024.lcheck2(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
--
function c1156024.op3(e,tp,eg,ep,ev,re,r,rp)
	if c1156024[rp]<=1 then
		Duel.RegisterFlagEffect(rp,1156025,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(rp,1156024,RESET_PHASE+PHASE_END,0,2)
	else
		c1156024[rp]=c1156024[rp]-1
	end
end
function c1156024.clear4(e,tp,eg,ep,ev,re,r,rp)
	c1156024[0]=5
	c1156024[1]=5
end
--
