--ReLiveStage-Captwins
local m=20100116
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveStage(c) 
    --Activate1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m-8,1))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCondition(Cirn9.nanacon1)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)    
    --To deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCost(cm.thcost)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.tdtg)
    e2:SetOperation(cm.tdop)
    c:RegisterEffect(e2) 
    --finish act
    local e3=Cirn9.FinishAct(c)
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_RECOVER+CATEGORY_TOHAND)
    e3:SetTarget(cm.fatg)
    e3:SetOperation(cm.faop)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCost(Cirn9.ap2)
    e4:SetCondition(cm.spcon)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
    cm.FinishAct=e3
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local lp0=Duel.GetLP(1-tp)
    Duel.SetLP(1-tp,lp0+2000)
    Cirn9.RevueBgm(tp)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99) and c:IsAbleToDeck()
end
function cm.sfilter(c,tp)
    return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.filter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,5,nil)
    local ct=g:GetCount()
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,ct,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,math.floor(ct/2))
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<1 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(cm.sfilter,1,nil,tp) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    local dc=math.floor(ct/2)
    if dc>0 then
        Duel.BreakEffect()
        Duel.Draw(tp,dc,REASON_EFFECT)
    end
end
function cm.desfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT)
        and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0xc99)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.desfilter,1,nil,tp) and Duel.GetTurnPlayer()==1-tp
end
function cm.spfilter(c,e,tp)
    return c:IsSetCard(0xc99) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.fafilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.fatg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function cm.rlfilter(c)
    return c:IsSetCard(0xc99) and c:IsAbleToHand()
end
function cm.faop(e,tp,eg,ep,ev,re,r,rp,chk)
    if not Duel.IsExistingMatchingCard(cm.fafilter,tp,LOCATION_MZONE,0,2,nil) then return end
    local sg=Duel.SelectMatchingCard(tp,cm.fafilter,tp,LOCATION_MZONE,0,2,2,nil)
    Duel.HintSelection(sg)
    Duel.BreakEffect()
    local c=e:GetHandler()
    local sum=Group.GetSum(sg,Card.GetAttack)
    if sum>0 then Duel.Recover(tp,sum,REASON_EFFECT) end
    if not Duel.IsExistingMatchingCard(cm.rlfilter,tp,LOCATION_DECK,0,1,nil) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.rlfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end