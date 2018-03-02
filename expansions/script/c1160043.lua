--梦游仙境·柴郡猫
function c1160043.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1160043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,1160043)
	e1:SetCondition(c1160043.con1)
	e1:SetTarget(c1160043.tg1)
	e1:SetOperation(c1160043.op1)
	c:RegisterEffect(e1)	
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1160043,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1160043.cost2)
	e2:SetTarget(c1160043.tg2)
	e2:SetOperation(c1160043.op2)
	c:RegisterEffect(e2)
--
end
--
function c1160043.cfilter1(c)
	return c:GetLevel()==1 and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
end
function c1160043.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c1160043.cfilter1,1,c)
end
--
function c1160043.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c1160043.ofilter1(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:GetLevel()==1
end
function c1160043.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<1 then return end
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1_1:SetValue(LOCATION_REMOVED)
	e1_1:SetReset(RESET_EVENT+0x47e0000)
	c:RegisterEffect(e1_1,true)
	if not (Duel.IsExistingMatchingCard(c1160043.ofilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1160043,2))) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK) 
	local g=Duel.SelectMatchingCard(tp,c1160043.ofilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)   
	if g:GetCount()<=0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
--
function c1160043.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
--
function c1160043.tfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1160043.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1160043.tfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(c1160043.chlimit2)
end
function c1160043.chlimit2(e,ep,tp)
	return not e:IsActiveType(TYPE_MONSTER)
end
--
function c1160043.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,c1160043.tfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()<=0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_CANNOT_ATTACK)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_1)  
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_SINGLE)
	e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2_2:SetValue(1)
	e2_2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2_2)
end
