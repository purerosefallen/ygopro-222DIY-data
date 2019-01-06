---新年快乐-
function c1170011.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1170011.tg1)
	e1:SetOperation(c1170011.op1)
	c:RegisterEffect(e1)
--
	if c1170011.clp==nil then
		c1170011.clp=true
		c1170011.tlp=Duel.GetLP(tp)
	end
--
end
--
function c1170011.tfilter1(c)
	return c:IsType(TYPE_MONSTER)
		and not (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_EFFECT))
end
function c1170011.sfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
end
function c1170011.dfilter1(c)
	return c:IsCode(1192018) and c:IsAbleToHand()
end
function c1170011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local el={}
	local check=0
	local mg=Duel.GetMatchingGroup(c1170011.tfilter1,tp,LOCATION_HAND,0,nil)
	for tc in aux.Next(mg) do
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CHANGE_TYPE)
		e1_1:SetValue(TYPE_RITUAL+TYPE_MONSTER+TYPE_EFFECT)
		tc:RegisterEffect(e1_1,true)
		table.insert(el,e1_1)
	end
	local res=mg:IsExists(c1170011.sfilter1,1,nil,e,tp)
	for _,e in ipairs(el) do
		e:Reset()
	end
	local b1=Duel.IsExistingMatchingCard(c1170011.dfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=(Duel.GetLP(tp)~=c1170011.tlp)
		or (Duel.GetLP(1-tp)~=c1170011.tlp)
	local b3=res and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1170011,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1170011,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(1170011,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if sel==3 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
--
function c1170011.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c1170011.dfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	if sel==2 then 
		Duel.SetLP(tp,c1170011.tlp)
		Duel.SetLP(1-tp,c1170011.tlp)
	end
	if sel==3 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		local el={}
		local mg=Duel.GetMatchingGroup(c1170011.tfilter1,tp,LOCATION_HAND,0,nil)
		for tc in aux.Next(mg) do
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_CHANGE_TYPE)
			e1_2:SetValue(TYPE_RITUAL+TYPE_MONSTER+TYPE_EFFECT)
			tc:RegisterEffect(e1_2,true)
			table.insert(el,e1_2)
		end
		local tg=mg:Filter(c1170011.sfilter1,nil,e,tp)
		for _,e in ipairs(el) do
			e:Reset()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local lg=tg:Select(tp,1,1,nil)
		if lg:GetCount()<1 then return end
		local lc=lg:GetFirst()
		local e1_3=Effect.CreateEffect(c)
		e1_3:SetValue(TYPE_RITUAL+TYPE_MONSTER+TYPE_EFFECT)
		e1_3:SetType(EFFECT_TYPE_SINGLE)
		e1_3:SetCode(EFFECT_CHANGE_TYPE)
		e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_3:SetReset(RESET_EVENT+0xfe0000)
		lc:RegisterEffect(e1_3,true)
		lc:SetMaterial(nil)
		Duel.SpecialSummon(lc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
		local e1_4=Effect.CreateEffect(c)
		e1_4:SetDescription(aux.Stringid(1170011,3))
		e1_4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1_4:SetType(EFFECT_TYPE_SINGLE)
		lc:RegisterEffect(e1_4,true)
		lc:CompleteProcedure()
	end
end
--
