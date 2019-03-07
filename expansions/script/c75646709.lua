--普洛姆特·时间游戏
function c75646709.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75646709.spcon)
	e1:SetOperation(c75646709.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_CANNOT_INACTIVATE)
	e2:SetCountLimit(1,75646709)
	e2:SetOperation(c75646709.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c75646709.con)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,5646709)
	e4:SetTarget(c75646709.tg)
	e4:SetOperation(c75646709.op1)
	c:RegisterEffect(e4)
end
c75646709.card_code_list={75646700,75646715}
function c75646709.filter(c)
	return c:IsCode(75646700,75646715) and c:IsAbleToGraveAsCost()
end
function c75646709.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646709.filter,tp,LOCATION_HAND,0,1,nil)
end
function c75646709.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646709.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646709.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c75646709.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED,0,nil,75646709)
	local tc=g:GetFirst()
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646709,4))
	op=Duel.SelectOption(tp,aux.Stringid(75646709,0),aux.Stringid(75646709,1),aux.Stringid(75646709,2))
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(75646709,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,75646709))
		e1:SetValue(500)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		while tc do
			tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75646709,0))
			tc=g:GetNext()
		end  
	elseif op==1 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(75646709,1))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetCondition(c75646709.actcon)
		e2:SetValue(c75646709.aclimit)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e2,tp)
		while tc do
			tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75646709,1))
			tc=g:GetNext()
		end  
	else
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(75646709,3))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,75646709))
		e3:SetValue(aux.tgoval)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e3,tp)
		while tc do
			tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75646709,2))
			tc=g:GetNext()
		end  
	end
end
function c75646709.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(75646709) and c:IsControler(tp)
end
function c75646709.actcon(e) 
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and c75646709.cfilter(a,tp)) or (d and c75646709.cfilter(d,tp))
end
function c75646709.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c75646709.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c75646709.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED,0,nil,75646709)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646709,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,75646709))
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c75646709.actcon)
	e2:SetValue(c75646709.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,75646709))
	e3:SetValue(aux.tgoval)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e4:SetReset(RESET_PHASE+PHASE_MAIN1)
	else
		e4:SetReset(RESET_PHASE+PHASE_MAIN2)
	end
	e4:SetOperation(c75646709.op2)
	Duel.RegisterEffect(e4,tp)
	while tc do
			tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75646709,3))
			tc=g:GetNext()
	end  
end
function c75646709.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c75646709.chlimit)
end
function c75646709.chlimit(e,ep,tp)
	return tp==ep
end