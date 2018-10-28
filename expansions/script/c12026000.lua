--黑白神的准则
function c12026000.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026000,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c12026000.cost)
	e1:SetOperation(c12026000.operation)
	c:RegisterEffect(e1)   
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12026000,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,12026000)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c12026000.thcon)
	e2:SetTarget(c12026000.thtg)
	e2:SetOperation(c12026000.thop)
	c:RegisterEffect(e1) 
end
function c12026000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12026000.thcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12026000.thcfilter(c)
	return c:IsFaceup() and c:IsCode(12009100,12009101)
end
function c12026000.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12026000.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c12026000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c12026000.operation(e,tp,eg,ep,ev,re,r,rp)
	local rct=1
	if Duel.GetTurnPlayer()~=tp then rct=0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,rct)
	e1:SetTarget(c12026000.splimit)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,tp)

	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetCondition(c12026000.scon1)
	e1:SetTarget(c12026000.splimit1)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e5,tp)
end
function c12026000.scon1(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER)
end
function c12026000.splimit1(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelBelow(4)
end
function c12026000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if c:IsType(TYPE_FUSION) then return not c:IsLocation(LOCATION_EXTRA) or not se:GetHandler():IsType(TYPE_SPELL) end
	if c:IsType(TYPE_SYNCHRO) then return not c:IsLocation(LOCATION_EXTRA) or sumtype&SUMMON_TYPE_SYNCHRO ~=SUMMON_TYPE_SYNCHRO end
	if c:IsType(TYPE_PENDULUM) then return not c:IsLocation(LOCATION_EXTRA) or sumtype&SUMMON_TYPE_PENDULUM ~=SUMMON_TYPE_PENDULUM end
	if c:IsType(TYPE_LINK) then return not c:IsLocation(LOCATION_EXTRA) or sumtype&SUMMON_TYPE_LINK ~=SUMMON_TYPE_LINK end
	if c:IsType(TYPE_XYZ) then return not c:IsLocation(LOCATION_EXTRA) or sumtype&SUMMON_TYPE_XYZ ~=SUMMON_TYPE_XYZ end
	return false
end
