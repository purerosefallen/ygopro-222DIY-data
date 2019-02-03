--ReLiveStage-Elysion
local m=20100118
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveStage(c) 
    --Activate1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m-10,1))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(Cirn9.nanacon1)
    e1:SetTarget(cm.tgtg)
    e1:SetOperation(cm.tgop)
    c:RegisterEffect(e1)   
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,m)
    e2:SetCost(cm.thcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)  
    --finish act
    local e3=Cirn9.FinishAct(c)
    e3:SetCategory(CATEGORY_COUNTER+CATEGORY_DRAW)
    e3:SetTarget(cm.fatg)
    e3:SetOperation(cm.faop)
    c:RegisterEffect(e3)
    --negate
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,2))
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(cm.condition)
    e4:SetCost(cm.cost)
    e4:SetTarget(cm.target)
    e4:SetOperation(cm.operation)
    c:RegisterEffect(e4)   
    cm.FinishAct=e3
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Cirn9.RevueBgm(tp)
    if not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_EFFECT)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsType(TYPE_FIELD)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return rp==1-tp and Duel.IsChainNegatable(ev)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xc99,1,REASON_COST) end
    Duel.RemoveCounter(tp,1,0,0xc99,1,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function cm.fafilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0xc99)
end
function cm.rlfilter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand()
end
function cm.faop(e,tp,eg,ep,ev,re,r,rp,chk)
    if not Duel.IsExistingMatchingCard(cm.fafilter,tp,LOCATION_MZONE,0,2,nil) then return end
    local sg=Duel.SelectMatchingCard(tp,cm.fafilter,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.HintSelection(sg)
    Duel.BreakEffect()
    local tc=sg:GetFirst()
    while tc do
        tc:AddCounter(0xc99,1)
        tc=sg:GetNext()
    end
    Duel.Draw(tp,1,REASON_EFFECT)
end