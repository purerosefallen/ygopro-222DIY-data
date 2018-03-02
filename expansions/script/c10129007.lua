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
	if c10129007.counter==nil then
	   c10129007.counter=true
	   c10129007[0]=0
	end
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
	return not c:IsImmuneToEffect(e)
end
function c10129007.filter2(c,e,tp,m,f,chkf)
	local mat=m:Clone()
	if not c:IsCode(10129017) then
	   mat:Remove(Card.IsLocation,nil,LOCATION_REMOVED)
	end
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1 and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+101,tp,false,false) and c:CheckFusionMaterial(mat,nil,chkf) and (e:GetHandler():IsCode(10129007) or not c.outhell_fusion)
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
			  cg=cg:Filter(c10129007.filter1,nil,e):Filter(Card.IsCanBeFusionMaterial,nil)
		   end
		   g:Merge(cg)
		end
	end
   return g
end
function c10129007.exfilter0(c)
	return c:IsAbleToRemove() and c:IsHasEffect(10129016)
end
function c10129007.exfilter(c)
	return c:IsCanBeFusionMaterial() and (c:IsAbleToRemove() or c:IsAbleToGrave()) and c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1
end
function c10129007.exfilter1(c,e)
	return c10129007.exfilter(c) and not c:IsImmuneToEffect(e)
end
function c10129007.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)<=c10129007[0]
end
function c10129007.exfilter2(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c10129007.exfilter3(c,e)
	return c10129007.exfilter2(c) and not c:IsImmuneToEffect(e)
end
function c10129007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local exg=c10129007.checklinkmonster(tp)
		if exg:GetCount()>0 then
		   mg1:Merge(exg)
		end
		local exg3=Duel.GetMatchingGroup(c10129007.exfilter2,tp,LOCATION_REMOVED,0,nil)
		mg1:Merge(exg3)
		local ct=Duel.GetMatchingGroupCount(c10129007.exfilter0,tp,LOCATION_GRAVE,0,nil)
		c10129007[0]=0
		if ct>0 then
		   c10129007[0]=ct
		   local exg2=Duel.GetMatchingGroup(c10129007.exfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
		   if exg2:GetCount()>0 then
			  mg1:Merge(exg2)
			  Auxiliary.FCheckAdditional=c10129007.fcheck
		   end
		end
		local res=Duel.IsExistingMatchingCard(c10129007.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		c10129007[0]=0
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
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10129007.filter1,nil,e)
	local exg=c10129007.checklinkmonster(tp,e)
	if exg:GetCount()>0 then
	   mg1:Merge(exg)
	end
	local exg3=Duel.GetMatchingGroup(c10129007.exfilter3,tp,LOCATION_REMOVED,0,nil,e)
	mg1:Merge(exg3)
	local mg1clone=mg1:Clone()
	local exmat=false
	local cg=Duel.GetMatchingGroup(c10129007.exfilter0,tp,LOCATION_GRAVE,0,nil)
	c10129007[0]=0
	if cg:GetCount()>0 then
	c10129007[0]=cg:GetCount()
	   local exg2=Duel.GetMatchingGroup(c10129007.exfilter1,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
	   if exg2:GetCount()>0 then
		  mg1:Merge(exg2)
		  exmat=true
	   end
	end
	if exmat then Auxiliary.FCheckAdditional=c10129007.fcheck end
	local sg1=Duel.GetMatchingGroup(c10129007.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	exmat=false
	c10129007[0]=0
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
		if not tc:IsCode(10129017) then
		   mg1:Remove(Card.IsLocation,nil,LOCATION_REMOVED)
		   mg1clone:Remove(Card.IsLocation,nil,LOCATION_REMOVED)
		end
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then   
			if tc:CheckFusionMaterial(mg1clone,nil,chkf) then
			   local mgdeck,deckmat=mg1:Filter(Card.IsLocation,tc,LOCATION_EXTRA+LOCATION_DECK),false
			   if mgdeck:GetCount()>0 then
				  for dc in aux.Next(mgdeck) do
					  if tc:CheckFusionMaterial(mg1,dc,chkf) then
						 deckmat=true
						 break 
					  end
				  end
				  if deckmat and Duel.SelectYesNo(tp,aux.Stringid(10129016,0)) then
					 exmat=true
				  end
			   end
			else
				exmat=true 
			end
			if exmat then 
			   c10129007[0]=cg:GetCount()
			end
			Auxiliary.FCheckAdditional=c10129007.fcheck 
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			c10129007[0]=0
			tc:SetMaterial(mat1)
			local ct=mat1:FilterCount(Card.IsLocation,tc,LOCATION_EXTRA+LOCATION_DECK)
			if ct>0 then
			   local graveg=cg:Select(tp,ct,ct,nil)
			   Duel.Hint(HINT_CARD,0,10129016)
			   Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10129016,1))
			   Duel.Remove(graveg,POS_FACEUP,REASON_EFFECT)
			end
			local mat3=mat1:Filter(c10129007.matfilter2,nil)
			if mat3:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10129007,0)) then
			   local mat4=Group.CreateGroup()
			   if mat3:GetCount()==1 then
				  mat4=mat3:Clone()
			   else
				  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				  mat4=mat3:Select(tp,1,mat3:GetCount(),nil)
			   end
			   Duel.Remove(mat4,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			   c10129007.matfilter(c,mat4)
			   mat1:Sub(mat4)
			end
			local mat5=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			Duel.SendtoDeck(mat5,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			mat1:Sub(mat5)
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
function c10129007.matfilter2(c)
	return c:IsAbleToRemove() and not c:IsLocation(LOCATION_REMOVED)
end
function c10129007.matfilter(c,matg)
	local g=matg:Clone()
	local tc=g:GetFirst()
	while tc do
		  tc:RegisterFlagEffect(10129007,RESET_EVENT+0x1fe0000,0,0)
	tc=g:GetNext()
	end
end
