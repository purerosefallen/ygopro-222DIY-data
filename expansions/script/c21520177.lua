--扭曲揉合
function c21520177.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetDescription(aux.Stringid(21520177,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21520177)
	e1:SetCondition(c21520177.condition)
	e1:SetCost(c21520177.cost)
	e1:SetTarget(c21520177.target)
	e1:SetOperation(c21520177.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(21520177,1))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c21520177.thcon)
	e2:SetTarget(c21520177.thtg)
	e2:SetOperation(c21520177.thop)
	c:RegisterEffect(e2)
end
function c21520177.filter1(c,e,tp)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c21520177.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x3490) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21520177.filter0(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x490) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21520177.tdfilter(c)
--	return (not c:IsSetCard(0x490) and not c:IsDisabled() and (not c:IsType(TYPE_NORMAL) or bit.band(c:GetOriginalType(),TYPE_EFFECT)~=0)) or not c:IsFaceup()
	return not c:IsSetCard(0x490) or not c:IsFaceup()
end
function c21520177.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function c21520177.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone(e1)
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function c21520177.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c21520177.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c21520177.filter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		local res=Duel.IsExistingMatchingCard(c21520177.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if Duel.IsExistingMatchingCard(c21520177.cfilter,tp,0,LOCATION_MZONE,1,nil) then
			res=Duel.IsExistingMatchingCard(c21520177.filter0,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		end
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21520177.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				if Duel.IsExistingMatchingCard(c21520177.cfilter,tp,0,LOCATION_MZONE,1,nil) then
					res=Duel.IsExistingMatchingCard(c21520177.filter0,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21520177.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c21520177.filter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local sg1=Duel.GetMatchingGroup(c21520177.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	if Duel.IsExistingMatchingCard(c21520177.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		sg1=Duel.GetMatchingGroup(c21520177.filter0,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	end
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21520177.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		if Duel.IsExistingMatchingCard(c21520177.cfilter,tp,0,LOCATION_MZONE,1,nil) then
			sg2=Duel.GetMatchingGroup(c21520177.filter0,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		--reduce
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e4:SetCondition(c21520177.rdcon)
		e4:SetOperation(c21520177.rdop)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
	local tdg=Duel.GetMatchingGroup(c21520177.tdfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SendtoDeck(tdg,nil,2,REASON_RULE)
end
function c21520177.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c21520177.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c21520177.thfilter(c,tp)
	return c:IsSetCard(0x490) and c:IsType(TYPE_FUSION) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c21520177.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520177.thfilter,1,nil,tp) and bit.band(r,REASON_DESTROY)~=0
end
function c21520177.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c21520177.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
