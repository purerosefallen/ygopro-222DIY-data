--战场女武神 瓦尔基里枪盾
function c11113001.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11113001)
	e1:SetTarget(c11113001.target)
	e1:SetOperation(c11113001.activate)
	c:RegisterEffect(e1)
	--shuffle and draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113001,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,111130010)
	e2:SetCost(c11113001.thcost)
	e2:SetTarget(c11113001.thtg)
	e2:SetOperation(c11113001.thop)
	c:RegisterEffect(e2)
end
function c11113001.filter0(c)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToRemove()
end
function c11113001.mfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c11113001.exfilter0(c)
	return c:IsSetCard(0x15c) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c11113001.filter1(c,e)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c11113001.mfilter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c11113001.exfilter1(c,e)
	return c:IsSetCard(0x15c) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c11113001.spfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x15c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11113001.cfilter(c)
	return c:GetSequence()<5
end
function c11113001.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1
end
function c11113001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c11113001.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c11113001.mfilter0,tp,LOCATION_GRAVE,0,nil)
		mg2:Merge(mg1)
		if not Duel.IsExistingMatchingCard(c11113001.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local sg=Duel.GetMatchingGroup(c11113001.exfilter0,tp,LOCATION_EXTRA,0,nil)
			if sg:GetCount()>0 then
				mg2:Merge(sg)
				Auxiliary.FCheckAdditional=c11113001.fcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c11113001.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c11113001.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11113001.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c11113001.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c11113001.mfilter1,tp,LOCATION_GRAVE,0,nil,e)
	mg2:Merge(mg1)
	local exmat=false
	if not Duel.IsExistingMatchingCard(c11113001.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(c11113001.exfilter1,tp,LOCATION_EXTRA,0,nil,e)
		if sg:GetCount()>0 then
			mg2:Merge(sg)
			exmat=true
		end
	end
	if exmat then Auxiliary.FCheckAdditional=c11113001.fcheck end
	local sg1=Duel.GetMatchingGroup(c11113001.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
	local mg3=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(c11113001.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		    if exmat then Auxiliary.FCheckAdditional=c11113001.fcheck end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function c11113001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11113001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c11113001.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,g:GetCount(),REASON_EFFECT)
end