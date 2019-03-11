--氷獄の王・サタン
local m=17090009
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --to deck
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(m,0))
    e0:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
    e0:SetType(EFFECT_TYPE_IGNITION)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetRange(LOCATION_PZONE)
    e0:SetTarget(cm.tdtg)
    e0:SetOperation(cm.tdop)
    c:RegisterEffect(e0)
    --special summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA+LOCATION_HAND)
    e2:SetCondition(cm.spcon)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    --summon success
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(cm.sumsuc)
    c:RegisterEffect(e3)
end
function cm.tdfilter(c)
    return c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 and Duel.Destroy(c,REASON_EFFECT)~=0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
function cm.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
        (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0))
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,e:GetHandler())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,e:GetHandler())
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
    if g:GetCount()<1 then return end
    Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    --to deck
    local e_1=Effect.CreateEffect(e:GetHandler())
    e_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_1:SetCategory(CATEGORY_TODECK)
    e_1:SetCode(EVENT_PHASE+PHASE_END)
    e_1:SetCountLimit(1)
    e_1:SetCondition(cm.epcon)
    e_1:SetOperation(cm.activate)
    Duel.RegisterEffect(e_1,tp)
    --discard
    local e_2=Effect.CreateEffect(e:GetHandler())
    e_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_2:SetCategory(CATEGORY_HANDES)
    e_2:SetCode(EVENT_SUMMON_SUCCESS)
    e_2:SetCountLimit(1)
    e_2:SetCondition(cm.condition)
    e_2:SetOperation(cm.operation)
    Duel.RegisterEffect(e_2,tp)
    --remove
    local e_3=Effect.CreateEffect(e:GetHandler())
    e_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e_3:SetCategory(CATEGORY_REMOVE)
    e_3:SetCode(EVENT_CHAIN_SOLVING)
    e_3:SetCountLimit(1)
    e_3:SetCondition(cm.rmon)
    e_3:SetOperation(cm.rmop)
    Duel.RegisterEffect(e_3,tp)
end
function cm.epcon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local g2=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0):RandomSelect(tp,3)
    Duel.SendtoDeck(g2,nil,2,REASON_EFFECT)
end
function cm.cfilter(c,tp)
    return c:GetSummonPlayer()==tp
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
function cm.rmon(e,tp,eg,ep,ev,re,r,rp)
    return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,2,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    end
end