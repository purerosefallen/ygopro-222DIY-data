--Stage! ReLive!
local m=20100126
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)  
    --Activate Field
    local e2=Effect.CreateEffect(c)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,m)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(cm.acon)
    e2:SetTarget(cm.atg)
    e2:SetOperation(cm.aop)
    c:RegisterEffect(e2)
    if not cm.global_check then
        cm.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_LEAVE_FIELD)
        ge1:SetOperation(cm.checkop)
        Duel.RegisterEffect(ge1,0)
    end  
end
function cm.filter(c)
    return c:IsType(TYPE_FIELD) and c:IsAbleToDeck() and c:IsSetCard(0xc99)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==3 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function cm.ffilter(c,tp)
    return c:IsType(TYPE_FIELD) and c:IsControler(tp)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    if eg:IsExists(cm.ffilter,1,nil,tp) then
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
    end
end
function cm.acon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,m)>0
end
function cm.afilter(c,tp)
    return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsSetCard(0xc99)
end
function cm.atg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(cm.afilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
    local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
    if tc then
        local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
        if fc then
            Duel.SendtoGrave(fc,REASON_RULE)
            Duel.BreakEffect()
        end
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        Cirn9.RevueBgm(tp)
        local te=tc:GetActivateEffect()
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    end
end