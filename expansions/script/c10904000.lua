--灵刻使 月魔女
local m=10904000
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    c:RegisterEffect(e1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(cm.spcon)
    c:RegisterEffect(e1)  
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(65518099,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)  
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_PZONE)
    e4:SetValue(cm.efilter)
    c:RegisterEffect(e4)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.spcon(e)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.filter(c)
    return c:GetLeftScale()==1 and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.efilter(e,re,rp)
    return rp==e:GetHandlerPlayer()
end
