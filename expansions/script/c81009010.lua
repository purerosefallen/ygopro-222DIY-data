--彼此间的婚约
c81009010.card_code_list={81010019}
function c81009010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81009010+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81009010.condition)
	e1:SetCost(c81009010.cost)
	e1:SetTarget(c81009010.target)
	e1:SetOperation(c81009010.activate)
	c:RegisterEffect(e1)
end
function c81009010.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function c81009010.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81009010.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81009010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c81009010.geffilter(c)
	return c:IsFaceup() and c:IsCode(81010019)
end
function c81009010.filter(c,tp)
	return (Duel.IsExistingMatchingCard(c81009010.geffilter,tp,LOCATION_ONFIELD,0,1,nil)
		or (c:IsFaceup() and c:IsType(TYPE_RITUAL)and c:IsType(TYPE_MONSTER))) and c:IsControlerCanBeChanged()
end
function c81009010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c81009010.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c81009010.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c81009010.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c81009010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end