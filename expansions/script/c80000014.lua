--超越者 创造术士
local m=80000014
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=80000001
cm.afkind=1--jiexi
cm.is_named_with_yvwan=1
cm.can_exchange=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
    --to deck
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetTarget(cm.target)
    e4:SetOperation(cm.operation)
    c:RegisterEffect(e4) 
    --to hand
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetDescription(aux.Stringid(m,1))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(cm.thtg)
    e5:SetOperation(cm.thop)
    c:RegisterEffect(e5)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    c=e:GetHandler()
    if chk==0 then return Duel.IsPlayerCanSendtoDeck(tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Sym.uptodeck(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetOperation(cm.drop)
    Duel.RegisterEffect(e1,tp)    
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end