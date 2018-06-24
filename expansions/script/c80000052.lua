--古代增幅器
local m=80000052
local cm=_G["c"..m]
cm.is_named_with_yvwan=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(cm.drtg)
    e2:SetOperation(cm.drop)
    c:RegisterEffect(e2)    
end
function cm.filter(c)
    return Sym.isyvwan(c) and c:IsType(TYPE_MONSTER)
end
function cm.thfilter1(c)
    return Sym.isyvwan(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.thfilter2(c)
    return Sym.isyvwan(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFacedown()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local ug=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK,0,nil)
    local dg=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
    if ug:GetCount()>0 then
        Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3))
        Duel.ConfirmCards(tp,ug)
    end
    if dg:GetCount()>0 then
        Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,4))
        Duel.ConfirmCards(tp,dg)
    end
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function cm.tdfilter(c)
    return Sym.isyvwan(c) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()<=0 then return end
    local c=tg:GetFirst()
    if c then Sym.uptodeck2(c,1) end
    c=tg:GetNext()
    if c then Sym.uptodeck2(c) 
    else Duel.ShuffleDeck(tp)
    end
end
