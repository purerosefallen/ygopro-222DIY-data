--虚梦·西瓜
function c81009005.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c81009005.ffilter,2,false)
	--ritual material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e1:SetValue(c81009005.mtval)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81009005,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81009005)
	e2:SetCost(c81009005.spcost)
	e2:SetTarget(c81009005.sptg)
	e2:SetOperation(c81009005.spop)
	c:RegisterEffect(e2)
end
function c81009005.ffilter(c)
	return c:IsFusionType(TYPE_EFFECT) and c:GetBaseAttack()>=2000
end
function c81009005.mtval(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function c81009005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c81009005.spfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c81009005.spfilter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c81009005.spfilter2(c,e,tp,m,f,chkf)
	return (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true) and c:CheckFusionMaterial(m,nil,chkf)
end
function c81009005.spfilter3(c,e,tp,chkf)
	if not c:IsType(TYPE_FUSION) or not c:IsAbleToExtra() then return false end
	local mg=Duel.GetMatchingGroup(c81009005.spfilter0,tp,LOCATION_GRAVE,0,c)
	local res=c81009005.spfilter2(c,e,tp,mg,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=c81009005.spfilter2(c,e,tp,mg,mf,chkf)
		end
	end
	return res
end
function c81009005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chkf=PLAYER_NONE
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c81009005.spfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,chkf) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81009005.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81009005.spfilter3),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,chkf)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		local mg1=Duel.GetMatchingGroup(c81009005.spfilter1,tp,LOCATION_GRAVE,0,nil,e)
		local mgchk1=c81009005.spfilter2(tc,e,tp,mg1,nil,chkf)
		local mg2=nil
		local mgchk2=false
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			mgchk2=c81009005.spfilter2(tc,e,tp,mg2,mf,chkf)
		end
		if (Duel.GetLocationCountFromEx(tp)>0 and mgchk1) or mgchk2 then
			if mgchk1 and (not mgchk2 or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
end
