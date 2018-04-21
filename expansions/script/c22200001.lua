--预谋者
function c22200001.initial_effect(c)
	--Set & Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22200001,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22200001)
	e1:SetCondition(c22200001.condition)
	e1:SetCost(c22200001.cost)
	e1:SetTarget(c22200001.target)
	e1:SetOperation(c22200001.operation)
	c:RegisterEffect(e1)
end
function c22200001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22200001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c22200001.filter(c,ignore)
	return c:IsType(TYPE_TRAP) and c:IsSSetable(ignore)
end
function c22200001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22200001.filter,tp,LOCATION_HAND,0,1,1,nil,false) end
end
function c22200001.operation(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.SelectMatchingCard(tp,c22200001.filter,tp,LOCATION_HAND,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		--act qp in hand
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end