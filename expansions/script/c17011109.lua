--雷鸣军神·福尼加尔
local m=17011109
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,cm.matfilter,2,2,cm.lcheck)
    c:EnableReviveLimit()
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(17011109,1))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCondition(cm.descon)
    e1:SetTarget(cm.destg)
    e1:SetOperation(cm.desop)
    c:RegisterEffect(e1)
    --atk voice
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetOperation(cm.atksuc)
    c:RegisterEffect(e2)
    --destroy voice
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(cm.descon1)
    e3:SetOperation(cm.dessuc)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCondition(cm.descon2)
    e4:SetOperation(cm.evoldessuc)
    c:RegisterEffect(e4)
    --spsummon voice
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetOperation(cm.sumsuc)
    c:RegisterEffect(e5)
end
function cm.matfilter(c)
    return not c:IsLinkType(TYPE_TOKEN)
end
function cm.lcheck(g,lc)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end
function cm.descon(e)
    return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,4))
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Damage(1-tp,800,REASON_EFFECT)
    end
end
function cm.Odin(c)
    return c:IsFaceup() and c:IsCode(47550003)
end
function cm.Grimnir(c)
    return c:IsFaceup() and c:IsCode(17011108)
end
function cm.Jafnhar(c)
    return c:IsFaceup() and c:IsCode(17011110)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMutualLinkedGroupCount()>0 then
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,2))
    elseif e:GetHandler():GetMutualLinkedGroupCount()>0 then
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,5))
    elseif Duel.IsExistingMatchingCard(cm.Odin,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,8))
    elseif Duel.IsExistingMatchingCard(cm.Grimnir,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,9))
    elseif Duel.IsExistingMatchingCard(cm.Jafnhar,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,10))
    else
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,1))
    end
end 
function cm.atksuc(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():GetMutualLinkedGroupCount()>0 then
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,4))
    else 
        Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,3))
    end
end
function cm.dessuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,6))
end
function cm.evoldessuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(17011109,7))
end
function cm.descon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_ONFIELD) 
    and e:GetHandler():GetMutualLinkedGroupCount()==0 and c:IsFaceup()
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return e:GetHandler():GetMutualLinkedGroupCount()>0
end