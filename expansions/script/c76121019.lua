--指挥官波鼠
function c76121019.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76121019,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetCost(c76121019.sumcost)
	e1:SetTarget(c76121019.sumtg)
	e1:SetOperation(c76121019.sumop)
	c:RegisterEffect(e1)
	--lock zones
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121019,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCondition(c76121019.lzcon)
	e2:SetCost(c76121019.cost)
	e2:SetTarget(c76121019.lztg)
	e2:SetOperation(c76121019.lzop)
	c:RegisterEffect(e2)
end
function c76121019.cfilter(c)
	return c:IsSetCard(0xea2) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c76121019.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() and Duel.IsExistingMatchingCard(c76121019.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) and e:GetHandler():GetFlagEffect(76121019)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76121019.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:GetHandler():RegisterFlagEffect(76121019,RESET_CHAIN,0,1)
end
function c76121019.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsMSetable(true,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c76121019.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsMSetable(true,nil,0) then
		Duel.MSet(tp,c,true,nil,0)
	end
end
function c76121019.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c76121019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function c76121019.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xea2)
end
function c76121019.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c76121019.ctfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)
		+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>ct end
	local dis=Duel.SelectDisableField(tp,ct,LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,0)
	e:SetLabel(dis)
end
function c76121019.lzop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c76121019.disop)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c76121019.disop(e,tp)
	return e:GetLabel()
end