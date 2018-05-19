--探寻者
function c22200002.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22200002,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22200002)
	e1:SetCost(c22200002.cost1)
	e1:SetTarget(c22200002.target1)
	e1:SetOperation(c22200002.operation1)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22200002,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22200002)
	e2:SetCost(c22200002.cost2)
	e2:SetTarget(c22200002.target2)
	e2:SetOperation(c22200002.operation2)
	c:RegisterEffect(e2)
end
function c22200002.codefilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c22200002.cost1filter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c22200002.codefilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetCode())
end
function c22200002.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22200002.cost1filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22200002.cost1filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c22200002.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,0)
	if chk==0 then return tc and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c22200002.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,0)
	if tc and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c22200002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(e:GetHandler(),nseq)
end
function c22200002.target2filter(c)
	return c:GetSequence()<5
end
function c22200002.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22200002.target2filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c22200002.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectMatchingCard(tp,c22200002.target2filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler()):GetFirst()
	if not tc then return end
	Duel.SwapSequence(c,tc)
end