--时线的缔合
function c65011008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65011008)
	e1:SetTarget(c65011008.distg)
	e1:SetOperation(c65011008.disop)
	c:RegisterEffect(e1)
	--bfg
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65011028)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c65011008.target)
	e2:SetOperation(c65011008.activate)
	c:RegisterEffect(e2)
end
function c65011008.filfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c65011008.filfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c65011008.filfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xda2) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function c65011008.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c65011008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		if Duel.IsExistingMatchingCard(c65011008.cfilter,tp,0,LOCATION_MZONE,1,nil) then
			local mg2=Duel.GetMatchingGroup(c65011008.filfilter0,tp,0,LOCATION_MZONE,nil)
			mg1:Merge(mg2)
		end
		local res=Duel.IsExistingMatchingCard(c65011008.filfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c65011008.filfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c65011008.fcheckfil(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
end

function c65011008.fcheck(tp,sg,fc)
	return sg:FilterCount(c65011008.fcheckfil,nil,tp)<=1
end
function c65011008.disop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c65011008.filfilter1,nil,e)
	if Duel.IsExistingMatchingCard(c65011008.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		local mg2=Duel.GetMatchingGroup(c65011008.filfilter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		Auxiliary.FCheckAdditional=c65011008.fcheck
	end
	local sg1=Duel.GetMatchingGroup(c65011008.filfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c65011008.filfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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

function c65011008.filter1(c,tp)
	return c.material and Duel.IsExistingMatchingCard(c65011008.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c) and c:IsSetCard(0xda2)
end
function c65011008.filter2(c,fc)
	if c:IsForbidden() or not c:IsAbleToHand() then return false end
	return c:IsCode(table.unpack(fc.material))
end
function c65011008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011008.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65011008.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c65011008.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65011008.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,cg:GetFirst())
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(c65011008.aclimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c65011008.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end