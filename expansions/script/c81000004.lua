--hongyejijie
function c81000004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c81000004.indtg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,81000004)
	e3:SetCondition(c81000004.rmcon)
	e3:SetTarget(c81000004.rmtg)
	e3:SetOperation(c81000004.rmop)
	c:RegisterEffect(e3)
	--shuffle
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,81000904)
	e4:SetCondition(c81000004.atkcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c81000004.atktg)
	e4:SetOperation(c81000004.atkop)
	c:RegisterEffect(e4)
end
function c81000004.indtg(e,c)
	return c:IsType(TYPE_EQUIP)
end
function c81000004.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup() and (tc:IsCode(81000016) or tc:IsCode(81008004)) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c81000004.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return bc:IsAbleToRemove() and Duel.GetFlagEffect(tp,81000004)==0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
	Duel.RegisterFlagEffect(tp,81000004,RESET_PHASE+PHASE_END,0,1)
end
function c81000004.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) and Duel.Remove(bc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		bc:SetTurnCounter(0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(81000004,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		e1:SetLabelObject(bc)
		e1:SetCountLimit(1)
		e1:SetCondition(c81000004.retcon)
		e1:SetOperation(c81000004.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c81000004.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c81000004.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	ct=ct+1
	tc:SetTurnCounter(ct)
	if ct==2 then
		Duel.ReturnToField(tc)
	end
end
function c81000004.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c81000004.tdfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToDeck()
end
function c81000004.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81000004.tdfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c81000004.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local g=Duel.GetMatchingGroup(c81000004.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	local ct=math.min(#g,math.floor(tc:GetAttack()/400))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,ct,nil)
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():GetCount()
	if tc:IsFaceup() and tc:IsRelateToBattle() and ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*-400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end