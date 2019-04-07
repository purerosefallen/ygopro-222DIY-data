--蝶舞·强制凭依
function c1111026.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c1111026.tg1)
	e1:SetOperation(c1111026.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c1111026.tg2)
	e2:SetOperation(c1111026.op2)
	c:RegisterEffect(e2)
--
end
--
function c1111026.tfilter1_1(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c1111026.tfilter1_2(c,tp)
	return c:IsCanBeFusionMaterial()
		and (c:IsControler(tp) or c:IsFaceup())
end
function c1111026.tfilter1_3(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
		and muxu.check_set_Urban(c)
end
function c1111026.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetMatchingGroup(c1111026.tfilter1_1,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		local mg3=Duel.GetMatchingGroup(c1111026.tfilter1_2,tp,LOCATION_SZONE,LOCATION_SZONE,nil,tp)
		mg1:Merge(mg3)
		local res=Duel.IsExistingMatchingCard(c1111026.tfilter1_3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c1111026.tfilter1_3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	Duel.SetChainLimit(aux.FALSE)
end
--
function c1111026.ofilter1_1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function c1111026.ofilter1_2(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c1111026.ofilter1_3(c,tp,e)
	return c:IsCanBeFusionMaterial()
		and (c:IsControler(tp) or c:IsFaceup())
		and not c:IsImmuneToEffect(e)
end
function c1111026.op1(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c1111026.ofilter1_1,nil,e)
	local mg2=Duel.GetMatchingGroup(c1111026.ofilter1_2,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local mg3=Duel.GetMatchingGroup(c1111026.ofilter1_3,tp,LOCATION_SZONE,LOCATION_SZONE,nil,tp,e)
	mg1:Merge(mg3)
	local sg1=Duel.GetMatchingGroup(c1111026.tfilter1_3,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c1111026.tfilter1_2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
function c1111026.tfilter2(c)
	return muxu.check_set_Soul(c) and not c:IsForbidden()
		and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c1111026.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0
		and Duel.IsExistingMatchingCard(c1111026.tfilter2,tp,LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
--
function c1111026.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE,0)
	if ft<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local lg=Duel.SelectMatchingCard(tp,c1111026.tfilter2,tp,LOCATION_GRAVE,0,1,ft,c)
	if lg:GetCount()<1 then return end
	local lc=lg:GetFirst()
	while lc do
		Duel.MoveToField(lc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetDescription(aux.Stringid(1111026,0))
		e2_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e2_1:SetCondition(c1111026.con2_1)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2_1,true)
		lc=lg:GetNext()
	end
end
--
function c1111026.con2_1(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetHandler():GetColumnGroup()
	sg:AddCard(e:GetHandler())
	return not sg:IsExists(Card.IsType,1,nil,TYPE_SPIRIT)
end
--
