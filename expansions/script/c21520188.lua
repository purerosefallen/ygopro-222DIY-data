--艺形魔-纸凤凰
function c21520188.initial_effect(c)
	--spsumon from szone muti
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(21520188,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21520188)
	e1:SetCondition(c21520188.spmcon)
	e1:SetCost(c21520188.spmcost)
	e1:SetTarget(c21520188.spmtg)
	e1:SetOperation(c21520188.spmop)
	c:RegisterEffect(e1)
	--spsumon from szone one
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520188,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21520188)
	e2:SetTarget(c21520188.spotg)
	e2:SetOperation(c21520188.spoop)
	c:RegisterEffect(e2)
	local e2_2=e2:Clone()
	e2_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2_2)
	--spsumon from szone at end_phase
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetDescription(aux.Stringid(21520188,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(TIMING_END_PHASE)
	e3:SetCondition(c21520188.specon)
	e3:SetTarget(c21520188.spetg)
	e3:SetOperation(c21520188.speop)
	c:RegisterEffect(e3)
end
function c21520188.fieldfilter(c)
	return c:IsCode(21520181) and c:IsFaceup()
end
function c21520188.spmcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c21520188.fieldfilter,tp,LOCATION_ONFIELD,0,1,nil) then 
		return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
	else
		return Duel.GetTurnPlayer()==tp
	end
end
function c21520188.spmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST) 
end
function c21520188.pfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and not c:IsPublic()
end
function c21520188.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x490) and c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER
end
function c21520188.spmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520188.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c21520188.pfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local spg=Duel.GetMatchingGroup(c21520188.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	local pgct=Duel.GetMatchingGroupCount(c21520188.pfilter,tp,LOCATION_HAND,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,math.min(spg:GetCount(),pgct,Duel.GetLocationCount(tp,LOCATION_MZONE)),0,LOCATION_SZONE)
end
function c21520188.spmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520188.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	local hg=Duel.GetMatchingGroup(c21520188.pfilter,tp,LOCATION_HAND,0,e:GetHandler())
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if g:GetCount()>0 and hg:GetCount()>0 and ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local pg=hg:Select(tp,1,math.min(hg:GetCount(),g:GetCount(),ft),nil)
		Duel.ConfirmCards(1-tp,pg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ct=pg:GetCount()
		local dg=g:Select(tp,ct,ct,nil)
		Duel.SpecialSummon(dg,0,tp,tp,true,false,POS_FACEUP)
		Duel.ShuffleHand(tp)
	end
end
function c21520188.spotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520188.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
end
function c21520188.spoop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520188.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c21520188.specon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetType()&(TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS and ph==PHASE_END
end
function c21520188.spefilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToRemove()
end
function c21520188.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520188.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c21520188.spefilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
end
function c21520188.speop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21520188.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	local rg=Duel.GetMatchingGroup(c21520188.spefilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and rg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg1=rg:Select(tp,1,1,nil)
		if Duel.Remove(rg1,REASON_EFFECT,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
--[[
function c21520188.fcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_END
end
function c21520188.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c21520188.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x490)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21520188.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c21520188.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		local res=Duel.IsExistingMatchingCard(c21520188.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21520188.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c21520188.fsop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c21520188.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local sg1=Duel.GetMatchingGroup(c21520188.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21520188.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			Duel.ConfirmCards(1-tp,mat1)
			Duel.SendtoDeck(mat1,tp,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		Duel.BreakEffect()
		local dct=Duel.GetMatchingGroupCount(c21520188.desfilter,tp,LOCATION_ONFIELD,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,dct,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c21520188.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x490)
end
--]]