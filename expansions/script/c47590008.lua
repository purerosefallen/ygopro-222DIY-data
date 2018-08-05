--天司长 路西菲尔
local m=47590008
local cm=_G["c"..m]
function c47590008.initial_effect(c)
    c:SetSPSummonOnce(47590008)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(c47590008.synfilter2),2)
    c:EnableReviveLimit() 
    --cannot special summon
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.synlimit)
    c:RegisterEffect(e0)
    --atk up
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(c47590008.atkcon)
    e1:SetTarget(c47590008.atktg)
    e1:SetOperation(c47590008.atkop)
    c:RegisterEffect(e1)
    --Immunity
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetValue(c47590008.efilter2)
    c:RegisterEffect(e2)
    --lp
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_RECOVER)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetCondition(c47590008.con)
    e6:SetTarget(c47590008.target)
    e6:SetOperation(c47590008.operation)
    c:RegisterEffect(e6)
    --negate
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_CHAINING)
    e7:SetCountLimit(1)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47590008.ngco)
    e7:SetTarget(c47590008.ngtg)
    e7:SetOperation(c47590008.ngop)
    c:RegisterEffect(e7)
        --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_LEAVE_FIELD)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47590008.pencon)
    e8:SetTarget(c47590008.pentg)
    e8:SetOperation(c47590008.penop)
    c:RegisterEffect(e8)
    --spsummon bgm
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(47590008,0))
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetOperation(c47590008.spsuc)
    c:RegisterEffect(e9)
end
function c47590008.synfilter2(c)
    return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO+TYPE_FUSION)
end
function c47590008.efilter2(e,re,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    return not g:IsContains(e:GetHandler())
end
function c47590008.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47590008.atkfilter(c)
    return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c47590008.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47590008.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c47590008.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47590008.atkfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1500)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c47590008.spsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_MUSIC_OGG,0,aux.Stringid(47590008,1))
end 
function c47590008.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47590008.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47590008.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(3000)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,3000)
    Duel.SetChainLimit(aux.FALSE)
end
function c47590008.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47590008,2))
end
function c47590008.ngco(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c47590008.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ng=Group.CreateGroup()
    local dg=Group.CreateGroup()
    for i=1,ev do
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
            local tc=te:GetHandler()
            ng:AddCard(tc)
            if tc:IsOnField() and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
                dg:AddCard(tc)
            end
        end
    end
    Duel.SetTargetCard(dg)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
end
function c47590008.ngop(e,tp,eg,ep,ev,re,r,rp)
    local dg=Group.CreateGroup()
    for i=1,ev do
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.NegateActivation(i) then
            local tc=te:GetHandler()
            if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
                tc:CancelToGrave()
                dg:AddCard(tc)
            end
        end
    end
    Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end
function c47590008.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47590008.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47590008.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end