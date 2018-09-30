--源初数码兽 APOCALYPSE
function c50218149.initial_effect(c)
    c:EnableReviveLimit()
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c50218149.spcon)
    e2:SetOperation(c50218149.spop)
    c:RegisterEffect(e2)
    ---atk
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_SET_BASE_ATTACK)
    e3:SetValue(c50218149.value)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_SET_BASE_DEFENSE)
    e4:SetValue(c50218149.value)
    c:RegisterEffect(e4)
    --to deck
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TODECK)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCost(c50218149.cost)
    e5:SetTarget(c50218149.target)
    e5:SetOperation(c50218149.activate)
    c:RegisterEffect(e5)
    --to deck
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_TODECK)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetTarget(c50218149.tdtg)
    e6:SetOperation(c50218149.tdop)
    c:RegisterEffect(e6)
end
function c50218149.spfilter(c)
    return c:IsSetCard(0xcb1) and c:IsAbleToRemoveAsCost()
end
function c50218149.spcon(e,c)
    if c==nil then return true end
    if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
    local g=Duel.GetMatchingGroup(c50218149.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    return ct>=8
end
function c50218149.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c50218149.spfilter,tp,LOCATION_GRAVE,0,nil)
    local rg=Group.CreateGroup()
    for i=1,8 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        if tc then
            rg:AddCard(tc)
            g:Remove(Card.IsCode,nil,tc:GetCode())
        end
    end
    Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c50218149.afilter(c)
    return c:IsSetCard(0xcb1) and c:IsFaceup()
end
function c50218149.value(e,c)
    return Duel.GetMatchingGroupCount(c50218149.afilter,c:GetControler(),LOCATION_REMOVED,0,nil)*500
end
function c50218149.rfilter(c)
    return c:IsSetCard(0xcb1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c50218149.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50218149.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c50218149.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50218149.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c50218149.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
function c50218149.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c50218149.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,0,nil)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end