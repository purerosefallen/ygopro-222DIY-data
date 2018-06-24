--『地上弹跳』
function c11200025.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11200025)
	e1:SetCost(c11200025.cost1)
	e1:SetTarget(c11200025.tg1)
	e1:SetOperation(c11200025.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200025,0))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200025)
	e2:SetCondition(c11200025.con2)
	e2:SetCost(c11200025.cost2)
	e2:SetTarget(c11200025.tg2)
	e2:SetOperation(c11200025.op2)
	c:RegisterEffect(e2)
--
end
--
function c11200025.sfilter1(c)
	return c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsReleasable()
end
function c11200025.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200025.sfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c11200025.sfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Release(sg,REASON_EFFECT)
end
--
function c11200025.tfilter1_1(c,e,tp)
	return c:IsAbleToHand() and c:IsSetCard(0x132) and c:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c11200025.tfilter1_2,tp,LOCATION_DECK,0,1,c,e,tp,c)
end
function c11200025.tfilter1_2(c,e,tp,tc)
	return c:IsAbleToHand() and c:IsSetCard(0x132) and c:IsType(TYPE_SPELL) and
		(Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT) 
		or Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT))
end
function c11200025.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200025.tfilter1_1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
--
function c11200025.ofilter1(c,e,tp)
	return c:IsSetCard(0x132) and c:IsType(TYPE_SPELL) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT)
end
function c11200025.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=Duel.SelectMatchingCard(tp,c11200025.tfilter1_1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if sg1:GetCount()<1 then return end
	local sc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg2=Duel.SelectMatchingCard(tp,c11200025.tfilter1_2,tp,LOCATION_DECK,0,1,1,sc1,e,tp,sc1)
	if sg2:GetCount()<1 then return end
	local sc2=sg2:GetFirst()
	local sg=Group.CreateGroup()
	sg:AddCard(sc1)
	sg:AddCard(sc2)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sg)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		local tg=sg:FilterSelect(tp,c11200025.ofilter1,1,1,nil,e,tp)
		if tg:GetCount()<1 then return end
		Duel.BreakEffect()
		local tc=tg:GetFirst()
		tc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
		tc:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
end
--
function c11200025.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and rp==tp
end
--
function c11200025.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
--
function c11200025.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return Duel.GetLocationCount(rp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(rp,rc:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT) end
end
--
function c11200025.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c11200025.op2_1)
end
--
function c11200025.op2_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
end
--

