--梦魇融合
function c10129006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10129006.target)
	e1:SetOperation(c10129006.activate)
	c:RegisterEffect(e1)
	if c10129006.counter==nil then
	   c10129006.counter=true
	   c10129006[0]=0
	end 
end
c10129006.card_code_list={10129007}
function c10129006.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c10129006.exfilter0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c10129006.exfilter1(c,e)
	return c10129006.exfilter0(c) and not c:IsImmuneToEffect(e)
end
function c10129006.exfilter2(c)
	return not c:IsRace(RACE_ZOMBIE) or c:IsFacedown()
end
function c10129006.filter2(c,e,tp,m,f,chkf)
	local mat=m:Clone()
	if not c:IsCode(10129017) then
	   mat:Remove(Card.IsLocation,nil,LOCATION_REMOVED)
	end
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1 and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+101,tp,false,false) and c:CheckFusionMaterial(mat,nil,chkf)
end
function c10129006.lfilter1(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c10129006.ffilter(c,tp)
	return c:IsControler(tp) and c:IsCanBeFusionMaterial() and c:IsFaceup()
end
function c10129006.checklinkmonster(tp,e)
	local g=Group.CreateGroup()
	local lg=Duel.GetMatchingGroup(c10129006.lfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(lg) do
		local lm=tc:GetLinkedGroup()
		if lm:GetCount()>0 and lm:FilterCount(c10129006.ffilter,nil,1-tp)>0 then
		   local cg=lm:Filter(c10129006.ffilter,nil,1-tp)
		   if e then
			  cg=cg:Filter(c10129006.filter1,nil,e):Filter(Card.IsCanBeFusionMaterial,nil)
		   end
		   g:Merge(cg)
		end
	end
   return g
end
function c10129006.exfilter3(c)
	return c:IsAbleToRemove() and c:IsHasEffect(10129016)
end
function c10129006.exfilter4(c)
	return c:IsCanBeFusionMaterial() and (c:IsAbleToRemove() or c:IsAbleToGrave()) and c:IsRace(RACE_ZOMBIE) and c:GetLevel()==1
end
function c10129006.exfilter5(c,e)
	return c10129006.exfilter4(c) and not c:IsImmuneToEffect(e)
end
function c10129006.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA+LOCATION_DECK)<=c10129006[0]
end
function c10129006.exfilter6(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c10129006.exfilter7(c,e)
	return c10129006.exfilter6(c) and not c:IsImmuneToEffect(e)
end
function c10129006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		local exg=c10129006.checklinkmonster(tp)
		if exg:GetCount()>0 then
		   mg1:Merge(exg)
		end
		if not Duel.IsExistingMatchingCard(c10129006.exfilter2,tp,LOCATION_MZONE,0,1,nil) then
			local sg=Duel.GetMatchingGroup(c10129006.exfilter0,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
			if sg:GetCount()>0 then
			   mg1:Merge(sg)
			end
		end
		local exg3=Duel.GetMatchingGroup(c10129006.exfilter6,tp,LOCATION_REMOVED,0,nil)
		mg1:Merge(exg3)
		local ct=Duel.GetMatchingGroupCount(c10129006.exfilter3,tp,LOCATION_GRAVE,0,nil)
		c10129006[0]=0
		if ct>0 then
		   c10129006[0]=ct
		   local exg2=Duel.GetMatchingGroup(c10129006.exfilter4,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil)
		   if exg2:GetCount()>0 then
			  mg1:Merge(exg2)
			  Auxiliary.FCheckAdditional=c10129006.fcheck
		   end
		end
		local res=Duel.IsExistingMatchingCard(c10129006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		c10129006[0]=0
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10129006.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10129006.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf,c=tp,e:GetHandler()
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10129006.filter1,nil,e)
	local exg=c10129006.checklinkmonster(tp,e)
	if exg:GetCount()>0 then
	   mg1:Merge(exg)
	end
	if not Duel.IsExistingMatchingCard(c10129006.exfilter2,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(c10129006.exfilter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
		if sg:GetCount()>0 then
		   mg1:Merge(sg)
		end
	end
	local exg3=Duel.GetMatchingGroup(c10129006.exfilter7,tp,LOCATION_REMOVED,0,nil,e)
	mg1:Merge(exg3)
	local mg1clone=mg1:Clone()
	local exmat=false
	local cg=Duel.GetMatchingGroup(c10129006.exfilter3,tp,LOCATION_GRAVE,0,nil)
	c10129006[0]=0
	if cg:GetCount()>0 then
	c10129006[0]=cg:GetCount()
	   local exg2=Duel.GetMatchingGroup(c10129006.exfilter5,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e)
	   if exg2:GetCount()>0 then
		  mg1:Merge(exg2)
		  exmat=true
	   end
	end
	if exmat then Auxiliary.FCheckAdditional=c10129006.fcheck end
	local sg1=Duel.GetMatchingGroup(c10129006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	exmat=false
	c10129006[0]=0
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10129006.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
		mg1:RemoveCard(tc)
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
			   c10129006[0]=cg:GetCount()
			end
			Auxiliary.FCheckAdditional=c10129006.fcheck 
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			c10129006[0]=0
			tc:SetMaterial(mat1)
			local deckmat2,rg=mat1:Filter(Card.IsLocation,tc,LOCATION_EXTRA+LOCATION_DECK),Group.CreateGroup()
			if deckmat2:GetCount()>0 then
			   local graveg=cg:Select(tp,deckmat2:GetCount(),deckmat2:GetCount(),nil)
			   Duel.Hint(HINT_CARD,0,10129016)
			   Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10129016,1))
			   Duel.Remove(graveg,POS_FACEUP,REASON_EFFECT)
			   if Duel.SelectYesNo(tp,aux.Stringid(10129016,2)) then
				  if deckmat2:GetCount()==1 then rg:Merge(deckmat2)
				  else
					 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					 rg=deckmat2:Select(tp,1,99,nil)
				  end
			   end
			end
			local rmat=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			if rmat then
			   if rg:GetCount()>0 then rmat:Merge(rg) end
			   Duel.Remove(rmat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			   c10129006.matfilter(c,rmat)
			   mat1:Sub(rmat)
			end
			rmat=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			if rmat:GetCount()>0 then
			   Duel.SendtoDeck(rmat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			   mat1:Sub(rmat)
			end
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			c10129006.matfilter(c,mat1)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION+101,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			c10129006.matfilter(c,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c10129006.matfilter(c,matg)
	local g=matg:Clone()
	local tc=g:GetFirst()
	while tc do
		 tc:RegisterFlagEffect(10129007,RESET_EVENT+0x1fe0000,0,0)
	tc=g:GetNext()
	end
end
