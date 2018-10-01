local m=47501001
local cm=_G["c"..m]
function c47501001.initial_effect(c)
    c:SetSPSummonOnce(47501001)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcMix(c,false,true,c47501001.fusfilter1,c47501001.fusfilter2,c47501001.fusfilter3,c47501001.fusfilter4,c47501001.fusfilter5)
    --spsummon condition
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EFFECT_SPSUMMON_CONDITION)
    e5:SetValue(aux.fuslimit)
    c:RegisterEffect(e5)
    --fusumon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e1)
    --break
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47501001,0))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47501001+EFFECT_COUNT_CODE_DUEL)
    e2:SetCondition(c47501001.descon)
    e2:SetTarget(c47501001.target)
    e2:SetOperation(c47501001.operation)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c47501001.damop)
    c:RegisterEffect(e3)
    --spsummon bgm
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(47501001,3))
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetOperation(c47501001.spsuc)
    c:RegisterEffect(e9)
    --atk bgm
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(47501001,4))
    e10:SetCategory(CATEGORY_ATKCHANGE)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e10:SetCode(EVENT_ATTACK_ANNOUNCE)
    e10:SetOperation(c47501001.atksuc)
    c:RegisterEffect(e10)
end
function c47501001.fusfilter1(c)
    return c:IsFusionType(TYPE_FUSION)
end
function c47501001.fusfilter2(c)
    return c:IsFusionType(TYPE_SYNCHRO)
end
function c47501001.fusfilter3(c)
    return c:IsFusionType(TYPE_XYZ)
end
function c47501001.fusfilter4(c)
    return c:IsFusionType(TYPE_PENDULUM)
end
function c47501001.fusfilter5(c)
    return c:IsFusionType(TYPE_LINK)
end
function c47501001.genchainlm(c)
    return  function (e,rp,tp)
                return e:GetHandler()==c
            end
end
function c47501001.spsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47501001,1))
end
function c47501001.atksuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SOUND,0,aux.Stringid(47501001,2))
end 
function c47501001.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function c47501001.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47501001.filter(c)
    return c:IsAbleToRemove()
end
function c47501001.tfilter(c)
    return not c:IsAbleToRemove()
end
function c47501001.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c47501001.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
        return g:GetCount()>0 and not g:IsExists(c47501001.tfilter,1,nil)
    end
    local g=Duel.GetMatchingGroup(c47501001.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function c47501001.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47501001.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end