--融合武器 暗魔剑
function c10173086.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10173086.target)
	e1:SetOperation(c10173086.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173086,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10173086.fuscon)
	e3:SetTarget(c10173086.fustg)
	e3:SetOperation(c10173086.fusop)
	c:RegisterEffect(e3)
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c10173086.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10173086.spfilter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c10173086.spfilter3(c,e,tp,m,ec,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,ec,chkf)
end
function c10173086.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c10173086.fcheck(tp,sg,fc,mg)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		local g=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		return g:GetCount()<=1 and (g:GetCount()==0 or sg:FilterCount(Card.IsLocation,g:GetFirst(),LOCATION_MZONE)==sg:GetCount()-1) end
	return true
end
function c10173086.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then
		if not ec then return false end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c10173086.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		mg1:Merge(mg2)
		aux.FCheckAdditional=c10173086.fcheck
		local res=Duel.IsExistingMatchingCard(c10173086.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,ec,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10173086.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,ec,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10173086.fusop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) or not ec then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10173086.spfilter2,nil,e)
	local mg2=Duel.GetMatchingGroup(c10173086.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil):Filter(c10173086.spfilter2,nil,e)
	mg1:Merge(mg2)
	aux.FCheckAdditional=c10173086.fcheck
	local sg1=Duel.GetMatchingGroup(c10173086.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,ec,nil,chkf)
	aux.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10173086.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,ec,mf,chkf)
	end
	local sg=sg1:Clone()
	if sg2 then sg:Merge(sg2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		aux.FCheckAdditional=c10173086.fcheck
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,ec,chkf)
		aux.FCheckAdditional=nil
		tc:SetMaterial(mat1)
		local matg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if matg:GetCount()>0 then
		   Duel.Remove(matg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		   mat1:Sub(matg)
		end
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	else
		local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,ec,chkf)
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,mat2)
	end
	tc:CompleteProcedure()
end
function c10173086.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c10173086.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end