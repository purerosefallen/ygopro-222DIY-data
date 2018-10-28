--三色的陷阱
function c12005021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(c12005021.cost)
	e1:SetCondition(c12005021.condition)
	e1:SetTarget(c12005021.target)
	e1:SetOperation(c12005021.activate)
	c:RegisterEffect(e1)
	--act other
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c12005021.actcon)
	c:RegisterEffect(e2)   
end
function c12005021.actcon(e)
	if Duel.GetCurrentChain()<1 then return false end
	local re=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_PENDULUM)
end
function c12005021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,333) end
	Duel.PayLPCost(tp,333) 
end
function c12005021.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) or re:GetActivateLocation()==LOCATION_HAND) and Duel.IsChainNegatable(ev)
end
function c12005021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12005021.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005021,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOGRAVE-RESET_LEAVE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetLabel(re:GetHandler():GetCode())
	e1:SetCondition(c12005021.thcon)
	e1:SetTarget(c12005021.thtg)
	e1:SetOperation(c12005021.thop)
	c:RegisterEffect(e1)
end
function c12005021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function c12005021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_CHAINING)
		and c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c12005021.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end

