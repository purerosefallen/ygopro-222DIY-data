--外典救世主 逆—界限终结
local m=62200020
local cm=_G["c"..m]
function cm.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --skip turn
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(cm.con)
    e1:SetCost(cm.skipcost)
    e1:SetTarget(cm.skiptg)
    e1:SetOperation(cm.skipop)
    c:RegisterEffect(e1)
    --summon limit
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    e2:SetCondition(cm.con2)
    c:RegisterEffect(e2)
    --spsummon limit
    local e3=Effect.CreateEffect(c)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SPSUMMON_CONDITION)
    e3:SetValue(aux.FALSE)
    e3:SetCondition(cm.con2)
    c:RegisterEffect(e3)
end
--
function cm.cfilter(c,tp)
    return c:IsType(TYPE_NORMAL) and c:GetAttack()>=10000
end
function cm.skipcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,tp) end
    local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()~=1
end
function cm.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_TURN) end
end
function cm.skipop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_SKIP_TURN)
    e1:SetTargetRange(0,1)
    e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    e1:SetCondition(cm.skipcon)
    Duel.RegisterEffect(e1,tp)
end
function cm.skipcon(e)
    return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
--
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==1
end