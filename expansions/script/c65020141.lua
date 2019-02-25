--于魔梦夜的款待
function c65020141.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c65020141.sumtg)
	e1:SetOperation(c65020141.sumop)
	c:RegisterEffect(e1)
	--daocaoren
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65020141.condition)
	e2:SetCost(c65020141.cost)
	e2:SetTarget(c65020141.target)
	e2:SetOperation(c65020141.operation)
	c:RegisterEffect(e2)
end
function c65020141.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()~=tp and Duel.GetAttackTarget()==nil 
end
function c65020141.costfil(c)
	return c:IsSetCard(0x5da7) and c:IsDiscardable()
end
function c65020141.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020141.costfil,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c65020141.costfil,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c65020141.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c65020141.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c65020141.filter(c)
	return c:IsSetCard(0x5da7) and c:IsSummonable(true,nil)
end
function c65020141.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020141.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c65020141.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c65020141.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Summon(tp,g:GetFirst(),true,nil)~=0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_HAND_LIMIT)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,0)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetValue(100)
			Duel.RegisterEffect(e2,tp)
		end
	end
end