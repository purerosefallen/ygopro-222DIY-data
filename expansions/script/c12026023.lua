--终结的炽天使 牙月拉结尔
function c12026023.initial_effect(c)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(12026023,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c12026023.cpcon)
	e6:SetTarget(c12026023.target)
	e6:SetOperation(c12026023.activate)
	c:RegisterEffect(e6)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026023,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12026023.condition)
	e1:SetValue(c12026023.efilter)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetCondition(c12026023.condition)
	e2:SetTarget(c12026023.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
end
function c12026023.disable(e,c)
	local cc=e:GetHandler()
	return c:IsControler(1) and not c:IsCode(12026023) and cc:GetColumnGroup():IsContains(c) and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT )
end
function c12026023.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	return ct>0
end
function c12026023.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c12026023.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsType(TYPE_SPELL) and ( re:GetHandler():IsControler(1-tp) or Duel.GetFlagEffect(tp,12026023)==0 )
end
function c12026023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12026023,2))
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local event=re:GetCode()
	e:SetLabelObject(re)
	e:SetCategory(re:GetCategory())
	e:SetProperty(re:GetProperty())
	e:SetLabel(re:GetLabel())
--  Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12026023.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetOriginalCode()==12026023 then return end
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if re:GetHandler():IsControler(tp) then
	   Duel.RegisterFlagEffect(tp,12026023,RESET_PHASE+PHASE_END,0,1)
	end
end