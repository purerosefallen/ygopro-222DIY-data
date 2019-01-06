--天星-斗转星移
function c50218690.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c50218690.cost)
	e1:SetTarget(c50218690.target)
	e1:SetOperation(c50218690.activate)
	c:RegisterEffect(e1)
end
function c50218690.filter(c)
	return c:IsSetCard(0xcb6) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToRemoveAsCost()
end
function c50218690.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c50218690.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=7 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local rg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		rg:AddCard(sg:GetFirst())
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c50218690.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c50218690.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end
