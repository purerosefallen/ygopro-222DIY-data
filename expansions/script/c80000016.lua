--超越者 重力战士
local m=80000016
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=80000004
cm.afkind=4--xuanlan
cm.is_named_with_yvwan=1
cm.can_exchange=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
    --to deck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(cm.stg)
    e2:SetOperation(cm.sop)
    c:RegisterEffect(e2)    
end
function cm.tdfilter(c)
    return c:IsType(TYPE_MONSTER) and Sym.isyvwan(c) and c:IsAbleToDeck() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,c) and c:IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not (Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,c) and c:IsRelateToEffect(e) and c:IsPosition(LOCATION_HAND)) then end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND,0,1,1,c)
    nc=g:GetFirst()
    Sym.uptodeck2(c,1)
    Sym.uptodeck2(nc)
    Duel.Draw(tp,2,REASON_EFFECT)
end
function cm.sfilter(c)
    return Sym.isyvwan(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end