--愈灵刻使 阿丽亚娜
local m=10904016
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_PENDULUM),4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c,false) 
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(m)
    e0:SetRange(LOCATION_MZONE)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e0:SetTargetRange(1,0)
    e0:SetCondition(cm.upcon)
    c:RegisterEffect(e0) 
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.tgcon)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1) 
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,2))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(cm.lpcon)
    e4:SetCost(cm.cost)
    e4:SetOperation(cm.lpop)
    c:RegisterEffect(e4)
end
function cm.ovfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if chk==0 then return tc1:GetLeftScale()==tc2:GetRightScale() end
end
function cm.upcon(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==0 and tc2:GetRightScale()==0
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetHandler():GetControler()
    local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if not tc1 or not tc2 then return false end
    return tc1:GetLeftScale()==tc2:GetRightScale() and e:GetHandler():GetLeftScale()>tc1:GetLeftScale()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return  Duel.IsExistingTarget(Card.IsAbleToDeckAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0) 
    local tc=Duel.GetFirstTarget()
    if not Duel.IsPlayerAffectedByEffect(tp,m) and g:GetFirst():IsType(TYPE_MONSTER) and g:GetFirst():GetControler()==1-tp then
        e:SetLabel(1)
    else
        e:SetLabel(0)
    end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
        and e:GetLabel()==1 and Duel.IsPlayerCanDraw(1-tp,1)
        and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
        Duel.BreakEffect()
        Duel.ShuffleDeck(1-tp)
        Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.lpcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)~=8000
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(tp,8000)
end
