--Spiral Drill - Sky Drive Warrior
function c32912374.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,32912371),aux.NonTuner(Card.IsSetCard,0x205),1)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.synlimit)
    c:RegisterEffect(e1)
    --actlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c32912374.aclimit)
    e2:SetCondition(c32912374.actcon)
    c:RegisterEffect(e2)
    --pierce
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e4:SetCondition(c32912374.damcon)
    e4:SetOperation(c32912374.damop)
    c:RegisterEffect(e4)
    --position
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(32912374,1))
    e5:SetCategory(CATEGORY_POSITION)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetTarget(c32912374.postg)
    e5:SetOperation(c32912374.posop)
    c:RegisterEffect(e5)
end
function c32912374.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c32912374.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c32912374.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c32912374.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function c32912374.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    local d=Duel.GetAttackTarget()
    if chk==0 then return d and d:IsControler(1-tp) and d:IsCanChangePosition() end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,d,1,0,0)
end
function c32912374.posop(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d:IsRelateToBattle() then
        Duel.ChangePosition(d,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end