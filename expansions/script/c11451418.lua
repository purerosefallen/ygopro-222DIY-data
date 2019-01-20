--march of dragon palace
function c11451418.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11451418.target)
	e1:SetOperation(c11451418.activate)
	c:RegisterEffect(e1)
	--Ad
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c11451418.condition)
	e2:SetCost(c11451418.cost)
	e2:SetOperation(c11451418.operation)
	c:RegisterEffect(e2)
end
function c11451418.filter(c,e,tp)
	return c:IsSetCard(0x6978) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c11451418.cfilter(c)
	return c:IsSetCard(0x6978) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c11451418.drfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x6978) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsLocation(LOCATION_MZONE)
end
function c11451418.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local gt=Duel.GetMatchingGroupCount(c11451418.cfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	gt=math.floor(gt/2)
	if chk==0 then return ft>0 and gt>0 and Duel.IsExistingMatchingCard(c11451418.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c11451418.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
end
function c11451418.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local gt=Duel.GetMatchingGroupCount(c11451418.cfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	gt=math.floor(gt/2)
	ft=math.min(ft,gt)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft<=0 or not Duel.IsExistingMatchingCard(c11451418.filter,tp,LOCATION_HAND,0,1,nil,e,tp) or not Duel.IsExistingMatchingCard(c11451418.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c11451418.filter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
	local r=g2:GetCount()+g2:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c11451418.cfilter,tp,LOCATION_GRAVE,0,r,r,nil,e,tp)
	tc=g2:GetFirst()
	while tc do
		tc:SetMaterial(g1)
		tc=g2:GetNext()
	end
	Duel.SendtoDeck(g1,tp,2,REASON_EFFECT)
	Duel.BreakEffect()
	tc=g2:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc=g2:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c11451418.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local sg=Group.CreateGroup()
	sg:AddCard(a)
	if b~=nil then
		sg:AddCard(b)
	end
	sg=sg:Filter(c11451418.drfilter,nil)
	return sg:GetCount()~=0
end
function c11451418.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c11451418.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local sg=Group.CreateGroup()
	sg:AddCard(a)
	if b~=nil then
		sg:AddCard(b)
	end
	sg=sg:Filter(c11451418.drfilter,nil)
	if sg:GetCount()==1 then
		local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetDefense()*2)
		tc:RegisterEffect(e2)
	elseif sg:GetCount()==2 then
		local qg=Group.Select(sg,tp,1,1,nil)
		local tc=qg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetDefense()*2)
		tc:RegisterEffect(e2)
	end
end