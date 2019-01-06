--网织贵女郎
function c65080053.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_INSECT),1)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(c65080053.tg)
	e1:SetOperation(c65080053.op)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65080053.condition)
	e2:SetCost(c65080053.cost)
	e2:SetTarget(c65080053.target)
	e2:SetOperation(c65080053.activate)
	c:RegisterEffect(e2)
end
function c65080053.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsPosition(POS_FACEUP_ATTACK) and Duel.IsChainNegatable(ev) and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c65080053.costfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c65080053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080053.costfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c65080053.costfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65080053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
	if re:GetHandler():IsCanChangePosition() then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
	end
end
function c65080053.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if re:GetHandler():IsCanChangePosition() then
			Duel.ChangePosition(eg,POS_FACEUP_DEFENSE)
		else Duel.SendtoGrave(eg,REASON_EFFECT) end
	end
end

function c65080053.filter(c,e,tp,spchk)
	return c:IsPosition(POS_FACEUP_DEFENSE) and (c:IsAbleToGrave() or (spchk and c:IsControlerCanBeChanged()))
end
function c65080053.confil(c)
	return not (c:IsFaceup() and c:IsRace(RACE_INSECT))
end
function c65080053.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local gn=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local gr=gn:Filter(c65080053.confil,nil)
	local spchk=gn:GetCount()>0 and gr:GetCount()==0
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c65080053.filter(c,e,tp,spchk) end
	if chk==0 then return Duel.IsExistingTarget(c65080053.filter,tp,0,LOCATION_MZONE,1,nil,e,tp,spchk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c65080053.filter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,spchk)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,0,0,0)
end
function c65080053.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local gn=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local gr=gn:Filter(c65080053.confil,nil)
	if tc and tc:IsRelateToEffect(e) then
		if gn:GetCount()>0 and gr:GetCount()==0
			and tc:IsControlerCanBeChanged()
			and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(65080053,0))) then
			Duel.GetControl(tc,tp)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
