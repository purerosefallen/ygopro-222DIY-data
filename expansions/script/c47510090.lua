--星晶兽融合体 维拉=修瓦利耶
local m=47510090
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function c47510090.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),1,1)
    c:EnableReviveLimit() 
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47510090)
    e1:SetCost(c47510090.thcost)
    e1:SetTarget(c47510090.thtg)
    e1:SetOperation(c47510090.thop)
    c:RegisterEffect(e1)
    --change ageis
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_ATTACK_ANNOUNCE)
    e4:SetCountLimit(1)
    e4:SetCondition(c47510090.negcon)
    e4:SetOperation(c47510090.negop)
    c:RegisterEffect(e4) 
end
function c47510090.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c47510090.thfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c47510090.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c47510090.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c47510090.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local g=Duel.SelectMatchingCard(tp,c47510090.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
       Duel.SendtoHand(g,tp,REASON_EFFECT)
       Duel.ConfirmCards(1-tp,g)
    end
end
function c47510090.cfilter(c,g)
    return c:IsFaceup() and g:IsContains(c)
end
function c47510090.drcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return lg and eg:IsExists(c47510090.cfilter,1,nil,lg)
end
function c47510090.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47510090.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c47510090.negcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==1-tp
end
function c47510090.negop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateAttack() then
        local c=e:GetHandler()
        local tcode=c.dfc_back_side
        c:SetEntityCode(tcode,true)
        c:ReplaceEffect(tcode,0,0)
        Duel.Hint(HINT_MUSIC,0,aux.Stringid(47510090,0))
    end
end
