--梦幻星辰
function c1145001.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1145001,1)
	e1:SetTarget(c1145001.tg1)
	e1:SetOperation(c1145001.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1145001,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1145001.cost2)
	e2:SetTarget(c1145001.tg2)
	e2:SetOperation(c1145001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1145001.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
	local sg=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
--
function c1145001.ofilter1(c,tg,e)
	local check=0
	local tc=tg:GetFirst()
	while tc do
		if c:GetLevel()==tc:GetLeftScale() then check=1 end
		if c:GetLevel()==tc:GetRightScale() then check=1 end
		tc=tg:GetNext()
	end
	return check==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function c1145001.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		local tg=Duel.GetOperatedGroup()
		local hg=Duel.GetMatchingGroup(c1145001.ofilter1,tp,LOCATION_DECK,0,nil,tg,e)
		if hg:GetCount()<1 then return end
		local tc=tg:GetFirst()
		while tc do
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1_1)
			tc=tg:GetNext()
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		if Duel.SelectYesNo(tp,aux.Stringid(1145001,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local lg=hg:Select(tp,1,1,nil)
			Duel.SpecialSummon(lg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c1145001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
--
function c1145001.tfilter2(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c1145001.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c1145001.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
--
function c1145001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(c1145001.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local num=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
	if tg:GetCount()<1 or num<1 then return end
	local tc=tg:GetFirst()
	while tc do
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_LEVEL)
		e2_1:SetValue(num)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2_1)
		tc=tg:GetNext()
	end
end
--
