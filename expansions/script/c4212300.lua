--箱庭世界的吸血鬼女仆
function c4212300.initial_effect(c)
	--destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4212313,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,4212300)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c4212300.condition)
	e1:SetCost(c4212300.cost)
	e1:SetTarget(c4212300.target)
	e1:SetOperation(c4212300.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4212313,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,4212300)
	e2:SetCost(c4212300.cost)
	e2:SetTarget(c4212300.target2)
	e2:SetOperation(c4212300.operation2)
	c:RegisterEffect(e2)
end
function c4212300.mfilter(c,re)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK) and c:IsReason(REASON_COST)
end
function c4212300.tgfilter(c,e,re)
	return Group.FromCards(e:GetHandler(),(c:GetReasonEffect() and {c:GetReasonEffect():GetOwner()} or {nil})[1]):FilterCount(function(c) return c:IsType(0x7) end,re:GetHandler()) == 1 
end
function c4212300.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE):Filter(c4212300.tgfilter,nil,e,re):IsExists(c4212300.mfilter,1,e:GetHandler(),re) end
	local sg = Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE):Filter(c4212300.tgfilter,nil,e,re):Filter(c4212300.mfilter,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
end
function c4212300.operation2(e,tp,eg,ep,ev,re,r,rp)
	local sg = Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE):Filter(c4212300.tgfilter,nil,e,re):Filter(c4212300.mfilter,e:GetHandler())
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c4212300.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK) and c:IsReason(REASON_COST)
end
function c4212300.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(0x7f0) and eg:IsExists(c4212300.cfilter,1,nil) and rp==tp
end
function c4212300.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4212300.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c4212300.cfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
end
function c4212300.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg = eg:Filter(function(c) return c:IsLocation(LOCATION_GRAVE) end,nil)
	local tc = sg:GetFirst()
	local c=e:GetHandler()
	while tc do	    
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
        e1:SetTarget(c4212300.distg)
        e1:SetLabel(tc:GetCode())
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_CHAIN_SOLVING)
        e2:SetCondition(c4212300.discon)
        e2:SetOperation(c4212300.disop)
        e2:SetLabel(tc:GetCode())
        e2:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e2,tp)
		tc=sg:GetNext()
	end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c4212300.distg(e,c)
    return c:IsCode(e:GetLabel())
end
function c4212300.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler():IsCode(e:GetLabel())
end
function c4212300.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end