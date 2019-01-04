--魔王 布伦希尔德
local m=47510044
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function c47510044.initial_effect(c)
    c:EnableCounterPermit(0x5db)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510044.psplimit)
    c:RegisterEffect(e1)  
    --pendulum set
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510044)
    e2:SetCondition(c47510044.pencon)
    e2:SetTarget(c47510044.pentg)
    e2:SetOperation(c47510044.penop)
    c:RegisterEffect(e2)
    --serch
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510045)
    e3:SetTarget(c47510044.rmtg)
    e3:SetOperation(c47510044.rmop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --sunmoneffect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,47510000)
    e5:SetCost(c47510044.cost)
    e5:SetOperation(c47510044.atkop)
    c:RegisterEffect(e5)
    c47510044.ss_effect=e5
    --darkforce
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47510044,0))
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetOperation(c47510044.opd1)
    c:RegisterEffect(e6)
    --Change
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47510044,1))
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCost(c47510044.chcost)
    e7:SetTarget(c47510044.changetg)
    e7:SetOperation(c47510044.changeop)
    c:RegisterEffect(e7)
end
function c47510044.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510044.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510044.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510044.cfilter(c)
    return c:IsSetCard(0x5da) or c:IsSetCard(0x5de)
end
function c47510044.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47510044.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47510044.penfilter(c)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_PENDULUM) and not c:IsCode(47510044) and not c:IsForbidden()
end
function c47510044.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c47510044.penfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c47510044.penop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47510044.penfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
end
function c47510044.rmfilter(c)
    return c:IsAbleToRemove()
end
function c47510044.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510044.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c47510044.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47510044.rmfilter,tp,0,LOCATION_EXTRA,nil)
    if g:GetCount()==0 then return end
    local tc=g:RandomSelect(tp,1):GetFirst()
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c47510044.dcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
end
function c47510044.dop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev/2)
end
function c47510044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510044.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()  
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetTargetRange(0,1)
    e2:SetCondition(c47510044.condition)
    e2:SetValue(c47510044.aclimit)
    c:RegisterEffect(e2)
end
function c47510044.condition(e)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()==e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c47510044.actlimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47510044.opd1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5db,1)
    end
end
function c47510044.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x5db,2,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x5db,2,REASON_COST)
end
function c47510044.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47510044.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    c:ReplaceEffect(tcode,0,0)
end