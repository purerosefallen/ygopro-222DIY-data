--前线阵地 火山惑星
function c13257217.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c13257217.operation)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c13257217.etarget)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--roll and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257217,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetOperation(c13257217.rdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257217,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_FZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c13257217.spcon)
	e4:SetCost(c13257217.spcost)
	e4:SetTarget(c13257217.sptg)
	e4:SetOperation(c13257217.spop)
	c:RegisterEffect(e4)
	
end
function c13257217.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257217,4))
end
function c13257217.etarget(e,c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD) and c:IsFaceup()
end
function c13257217.rdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if not e:GetHandler():IsRelateToEffect(e) or sg:GetCount()==0 then return end
	local g=Group.CreateGroup()
	if Duel.SelectYesNo(tp,aux.Stringid(13257217,2)) then
		local tc=sg:GetFirst()
		while tc do
			local dg=Group.CreateGroup()
			dg:AddCard(tc)
			Duel.HintSelection(dg)
			local d1=Duel.TossDice(tp,1)
			if d1<=3 then
				g:AddCard(tc)
			end
			tc=sg:GetNext()
		end
	else
		while sg:GetCount()>0 do
			local dg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			sg:Sub(dg)
			local d1=Duel.TossDice(tp,1)
			if d1<=3 then
				g:Merge(dg)
			end
		end
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c13257217.spfilter(c,e,tp)
	return c:IsCode(13257201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13257217.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetTurnPlayer()~=tp
end
function c13257217.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,13257217)==0 end
	Duel.RegisterFlagEffect(tp,13257217,RESET_CHAIN,0,1)
end
function c13257217.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13257217.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13257217.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13257217.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(11,0,aux.Stringid(13257201,4))
	end
end
