--幻想乐章的沉寂
function c60150549.initial_effect(c)
    c:SetUniqueOnField(1,0,60150549)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --Destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c60150549.e2con)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --cannot target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetCondition(c60150549.e3con)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetCondition(c60150549.e4con)
    e4:SetValue(c60150549.e4filter)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(aux.TargetBoolFunction(c60150549.confilter2))
    e5:SetCondition(c60150549.e5con)
    e5:SetValue(c60150549.e4filter)
    c:RegisterEffect(e5)
    --damage
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_CHAINING)
    e6:SetRange(LOCATION_MZONE)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetOperation(c60150549.e6op)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_CHAIN_SOLVED)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c60150549.e7con)
    e7:SetOperation(c60150549.e7op)
    c:RegisterEffect(e7)
end
function c60150549.confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_CONTINUOUS)
end
function c60150549.confilter2(c)
    return c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ)
end
function c60150549.e2con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150549.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=2 and Duel.IsExistingMatchingCard(c60150549.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150549.e3con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150549.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=3 and Duel.IsExistingMatchingCard(c60150549.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150549.e4con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150549.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=4 and Duel.IsExistingMatchingCard(c60150549.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150549.e4filter(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c60150549.e5con(e,c)
    if c==nil then return true end
    local g=Duel.GetMatchingGroup(c60150549.confilter,tp,LOCATION_SZONE,0,nil)
    local tp=c:GetControler()
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) 
		and g:GetClassCount(Card.GetCode)>=1 and Duel.IsExistingMatchingCard(c60150549.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150549.e6op(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(60150549,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c60150549.e7con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c60150549.confilter,tp,LOCATION_SZONE,0,nil)
    return c:GetOverlayCount()>0 and ep~=tp and c:GetFlagEffect(60150549)~=0
		and g:GetClassCount(Card.GetCode)==5 and Duel.IsExistingMatchingCard(c60150549.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150549.e7op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_CARD,0,60150549)
    local g3=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if g3:GetCount()>0 then 
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
        local sg2=g3:Select(1-tp,1,1,nil)
        Duel.HintSelection(sg2)
        Duel.SendtoGrave(sg2,REASON_RULE)
    end
end