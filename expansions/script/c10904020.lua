--铭灵刻使 阿丽亚娜
local m=10904020
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x237),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c,false)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(cm.sumcon)
    e2:SetOperation(cm.sumsuc)
    c:RegisterEffect(e2)    
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(17060851,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.tgtg)
    e1:SetOperation(cm.tgop)
    c:RegisterEffect(e1)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and tc1:GetLeftScale()==tc2:GetRightScale() and e:GetHandler():GetLeftScale()>tc1:GetLeftScale()
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(cm.actlimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function cm.lvfilter(c,tp)
    local LeftScale=c:GetLeftScale()
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil,LeftScale)
end
function cm.tgfilter(c,LeftScale)
    return c:GetLeftScale()==LeftScale and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and cm.lvfilter(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(cm.lvfilter,tp,LOCATION_PZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.lvfilter,tp,LOCATION_PZONE,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLeftScale())
    if g:GetCount()>0 then
        local gc=g:GetFirst()
        if Duel.SendtoHand(gc,nil,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_HAND) and e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(e:GetHandler(),nseq)
        end
    end
end
