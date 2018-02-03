--灵刻使 人鱼
local m=10904002
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCondition(cm.spcon)
    c:RegisterEffect(e0)  
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(65518099,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.scon)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)  
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(60549248,1))
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCondition(cm.tgcon)
    e4:SetTarget(cm.tg)
    e4:SetOperation(cm.op)
    c:RegisterEffect(e4)    
end
function cm.spcon(e)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale() and e:GetHandler():GetLeftScale()>tc1:GetLeftScale() and Duel.GetTurnPlayer()==tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function cm.filter(c)
    return c:IsSetCard(0x237) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
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
