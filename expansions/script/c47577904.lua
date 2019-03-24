--堕天司的奇袭
function c47577904.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47577904+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c47577904.target)
	e1:SetOperation(c47577904.activate)
	c:RegisterEffect(e1)	 
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47577904,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,47577905)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c47577904.ptg)
	e2:SetOperation(c47577904.pop)
	c:RegisterEffect(e2) 
end
function c47577904.inmfilter(c)
	return c:IsSetCard(0x95de) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c47577904.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47577900.inmfilter,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c47577900.inmfilter,tp,LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
end
function c47577904.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c47577904.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c47577904.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47577904.penfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ev) end
end
function c47577904.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c47577904.penfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end