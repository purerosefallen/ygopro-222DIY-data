--觉醒十天众 艾洁儿
local m=47591200
local cm=_G["c"..m]
function c47591200.initial_effect(c)
    c:EnableCounterPermit(0x5d4)
    --xyz summon
    aux.AddXyzProcedure(c,nil,10,2,c47591200.ovfilter,aux.Stringid(47591200,0),2,c47591200.xyzop)
    c:EnableReviveLimit()
    --serch
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47591200)
    e1:SetCondition(c47591200.poscon)
    e1:SetTarget(c47591200.thtg)
    e1:SetOperation(c47591200.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --drop
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47591200,1))
    e3:SetCategory(CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c47591200.ctcost)
    e3:SetOperation(c47591200.ctop)
    c:RegisterEffect(e3)
    --atk up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(c47591200.atk)
    c:RegisterEffect(e4)
    --draw
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47591200,2))
    e5:SetCategory(CATEGORY_DRAW)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetCondition(c47591200.drcon)
    e5:SetTarget(c47591200.drtg)
    e5:SetCost(c47591200.cost)
    e5:SetOperation(c47591200.drop)
    c:RegisterEffect(e5) 
end
function c47591200.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5d1) and not c:IsCode(47591200)
end
function c47591200.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,47591200)==0 end
    Duel.RegisterFlagEffect(tp,47591200,RESET_PHASE+PHASE_END,0,1)
end
function c47591200.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47591200.filter(c)
    return c:IsCode(47591010) and c:IsAbleToHand()
end
function c47591200.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47591200.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c47591200.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47591200.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47591200.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47591200.ctop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do 
        tc:AddCounter(0x105d,4)
        tc=g:GetNext()
    end
end
function c47591200.atk(e,c)
    return Duel.GetCounter(0,1,1,0x105d)*500
end
function c47591200.drcon(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    return bc:IsType(TYPE_MONSTER) and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c47591200.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47591200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x105d,3,REASON_COST) end
    Duel.RemoveCounter(tp,1,1,0x105d,3,REASON_COST)
end
function c47591200.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(tp,1,REASON_EFFECT)
end