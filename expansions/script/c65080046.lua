--噩梦蜘蛛
function c65080046.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65080046)
	e1:SetCost(c65080046.cost)
	e1:SetOperation(c65080046.operation)
	c:RegisterEffect(e1)
end
function c65080046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65080046.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c65080046.poop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
	--activate cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	e4:SetTarget(c65080046.actarget)
	e4:SetCost(c65080046.costchk)
	e4:SetOperation(c65080046.costop)
	Duel.RegisterEffect(e4,tp)
end
function c65080046.filter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function c65080046.poop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c65080046.filter,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function c65080046.actarget(e,te,tp)
	local c=te:GetHandler()
	return c:IsType(TYPE_MONSTER) and c:IsAttackPos() and c:IsLocation(LOCATION_MZONE)
end
function c65080046.costchk(e,te,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
end
function c65080046.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65080046)
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST,nil)
end