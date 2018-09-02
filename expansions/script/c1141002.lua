--可怜的非法投弃物·多多良小伞
local m=1141002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Tatara=true
--
function c1141002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1141002,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c1141002.tg1)
	e1:SetOperation(c1141002.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1141002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c1141002.cost2)
	e2:SetTarget(c1141002.tg2)
	e2:SetOperation(c1141002.op2)
	c:RegisterEffect(e2)
--
end
--
c1141002.muxu_ih_Tatara=1
--
function c1141002.tfilter1(c)
	return c.muxu_ih_Tatara and c:IsAbleToHand()
end
function c1141002.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1141002.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1141002.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c1141002.tfilter1,tp,LOCATION_DECK,0,1,3,nil)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	local lg=Duel.GetOperatedGroup()
	if lg:GetCount()<1 then return end
	Duel.ConfirmCards(1-tp,lg)
	Duel.SendtoGrave(lg,REASON_EFFECT+REASON_DISCARD)
end
--
function c1141002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--
function c1141002.allfilter2(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c1141002.ollfilter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c1141002.decfilter2_1(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c1141002.decfilter2_2(c,e)
	return c:IsFacedown() and not c:IsImmuneToEffect(e)
end
--
function c1141002.cfdfilter2(c,sg)
	local checknum=0
	local sc=sg:GetFirst()
	local mg=Group.CreateGroup()
	while sc do
		mg=sc:GetColumnGroup()
		if mg:IsContains(c) then checknum=1 end
		sc=sg:GetNext()
	end
	return c:IsFacedown() and checknum==1
end
--
function c1141002.checkmat(c,fc,tp)
	local t=fc.muxu_fus_mat
	if not t then return false end
	for i,f in pairs(t) do
		if (c:IsFaceup() and f(c))
			or (c:IsControler(tp) and f(c))
			or (c:IsControler(1-tp) and c:IsFacedown()) then
			return c:IsCanBeFusionMaterial(fc) end
	end
	return false
end
function c1141002.checkfup(fc)
	local l=fc.muxu_check_fus_mat
	if not l then return false end
	for i,l in pairs(l) do
		if i==1 then return true end
	end
	return false
end
function c1141002.CheckFusionFilter2(c,sc,fc,tp,exg)
	local checknum1=0
	local checknum2=0
	local t=fc.muxu_fus_mat
	if not c1141002.checkfup(fc) then
		local checknum1=0
		local checknum2=0
		local t=fc.muxu_fus_mat
		if t[1](sc) then checknum1=1 end
		if t[2](sc) then checknum2=1 end
		return (checknum1==0 and t[1](c))
			or (checknum2==0 and t[2](c))
			or (checknum1~=0 and checknum2~=0)
	else
		local l=fc.muxu_check_fus_mat
		if (l[1]==1 and l[2]~=1) then
			if exg:IsContains(sc) then checknum1=1 end
			if t[1](sc) and not exg:IsContains(sc) then checknum1=1 end
			if t[2](sc) and not exg:IsContains(sc) then checknum2=2 end
			return (checknum1==0 and (exg:IsContains(c) or (t[1](c) and not exg:IsContains(c))))
				or (checknum2==0 and t[2](c) and not exg:IsContains(c))
				or (checknum1~=0 and checknum2~=0)
		elseif (l[2]==1 and l[1]~=1) then
			if exg:IsContains(sc) then checknum2=1 end
			if t[1](sc) and not exg:IsContains(sc) then checknum1=1 end
			if t[2](sc) and not exg:IsContains(sc) then checknum2=2 end
			return (checknum1==0 and t[1](c) and not exg:IsContains(c)) 
				or (checknum2==0 and (exg:IsContains(c) or (t[2](c) and not exg:IsContains(c))))
				or (checknum1~=0 and checknum2~=0)
		else
			if t[1](sc) or exg:IsContains(sc) then checknum1=1 end
			if t[2](sc) or exg:IsContains(sc) then checknum2=1 end
			return (checknum1==0 and (t[1](c) or exg:IsContains(c)))
				or (checknum2==0 and (t[2](c) or exg:IsContains(c)))
				or (checknum1~=0 and checknum2~=0)
		end
	end
end
--
function c1141002.CheckRecursive2(c,mg,sg,exg,tp,fc,chkf)
	if exg:IsContains(c) and not c1141002.checkfup(fc) then return false end
	if not c1141002.checkmat(c,fc,tp) then return false end
	if sg:GetCount()>0 and not sg:IsExists(c1141002.CheckFusionFilter2,1,nil,c,fc,tp,exg) then return false end
	sg:AddCard(c)
	local res=false
	if sg:GetCount()==2 then
		res=Duel.GetLocationCountFromEx(chkf,tp,sg,fc)>0
	else
		res=mg:IsExists(c1141002.CheckRecursive2,1,sg,mg,sg,exg,tp,fc,chkf)
	end
	sg:RemoveCard(c)
	return res
end
--
function c1141002.tfilter2(c,e,tp,mg,exg,f,chkf)
	mg:Merge(exg)
	local sg=Group.CreateGroup()
	return c:IsType(TYPE_FUSION) 
		and muxu.check_set_Tatara(c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mg:IsExists(c1141002.CheckRecursive2,1,sg,mg,sg,exg,tp,c,chkf)
end
function c1141002.mfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION)
		and muxu.check_set_Tatara(c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
--
function c1141002.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		mg=mg:Filter(c1141002.allfilter2,nil)
		mg=mg:Filter(c1141002.ollfilter2,nil,e)
		local cg=Duel.GetMatchingGroup(c1141002.decfilter2_1,tp,0,LOCATION_MZONE,mg,e)
		mg:Merge(cg)
		local exg=Duel.GetMatchingGroup(c1141002.decfilter2_2,tp,0,LOCATION_MZONE,mg,e)
		local res=Duel.IsExistingMatchingCard(c1141002.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,exg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c1141002.mfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function c1141002.op2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp)
	mg=mg:Filter(c1141002.allfilter2,nil)
	mg=mg:Filter(c1141002.ollfilter2,nil,e)
	local cg=Duel.GetMatchingGroup(c1141002.decfilter2_1,tp,0,LOCATION_MZONE,mg,e)
	mg:Merge(cg)
	local exg=Duel.GetMatchingGroup(c1141002.decfilter2_2,tp,0,LOCATION_MZONE,mg,e)
	local sg1=Duel.GetMatchingGroup(c1141002.tfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,exg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		lg=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c1141002.tfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local lg=Group.CreateGroup()
			mg:Merge(exg)
			repeat
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local g=mg:FilterSelect(tp,c1141002.CheckRecursive2,1,1,lg,mg,lg,exg,tp,tc,chkf)
				lg:Merge(g)
			until lg:GetCount()==2
			tc:SetMaterial(lg)
			Duel.SendtoGrave(lg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
--
