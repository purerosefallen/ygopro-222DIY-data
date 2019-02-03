--ReLive-Tsukasa
local m=20100090
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2,cm.ovfilter,aux.Stringid(m,2),2,cm.xyzop)
    c:EnableReviveLimit() 
    --ret&draw
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(Cirn9.fap1)
    e1:SetTarget(cm.rdtg)
    e1:SetOperation(cm.rdop)
    c:RegisterEffect(e1)  
    --ntr
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(Cirn9.clcon)
    e2:SetCost(Cirn9.clcost)
    e2:SetTarget(cm.ntg)
    e2:SetOperation(cm.nop)
    c:RegisterEffect(e2)
    cm.ClimaxAct=e2
end

function cm.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99) and not c:IsCode(m)
end
function cm.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.filter1(c)
    return c:IsType(TYPE_FIELD) and c:IsAbleToDeck() and c:IsSetCard(0xc99) 
        and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_GRAVE,0,2,nil)
end
function cm.filter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc99) and c:IsAbleToDeck()
end
function cm.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsAbleToDeck() end
    if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
    g1:Merge(g2)
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.rdop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==3 and e:GetHandler():IsRelateToEffect(e) then
        Duel.BreakEffect()
        e:GetHandler():AddCounter(0xc99,1)
    end
end

function cm.nfilter(c)
    return c:IsControlerCanBeChanged() and c:IsFaceup()
end

function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
    if chk==0 then return Duel.IsExistingTarget(cm.nfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,cm.nfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.GetControl(tc,tp,PHASE_END,1) then
            --attack cost
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_ATTACK_COST)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetCost(Cirn9.rlcost)
            e1:SetOperation(Cirn9.rlop)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_CANNOT_TRIGGER)
            e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e2:SetRange(LOCATION_MZONE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2)
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_ADD_SETCODE)
            e3:SetValue(0xc99)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3)
            tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
        end
    end
end