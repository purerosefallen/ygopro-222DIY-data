--ReLive-Meifan
local m=20100104
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    Cirn9.ReLink(c)
    --link summon
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()   
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(Cirn9.sap2)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1) 
    --battle target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e2:SetCondition(cm.btcon)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(aux.imval1)
    c:RegisterEffect(e2)
    --sort
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.sdtg)
    e3:SetOperation(cm.sdop)
    c:RegisterEffect(e3)
    cm.ClimaxAct=e3
end
function cm.matfilter(c)
    return c:IsLinkSetCard(0xc99) and not c:IsLinkCode(m)
end
function cm.filter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand() and c:IsType(TYPE_FIELD)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) 
        and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0xc99)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoHand(g,nil,REASON_EFFECT) then
            Duel.ConfirmCards(1-tp,g)
            if c:IsRelateToEffect(e) then
                Duel.BreakEffect()
                c:AddCounter(0xc99,2)
            end
        end  
    end
end
function cm.btcon(e,tp)
    return Cirn9.IsReLinkState(e:GetHandler())
end
function cm.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function cm.sdop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    Duel.ShuffleDeck(tp)
    Duel.SortDecktop(tp,tp,3)
end