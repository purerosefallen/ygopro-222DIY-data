--幻想乐章的琶音
function c60150547.initial_effect(c)
    c:SetUniqueOnField(1,0,60150547)
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
    e2:SetCondition(c60150547.e2con)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --cannot target
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetCondition(c60150547.e3con)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetCondition(c60150547.e4con)
    e4:SetValue(c60150547.e4filter)
    c:RegisterEffect(e4)
    --atk/def
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb20))
    e5:SetValue(c60150547.val)
    e5:SetCondition(c60150547.e5con)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e6)
    --
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DRAW)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCode(EVENT_BATTLE_DAMAGE)
    e7:SetCondition(c60150547.e7con)
    e7:SetOperation(c60150547.e7op)
    c:RegisterEffect(e7)
end
function c60150547.confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xcb20) and c:IsType(TYPE_CONTINUOUS)
end
function c60150547.confilter2(c)
    return c:IsSetCard(0xcb20) and c:IsType(TYPE_XYZ)
end
function c60150547.e2con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150547.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=2 and Duel.IsExistingMatchingCard(c60150547.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150547.e3con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150547.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=3 and Duel.IsExistingMatchingCard(c60150547.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150547.e4con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150547.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=4 and Duel.IsExistingMatchingCard(c60150547.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150547.e4filter(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c60150547.val(e,c)
    return Duel.GetOverlayCount(c:GetControler(),1,0)*800
end
function c60150547.e5con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150547.confilter,tp,LOCATION_SZONE,0,nil)
    return g:GetClassCount(Card.GetCode)>=1 and Duel.IsExistingMatchingCard(c60150547.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150547.e7con(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c60150547.confilter,tp,LOCATION_SZONE,0,nil)
    return ep~=tp and eg:GetFirst():IsControler(tp) and (eg:GetFirst():IsSetCard(0xcb20) and eg:GetFirst():IsType(TYPE_XYZ)) and g:GetClassCount(Card.GetCode)>=5 and Duel.IsExistingMatchingCard(c60150547.confilter2,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150547.e7op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,60150547)
    Duel.Draw(tp,1,REASON_EFFECT)
end