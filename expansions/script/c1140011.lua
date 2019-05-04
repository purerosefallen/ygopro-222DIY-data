--被遗弃的人偶·梅蒂欣
local m=1140011
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Medicine=true
--
function c1140011.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c1140011.SynMixCondition(c1140011.filter,nil,nil,nil,1,1,nil))
	e1:SetTarget(c1140011.SynMixTarget(c1140011.filter,nil,nil,nil,1,1,nil))
	e1:SetOperation(c1140011.SynMixOperation(c1140011.filter,nil,nil,nil,1,1,nil))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c1140011.con2)
	e2:SetTarget(c1140011.tg2)
	e2:SetOperation(c1140011.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCondition(c1140011.con3)
	e3:SetCost(c1140011.cost3)
	e3:SetTarget(c1140011.tg3)
	e3:SetOperation(c1140011.op3)
	c:RegisterEffect(e3)
--
end
--
function c1140011.filter(c)
	return c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_DARK)
end
--
function c1140011.SynMixCondition(f1,f2,f3,f4,minc,maxc,gc)
	return  
	function(e,c,smat,mg1)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg
		if mg1 then
			mg=mg1
		else
			mg=aux.GetSynMaterials(tp,c)
		end
		if smat~=nil then mg:AddCard(smat) end
		return mg:IsExists(c1140011.SynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc)
	end
end
--
function c1140011.SynMixTarget(f1,f2,f3,f4,minc,maxc,gc)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1)
		local g=Group.CreateGroup()
		local mg
		if mg1 then
			mg=mg1
		else
			mg=aux.GetSynMaterials(tp,c)
		end
		if smat~=nil then mg:AddCard(smat) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local c1=mg:FilterSelect(tp,c1140011.SynMixFilter1,1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc):GetFirst()
		g:AddCard(c1)
		if f2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local c2=mg:FilterSelect(tp,c1140011.SynMixFilter2,1,1,c1,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc):GetFirst()
			g:AddCard(c2)
			if f3 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local c3=mg:FilterSelect(tp,c1140011.SynMixFilter3,1,1,Group.FromCards(c1,c2),f3,f4,minc,maxc,c,mg,smat,c1,c2,gc):GetFirst()
				g:AddCard(c3)
			end
		end
		local g4=Group.CreateGroup()
		for i=0,maxc-1 do
			local mg2=mg:Clone()
			if f4 then
				mg2=mg2:Filter(f4,nil)
			end
			local cg=mg2:Filter(c1140011.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc)
			if cg:GetCount()==0 then break end
			local minct=1
			if c1140011.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc) then
				minct=0
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local tg=cg:Select(tp,minct,1,nil)
			if tg:GetCount()==0 then break end
			g4:Merge(tg)
		end
		g:Merge(g4)
		if g:GetCount()>0 then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else return false end
	end
end
--
function c1140011.SynMixOperation(f1,f2,f3,f4,minct,maxc,gc)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
		g:DeleteGroup()
	end
end
--
function c1140011.SynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc)
	return (not f1 or f1(c,syncard)) and mg:IsExists(c1140011.SynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c,gc)
end
--
function c1140011.SynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1,gc)
	if f2 then
		return f2(c,syncard,c1) and mg:IsExists(c1140011.SynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c,gc)
	else
		return mg:IsExists(c1140011.SynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil,gc)
	end
end
--
function c1140011.SynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc)
	if f3 then
		return f3(c,syncard,c1,c2) and mg:IsExists(c1140011.SynMixFilter4,1,Group.FromCards(c1,c2,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc)
	else
		return mg:IsExists(c1140011.SynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil,gc)
	end
end
--
function c1140011.SynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,nil)
	end
	return c1140011.SynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc)
end
--
function c1140011.SynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc)
	local tp=syncard:GetControler()
	for c in aux.Next(sg1) do
		mg:RemoveCard(c)
	end
	local sg=Group.CreateGroup()
	if minc==0 and c1140011.SynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc) then return true end
	if maxc==0 then return false end
	return mg:IsExists(c1140011.SynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc)
end
--
function c1140011.SynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc)
	sg:AddCard(c)
	ct=ct+1
	local res=c1140011.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc)
		or (ct<maxc and mg:IsExists(c1140011.SynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1140011.GetSynchroLevelCheck1(c,syncard)
	return c:GetSynchroLevel(syncard)<1 or c:IsCode(1140901)
end
function c1140011.GetSynchroLevelCheck2(c,syncard,num,tc)
	return c:GetSynchroLevel(syncard)==num
		or (syncard:GetLevel()==num and tc:IsCode(1140901)
			and c:GetSynchroLevel(syncard)==(num-1))
end
--
function c1140011.SynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
--
	local checknum=0
	if g:GetCount()<1 then return false end
	local tc=g:GetFirst()
	while tc do
		local lv=0
		local num=syncard:GetLevel()
		if not tc:IsCode(1140901) then 
			lv=tc:GetSynchroLevel(syncard)
		end
		num=syncard:GetLevel()-lv
		local b1=(num==0 and g:IsExists(c1140011.GetSynchroLevelCheck1,1,tc,syncard) end
		local b2=(num~=0 and g:IsExists(c1140011.GetSynchroLevelCheck2,1,tc,syncard,tc,num))
		if b1 or b2 then checknum=1 end
		tc=g:GetNext()
	end
	if checknum~=1 then return false end
--
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(aux.SynLimitFilter,1,c,hf,he) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end
--
function c1140011.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)~=0
end
--
function c1140011.tfilter2(c)
	return c:GetType()==TYPE_TRAP and c:IsAbleToGrave()
end
function c1140011.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1140011.tfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
--
function c1140011.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c1140011.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()<1 then return end
	if Duel.SendtoGrave(sg,REASON_EFFECT)<1 then return end
	Duel.Damage(1-tp,600,REASON_EFFECT)
end
--
function c1140011.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
--
function c1140011.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
--
function c1140011.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsPlayerCanSpecialSummonMonster(tp,1140901,nil,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,tp) 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,1140901,nil,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,1-tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
--
function c1140011.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,1140901,nil,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,tp) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,1140901,nil,0x4011,400,600,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
--
	local token1=Duel.CreateToken(tp,1140901)
	Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2_1:SetValue(1)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	token1:RegisterEffect(e2_1,true)
	local e2_2=e2_1:Clone()
	e2_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token1:RegisterEffect(e2_2,true)
	local e2_3=e2_1:Clone()
	e2_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token1:RegisterEffect(e2_3,true)
	local e2_4=e2_1:Clone()
	e2_4:SetDescription(aux.Stringid(1140011,0))
	e2_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
	e2_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	token1:RegisterEffect(e2_4,true)
--
	local token2=Duel.CreateToken(tp,1140901)
	Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2_1:SetValue(1)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	token2:RegisterEffect(e2_1,true)
	local e2_2=e2_1:Clone()
	e2_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token2:RegisterEffect(e2_2,true)
	local e2_3=e2_1:Clone()
	e2_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token2:RegisterEffect(e2_3,true)
	local e2_4=e2_1:Clone()
	e2_4:SetDescription(aux.Stringid(1140011,0))
	e2_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
	e2_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	token2:RegisterEffect(e2_4,true)
--
	Duel.SpecialSummonComplete()
--
end
--
