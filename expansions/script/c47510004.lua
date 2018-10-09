--制裁的星晶兽 托尔
local m=47510004
local cm=_G["c"..m]
function c47510004.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510004.psplimit)
    c:RegisterEffect(e1) 
    --destroy & counter
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510004)
    e2:SetCondition(c47510004.sercon)
    e2:SetCost(c47510004.sercost)
    e2:SetTarget(c47510004.sertg)
    e2:SetOperation(c47510004.serop)
    c:RegisterEffect(e2) 
    --atk
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(26270847,0))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetOperation(c47510004.atkop)
    c:RegisterEffect(e3)
    --sunmoneffect
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DISABLE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,47510000)
    e5:SetCost(c47510004.cost)
    e5:SetTarget(c47510004.distg)
    e5:SetOperation(c47510004.disop)
    c:RegisterEffect(e5)
    --summon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47510001,0))
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_SUMMON_PROC)
    e6:SetRange(LOCATION_HAND)
    e6:SetCondition(c47510004.ntcon)
    c:RegisterEffect(e6)
    --immune
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_IMMUNE_EFFECT)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47510004.immcon)
    e7:SetValue(c47510004.efilter)
    c:RegisterEffect(e7)
end
function c47510004.immcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c47510004.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47510004.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510004.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510004.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510004.sercon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47510004.sercost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c47510004.thfilter(c)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and not c:IsCode(47510004)
end
function c47510004.sertg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510004.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47510004.serop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47510004.atkop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.TossDice(tp,1)
    if d==1 or d==2 or d==3 then
    Duel.NegateAttack()
    elseif d==4 or d==5 or d==6 then
    local c=e:GetHandler()
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
            e1:SetValue(4500)
            c:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_FIELD)
            e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e2:SetCode(EFFECT_CANNOT_ACTIVATE)
            e2:SetRange(LOCATION_MZONE)
            e2:SetTargetRange(0,1)
            e2:SetReset(RESET_PHASE+PHASE_BATTLE)
            e2:SetValue(c47510004.aclimit)
            e2:SetCondition(c47510004.actcon)
            c:RegisterEffect(e2)
        end
    end
end
function c47510004.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47510004.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c47510004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510004.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47510004.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(-1500)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e4)
       tc=g:GetNext()
    end
end
function c47510004.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5)
        and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end