--红莲的星晶兽 阿格尼斯
local m=47510072
local cm=_G["c"..m]
function c47510072.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,3,c47510072.lcheck)
    c:EnableReviveLimit() 
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c47510072.atkval)
    c:RegisterEffect(e1)
    --fire
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47510072)
    e2:SetTarget(c47510072.destg)
    e2:SetOperation(c47510072.desop)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c47510072.intg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function c47510072.lcheck(g)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x5da) or g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end
function c47510072.intg(e,c)
    return c:GetAttribute()~=ATTRIBUTE_FIRE
end
function c47510072.afilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c47510072.atkval(e,c)
    return Duel.GetMatchingGroupCount(c47510072.afilter,c:GetControler(),LOCATION_MZONE,0,c)*500
end
function c47510072.ffilter(c)
    return c:GetAttribute()~=ATTRIBUTE_FIRE
end
function c47510072.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=c end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47510072.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
    local g=Duel.GetMatchingGroup(c47510072.ffilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            Duel.BreakEffect()
            Duel.Destroy(g,REASON_EFFECT)
        end
    end
end