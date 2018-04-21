--消失的埋葬
function c22202102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c22202102.cost)
	e1:SetCondition(c22202102.condition)
	e1:SetTarget(c22202102.target)
	e1:SetOperation(c22202102.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c22202102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=re:GetHandler():GetAttack()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(Card.IsType,nil,TYPE_MONSTER)
	if chk==0 then 
		if c:IsLocation(LOCATION_HAND) then
			return g:GetCount()==g:GetClassCount(Card.GetAttack) and Duel.CheckLPCost(tp,atk)
		else
			return Duel.CheckLPCost(tp,atk)
		end
	end
	Duel.PayLPCost(tp,atk)
end
function c22202102.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER)
end
function c22202102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=re:GetHandler():GetAttack()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_GRAVE):Filter(c22202102.filter,nil,atk)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE+LOCATION_MZONE)
end
function c22202102.filter(c,atk)
	return c:IsAbleToDeck() and c:GetAttack()==atk and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c22202102.activate(e,tp,eg,ep,ev,re,r,rp)
	local atk=re:GetHandler():GetAttack()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_GRAVE):Filter(c22202102.filter,nil,atk)
	local tg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	tg:AddCard(tc)
	g:Remove(Card.IsCode,nil,tc:GetCode())
	while g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22202102,0)) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tg:AddCard(tc)
		g:Remove(Card.IsCode,nil,tc:GetCode())
	end
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end