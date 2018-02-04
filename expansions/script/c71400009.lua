--梦之书中的公式证明图表
function c71400009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--summon limit
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	el1:SetType(EFFECT_TYPE_SINGLE)
	el1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	el1:SetCondition(c71400009.sumlimit)
	c:RegisterEffect(el1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c71400009.condition)
	e1:SetTarget(c71400009.target)
	e1:SetOperation(c71400009.operation)
	c:RegisterEffect(e1)
	if not c71400009.global_check then
		c71400009.global_check=true
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetRange(LOCATION_FZONE)
		e4:SetCode(EFFECT_SEND_REPLACE)
		e4:SetTarget(c71400009.reptg)
		e4:SetValue(aux.TRUE)
		Duel.RegisterEffect(e4,0)
	end
end
function c71400009.lfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3714)
end
function c71400009.sumlimit(e)
	return not Duel.IsExistingMatchingCard(c71400009.lfilter,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
function c71400009.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c71400009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c71400009.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsOnField,1,nil) end
	local g=eg:Filter(Card.IsOnField,nil)
	for tc in aux.Next(g) do
		c71400009[tc]=tc:GetOverlayCount()
	end
	return false
end
function c71400009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mcount=c71400009[c]
	if not mcount or mcount<=0 or not Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,mcount,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,mcount,mcount,nil)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
end