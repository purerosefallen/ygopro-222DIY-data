--MS-765·北上丽花
function c81015010.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c81015010.ntcon)
	c:RegisterEffect(e1)
	--synchro level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e3:SetTarget(c81015010.syntg)
	e3:SetValue(1)
	e3:SetOperation(c81015010.synop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(81011013)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
end
function c81015010.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c81015010.cardiansynlevel(c)
	return 3
end
function c81015010.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c81015010.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c81015010.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(c81015010.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c81015010.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and (g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
			or g:CheckWithSumEqual(c81015010.cardiansynlevel,lv,ct,ct,syncard))
end
function c81015010.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() and lv<=c81015010.cardiansynlevel(c) then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c81015010.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	return mg:IsExists(c81015010.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c81015010.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c81015010.synfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	for i=1,maxc do
		local cg=mg:Filter(c81015010.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c81015010.syngoal(g,tp,lv,syncard,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end