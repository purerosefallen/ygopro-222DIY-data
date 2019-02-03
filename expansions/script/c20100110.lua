--ReLiveStage-L·T·M
local m=20100110
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveStage(c) 
    --Activate1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m-2,1))
    e1:SetCategory(CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(Cirn9.nanacon1)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
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
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetTarget(cm.fatg)
    e3:SetOperation(cm.faop)
    c:RegisterEffect(e3)
    --act limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_FZONE)
    e4:SetOperation(cm.chainop)
    c:RegisterEffect(e4)
    cm.FinishAct=e3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Cirn9.RevueBgm(tp)
    if not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) then return end
    Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsLevel(4)
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
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsSetCard(0xc99) then
        Duel.SetChainLimit(cm.chainlm)
    end
end
function cm.chainlm(e,rp,tp)
    return tp==rp
end
function cm.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
end
function cm.fafilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.faop(e,tp,eg,ep,ev,re,r,rp,chk)
    if not Duel.IsExistingMatchingCard(cm.fafilter,tp,LOCATION_MZONE,0,2,nil) then return end
    local sg=Duel.SelectMatchingCard(tp,cm.fafilter,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.HintSelection(sg)
    Duel.BreakEffect()
    local c=e:GetHandler()
    local fc=sg:GetFirst()
    local sc=sg:GetNext()
    local atk1=fc:GetBaseAttack()
    local atk2=sc:GetBaseAttack()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    e1:SetValue(atk2)
    fc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    e2:SetValue(atk1)
    sc:RegisterEffect(e2)
end