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
	if not c11200025.check then
		c11200025.check=true
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(c11200025.op2)
		Duel.RegisterEffect(e2,0)
	end

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,11200125)
	e3:SetCost(c11200025.cost3)
	e3:SetTarget(c11200025.tg3)
	e3:SetOperation(c11200025.op3)
	c:RegisterEffect(e3)
--
end
--
function c11200025.cfilter1(c)
	return c:IsRace(RACE_BEAST) and c:IsReleasable()
end
function c11200025.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200025.cfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c11200025.cfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.Release(sg,REASON_EFFECT)
end
--
function c11200025.tfilter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x132)
end
function c11200025.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200025.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
--
function c11200025.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c11200025.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	if Duel.GetMZoneCount(tp)<1 then return end
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetFlagEffect(tp,11200025)>0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x132,0x21,1100,1100,4,RACE_BEAST,ATTRIBUTE_LIGHT) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(11200025,0)) then
		c:CancelToGrave()
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then 
			c:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_LIGHT,RACE_BEAST,4,1100,1100)
			Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
			c:AddMonsterAttributeComplete()
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1_1:SetValue(1)
			e1_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1_1,true)
			local e1_2=Effect.CreateEffect(c)
			e1_2:SetType(EFFECT_TYPE_SINGLE)
			e1_2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1_2:SetReset(RESET_EVENT+0x1fe0000)
			e1_2:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1_2,true)
			Duel.SpecialSummonComplete()
		else
			c:CancelToGrave(false)
		end
	end
end
--
function c11200025.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not re:IsActiveType(TYPE_MONSTER) then return end
	Duel.RegisterFlagEffect(rc:GetControler(),11200025,RESET_PHASE+PHASE_END,0,1)
end
--
function c11200025.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_COST)
end
--
function c11200025.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
--
function c11200025.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
--
