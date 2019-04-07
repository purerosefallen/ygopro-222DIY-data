--响色的混融合调
function c65020133.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020133)
	e1:SetTarget(c65020133.target)
	e1:SetOperation(c65020133.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(65020133,ACTIVITY_CHAIN,c65020133.chainfilter)
end
function c65020133.chainfilter(re,tp,cid)
	local attr=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_ATTRIBUTE)
	return re:GetHandler():IsSetCard(0xcda4)
end
function c65020133.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65020133,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c65020133.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65020133.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0xcda4)
end
function c65020133.grfilter(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c65020133.refilter(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c65020133.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c65020133.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and c:IsSetCard(0xcda4)
end
function c65020133.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c65020133.grfilter,tp,LOCATION_GRAVE,0,nil)
		local mg3=Duel.GetMatchingGroup(c65020133.refilter,tp,LOCATION_REMOVED,0,nil)
		mg1:Merge(mg2)
		mg1:Merge(mg3)
		local res=Duel.IsExistingMatchingCard(c65020133.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c65020133.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65020133.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp)
	local mg0=Duel.GetMatchingGroup(c65020133.grfilter,tp,LOCATION_GRAVE,0,nil)
	local mg05=Duel.GetMatchingGroup(c65020133.refilter,tp,LOCATION_REMOVED,0,nil)
	mg:Merge(mg0)
	mg:Merge(mg05)
	mg1=mg:Filter(c65020133.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c65020133.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c65020133.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local matfm=mat1:Filter(c65020133.matfmfil,nil)
			local matgr=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			local matre=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			Duel.SendtoGrave(matfm,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Remove(matgr,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.SendtoDeck(matre,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c65020133.matfmfil(c)
	return c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_MZONE)
end