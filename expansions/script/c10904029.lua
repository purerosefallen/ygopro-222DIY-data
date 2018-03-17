--重整的灵刻使
local m=10904029
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(cm.repcon)
    e2:SetTarget(cm.reptg)
    e2:SetValue(cm.repval)
    e2:SetOperation(cm.repop)
    c:RegisterEffect(e2)    
end
function cm.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x237) and c:IsLevelAbove(3) and not c:IsType(TYPE_TUNER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and cm.filter(tc) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(TYPE_TUNER)
        tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_LEVEL)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    e2:SetValue(-2)
    tc:RegisterEffect(e2)
    end
end
function cm.cfilter2(c)
    return c:IsFaceup() and c:IsCode(10904019)
end
function cm.repcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil)
end
function cm.repfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x237) and c:IsLocation(LOCATION_ONFIELD)
        and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
    return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

