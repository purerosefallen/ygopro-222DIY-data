--瓦尔哈拉的狮鹫骑士
function c22230004.initial_effect(c)
	--replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1,22230004)
	e1:SetCondition(c22230004.con1)
	e1:SetCost(c22230004.cost1)
	e1:SetTarget(c22230004.tg1)
	e1:SetOperation(c22230004.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22230004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,22230004)
	e2:SetCondition(c22230004.con2)
	e2:SetCost(c22230004.cost2)
	e2:SetTarget(c22230004.tg2)
	e2:SetOperation(c22230004.op2)
	c:RegisterEffect(e2)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22230004,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22230004.target)
	e1:SetOperation(c22230004.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
c22230004.named_with_Valhalla=1
function c22230004.IsValhalla(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Valhalla
end
function c22230004.con1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttackTarget()
	if not at then return false end
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and c22230004.IsValhalla(at)
end
function c22230004.cost1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttackTarget()
	if chk==0 then return at:IsAbleToRemoveAsCost() end
	Duel.Remove(at,POS_FACEUP,REASON_COST)
end
function c22230004.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetMZoneCount(tp,at,tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22230004.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22230004.con2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	return tc:IsFaceup() and c22230004.IsValhalla(tc) and tc:IsAbleToRemoveAsCost() and rp~=tp and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end
function c22230004.cost2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	if chk==0 then return tc:IsAbleToRemoveAsCost() end
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c22230004.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	if chk==0 then return Duel.GetMZoneCount(tp,tc,tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22230004.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22230004.filter(c)
	return c:IsAbleToDeck() and c:IsAbleToDeck()
end
function c22230004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c22230004.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c22230004.filter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22230004.filter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22230004.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	if tg:FilterCount(Card.IsAbleToHand,nil)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		dg=tg:Filter(Card.IsAbleToDeck,tc)
		Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	end
end