--花之时计
function c44444561.initial_effect(c)
    --boom monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCountLimit(1,44444561+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c44444561.condition)
	e1:SetCost(c44444561.cost)
	e1:SetTarget(c44444561.target)
	e1:SetOperation(c44444561.activate)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCountLimit(1,99999562+EFFECT_COUNT_CODE_DUEL)
	e11:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetCost(c44444561.poscost)
	e11:SetCondition(c44444561.condition)
	e11:SetOperation(c44444561.activate1)
	c:RegisterEffect(e11)
end
function c44444561.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==PHASE_STANDBY
end
function c44444561.filter1(c)
	return c:IsDestructable()
	and c:IsType(TYPE_MONSTER)
	and c:IsRace(RACE_PLANT)
	and c:GetLevel()==1 
	and c:IsAttribute(ATTRIBUTE_DARK)
end
function c44444561.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c44444561.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444561.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c44444561.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c44444561.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(c44444561.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c44444561.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c44444561.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c44444561.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c44444561.activate1(e,tp,eg,ep,ev,re,r,rp)
local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SKIP_M1)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SKIP_BP)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SKIP_M2)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SKIP_EP)
	Duel.RegisterEffect(e5,tp)
	local e11=Effect.CreateEffect(e:GetHandler())
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCode(EFFECT_SKIP_TURN)
	e11:SetTargetRange(0,1)
	e11:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e11,tp)
	
end

function c44444561.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end