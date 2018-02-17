--废狱融合
function c10129007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10129007.target)
	e1:SetOperation(c10129007.activate)
	c:RegisterEffect(e1)   
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(10129007,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10129007)
	e2:SetCost(c10129007.thcost)
	e2:SetTarget(c10129007.thtg)
	e2:SetOperation(c10129007.thop)
	c:RegisterEffect(e2)  
end
c10129007.card_code_list={10129007}
function c10129007.cfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_FUSION) and c:GetLevel()==1 and c:IsAbleToExtraAsCost()
end
function c10129007.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10129007.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10129007.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c10129007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10129007.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end
function c10129007.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c10129007.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1 and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+101,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and (e:GetHandler():IsCode(10129007) or not c.outhell_fusion)
end
function c10129007.lfilter1(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c10129007.ffilter(c,tp)
	return c:IsControler(tp) and c:IsCanBeFusionMaterial() and c:IsFaceup()
end
function c10129007.checklinkmonster(tp,e)
	local g=Group.CreateGroup()
	local lg=Duel.GetMatchingGroup(c10129007.lfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		local lm=tc:GetLinkedGroup()
		if lm:GetCount()>0 and lm:FilterCount(c10129007.ffilter,nil,1-tp)>0 then
		   local cg=lm:Filter(c10129007.ffilter,nil,1-tp)
		   if e then
			  cg=cg:Filter(c10129007.filter1,nil,e)
		   end
		   g:Merge(cg)
		end
	end
   return g
end
function c10129007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local exg=c10129007.checklinkmonster(tp)
		if exg:GetCount()>0 then
		   mg1:Merge(exg)
		end
		local res=Duel.IsExistingMatchingCard(c10129007.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10129007.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10129007.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf,c=tp,e:GetHandler()
	local mg1=Duel.GetMatchingGroup(c10129007.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local exg=c10129007.checklinkmonster(tp,e)
	if exg:GetCount()>0 then
	   mg1:Merge(exg)
	end
	local sg1=Duel.GetMatchingGroup(c10129007.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10129007.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local mat3=mat1:Filter(Card.IsAbleToRemove,nil)
			if mat3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10129007,0)) then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			   local mat4=mat3:Select(tp,1,mat3:GetCount(),nil)
			   Duel.Remove(mat4,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			   c10129007.matfilter(c,mat4)
			   mat1:Sub(mat4)
			end
			if mat1:GetCount()>0 then
			   Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			c10129007.matfilter(c,mat1)  
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION+101,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2,SUMMON_TYPE_FUSION+101)
			c10129007.matfilter(c,mat2)  
		end
		tc:CompleteProcedure()
	end
end
function c10129007.matfilter(c,matg)
	local g=matg:Clone()
	local tc=g:GetFirst()
	while tc do
		  tc:RegisterFlagEffect(10129007,RESET_EVENT+0x1fe0000,0,0)
	tc=g:GetNext()
	end
end
