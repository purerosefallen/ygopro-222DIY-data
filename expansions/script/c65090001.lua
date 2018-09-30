--星之骑士的希望 卡比
function c65090001.initial_effect(c)
	--FUSION
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c65090001.target)
	e1:SetCost(c65090001.cost)
	e1:SetOperation(c65090001.activate)
	c:RegisterEffect(e1)
	--lose copy
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCondition(c65090001.lccon)
	e0:SetCost(c65090001.lccost)
	e0:SetTarget(c65090001.lctg)
	e0:SetOperation(c65090001.lcop)
	c:RegisterEffect(e0)
	Duel.AddCustomActivityCounter(65090001,ACTIVITY_SPSUMMON,c65090001.counterfilter)
end
function c65090001.counterfilter(c)
	return c:IsSetCard(0xda6)
end
function c65090001.lcfil(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x3da6)  and c:IsPreviousPosition(POS_FACEUP) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:GetPreviousControler()==tp 
end
function c65090001.lccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65090001.lcfil,1,nil,tp)
end
function c65090001.lccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65090001,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFlagEffect(tp,65090002)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65090001.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,65090002,RESET_CHAIN,0,1)
end
function c65090001.lctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c65090001.lcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65090001.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c65090001.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c65090001.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and c:IsSetCard(0x3da6)
end
function c65090001.filter3(c,e)
	return c:IsOnField() and c:IsAbleToGraveAsCost()
end
function c65090001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetMatchingGroup(c65090001.filter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c65090001.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c65090001.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65090001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c65090001.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(c65090001.filter1,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c65090001.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c65090001.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if chk==0 then return sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) and Duel.GetCustomActivityCount(65090001,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFlagEffect(tp,65090001)==0 end
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			Duel.ConfirmCards(1-tp,tc)
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_COST+REASON_MATERIAL+REASON_FUSION)
			e:SetLabelObject(tc)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65090001.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,65090001,RESET_CHAIN,0,1)
end
function c65090001.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xda6)
end
function c65090001.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetLocationCountFromEx(tp)>0 and tc:IsLocation(LOCATION_EXTRA) and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) then
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end