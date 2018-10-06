--忍妖 粉雪
function c12017001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12017001,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCost(c12017001.discost)
	e1:SetTarget(c12017001.distg)
	e1:SetOperation(c12017001.disop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12017001,3))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c12017001.thcon)
	e2:SetTarget(c12017001.thtg)
	e2:SetOperation(c12017001.thop)
	c:RegisterEffect(e2)  
end
function c12017001.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) or (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.GetFlagEffect(tp,12017001)==0 ) end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then Duel.RegisterFlagEffect(tp,12017001,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
	else
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
	end
end
function c12017001.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c12017001.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c12017001.filter2(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc)
end
function c12017001.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c12017001.filter0,tp,LOCATION_GRAVE,0,nil)
		local res=Duel.GetLocationCountFromEx(tp)>0
			and Duel.IsExistingMatchingCard(c12017001.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c12017001.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12017001.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c12017001.filter1,tp,LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c12017001.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c12017001.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if (Duel.GetLocationCountFromEx(tp)>0 and sg1:GetCount()>0) or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c12017001.cfilter(c,tp)
	return c:GetPreviousControler()==tp
		and c:IsSetCard(0xfb4)  
end
function c12017001.cfilter1(c,e,tp)
	return c:IsSetCard(0xfb4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12017001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12017001.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0  and not re:GetHandler():IsCode(12017001)
end
function c12017001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=(c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.GetFlagEffect(tp,12017001+100)==0)
	local b2=(c:IsAbleToDeck() and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c12017001.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,12017001+200)==0 )
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,1,0)
	local g=Duel.GetMatchingGroup(c12017001.cfilter1,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c12017001.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=(c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.GetFlagEffect(tp,12017001+100)==0 )
	local b2=(c:IsAbleToDeck() and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c12017001.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,12017001+200)==0 )
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(12017001,1),aux.Stringid(12017001,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(12017001,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(12017001,2))+1
	else return end
	if op==0 then
		if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		h1=Duel.Draw(tp,1,REASON_EFFECT)
		h2=Duel.Draw(1-tp,1,REASON_EFFECT)
		if h1>0 then
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		 end
		if h2>0 then 
		Duel.ShuffleHand(1-tp)
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
		Duel.RegisterFlagEffect(tp,12017001+100,RESET_PHASE+PHASE_END,0,1)
	else
		if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>=0  and Duel.GetMZoneCount(tp)>=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c12017001.cfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,12017002+200,RESET_PHASE+PHASE_END,0,1)
		end
		end
	end
end