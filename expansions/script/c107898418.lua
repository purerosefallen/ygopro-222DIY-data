--
function c107898418.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898418,0))
	e1:SetCategory(CATEGORY_DICE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c107898418.condition)
	e1:SetCost(c107898418.cost)
	e1:SetTarget(c107898418.target)
	e1:SetOperation(c107898418.operation)
	c:RegisterEffect(e1)
end
function c107898418.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898418.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c107898418.filter(c)
	return c:IsCode(107898102) and c:IsFaceup()
end
function c107898418.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and e:GetHandler():IsAbleToRemoveAsCost() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c107898418.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898418.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c107898418.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898418.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898418.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or tc:IsControler(1-tp) then return end
	local dc=Duel.TossDice(tp,1)
	if dc~=1 and dc~=2 and dc~=3 and dc~=4 and dc~=5 and dc~=6 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898418,dc))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	if dc==1 then
		--dmg 100
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetOperation(c107898418.op1)
	elseif dc==2 then
		--atk up
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetOperation(c107898418.op2)
	elseif dc==3 then
		--end battle phase
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(c107898418.con3)
		e1:SetOperation(c107898418.op3)
	elseif dc==4 then
		--def up
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCategory(CATEGORY_DEFCHANGE)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetOperation(c107898418.op4)
	elseif dc==5 then
		--addct
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCategory(CATEGORY_COUNTER)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetTarget(c107898418.tg5)
		e1:SetOperation(c107898418.op5)
	elseif dc==6 then
		--negate
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCategory(CATEGORY_NEGATE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(c107898418.con6)
		e1:SetTarget(c107898418.tg6)
		e1:SetOperation(c107898418.op6)
	end
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1,true)
end
function c107898418.op1(e,tp,eg,ep,ev,re,r,rp)
	--dmg change
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c107898418.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(200)
		c:RegisterEffect(e1)
	end
end
function c107898418.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c107898418.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end
function c107898418.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(200)
		c:RegisterEffect(e1)
	end
end
function c107898418.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1)
end
function c107898418.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x1,2)
	end
end
function c107898418.con6(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c107898418.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if not re:GetHandler():IsRelateToEffect(re) then return end
end
function c107898418.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end