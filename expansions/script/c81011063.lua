--Answer·关裕美·S
function c81011063.initial_effect(c)
	--fusion name
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81011063,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,81011063)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c81011063.cost)
	e1:SetOperation(c81011063.operation)
	c:RegisterEffect(e1)
end
function c81011063.costfilter(c,ec)
	return not c:IsFusionCode(ec:GetFusionCode()) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c81011063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c81011063.costfilter,tp,LOCATION_HAND,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c81011063.costfilter,tp,LOCATION_HAND,0,1,1,nil,c)
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetFirst():GetCode())
end
function c81011063.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_FUSION_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
end
