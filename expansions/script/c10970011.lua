--纸上魔法使 克丽索贝莉露
local m=10970011
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLevel,6),2,2)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(10970008)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10970007,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m)
    e2:SetCost(cm.cost)
    e2:SetTarget(cm.tg)
    e2:SetOperation(cm.op)
    c:RegisterEffect(e2) 
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(30328508,1))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.tgtg)
    e3:SetOperation(cm.tgop)
    c:RegisterEffect(e3)   
end
function cm.cfilter(c)
    return c:IsSetCard(0x2233) and c:IsFaceup()
end
function cm.ffilter(c)
    return c:IsType(TYPE_FIELD)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local a=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_FZONE,0,1,nil)
    local b=Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_ONFIELD,0,1,nil)
    if chk==0 then return a or not b end
    if a then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_FZONE,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
    elseif not b then
   return true
    end
end
function cm.sfilter(c)
    return c:IsType(TYPE_FIELD) and c:IsSetCard(0x2233)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil)  end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(nil,tp,LOCATION_FZONE,0,1,nil) then return false end
    local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function cm.filter(c)
    return c:IsType(TYPE_FIELD) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end

