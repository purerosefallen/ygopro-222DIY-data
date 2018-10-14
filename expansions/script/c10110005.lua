--元素火花 融合
function c10110005.initial_effect(c)
	--ACTIVATE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10110005.target)
	e1:SetOperation(c10110005.activate)
	c:RegisterEffect(e1)
	--fusion 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c10110005.spcost)
	e2:SetTarget(c10110005.target)
	e2:SetOperation(c10110005.activate)
	c:RegisterEffect(e2)
end
function c10110005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10110005.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c10110005.gfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c10110005.gfilter2(c,e)
	return c10110005.gfilter(c) and not c:IsImmuneToEffect(e)
end
function c10110005.tdfilter(c,e,tp,mg1,chkf)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsType(TYPE_MONSTER) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10110005.tdfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp,mg1,c:GetAttribute(),c,chkf)
end
function c10110005.tdfilter2(c,e,tp,mg1,att,rc,chkf)
	local mg2=mg1:Clone()
	mg2:Sub(Group.FromCards(c,rc))
	return c:IsAbleToDeckOrExtraAsCost() and c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsAttribute(att) and Duel.IsExistingMatchingCard(c10110005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
end
function c10110005.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and c:IsSetCard(0x9332)
end
function c10110005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf,res=tp,false
		local mg1=Duel.GetFusionMaterial(tp)
		local gmg=Duel.GetMatchingGroup(c10110005.gfilter,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(gmg)
		if e:GetLabel()==100 then
		   res=(Duel.IsExistingMatchingCard(c10110005.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,mg1,chkf) and e:GetHandler():IsAbleToDeckAsCost())
		else
		   res=Duel.IsExistingMatchingCard(c10110005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		end
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10110005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	if e:GetLabel()==100 then
	   local mg1=Duel.GetFusionMaterial(tp)
	   local gmg=Duel.GetMatchingGroup(c10110005.gfilter,tp,LOCATION_GRAVE,0,nil)
	   mg1:Merge(gmg)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local tc=Duel.SelectMatchingCard(tp,c10110005.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,mg1,chkf):GetFirst()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local g1=Duel.SelectMatchingCard(tp,c10110005.tdfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,mg1,tc:GetAttribute(),tc,chkf)
	   g1:AddCard(tc)
	   Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	   Duel.SendtoDeck(g1,nil,2,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10110005.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10110005.filter1,nil,e)
	local gmg=Duel.GetMatchingGroup(c10110005.gfilter2,tp,LOCATION_GRAVE,0,nil,e)
	mg1:Merge(gmg)
	local sg1=Duel.GetMatchingGroup(c10110005.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10110005.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local matg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			if matg:GetCount()>0 then
			   Duel.Remove(matg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			   mat1:Sub(matg)
			end
			if mat1:GetCount()>0 then
			   Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
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